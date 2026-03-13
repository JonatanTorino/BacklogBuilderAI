import os
import unittest

class TestFlowDocumentation(unittest.TestCase):
    def test_documentation_file_exists(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        self.assertTrue(os.path.exists(doc_path), f"Documentation file not found at {doc_path}")

    def test_documentation_has_basic_structure(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        required_headers = [
            '# Documentación del Flujo End-to-End: BacklogBuilderAI',
            '## Introducción',
            '## 1. Módulos de Pre-procesamiento',
            '## 2. Pipeline de Orquestación LLM',
            '## 3. Integración con Ecosistema Azure DevOps',
            '## 4. Evolución de los Estados de Información',
            '## 5. Informe de Visión Estratégica'
        ]
        
        for header in required_headers:
            self.assertIn(header, content, f"Header '{header}' not found in documentation")

    def test_section_1_has_mermaid_diagram(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check if Mermaid flowchart is present in Section 1
        self.assertIn('```mermaid', content)
        self.assertIn('graph LR', content)
        self.assertIn('clean_vtt.py', content)
        self.assertIn('convert_docx_to_text.py', content)

    def test_section_2_has_sequence_diagram(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check if Mermaid sequence diagram is present in Section 2
        self.assertIn('sequenceDiagram', content)
        self.assertIn('Prompt-01', content)
        self.assertIn('Prompt-02', content)
        self.assertIn('Prompt-03', content)

    def test_section_3_has_mermaid_diagram(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check if Mermaid flowchart is present in Section 3
        self.assertIn('Invoke-BacklogCreation.ps1', content)
        self.assertIn('Create-BacklogFromJSON.ps1', content)

    def test_section_4_has_state_diagram(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check if Mermaid state diagram is present in Section 4
        self.assertIn('stateDiagram-v2', content)
        self.assertIn('Insumo_Crudo', content)
        self.assertIn('Texto_Normalizado', content)

    def test_section_5_has_strategic_report_content(self):
        doc_path = os.path.join('KnowledgeBase', 'BacklogBuilderAI', 'Documentation', 'Flow_E2E.md')
        if not os.path.exists(doc_path):
            self.skipTest("File does not exist")
        
        with open(doc_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Check for strategic report subsections
        self.assertIn('### 5.1. Optimización y Eficiencia', content)
        self.assertIn('### 5.2. Hoja de Ruta: Hacia una Plataforma SaaS Colaborativa', content)
        self.assertIn('### 5.3. Robustez Arquitectónica', content)

if __name__ == '__main__':
    unittest.main()
