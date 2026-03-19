<#
.SYNOPSIS
    Creates or updates User Stories and Tasks in Azure DevOps idempotently from a JSON file, saving rich-text fields as Markdown.

.DESCRIPTION
    Reads a JSON backlog file, creates work items in ADO (skipping those with existing ADO_ID),
    links Stories to the specified parent and Tasks to their Stories, and updates the JSON with assigned IDs.
    It correctly formats Description, Acceptance Criteria, and Definition of Done into their respective ADO fields using Markdown.

.PARAMETER OrganizationUrl
    Azure DevOps organization URL (e.g. https://dev.azure.com/myOrg)

.PARAMETER ProjectName
    Azure DevOps project name

.PARAMETER PersonalAccessToken
    PAT with permissions to create work items

.PARAMETER BacklogJsonFilePath
    Full path to the input/output JSON file

.PARAMETER ParentWorkItemId
    Parent work item ID to link User Stories to

.PARAMETER AreaPath
    Value for System.AreaPath field

.EXAMPLE
    .\Create-BacklogFromJSON.ps1 -OrganizationUrl "https://dev.azure.com/myOrg" `
        -ProjectName "MyProject" -PersonalAccessToken "your-pat-here" `
        -BacklogJsonFilePath ".\backlog.json" -ParentWorkItemId 123 `
        -AreaPath "MyProject\Area\SubArea"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$OrganizationUrl,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$ProjectName,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$PersonalAccessToken,
    [Parameter(Mandatory = $true)][ValidateScript({ Test-Path $_ -PathType Leaf })][string]$BacklogJsonFilePath,
    [Parameter(Mandatory = $true)][ValidateRange(1, [int]::MaxValue)][int]$ParentWorkItemId,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$AreaPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Helper Functions

function Get-AuthHeader {
    param([string]$Pat)
    $encodedPat = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Pat"))
    return @{
        Authorization  = "Basic $encodedPat"
        'Content-Type' = 'application/json-patch+json'
    }
}

function New-WorkItem {
    param(
        [string]$Type,
        [string]$Title,
        [string]$Description,
        [string]$AcceptanceCriteria, # Parámetro opcional para Criterios de Aceptación
        [int]$ParentId,
        [hashtable]$Headers,
        [string]$BaseUrl,
        [string]$AreaPathValue
    )

    $body = @(
        @{ op = 'add'; path = '/fields/System.Title'; value = $Title },
        @{ op = 'add'; path = '/fields/System.AreaPath'; value = $AreaPathValue }
    )

    # Añade la descripción si se proporcionó y establece su formato a Markdown
    if (-not [string]::IsNullOrWhiteSpace($Description)) {
        $body += (@{ op = 'add'; path = '/fields/System.Description'; value = $Description })
        # Establece el formato a Markdown para el campo Descripción
        $body += (@{ op = 'add'; path = '/multilineFieldsFormat/System.Description'; value = 'Markdown' })
    }

    # Añade los criterios de aceptación si se proporcionaron y establece su formato a Markdown
    if (-not [string]::IsNullOrWhiteSpace($AcceptanceCriteria)) {
        $body += (@{ op = 'add'; path = '/fields/Microsoft.VSTS.Common.AcceptanceCriteria'; value = $AcceptanceCriteria })
        # Establece el formato a Markdown para el campo Criterios de Aceptación
        $body += (@{ op = 'add'; path = '/multilineFieldsFormat/Microsoft.VSTS.Common.AcceptanceCriteria'; value = 'Markdown' })
    }

    # Añade el enlace al elemento padre si se especificó un ID
    if ($ParentId -gt 0) {
        $body +=(@{
            op = 'add'; path = '/relations/-'
            value = @{
                rel = 'System.LinkTypes.Hierarchy-Reverse'
                url = "$BaseUrl/_apis/wit/workitems/$ParentId"
            }
        })
    }

    $uri = "$BaseUrl/_apis/wit/workitems/`$$Type`?api-version=7.1"
    $jsonBody = $body | ConvertTo-Json -Depth 10
    Write-Verbose "API Request URL: $uri"
    Write-Verbose "API Request Body: $jsonBody"
    
    # MEJORA: Forzar codificación UTF8 al enviar el body
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)
    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $Headers -Body $bodyBytes -ContentType 'application/json-patch+json'
    return $response.id
}

function Add-IdempotencyProperty {
    param(
        [PSCustomObject]$WorkItemObject,
        [int]$Id
    )
    $orderedProps = [ordered]@{ ADO_ID = $Id }
    foreach ($prop in $WorkItemObject.PSObject.Properties) {
        if ($prop.Name -ne 'ADO_ID') {
            $orderedProps[$prop.Name] = $prop.Value
        }
    }
    return [PSCustomObject]$orderedProps
}
#endregion

#region Main Logic

Write-Information "STAGE: Reading JSON file..."
$backlogContent = Get-Content -Path $BacklogJsonFilePath -Raw -Encoding UTF8
$backlog = $backlogContent | ConvertFrom-Json

if (-not $backlog.userStories) {
    throw "JSON does not contain 'userStories' property. Script cannot continue."
}
Write-Information "JSON file loaded successfully. Found $($backlog.userStories.Count) User Stories."

Write-Information "STAGE: Preparing ADO connection..."
$headers = Get-AuthHeader -Pat $PersonalAccessToken
$baseUrl = "$OrganizationUrl/$ProjectName"
Write-Information "Connection configured for: $baseUrl"

$createdCount = 0
$skippedCount = 0
$errorCount = 0

# Collect IDs of created User Stories so we can list them in the summary
$createdStoryIds = [System.Collections.Generic.List[int]]::new()

try {
    Write-Information "STAGE: Processing User Stories..."
    for ($i = 0; $i -lt $backlog.userStories.Count; $i++) {
        $story = $backlog.userStories[$i]
        
        Write-Information "`nProcessing User Story: $($story.title)"
        
        if ($story.PSObject.Properties['ADO_ID'] -and ([int64]$story.ADO_ID -gt 0)) {
            Write-Verbose "  [SKIPPED] Story already has a valid ADO_ID: $($story.ADO_ID)."
            $skippedCount++
        }
        else {
            try {
                Write-Information "  [CREATING] User Story..."
                
                # Construir la Descripción completa en Markdown
                $descriptionParts = [System.Collections.Generic.List[string]]@()
                if ($story.PSObject.Properties['description']) { $descriptionParts.Add($story.description) }
                if ($story.PSObject.Properties['definitionOfDone']) { $descriptionParts.Add("`n`n**Definition of Done:**`n$($story.definitionOfDone)") }
                $fullDescription = $descriptionParts -join ''

                # Construir los Criterios de Aceptación en Markdown
                $acceptanceCriteriaText = ''
                if ($story.PSObject.Properties['acceptanceCriteria']) {
                    $acceptanceCriteriaText = ($story.acceptanceCriteria | ForEach-Object { "- $_" }) -join "`n"
                }

                $storyId = New-WorkItem -Type 'User Story' -Title $story.title `
                    -Description $fullDescription -AcceptanceCriteria $acceptanceCriteriaText `
                    -ParentId $ParentWorkItemId -Headers $headers -BaseUrl $baseUrl -AreaPathValue $AreaPath
                
                $backlog.userStories[$i] = Add-IdempotencyProperty -WorkItemObject $story -Id $storyId
                $story = $backlog.userStories[$i]
                
                # Record created Story ID for summary list
                $createdStoryIds.Add($storyId) | Out-Null

                $createdCount++
                Write-Information "  [SUCCESS] User Story created with ID: $storyId."
            }
            catch {
                Write-Warning "  [ERROR] Failed to create User Story '$($story.title)': $_"
                $errorCount++
                continue
            }
        }

        if ($story.tasks -and $story.ADO_ID) {
            Write-Verbose "  Processing $($story.tasks.Count) Tasks for this Story..."
            for ($j = 0; $j -lt $story.tasks.Count; $j++) {
                $task = $story.tasks[$j]
                
                if ($task.PSObject.Properties['ADO_ID'] -and ([int64]$task.ADO_ID -gt 0)) {
                    Write-Verbose "    [SKIPPED] Task '$($task.title)' already has ADO_ID: $($task.ADO_ID)."
                    $skippedCount++
                }
                else {
                    try {
                        Write-Information "    [CREATING] Task: $($task.title)"
                        
                        # Construir la Descripción de la Task en Markdown
                        $taskDescriptionParts = [System.Collections.Generic.List[string]]@()
                        if ($task.PSObject.Properties['description']) { $taskDescriptionParts.Add($task.description) } # Si la task tuviera descripción
                        if ($task.PSObject.Properties['definitionOfDone']) { $taskDescriptionParts.Add("**Definition of Done:**`n$($task.definitionOfDone)") }
                        $fullTaskDescription = $taskDescriptionParts -join ''

                        $taskId = New-WorkItem -Type 'Task' -Title $task.title `
                            -Description $fullTaskDescription -ParentId $story.ADO_ID `
                            -Headers $headers -BaseUrl $baseUrl -AreaPathValue $AreaPath
                        
                        $story.tasks[$j] = Add-IdempotencyProperty -WorkItemObject $task -Id $taskId

                        $createdCount++
                        Write-Information "    [SUCCESS] Task created with ID: $taskId."
                    }
                    catch {
                        Write-Warning "    [ERROR] Failed to create Task '$($task.title)': $_.Exception.Message"
                        $errorCount++
                    }
                }
            }
        }
    }
}
catch {
    Write-Error "A critical error interrupted the main process: $_.Exception.Message"
    $errorCount++
}
finally {
    Write-Information "`nSTAGE: Saving updated JSON..."
    try {
        $backlog | ConvertTo-Json -Depth 10 | Set-Content -Path $BacklogJsonFilePath -Encoding UTF8
        Write-Information "JSON file updated successfully."
    }
    catch {
        Write-Error "FATAL: Could not save the updated JSON file to '$BacklogJsonFilePath'. Any progress made in this run might be lost. Error: $_.Exception.Message"
    }

    Write-Information @"

========================================
EXECUTION SUMMARY
----------------------------------------
  Items created: $createdCount
  Items skipped (already existed): $skippedCount
  Errors encountered: $errorCount
----------------------------------------
List of US created
"@

    # If we created any User Stories, print each on its own line prefixed with '#'
    if ($createdStoryIds.Count -gt 0) {
        foreach ($id in $createdStoryIds) {
            Write-Information "#$id"
        }
    }

    Write-Information "========================================"
}

#endregion