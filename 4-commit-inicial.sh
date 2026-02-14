#!/bin/bash

################################################################################
# SCRIPT 4 DE 12: COMMIT INICIAL DE LA ESTRUCTURA
# 
# PROPÓSITO:
#   Este script hace el primer commit al repositorio con toda la estructura
#   base del proyecto (carpetas, archivos .md, prompts, etc.)
#
# QUÉ HACE:
#   1. Verifica que todos los archivos estén creados
#   2. Agrega todos los archivos a Git
#   3. Hace commit con mensaje descriptivo
#   4. Sube los cambios a GitHub
#
# PREREQUISITO: Haber ejecutado scripts 1, 2 y 3
# SE EJECUTA: Una sola vez, después del script 3
# SIGUIENTE PASO: Ejecutar 5-setup-backend.sh
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

################################################################################
# FUNCIÓN: Mostrar banner
################################################################################
function show_banner() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║         SCRIPT 4/12: COMMIT INICIAL DEL PROYECTO          ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar que estamos en el repo
################################################################################
function check_git_repo() {
    echo -e "${BLUE}🔍 Verificando repositorio Git...${NC}"
    
    if [ ! -d ".git" ]; then
        echo -e "${RED}✗ ERROR: No estás en un repositorio Git${NC}"
        echo -e "${YELLOW}Por favor ejecuta primero: ./1-clonar-repo.sh${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Repositorio Git encontrado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar archivos necesarios
################################################################################
function verify_required_files() {
    echo -e "${BLUE}🔍 Verificando que todos los archivos estén creados...${NC}"
    
    # Array de archivos que deben existir
    local required_files=(
        "tasks/TODO.md"
        "tasks/PROGRESS.md"
        "prompts/backend.md"
        "prompts/frontend.md"
        "prompts/testing.md"
        "prompts/docs.md"
        ".gitignore"
        "README.md"
    )
    
    local all_exist=true
    
    # Verificar cada archivo
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}   ✓ $file${NC}"
        else
            echo -e "${RED}   ✗ $file NO ENCONTRADO${NC}"
            all_exist=false
        fi
    done
    
    # Verificar carpetas
    local required_dirs=("tasks/locks" "prompts" "docs")
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "${GREEN}   ✓ $dir/${NC}"
        else
            echo -e "${RED}   ✗ $dir/ NO ENCONTRADA${NC}"
            all_exist=false
        fi
    done
    
    if [ "$all_exist" = false ]; then
        echo -e "${RED}✗ ERROR: Faltan archivos o carpetas${NC}"
        echo -e "${YELLOW}Por favor ejecuta los scripts 2 y 3 primero${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Todos los archivos necesarios existen${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Mostrar estado actual de Git
################################################################################
function show_git_status() {
    echo -e "${BLUE}📊 Estado actual de Git:${NC}"
    echo ""
    
    # git status muestra qué archivos han cambiado
    git status --short
    
    echo ""
}

################################################################################
# FUNCIÓN: Agregar archivos a Git
################################################################################
function add_files_to_git() {
    echo -e "${BLUE}➕ Agregando archivos a Git...${NC}"
    
    # git add -A agrega TODOS los archivos (nuevos, modificados, eliminados)
    git add -A
    
    echo -e "${GREEN}✓ Archivos agregados${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Hacer commit
################################################################################
function commit_changes() {
    echo -e "${BLUE}💾 Creando commit inicial...${NC}"
    
    # Mensaje de commit descriptivo
    local commit_message="chore: estructura inicial del proyecto

- Crear carpetas: tasks/, prompts/, docs/
- Crear archivos de coordinación: TODO.md, PROGRESS.md
- Crear prompts para 4 agentes (backend, frontend, testing, docs)
- Configurar .gitignore
- Crear README.md básico

Preparado para desarrollo multi-agente con Claude Code."
    
    # git commit -m crea el commit con el mensaje
    if git commit -m "$commit_message"; then
        echo -e "${GREEN}✓ Commit creado exitosamente${NC}"
    else
        echo -e "${RED}✗ ERROR: No se pudo crear el commit${NC}"
        echo -e "${YELLOW}Puede que no haya cambios para commitear${NC}"
        exit 1
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Ver el commit creado
################################################################################
function show_commit_info() {
    echo -e "${BLUE}📝 Información del commit:${NC}"
    echo ""
    
    # git log muestra el historial de commits
    # -1 = solo el último commit
    # --oneline = formato corto
    # --stat = muestra archivos modificados
    git log -1 --stat
    
    echo ""
}

################################################################################
# FUNCIÓN: Subir cambios a GitHub
################################################################################
function push_to_github() {
    echo -e "${BLUE}⬆️  Subiendo cambios a GitHub...${NC}"
    
    # Verificar que la rama actual sea 'main'
    local current_branch=$(git branch --show-current)
    
    if [ "$current_branch" != "main" ]; then
        echo -e "${YELLOW}⚠ Advertencia: Estás en la rama '$current_branch', no en 'main'${NC}"
        echo -e "${YELLOW}¿Quieres continuar de todas formas? (s/n)${NC}"
        read -r respuesta
        
        if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
            echo -e "${YELLOW}Push cancelado${NC}"
            exit 0
        fi
    fi
    
    # git push sube los cambios a GitHub
    # origin = nombre del remote (GitHub)
    # main = nombre de la rama
    echo -e "${BLUE}   Subiendo a: origin/$current_branch${NC}"
    
    if git push origin "$current_branch"; then
        echo -e "${GREEN}✓ Cambios subidos exitosamente a GitHub${NC}"
    else
        echo -e "${RED}✗ ERROR: No se pudieron subir los cambios${NC}"
        echo -e "${YELLOW}Verifica tu conexión a Internet y permisos del repositorio${NC}"
        exit 1
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Ver estado final
################################################################################
function show_final_status() {
    echo -e "${BLUE}🔍 Estado final del repositorio:${NC}"
    echo ""
    
    # git status debe mostrar "nothing to commit, working tree clean"
    git status
    
    echo ""
}

################################################################################
# FUNCIÓN: Mostrar resumen
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✅ SCRIPT 4 COMPLETADO                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 RESUMEN:${NC}"
    echo -e "${GREEN}   ✓ Todos los archivos agregados a Git${NC}"
    echo -e "${GREEN}   ✓ Commit inicial creado${NC}"
    echo -e "${GREEN}   ✓ Cambios subidos a GitHub${NC}"
    echo ""
    echo -e "${BLUE}🌐 Tu repositorio en GitHub:${NC}"
    echo -e "   https://github.com/jhonatanfdez/todo-app-agentes"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE PASO:${NC}"
    echo -e "   ../5-setup-backend.sh"
    echo ""
    echo -e "${BLUE}ℹ️  NOTA:${NC}"
    echo -e "   Ahora la estructura base está en GitHub."
    echo -e "   Los siguientes scripts instalarán backend y frontend."
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_git_repo
verify_required_files
show_git_status
add_files_to_git
commit_changes
show_commit_info
push_to_github
show_final_status
show_summary

exit 0
