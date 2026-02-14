#!/bin/bash

################################################################################
# SCRIPT 7 DE 12: EJECUTAR AGENTE #1 (BACKEND)
# 
# PROPÓSITO:
#   Este script ejecuta Claude Code como agente de backend.
#   Lee el prompt de prompts/backend.md y trabaja autónomamente.
#
# QUÉ HACE:
#   1. Verifica que Claude Code esté instalado
#   2. Hace git pull para obtener cambios de otros agentes
#   3. Ejecuta Claude Code con el prompt de backend
#   4. Claude Code trabaja hasta completar una tarea
#   5. Hace commit y push automático
#
# PREREQUISITO: Claude Code instalado y autenticado
# SE EJECUTA: Múltiples veces (en loop)
# SIGUIENTE PASO: Ejecutar 8-agent-frontend.sh
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

# Modelo de Claude a usar (Sonnet 4.5 es rápido y eficiente)
MODEL="claude-sonnet-4-5-20250929"

# Archivo de prompt para este agente
PROMPT_FILE="prompts/backend.md"

# Directorio de trabajo (donde trabajará el agente)
WORK_DIR="./backend"

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║         SCRIPT 7/12: AGENTE #1 - BACKEND                  ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar Claude Code
################################################################################
function check_claude_code() {
    echo -e "${BLUE}🔍 Verificando Claude Code...${NC}"
    
    # Verifica si claude-code está instalado
    if ! command -v claude-code &> /dev/null; then
        echo -e "${RED}✗ ERROR: Claude Code no está instalado${NC}"
        echo -e "${YELLOW}Por favor instala Claude Code primero${NC}"
        echo -e "${YELLOW}Visita: https://docs.claude.com/en/docs/build-with-claude/claude-code${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Claude Code está instalado${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar que el prompt existe
################################################################################
function check_prompt_file() {
    echo -e "${BLUE}🔍 Verificando archivo de prompt...${NC}"
    
    if [ ! -f "$PROMPT_FILE" ]; then
        echo -e "${RED}✗ ERROR: No se encontró $PROMPT_FILE${NC}"
        echo -e "${YELLOW}Asegúrate de haber ejecutado el script 3 primero${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Prompt encontrado: $PROMPT_FILE${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar que existe el directorio de trabajo
################################################################################
function check_work_directory() {
    echo -e "${BLUE}🔍 Verificando directorio de trabajo...${NC}"
    
    if [ ! -d "$WORK_DIR" ]; then
        echo -e "${RED}✗ ERROR: El directorio $WORK_DIR no existe${NC}"
        echo -e "${YELLOW}Asegúrate de haber ejecutado el script 5 primero${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Directorio encontrado: $WORK_DIR${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Hacer git pull antes de empezar
################################################################################
function git_pull_latest() {
    echo -e "${BLUE}⬇️  Obteniendo últimos cambios de GitHub...${NC}"
    
    # git pull trae los cambios que hicieron otros agentes
    if git pull origin main; then
        echo -e "${GREEN}✓ Cambios obtenidos${NC}"
    else
        echo -e "${YELLOW}⚠ Advertencia: git pull falló${NC}"
        echo -e "${YELLOW}Puede que haya conflictos de merge${NC}"
        # No salimos, dejamos que Claude Code lo maneje
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Ejecutar Claude Code
################################################################################
function run_claude_code() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║           🤖 INICIANDO AGENTE #1 - BACKEND                ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}⚙️  Configuración:${NC}"
    echo -e "${BLUE}   Modelo:     $MODEL${NC}"
    echo -e "${BLUE}   Prompt:     $PROMPT_FILE${NC}"
    echo -e "${BLUE}   Directorio: $WORK_DIR${NC}"
    echo ""
    echo -e "${YELLOW}▶ Ejecutando Claude Code...${NC}"
    echo -e "${YELLOW}  (El agente trabajará autónomamente hasta completar una tarea)${NC}"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # claude-code ejecuta Claude con el prompt
    # --model: qué modelo usar
    # --prompt-file: archivo con las instrucciones
    # --directory: dónde trabajar
    claude-code \
        --model "$MODEL" \
        --prompt-file "$PROMPT_FILE" \
        --directory "$WORK_DIR"
    
    # Capturamos el código de salida
    local exit_code=$?
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Agente #1 completó su trabajo${NC}"
    else
        echo -e "${YELLOW}⚠ Agente #1 terminó con código de salida: $exit_code${NC}"
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Mostrar lo que hizo el agente
################################################################################
function show_agent_work() {
    echo -e "${BLUE}📊 Cambios realizados por el agente:${NC}"
    echo ""
    
    # Mostrar últimos commits (el agente debería haber hecho commit)
    echo -e "${BLUE}Últimos commits:${NC}"
    git log --oneline -3
    
    echo ""
    
    # Mostrar archivos modificados (si quedó algo sin commitear)
    echo -e "${BLUE}Estado de Git:${NC}"
    git status --short
    
    echo ""
}

################################################################################
# FUNCIÓN: Resumen
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ AGENTE #1 TERMINÓ SU TRABAJO               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE AGENTE:${NC}"
    echo -e "   ../8-agent-frontend.sh"
    echo ""
    echo -e "${BLUE}💡 TIP:${NC}"
    echo -e "   Puedes ejecutar este script múltiples veces"
    echo -e "   Cada ejecución completará una tarea de la lista TODO.md"
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
