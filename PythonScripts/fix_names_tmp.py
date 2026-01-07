import os
import re

def rename_files(root_dir):
    for root, dirs, files in os.walk(root_dir):
        for filename in files:
            # No renombrar archivos .vtt (originales). Solo .txt (limpios).
            if not filename.endswith('.txt'):
                continue
            
            file_path = os.path.join(root, filename)
            base_name, ext = os.path.splitext(filename)
            
            # Si ya es un archivo limpio, trabajamos sobre la parte anterior al sufijo
            is_limpio = base_name.endswith('_limpio')
            temp_name = base_name[:-7] if is_limpio else base_name
            
            last_dash_index = temp_name.rfind('-')
            
            if last_dash_index != -1:
                prefix = temp_name[:last_dash_index]
                if is_limpio:
                    new_filename = f"{prefix}_limpio.txt"
                else:
                    new_filename = f"{prefix}{ext}"
                
                new_path = os.path.join(root, new_filename)
                
                if file_path != new_path:
                    print(f"Renombrando: {filename} -> {new_filename}")
                    try:
                        # Si el destino ya existe, evitamos sobrescribir si son distintos
                        if os.path.exists(new_path):
                            print(f"  [!] El archivo {new_filename} ya existe. Saltando...")
                        else:
                            os.rename(file_path, new_path)
                    except Exception as e:
                        print(f"  [!] Error: {e}")

if __name__ == "__main__":
    rename_files('.TmpFiles')
