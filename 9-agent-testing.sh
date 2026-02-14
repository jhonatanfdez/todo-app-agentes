#!/bin/bash

################################################################################
# SCRIPT 9 DE 12: EJECUTAR AGENTE #3 (TESTING)
# 
# PROPÓSITO:
#   Este script ejecuta Claude Code como agente de testing.
#   Lee el prompt de prompts/testing.md y crea tests para el código existente.
#
# QUÉ HACE:
#   1. Verifica Claude Code
#   2. Hace git pull
#   3. Ejecuta Claude Code con prompt de testing
#   4. Claude crea tests unitarios y E2E
#   5. Ejecuta los tests para verificar que pasen
#   6. Hace commit y push
#
# NOTA IMPORTANTE:
#   Este agente NO debe ejecutarse inmediatamente.
#   Debe esperar ~10-15 minutos hasta que haya código para testear.
#
# PREREQUISITO: Claude Code instalado, código de backend/frontend creado
# SE EJECUTA: Después que haya algo de código
# SIGUIENTE PASO: Ejecutar 10-agent-docs.sh
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

################################################################################
# CONFIGURACIÓN
################################################################################
MODEL="claude-sonnet-4-5-20250929"
PROMPT_FILE="prompts/testing.md"
WORK_DIR="."  # Testing trabaja en la raíz (testea backend y frontend)

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║        SCRIPT 9/12: AGENTE #3 - TESTING                   ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

function check_claude_code() {
    echo -e "${BLUE}🔍 Verificando Claude Code...${NC}"
    if ! command -v claude-code &> /dev/null; then
        echo -e "${RED}✗ ERROR: Claude Code no instalado${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Claude Code está instalado${NC}"
    echo ""
}

function check_prompt_file() {
    echo -e "${BLUE}🔍 Verificando prompt...${NC}"
    if [ ! -f "$PROMPT_FILE" ]; then
        echo -e "${RED}✗ ERROR: No se encontró $PROMPT_FILE${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Prompt encontrado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar que hay código para testear
################################################################################
function check_code_exists() {
    echo -e "${BLUE}🔍 Verificando que exista código para testear...${NC}"
    
    local has_backend=false
    local has_frontend=false
    
    # Verificar si hay código en backend/src
    if [ -d "backend/src" ] && [ "$(ls -A backend/src 2>/dev/null | wc -l)" -gt 5 ]; then
        has_backend=true
        echo -e "${GREEN}   ✓ Backend tiene código${NC}"
    else
        echo -e "${YELLOW}   ⚠ Backend aún no tiene mucho código${NC}"
    fi
    
    # Verificar si hay código en frontend/src
    if [ -d "frontend/src" ] && [ "$(ls -A frontend/src 2>/dev/null | wc -l)" -gt 5 ]; then
        has_frontend=true
        echo -e "${GREEN}   ✓ Frontend tiene código${NC}"
    else
        echo -e "${YELLOW}   ⚠ Frontend aún no tiene mucho código${NC}"
    fi
    
    # Si ninguno tiene código, advertir
    if [ "$has_backend" = false ] && [ "$has_frontend" = false ]; then
        echo ""
        echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║                     ⚠ ADVERTENCIA                          ║${NC}"
        echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}No hay suficiente código para testear todavía.${NC}"
        echo -e "${YELLOW}Este agente debería ejecutarse DESPUÉS de que:${NC}"
        echo -e "${YELLOW}  1. Agente #1 (Backend) haya creado al menos un módulo${NC}"
        echo -e "${YELLOW}  2. Agente #2 (Frontend) haya creado algunos componentes${NC}"
        echo ""
        echo -e "${YELLOW}¿Quieres continuar de todas formas? (s/n)${NC}"
        read -r respuesta
        
        if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
            echo -e "${YELLOW}Ejecución cancelada. Ejecuta este script más tarde.${NC}"
            exit 0
        fi
    fi
    
    echo ""
}

function git_pull_latest() {
    echo -e "${BLUE}⬇️  Obteniendo cambios de GitHub...${NC}"
    if git pull origin main; then
        echo -e "${GREEN}✓ Cambios obtenidos${NC}"
    else
        echo -e "${YELLOW}⚠ Advertencia: git pull falló${NC}"
    fi
    echo ""
}

function run_claude_code() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║          🤖 INICIANDO AGENTE #3 - TESTING                 ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}⚙️  Configuración:${NC}"
    echo -e "${BLUE}   Modelo:     $MODEL${NC}"
    echo -e "${BLUE}   Prompt:     $PROMPT_FILE${NC}"
    echo -e "${BLUE}   Directorio: $WORK_DIR${NC}"
    echo ""
    echo -e "${YELLOW}▶ Ejecutando Claude Code...${NC}"
    echo -e "${YELLOW}  (El agente creará tests para el código existente)${NC}"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    claude-code \
        --model "$MODEL" \
        --prompt-file "$PROMPT_FILE" \
        --directory "$WORK_DIR"
    
    local exit_code=$?
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Agente #3 completó su trabajo${NC}"
    else
        echo -e "${YELLOW}⚠ Código de salida: $exit_code${NC}"
    fi
    echo ""
}

function show_agent_work() {
    echo -e "${BLUE}📊 Tests creados:${NC}"
    echo ""
    git log --oneline -3
    echo ""
    git status --short
    echo ""
}

function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ AGENTE #3 TERMINÓ SU TRABAJO               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE AGENTE:${NC}"
    echo -e "   ../10-agent-docs.sh"
    echo ""
    echo -e "${BLUE}💡 TIP:${NC}"
    echo -e "   Para ejecutar los tests creados:"
    echo -e "   cd backend && npm test"
    echo -e "   cd frontend && npm test"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_claude_code
check_prompt_file
check_code_exists    # Verifica que haya código
git_pull_latest
run_claude_code
show_agent_work
show_summary

exit 0
