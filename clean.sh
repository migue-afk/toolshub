#!/bin/bash

echo "🔍 Iniciando revisión de privacidad..."

# 1. Limpiar metadatos de imágenes y PDFs
echo "🧼 Limpiando metadatos de imágenes y PDFs..."
find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.pdf" \) -exec exiftool -overwrite_original -all= {} \;

# 2. Buscar patrones sensibles en archivos de texto
echo "🕵️ Buscando datos sensibles..."
SENSITIVE=$(grep -riE "(apikey|token|secret|password|correo|email|clave|usuario|user)" . --exclude-dir={.git,node_modules,venv,__pycache__} --exclude=*.{png,jpg,jpeg,pdf} 2>/dev/null)

if [[ -n "$SENSITIVE" ]]; then
    echo "⚠️ Posibles datos sensibles encontrados:"
    echo "$SENSITIVE"
else
    echo "✅ No se encontraron datos sensibles evidentes en texto."
fi

# 3. Archivos que deberían ser ignorados
echo "📁 Verificando archivos sensibles que podrían estar en staging..."
SENSITIVE_FILES=(".env" ".env.local" "config.json" "settings.py")

for file in "${SENSITIVE_FILES[@]}"; do
    if git ls-files --others --exclude-standard | grep -q "$file"; then
        echo "⚠️ Archivo potencialmente sensible no está ignorado: $file"
    fi
done

# 4. Sugerencia de .gitignore si no existe
if [ ! -f ".gitignore" ]; then
    echo "📄 No se encontró archivo .gitignore. Se sugiere crear uno con al menos:"
    cat <<EOL
# Sugerencia mínima de .gitignore

*.env
*.log
__pycache__/
node_modules/
.DS_Store
*.sqlite3
*.pem
*.key
EOL
fi

echo "✅ Revisión de privacidad finalizada. Revisa cualquier advertencia antes de hacer commit."

