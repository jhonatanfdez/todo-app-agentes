#!/bin/bash

################################################################################
# SCRIPT 8 DE 12: EJECUTAR AGENTE #2 (FRONTEND)
# 
# PROPÓSITO:
#   Este script ejecuta Claude Code como agente de frontend.
#   Lee el prompt de prompts/frontend.md y trabaja autónomamente.
#
# QUÉ HACE:
#   1. Verifica Claude Code
#   2. Hace git pull
#   3. Ejecuta Claude Code con prompt de frontend
#   4. Claude trabaja hasta completar una tarea
#   5. Hace commit y push automático
#
# PREREQUISITO: Claude Code instalado
# SE EJECUTA: Múltiples veces (en loop)
# SIGUIENTE PASO: Ejecutar 9-agent-testing.sh
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

################################################################################
# CONFIGURACIÓN
################################################################################
MODEL="claude-sonnet-4-5-20250929"
PROMPT_FILE="prompts/frontend.md"
WORK_DIR="./frontend"

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║                                                            ║${NC}"
    echo -e "${MAGENTA}║        SCRIPT 8/12: AGENTE #2 - FRONTEND                  ║${NC}"
    echo -e "${MAGENTA}║                                                            ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
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

function check_work_directory() {
    echo -e "${BLUE}🔍 Verificando directorio...${NC}"
    if [ ! -d "$WORK_DIR" ]; then
        echo -e "${RED}✗ ERROR: $WORK_DIR no existe${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Directorio encontrado${NC}"
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
    echo -e "${GREEN}║          🤖 INICIANDO AGENTE #2 - FRONTEND                ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}⚙️  Configuración:${NC}"
    echo -e "${BLUE}   Modelo:     $MODEL${NC}"
    echo -e "${BLUE}   Prompt:     $PROMPT_FILE${NC}"
    echo -e "${BLUE}   Directorio: $WORK_DIR${NC}"
    echo ""
    echo -e "${YELLOW}▶ Ejecutando Claude Code...${NC}"
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    claude-code \
        --model "$MODEL" \
        --prompt-file "$PROMPT_FILE" \
        --directory "$WORK_DIR"
    
    local exit_code=$?
    
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Agente #2 completó su trabajo${NC}"
    else
        echo -e "${YELLOW}⚠ Código de salida: $exit_code${NC}"
    fi
    echo ""
}

function show_agent_work() {
    echo -e "${BLUE}📊 Cambios del agente:${NC}"
    echo ""
    git log --oneline -3
    echo ""
    git status --short
    echo ""
}

function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ AGENTE #2 TERMINÓ SU TRABAJO               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE AGENTE:${NC}"
    echo -e "   ../9-agent-testing.sh"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_claude_code
check_prompt_file
check_work_directory
git_pull_latest
run_claude_code
show_agent_work
show_summary

exit 0
