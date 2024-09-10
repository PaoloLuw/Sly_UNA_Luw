import json



# Función para leer el archivo JSON y devolver el contenido como un diccionario
def leer_json("/Sly_UNA_Luw/diccionary_09/09/2024.json"):
    with open(ruta_json, 'r', encoding='utf-8') as archivo:
        datos = json.load(archivo)
    return datos

# Función para convertir el diccionario a una tabla en formato Markdown
def convertir_a_md(diccionario, ruta_md):
    with open(ruta_md, 'w', encoding='utf-8') as archivo_md:
        archivo_md.write("| Palabra en Inglés | Traducción en Español |\n")
        archivo_md.write("|------------------|----------------------|\n")
        for clave, valor in diccionario.items():
            archivo_md.write(f"| {clave} | {valor} |\n")

if __name__ == "__main__":
    # Ruta al archivo JSON
    ruta_json = "ruta/al/archivo/2024.json"
    
    # Leer el JSON
    datos_json = leer_json(ruta_json)
    
    # Convertir a formato Markdown
    ruta_md = "ruta/al/archivo/2024.md"
    convertir_a_md(datos_json, ruta_md)

    print(f"Archivo Markdown generado exitosamente: {ruta_md}")
