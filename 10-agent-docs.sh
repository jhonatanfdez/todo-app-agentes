#!/bin/bash

################################################################################
# SCRIPT 10 DE 12: EJECUTAR AGENTE #4 (DOCUMENTATION)
# 
# PROPÓSITO:
#   Este script ejecuta Claude Code como agente de documentación.
#   Lee el prompt de prompts/docs.md y documenta el proyecto.
#
# QUÉ HACE:
#   1. Verifica Claude Code
#   2. Hace git pull
#   3. Ejecuta Claude Code con prompt de documentación
#   4. Claude documenta endpoints, crea guías, actualiza README
#   5. Hace commit y push
#
# NOTA IMPORTANTE:
#   Este agente NO debe ejecutarse inmediatamente.
#   Debe esperar ~30-45 minutos hasta que haya features completas.
#
# PREREQUISITO: Claude Code instalado, features completas (backend + frontend)
# SE EJECUTA: Cuando hay módulos completos
# SIGUIENTE PASO: Volver a ejecutar agentes en ciclo
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
PROMPT_FILE="prompts/docs.md"
WORK_DIR="."  # Docs trabaja en la raíz

################################################################################
# FUNCIÓN: Banner
################################################################################
function show_banner() {
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║                                                            ║${NC}"
    echo -e "${MAGENTA}║      SCRIPT 10/12: AGENTE #4 - DOCUMENTATION              ║${NC}"
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

################################################################################
# FUNCIÓN: Verificar que hay features para documentar
################################################################################
function check_features_ready() {
    echo -e "${BLUE}🔍 Verificando features completas...${NC}"
    
    # Leer PROGRESS.md para ver qué se ha hecho
    if [ ! -f "tasks/PROGRESS.md" ]; then
        echo -e "${YELLOW}   ⚠ PROGRESS.md no encontrado${NC}"
        return
    fi
    
    # Contar líneas en PROGRESS.md (excluyendo headers)
    local progress_lines=$(grep -c "AGENTE-" tasks/PROGRESS.md 2>/dev/null || echo 0)
    
    if [ "$progress_lines" -lt 5 ]; then
        echo ""
        echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║                     ⚠ ADVERTENCIA                          ║${NC}"
        echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}Parece que aún no hay muchas features completas.${NC}"
        echo -e "${YELLOW}Este agente debería ejecutarse DESPUÉS de que:${NC}"
        echo -e "${YELLOW}  1. Backend tenga al menos un módulo completo${NC}"
        echo -e "${YELLOW}  2. Frontend tenga páginas funcionando${NC}"
        echo -e "${YELLOW}  3. Haya tests pasando${NC}"
        echo ""
        echo -e "${BLUE}Progreso actual:${NC}"
        echo -e "${BLUE}  Líneas en PROGRESS.md: $progress_lines${NC}"
        echo ""
        echo -e "${YELLOW}¿Quieres continuar de todas formas? (s/n)${NC}"
        read -r respuesta
        
        if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
            echo -e "${YELLOW}Ejecución cancelada. Ejecuta este script más tarde.${NC}"
            exit 0
        fi
    else
        echo -e "${GREEN}   ✓ Hay $progress_lines tareas completadas${NC}"
        echo -e "${GREEN}   ✓ Suficiente contenido para documentar${NC}"
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
    echo -e "${GREEN}║        🤖 INICIANDO AGENTE #4 - DOCUMENTATION             ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}⚙️  Configuración:${NC}"
    echo -e "${BLUE}   Modelo:     $MODEL${NC}"
    echo -e "${BLUE}   Prompt:     $PROMPT_FILE${NC}"
    echo -e "${BLUE}   Directorio: $WORK_DIR${NC}"
    echo ""
    echo -e "${YELLOW}▶ Ejecutando Claude Code...${NC}"
    echo -e "${YELLOW}  (El agente documentará features completas)${NC}"
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
        echo -e "${GREEN}✓ Agente #4 completó su trabajo${NC}"
    else
        echo -e "${YELLOW}⚠ Código de salida: $exit_code${NC}"
    fi
    echo ""
}

function show_agent_work() {
    echo -e "${BLUE}📊 Documentación creada:${NC}"
    echo ""
    git log --oneline -3
    echo ""
    git status --short
    echo ""
    
    # Mostrar archivos de documentación creados
    echo -e "${BLUE}📚 Archivos de documentación:${NC}"
    if [ -d "docs" ]; then
        ls -la docs/ 2>/dev/null | grep -v "^total" | grep -v "^\.$" | grep -v "^\.\.$"
    fi
    echo ""
}

function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ AGENTE #4 TERMINÓ SU TRABAJO               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 CICLO DE AGENTES COMPLETADO${NC}"
    echo ""
    echo -e "${YELLOW}📍 OPCIONES:${NC}"
    echo -e "   1. Volver a ejecutar agentes en orden (7 → 8 → 9 → 10)"
    echo -e "   2. Ejecutar solo los agentes que tengan tareas pendientes"
    echo -e "   3. Revisar el progreso en: tasks/TODO.md y tasks/PROGRESS.md"
    echo ""
    echo -e "${BLUE}💡 TIP:${NC}"
    echo -e "   Puedes crear un loop automático ejecutando los 4 agentes"
    echo -e "   en secuencia hasta que todas las tareas estén completas."
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL
################################################################################

show_banner
check_claude_code
check_prompt_file
check_features_ready    # Verifica que haya contenido
git_pull_latest
run_claude_code
show_agent_work
show_summary

exit 0
