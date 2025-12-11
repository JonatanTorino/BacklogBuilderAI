import os
import re
import json
from datetime import datetime, timedelta

def parse_time(time_str):
    try:
        # Formatos posibles: MM:SS.mmm o HH:MM:SS.mmm
        if len(time_str.split(':')) == 2:
            t = datetime.strptime(time_str, "%M:%S.%f")
        else:
            t = datetime.strptime(time_str, "%H:%M:%S.%f")
        return t
    except ValueError:
        return None

def process_vtt_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    interventions = []
    current_speaker = None
    current_text = []
    last_end_time = None
    
    # Regex para capturar el bloque de tiempo y el orador/texto
    # Ejemplo: 00:00:06.696 --> 00:00:09.592
    time_pattern = re.compile(r'(\d{2}:\d{2}:\d{2}\.\d{3}|\d{2}:\d{2}\.\d{3})\s-->\s(\d{2}:\d{2}:\d{2}\.\d{3}|\d{2}:\d{2}\.\d{3})')
    speaker_pattern = re.compile(r'<v\s([^>]+)>(.*)</v>', re.DOTALL)
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # Detectar timestamp
        time_match = time_pattern.match(line)
        if time_match:
            start_time_str = time_match.group(1)
            end_time_str = time_match.group(2)
            current_start_time = parse_time(start_time_str)
            current_end_time = parse_time(end_time_str)
            
            # Buscar la siguiente línea con contenido
            i += 1
            if i < len(lines):
                content_line = lines[i].strip()
                # A veces el contenido puede ocupar varias líneas hasta el próximo bloque
                full_content = ""
                while i < len(lines) and not lines[i].strip() == "" and not time_pattern.match(lines[i].strip()) and not re.match(r'^[a-f0-9\-]+/\d+-\d+$', lines[i].strip()): # Evitar UUIDs
                     full_content += lines[i]
                     i += 1
                i -= 1 # Retroceder uno porque el while se pasó

                # Limpiar etiquetas <v> y extraer orador
                speaker_match = speaker_pattern.search(full_content)
                if speaker_match:
                    speaker = speaker_match.group(1)
                    text = speaker_match.group(2).strip()
                    
                    # Regla de consolidación: Mismo orador y menos de 2 segundos de diferencia (o 5 según regla general, usaremos 2 para ser conservadores con la "fragmentación")
                    # El prompt dice "menos de 5 segundos" en la tarea y "menos de 2" en el ejemplo de fragmentación.
                    # Usaremos 5 segundos para consolidar intervenciones consecutivas del mismo orador.
                    
                    is_consecutive = False
                    if current_speaker == speaker and last_end_time:
                        if current_start_time and (current_start_time - last_end_time).total_seconds() < 5:
                            is_consecutive = True
                    
                    if is_consecutive:
                        current_text.append(text)
                        last_end_time = current_end_time
                    else:
                        # Guardar intervención anterior si existe
                        if current_speaker:
                            interventions.append({'speaker': current_speaker, 'text': " ".join(current_text)})
                        
                        # Iniciar nueva intervención
                        current_speaker = speaker
                        current_text = [text]
                        last_end_time = current_end_time
                else:
                    # Si no hay speaker tag, puede ser continuación o error. 
                    # El prompt dice: "Si un archivo no contiene etiquetas <v>, devuelve el archivo sin cambios y marca una advertencia."
                    # Pero esto es línea por línea. Asumiremos que si no hay match, no es una intervención válida formato VTT esperado con <v>.
                    pass
        
        i += 1

    # Agregar la última intervención
    if current_speaker:
        interventions.append({'speaker': current_speaker, 'text': " ".join(current_text)})

    return interventions

def main():
    target_dir = r".TmpFiles\FE"
    output_report = {
        "processedFiles": [],
        "summary": {
            "totalFilesProcessed": 0,
            "successfulFiles": 0,
            "filesWithWarnings": 0,
            "totalInterventions": 0
        }
    }

    if not os.path.exists(target_dir):
        print(f"Directory not found: {target_dir}")
        return

    files = [f for f in os.listdir(target_dir) if f.endswith('.vtt')]
    output_report["summary"]["totalFilesProcessed"] = len(files)

    for filename in files:
        file_path = os.path.join(target_dir, filename)
        try:
            # Pre-chequeo de etiquetas <v>
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                if "<v " not in content:
                    status = "warning"
                    message = "No se encontraron etiquetas de orador (<v>)"
                    output_report["processedFiles"].append({
                        "inputFile": filename,
                        "outputFile": None,
                        "status": status,
                        "message": message
                    })
                    output_report["summary"]["filesWithWarnings"] += 1
                    continue

            interventions = process_vtt_file(file_path)
            
            output_filename = filename.replace('.vtt', '_limpio.txt')
            output_path = os.path.join(target_dir, output_filename)
            
            unique_speakers = set()
            with open(output_path, 'w', encoding='utf-8') as f:
                for intervention in interventions:
                    # Reconstruir formato <v Speaker>text</v>
                    # Limpieza extra de saltos de línea y espacios dobles
                    clean_text = intervention['text'].replace('\n', ' ').strip()
                    clean_text = re.sub(r'\s+', ' ', clean_text)
                    
                    f.write(f"<v {intervention['speaker']}>{clean_text}</v>\n\n")
                    unique_speakers.add(intervention['speaker'])
            
            output_report["processedFiles"].append({
                "inputFile": filename,
                "outputFile": output_filename,
                "status": "success",
                "interventionsCount": len(interventions),
                "uniqueSpeakers": list(unique_speakers)
            })
            output_report["summary"]["successfulFiles"] += 1
            output_report["summary"]["totalInterventions"] += len(interventions)

        except Exception as e:
            output_report["processedFiles"].append({
                "inputFile": filename,
                "outputFile": None,
                "status": "error",
                "message": str(e)
            })
            output_report["summary"]["filesWithWarnings"] += 1

    print(json.dumps(output_report, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
