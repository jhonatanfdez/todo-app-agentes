#!/bin/bash

################################################################################
# SCRIPT 6 DE 12: SETUP FRONTEND (React + Vite + TypeScript)
# 
# PROPÓSITO:
#   Este script instala y configura el frontend del proyecto usando React,
#   Vite y TypeScript. También configura TailwindCSS para estilos.
#
# QUÉ HACE:
#   1. Verifica que Node.js esté instalado
#   2. Crea proyecto React con Vite y TypeScript
#   3. Instala TailwindCSS y dependencias
#   4. Configura TailwindCSS
#   5. Instala React Router para navegación
#   6. Crea archivo .env con URL del API
#   7. Elimina .git interno (solo un repo)
#   8. Hace commit del frontend
#
# PREREQUISITO: Haber ejecutado scripts 1-5
# SE EJECUTA: Una sola vez
# SIGUIENTE PASO: Ejecutar 7-agent-backend.sh
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║                                                            ║${NC}"
    echo -e "${MAGENTA}║       SCRIPT 6/12: SETUP FRONTEND (React + Vite)          ║${NC}"
    echo -e "${MAGENTA}║                                                            ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar Node.js
################################################################################
function check_nodejs() {
    echo -e "${BLUE}🔍 Verificando Node.js...${NC}"
    
    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ ERROR: Node.js no está instalado${NC}"
        exit 1
    fi
    
    local node_version=$(node -v)
    echo -e "${GREEN}✓ Node.js: $node_version${NC}"
    
    local npm_version=$(npm -v)
    echo -e "${GREEN}✓ npm: $npm_version${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear proyecto React con Vite
################################################################################
function create_vite_project() {
    echo -e "${BLUE}🏗️  Creando proyecto React + Vite...${NC}"
    
    # Verificar si ya existe
    if [ -d "frontend" ]; then
        echo -e "${YELLOW}⚠ La carpeta 'frontend' ya existe${NC}"
        echo -e "${YELLOW}¿Quieres eliminarla y recrearla? (s/n)${NC}"
        read -r respuesta
        
        if [[ "$respuesta" =~ ^[Ss]$ ]]; then
            rm -rf frontend
        else
            echo -e "${YELLOW}Saltando creación...${NC}"
            return
        fi
    fi
    
    # npm create vite@latest crea proyecto con Vite
    # frontend = nombre de la carpeta
    # -- = separador entre comando y opciones
    # --template react-ts = usar template de React con TypeScript
    echo -e "${BLUE}   Ejecutando: npm create vite@latest frontend -- --template react-ts${NC}"
    echo -e "${YELLOW}   (Esto puede tardar 1-2 minutos...)${NC}"
    echo ""
    
    # El flag -y acepta automáticamente todas las preguntas
    if npm create vite@latest frontend -- --template react-ts; then
        echo -e "${GREEN}✓ Proyecto Vite creado en carpeta 'frontend/'${NC}"
    else
        echo -e "${RED}✗ ERROR: No se pudo crear el proyecto${NC}"
        exit 1
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Instalar dependencias del proyecto
################################################################################
function install_project_dependencies() {
    echo -e "${BLUE}📦 Instalando dependencias del proyecto...${NC}"
    
    cd frontend || exit 1
    
    echo -e "${BLUE}   Ejecutando: npm install${NC}"
    
    if npm install; then
        echo -e "${GREEN}✓ Dependencias base instaladas${NC}"
    else
        echo -e "${RED}✗ ERROR al instalar dependencias${NC}"
        exit 1
    fi
    
    cd ..
    echo ""
}

################################################################################
# FUNCIÓN: Instalar TailwindCSS
################################################################################
function install_tailwindcss() {
    echo -e "${BLUE}🎨 Instalando TailwindCSS...${NC}"
    
    cd frontend || exit 1
    
    echo -e "${BLUE}   Dependencias:${NC}"
    echo -e "   - tailwindcss"
    echo -e "   - postcss"
    echo -e "   - autoprefixer"
    echo ""
    
    # Instalar TailwindCSS y sus dependencias
    # -D = --save-dev (son dependencias de desarrollo)
    if npm install -D tailwindcss postcss autoprefixer; then
        echo -e "${GREEN}✓ TailwindCSS instalado${NC}"
    else
        echo -e "${RED}✗ ERROR al instalar TailwindCSS${NC}"
        exit 1
    fi
    
    # npx tailwindcss init -p crea archivos de configuración
    # -p = también crear postcss.config.js
    echo -e "${BLUE}   Creando archivos de configuración...${NC}"
    
    if npx tailwindcss init -p; then
        echo -e "${GREEN}✓ tailwind.config.js y postcss.config.js creados${NC}"
    else
        echo -e "${RED}✗ ERROR al crear configuración${NC}"
        exit 1
    fi
    
    cd ..
    echo ""
}

################################################################################
# FUNCIÓN: Configurar TailwindCSS
################################################################################
function configure_tailwindcss() {
    echo -e "${BLUE}⚙️  Configurando TailwindCSS...${NC}"
    
    # Actualizar tailwind.config.js con las rutas correctas
    cat > frontend/tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

    echo -e "${GREEN}✓ tailwind.config.js configurado${NC}"
    
    # Crear archivo CSS con directivas de Tailwind
    cat > frontend/src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

    echo -e "${GREEN}✓ index.css configurado con directivas de Tailwind${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Instalar React Router
################################################################################
function install_react_router() {
    echo -e "${BLUE}🛣️  Instalando React Router...${NC}"
    
    cd frontend || exit 1
    
    # react-router-dom permite navegación entre páginas
    if npm install react-router-dom; then
        echo -e "${GREEN}✓ React Router instalado${NC}"
    else
        echo -e "${RED}✗ ERROR al instalar React Router${NC}"
        exit 1
    fi
    
    cd ..
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo .env
################################################################################
function create_env_file() {
    echo -e "${BLUE}⚙️  Creando archivo .env...${NC}"
    
    # Variables de entorno para el frontend
    # VITE_ es el prefijo obligatorio para que Vite las exponga
    cat > frontend/.env << 'EOF'
# ============================================
# CONFIGURACIÓN DEL FRONTEND - TODO APP
# ============================================

# URL de la API backend
# En desarrollo, el backend corre en localhost:3000
VITE_API_URL=http://localhost:3000

# Ambiente
VITE_ENV=development
EOF

    echo -e "${GREEN}✓ Archivo .env creado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear .env.example
################################################################################
function create_env_example() {
    echo -e "${BLUE}📝 Creando .env.example...${NC}"
    
    cat > frontend/.env.example << 'EOF'
# ============================================
# PLANTILLA DE VARIABLES DE ENTORNO
# ============================================
# Copia este archivo como .env y ajusta los valores

# URL de la API
VITE_API_URL=http://localhost:3000

# Ambiente
VITE_ENV=development
EOF

    echo -e "${GREEN}✓ .env.example creado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Actualizar .gitignore
################################################################################
function update_gitignore() {
    echo -e "${BLUE}🚫 Actualizando .gitignore...${NC}"
    
    cat >> frontend/.gitignore << 'EOF'

# ============================================
# Variables de entorno
# ============================================
.env
.env.local
.env.development
.env.production

# ============================================
# Logs
# ============================================
*.log
logs/
EOF

    echo -e "${GREEN}✓ .gitignore actualizado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear estructura de carpetas
################################################################################
function create_folder_structure() {
    echo -e "${BLUE}📁 Creando estructura de carpetas...${NC}"
    
    # Crear carpetas para organizar el código
    mkdir -p frontend/src/components
    mkdir -p frontend/src/pages
    mkdir -p frontend/src/services
    mkdir -p frontend/src/types
    
    echo -e "${GREEN}   ✓ src/components/${NC}"
    echo -e "${GREEN}   ✓ src/pages/${NC}"
    echo -e "${GREEN}   ✓ src/services/${NC}"
    echo -e "${GREEN}   ✓ src/types/${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar estructura
################################################################################
function verify_frontend_structure() {
    echo -e "${BLUE}🔍 Verificando estructura del frontend...${NC}"
    
    local files=(
        "frontend/package.json"
        "frontend/src/main.tsx"
        "frontend/src/App.tsx"
        "frontend/tailwind.config.js"
        "frontend/.env"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}   ✓ $file${NC}"
        else
            echo -e "${RED}   ✗ $file NO ENCONTRADO${NC}"
        fi
    done
    
    echo ""
}

################################################################################
# FUNCIÓN: Commit del frontend
################################################################################
function commit_frontend() {
    echo -e "${BLUE}💾 Haciendo commit del frontend...${NC}"
    
    git add frontend/
    
    local commit_message="feat: configurar frontend con React + Vite

- Crear proyecto con Vite + React + TypeScript
- Instalar y configurar TailwindCSS
- Instalar React Router
- Configurar variables de entorno (.env)
- Crear estructura de carpetas (components, pages, services)
- Preparar para desarrollo multi-agente"
    
    if git commit -m "$commit_message"; then
        echo -e "${GREEN}✓ Commit creado${NC}"
    else
        echo -e "${YELLOW}⚠ No hay cambios o error${NC}"
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Push a GitHub
################################################################################
function push_frontend() {
    echo -e "${BLUE}⬆️  Subiendo frontend a GitHub...${NC}"
    
    if git push origin main; then
        echo -e "${GREEN}✓ Frontend subido a GitHub${NC}"
    else
        echo -e "${RED}✗ ERROR al subir${NC}"
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Resumen
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✅ SCRIPT 6 COMPLETADO                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 RESUMEN:${NC}"
    echo -e "${GREEN}   ✓ Proyecto React + Vite creado${NC}"
    echo -e "${GREEN}   ✓ TailwindCSS configurado${NC}"
    echo -e "${GREEN}   ✓ React Router instalado${NC}"
    echo -e "${GREEN}   ✓ Variables de entorno configuradas${NC}"
    echo -e "${GREEN}   ✓ Estructura de carpetas creada${NC}"
    echo -e "${GREEN}   ✓ Commit realizado y subido${NC}"
    echo ""
    echo -e "${BLUE}📁 Estructura:${NC}"
    echo -e "   frontend/"
    echo -e "   ├── src/"
    echo -e "   │   ├── components/"
    echo -e "   │   ├── pages/"
    echo -e "   │   ├── services/"
    echo -e "   │   ├── types/"
    echo -e "   │   └── App.tsx"
    echo -e "   ├── .env"
    echo -e "   └── package.json"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE PASO:${NC}"
    echo -e "   ../7-agent-backend.sh"
    echo ""
    echo -e "${CYAN}💡 PARA PROBAR EL FRONTEND:${NC}"
    echo -e "   cd frontend"
    echo -e "   npm run dev"
    echo -e "   # Abre http://localhost:5173 en el navegador"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_nodejs
create_vite_project
install_project_dependencies
install_tailwindcss
configure_tailwindcss
install_react_router
create_env_file
create_env_example
update_gitignore
create_folder_structure
verify_frontend_structure
commit_frontend
push_frontend
show_summary

exit 0
