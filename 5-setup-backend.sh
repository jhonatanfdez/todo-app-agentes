#!/bin/bash

################################################################################
# SCRIPT 5 DE 12: SETUP BACKEND (NestJS + PostgreSQL)
# 
# PROPÓSITO:
#   Este script instala y configura el backend del proyecto usando NestJS.
#   Crea la estructura base, instala dependencias y configura la base de datos.
#
# QUÉ HACE:
#   1. Verifica que Node.js esté instalado
#   2. Instala NestJS CLI globalmente (si no existe)
#   3. Crea proyecto NestJS en carpeta "backend/"
#   4. Instala dependencias adicionales (TypeORM, JWT, bcrypt, etc.)
#   5. Configura archivo .env con variables de entorno
#   6. Elimina el .git interno (solo queremos un repo Git)
#   7. Hace commit del backend al repo principal
#
# PREREQUISITO: Haber ejecutado scripts 1-4
# SE EJECUTA: Una sola vez
# SIGUIENTE PASO: Ejecutar 6-setup-frontend.sh
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║          SCRIPT 5/12: SETUP BACKEND (NestJS)              ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar Node.js
################################################################################
function check_nodejs() {
    echo -e "${BLUE}🔍 Verificando Node.js...${NC}"
    
    # Verifica si node está instalado
    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ ERROR: Node.js no está instalado${NC}"
        echo -e "${YELLOW}Por favor instala Node.js 18+ desde: https://nodejs.org${NC}"
        exit 1
    fi
    
    # Obtener versión de Node
    local node_version=$(node -v)
    echo -e "${GREEN}✓ Node.js instalado: $node_version${NC}"
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}✗ ERROR: npm no está instalado${NC}"
        exit 1
    fi
    
    local npm_version=$(npm -v)
    echo -e "${GREEN}✓ npm instalado: $npm_version${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Instalar NestJS CLI
