#!/bin/bash

################################################################################
# SCRIPT 1 DE 12: CLONAR REPOSITORIO Y CONFIGURAR GIT
# 
# PROPÓSITO:
#   Este script SOLO se encarga de clonar el repositorio de GitHub y
#   configurar Git localmente. No instala nada, solo prepara Git.
#
# QUÉ HACE:
#   1. Clona tu repositorio desde GitHub
#   2. Configura tu nombre y email para los commits
#   3. Verifica que todo esté correcto
#
# SE EJECUTA: Una sola vez al inicio del proyecto
# SIGUIENTE PASO: Ejecutar 2-crear-estructura.sh
################################################################################

# Colores para mensajes en terminal (hace más fácil leer)
GREEN='\033[0;32m'   # Verde = éxito
YELLOW='\033[1;33m'  # Amarillo = advertencia
BLUE='\033[0;34m'    # Azul = información
RED='\033[0;31m'     # Rojo = error
NC='\033[0m'         # Sin color (reset)

################################################################################
# DATOS PRECARGADOS (tus datos personales)
################################################################################

# URL de tu repositorio en GitHub
# Este es el repo que creaste: https://github.com/jhonatanfdez/todo-app-agentes
REPO_URL="https://github.com/jhonatanfdez/todo-app-agentes.git"

# Tu nombre completo (aparecerá en los commits)
GIT_NAME="Jhonatan Fernandez"

# Tu email de GitHub (debe coincidir con tu cuenta de GitHub)
GIT_EMAIL="jhonatandavidfernandezr@gmail.com"

# Nombre de la carpeta donde se clonará el proyecto
# Por defecto: todo-app-agentes (mismo nombre que el repo)
PROJECT_DIR="todo-app-agentes"

################################################################################
# FUNCIÓN: Mostrar banner inicial
################################################################################
function show_banner() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║        SCRIPT 1/12: CLONAR REPOSITORIO Y CONFIG GIT       ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar si Git está instalado
################################################################################
function check_git_installed() {
    echo -e "${BLUE}🔍 Verificando si Git está instalado...${NC}"
    
    # El comando 'which git' busca si el programa 'git' existe en el sistema
    if ! command -v git &> /dev/null; then
        echo -e "${RED}✗ ERROR: Git no está instalado${NC}"
        echo -e "${YELLOW}Por favor instala Git primero:${NC}"
        echo -e "   sudo apt update"
        echo -e "   sudo apt install git"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Git está instalado correctamente${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar si la carpeta ya existe
################################################################################
function check_project_exists() {
    echo -e "${BLUE}🔍 Verificando si el proyecto ya existe...${NC}"
    
    # El flag -d verifica si el directorio existe
    if [ -d "$PROJECT_DIR" ]; then
        echo -e "${YELLOW}⚠ La carpeta '$PROJECT_DIR' ya existe${NC}"
        echo -e "${YELLOW}¿Quieres eliminarla y empezar de nuevo? (s/n)${NC}"
        read -r respuesta
        
        # Convierte la respuesta a minúsculas para comparar
        if [[ "$respuesta" =~ ^[Ss]$ ]]; then
            echo -e "${BLUE}🗑️  Eliminando carpeta existente...${NC}"
            rm -rf "$PROJECT_DIR"
            echo -e "${GREEN}✓ Carpeta eliminada${NC}"
        else
            echo -e "${RED}✗ Abortando. Por favor renombra o elimina la carpeta manualmente${NC}"
            exit 1
        fi
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Clonar el repositorio
################################################################################
function clone_repository() {
    echo -e "${BLUE}📦 Clonando repositorio desde GitHub...${NC}"
    echo -e "${BLUE}   Repositorio: $REPO_URL${NC}"
    echo ""
    
    # git clone descarga todo el repositorio desde GitHub
    # Si falla, muestra el error y sale del script
    if ! git clone "$REPO_URL" "$PROJECT_DIR"; then
        echo -e "${RED}✗ ERROR: No se pudo clonar el repositorio${NC}"
        echo -e "${YELLOW}Verifica que:${NC}"
        echo -e "   1. La URL del repositorio es correcta"
        echo -e "   2. Tienes conexión a Internet"
        echo -e "   3. Tienes permisos para acceder al repositorio"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Repositorio clonado exitosamente${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Configurar Git local
################################################################################
function configure_git() {
    echo -e "${BLUE}⚙️  Configurando Git local...${NC}"
    
    # Entramos a la carpeta del proyecto
    cd "$PROJECT_DIR" || exit 1
    
    # Configuramos el nombre que aparecerá en los commits
    # --local significa que esta configuración SOLO aplica a este proyecto
    git config --local user.name "$GIT_NAME"
    echo -e "${GREEN}   ✓ Nombre configurado: $GIT_NAME${NC}"
    
    # Configuramos el email que aparecerá en los commits
    git config --local user.email "$GIT_EMAIL"
    echo -e "${GREEN}   ✓ Email configurado: $GIT_EMAIL${NC}"
    
    echo ""
}

################################################################################
# FUNCIÓN: Verificar configuración de Git
################################################################################
function verify_git_config() {
    echo -e "${BLUE}🔍 Verificando configuración de Git...${NC}"
    
    # Leemos la configuración que acabamos de establecer
    local configured_name=$(git config --local user.name)
    local configured_email=$(git config --local user.email)
    
    echo -e "${GREEN}   ✓ Nombre:  $configured_name${NC}"
    echo -e "${GREEN}   ✓ Email:   $configured_email${NC}"
    echo -e "${GREEN}   ✓ Branch:  $(git branch --show-current)${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Mostrar resumen final
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✅ SCRIPT 1 COMPLETADO                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 RESUMEN:${NC}"
    echo -e "${GREEN}   ✓ Repositorio clonado en: ./$PROJECT_DIR${NC}"
    echo -e "${GREEN}   ✓ Git configurado con tus datos${NC}"
    echo -e "${GREEN}   ✓ Listo para el siguiente paso${NC}"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE PASO:${NC}"
    echo -e "   cd $PROJECT_DIR"
    echo -e "   ../2-crear-estructura.sh"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL DEL SCRIPT
################################################################################

# Ejecutar funciones en orden
show_banner                 # Mostrar título
check_git_installed        # Verificar que Git esté instalado
check_project_exists       # Verificar si ya existe la carpeta
clone_repository           # Clonar desde GitHub
configure_git              # Configurar nombre y email
verify_git_config          # Verificar que todo quedó bien
show_summary               # Mostrar resumen

# Fin del script - éxito
exit 0