################################################################################
function install_nestjs_cli() {
    echo -e "${BLUE}📦 Verificando NestJS CLI...${NC}"
    
    # Verifica si nest CLI ya está instalado
    if command -v nest &> /dev/null; then
        local nest_version=$(nest --version)
        echo -e "${GREEN}✓ NestJS CLI ya instalado: v$nest_version${NC}"
        echo ""
        return
    fi
    
    # Si no está instalado, instalarlo globalmente
    echo -e "${YELLOW}⚠ NestJS CLI no encontrado. Instalando...${NC}"
    
    if npm install -g @nestjs/cli; then
        echo -e "${GREEN}✓ NestJS CLI instalado correctamente${NC}"
    else
        echo -e "${RED}✗ ERROR: No se pudo instalar NestJS CLI${NC}"
        echo -e "${YELLOW}Intenta manualmente: npm install -g @nestjs/cli${NC}"
        exit 1
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Crear proyecto NestJS
################################################################################
function create_nestjs_project() {
    echo -e "${BLUE}🏗️  Creando proyecto NestJS...${NC}"
    
    # Verificar si la carpeta backend ya existe
    if [ -d "backend" ]; then
        echo -e "${YELLOW}⚠ La carpeta 'backend' ya existe${NC}"
        echo -e "${YELLOW}¿Quieres eliminarla y recrearla? (s/n)${NC}"
        read -r respuesta
        
        if [[ "$respuesta" =~ ^[Ss]$ ]]; then
            echo -e "${BLUE}🗑️  Eliminando carpeta existente...${NC}"
            rm -rf backend
        else
            echo -e "${YELLOW}Saltando creación del proyecto...${NC}"
            return
        fi
    fi
    
    # nest new crea un nuevo proyecto
    # --package-manager npm = usar npm (no yarn ni pnpm)
    # --skip-git = no crear .git interno
    echo -e "${BLUE}   Ejecutando: nest new backend --package-manager npm --skip-git${NC}"
    echo -e "${YELLOW}   (Esto puede tardar 2-3 minutos...)${NC}"
    echo ""
    
    if nest new backend --package-manager npm --skip-git; then
        echo -e "${GREEN}✓ Proyecto NestJS creado en carpeta 'backend/'${NC}"
    else
        echo -e "${RED}✗ ERROR: No se pudo crear el proyecto${NC}"
        exit 1
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Instalar dependencias adicionales
################################################################################
function install_dependencies() {
    echo -e "${BLUE}📦 Instalando dependencias adicionales...${NC}"
    
    # Entramos a la carpeta backend
    cd backend || exit 1
    
    echo -e "${BLUE}   Dependencias a instalar:${NC}"
    echo -e "   - TypeORM (ORM para base de datos)"
    echo -e "   - PostgreSQL driver"
    echo -e "   - JWT (autenticación)"
    echo -e "   - bcrypt (hash de contraseñas)"
    echo -e "   - class-validator (validación de DTOs)"
    echo -e "   - class-transformer (transformación de datos)"
    echo -e "   - dotenv (variables de entorno)"
    echo ""
    
    # npm install instala las dependencias en node_modules/
    # Estas son las dependencias necesarias para el proyecto
    if npm install \
        @nestjs/typeorm \
        typeorm \
        pg \
        @nestjs/jwt \
        @nestjs/passport \
        passport \
        passport-jwt \
        bcrypt \
        @nestjs/config \
        class-validator \
        class-transformer; then
        
        echo -e "${GREEN}✓ Dependencias de producción instaladas${NC}"
    else
        echo -e "${RED}✗ ERROR: Fallo al instalar dependencias${NC}"
        exit 1
    fi
    
    echo ""
    
    # Instalar dependencias de desarrollo (types para TypeScript)
    echo -e "${BLUE}📦 Instalando tipos de TypeScript...${NC}"
    
    if npm install --save-dev \
        @types/bcrypt \
        @types/passport-jwt; then
        
        echo -e "${GREEN}✓ Tipos de TypeScript instalados${NC}"
    else
        echo -e "${YELLOW}⚠ Advertencia: No se pudieron instalar algunos tipos${NC}"
    fi
    
    # Volver a la carpeta raíz
    cd ..
    
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo .env
################################################################################
function create_env_file() {
    echo -e "${BLUE}⚙️  Creando archivo .env...${NC}"
    
    # Crear archivo .env con configuración de base de datos
    # Estos son valores por defecto que se pueden cambiar después
    cat > backend/.env << 'EOF'
# ============================================
# CONFIGURACIÓN DEL BACKEND - TODO APP
# ============================================

# ============================================
# Base de Datos PostgreSQL
# ============================================
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=todo_app

# ============================================
# JWT (Autenticación)
# ============================================
# IMPORTANTE: Cambiar en producción por algo secreto y aleatorio
JWT_SECRET=tu_clave_super_secreta_cambiar_en_produccion
JWT_EXPIRATION=1d

# ============================================
# Aplicación
# ============================================
PORT=3000
NODE_ENV=development

# ============================================
# NOTA IMPORTANTE:
# En producción, usa variables de entorno reales
# No subas este archivo a GitHub (ya está en .gitignore)
# ============================================
EOF

    echo -e "${GREEN}✓ Archivo .env creado en backend/.env${NC}"
    echo -e "${YELLOW}⚠ IMPORTANTE: Cambia JWT_SECRET antes de ir a producción${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo .env.example
################################################################################
function create_env_example() {
    echo -e "${BLUE}📝 Creando .env.example...${NC}"
    
    # .env.example es una plantilla que SÍ se sube a GitHub
    # Muestra qué variables se necesitan, sin valores reales
    cat > backend/.env.example << 'EOF'
# ============================================
# PLANTILLA DE VARIABLES DE ENTORNO
# ============================================
# Copia este archivo como .env y completa los valores

# Base de Datos
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_contraseña
DB_DATABASE=nombre_base_datos

# JWT
JWT_SECRET=tu_clave_secreta_aquí
JWT_EXPIRATION=1d

# Aplicación
PORT=3000
NODE_ENV=development
EOF

    echo -e "${GREEN}✓ Archivo .env.example creado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Actualizar .gitignore del backend
################################################################################
function update_backend_gitignore() {
    echo -e "${BLUE}🚫 Actualizando .gitignore del backend...${NC}"
    
    # Agregamos reglas adicionales al .gitignore existente
    cat >> backend/.gitignore << 'EOF'

# ============================================
# Variables de entorno (NUNCA subir a GitHub)
# ============================================
.env
.env.local
.env.development
.env.production

# ============================================
# Base de datos local
# ============================================
*.sqlite
*.db

# ============================================
# Logs
# ============================================
logs/
*.log
EOF

    echo -e "${GREEN}✓ .gitignore actualizado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar estructura del backend
################################################################################
function verify_backend_structure() {
    echo -e "${BLUE}🔍 Verificando estructura del backend...${NC}"
    
    echo -e "${BLUE}Archivos importantes:${NC}"
    
    local files=(
        "backend/package.json"
        "backend/src/main.ts"
        "backend/src/app.module.ts"
        "backend/.env"
        "backend/.env.example"
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
# FUNCIÓN: Hacer commit del backend
################################################################################
function commit_backend() {
    echo -e "${BLUE}💾 Haciendo commit del backend...${NC}"
    
    # Agregar todos los archivos del backend
    git add backend/
    
    # Crear commit
    local commit_message="feat: configurar backend con NestJS

- Instalar NestJS CLI
- Crear proyecto backend
- Instalar dependencias: TypeORM, PostgreSQL, JWT, bcrypt
- Configurar variables de entorno (.env)
- Preparar estructura para desarrollo multi-agente"
    
    if git commit -m "$commit_message"; then
        echo -e "${GREEN}✓ Commit creado${NC}"
    else
        echo -e "${YELLOW}⚠ No hay cambios para commitear (o error)${NC}"
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Push a GitHub
################################################################################
function push_backend() {
    echo -e "${BLUE}⬆️  Subiendo backend a GitHub...${NC}"
    
    if git push origin main; then
        echo -e "${GREEN}✓ Backend subido a GitHub${NC}"
    else
        echo -e "${RED}✗ ERROR al subir a GitHub${NC}"
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Resumen
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✅ SCRIPT 5 COMPLETADO                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 RESUMEN:${NC}"
    echo -e "${GREEN}   ✓ NestJS CLI instalado${NC}"
    echo -e "${GREEN}   ✓ Proyecto backend creado${NC}"
    echo -e "${GREEN}   ✓ Dependencias instaladas${NC}"
    echo -e "${GREEN}   ✓ Variables de entorno configuradas${NC}"
    echo -e "${GREEN}   ✓ Commit realizado y subido a GitHub${NC}"
    echo ""
    echo -e "${BLUE}📁 Estructura creada:${NC}"
    echo -e "   backend/"
    echo -e "   ├── src/"
    echo -e "   ├── node_modules/"
    echo -e "   ├── package.json"
    echo -e "   ├── .env"
    echo -e "   └── .env.example"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE PASO:${NC}"
    echo -e "   ../6-setup-frontend.sh"
    echo ""
    echo -e "${CYAN}💡 PARA PROBAR EL BACKEND:${NC}"
    echo -e "   cd backend"
    echo -e "   npm run start:dev"
    echo -e "   # Abre http://localhost:3000 en el navegador"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_nodejs
install_nestjs_cli
create_nestjs_project
install_dependencies
create_env_file
create_env_example
update_backend_gitignore
verify_backend_structure
commit_backend
push_backend
show_summary

exit 0
