#!/bin/bash

################################################################################
# SCRIPT 11 DE 12: HELPER - WAIT FOR SHARED FILES
# 
# PROPÓSITO:
#   Este es un script helper que usan los agentes para coordinar
#   el acceso a archivos compartidos (TODO.md, PROGRESS.md).
#   Implementa un sistema de locks para evitar conflictos.
#
# QUÉ HACE:
#   1. Verifica si un archivo compartido está bloqueado
#   2. Si está bloqueado, espera hasta que se libere
#   3. Una vez libre, crea un nuevo lock para el agente actual
#   4. Permite que el agente modifique el archivo de forma segura
#
# CÓMO SE USA:
#   source 11-wait-shared-files.sh
#   wait_for_file "TODO.md" "AGENTE-1-BACKEND"
#
# PREREQUISITO: Ninguno (es un helper)
# SE EJECUTA: Lo llaman otros scripts
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Directorio donde se guardan los locks
LOCKS_DIR="tasks/locks"

# Tiempo máximo de espera (en segundos) = 5 minutos
MAX_WAIT_TIME=300

# Intervalo entre intentos (en segundos)
RETRY_INTERVAL=2

################################################################################
# FUNCIÓN: Esperar que un archivo compartido esté disponible
################################################################################
# Parámetros:
#   $1 = nombre del archivo (ej: "TODO.md")
#   $2 = nombre del agente (ej: "AGENTE-1-BACKEND")
################################################################################
function wait_for_file() {
    local file_name="$1"
    local agent_name="$2"
    
    # Validar parámetros
    if [ -z "$file_name" ] || [ -z "$agent_name" ]; then
        echo -e "${RED}✗ ERROR: Parámetros faltantes${NC}"
        echo -e "${YELLOW}Uso: wait_for_file <archivo> <agente>${NC}"
        return 1
    fi
    
    # Crear directorio de locks si no existe
    mkdir -p "$LOCKS_DIR"
    
    # Nombre del archivo lock
    # Ejemplo: TODO.md -> tasks/locks/TODO.md.lock
    local lock_file="${LOCKS_DIR}/${file_name}.lock"
    
    # Contador de tiempo esperado
    local elapsed_time=0
    
    echo -e "${BLUE}🔒 Esperando acceso a: $file_name${NC}"
    
    # Loop: intentar obtener el lock
    while true; do
        # Verificar si el lock existe
        if [ ! -f "$lock_file" ]; then
            # Lock NO existe → archivo disponible
            # Crear lock inmediatamente
            create_lock "$file_name" "$agent_name"
            echo -e "${GREEN}✓ Lock obtenido para: $file_name${NC}"
            return 0
        fi
        
        # Lock SÍ existe → archivo ocupado
        # Verificar quién tiene el lock
        local lock_owner=$(cat "$lock_file" 2>/dev/null | grep "AGENTE:" | cut -d':' -f2 | xargs)
        
        echo -e "${YELLOW}⏳ Archivo bloqueado por: $lock_owner (esperando...)${NC}"
        
        # Esperar el intervalo de reintentos
        sleep "$RETRY_INTERVAL"
        elapsed_time=$((elapsed_time + RETRY_INTERVAL))
        
        # Verificar timeout
        if [ "$elapsed_time" -ge "$MAX_WAIT_TIME" ]; then
            echo -e "${RED}✗ ERROR: Timeout esperando lock de $file_name${NC}"
            echo -e "${YELLOW}El archivo estuvo bloqueado por más de $MAX_WAIT_TIME segundos${NC}"
            echo -e "${YELLOW}Puede que el otro agente haya fallado${NC}"
            
            # Opción: forzar liberación (peligroso)
            echo -e "${YELLOW}¿Quieres forzar la liberación del lock? (s/n)${NC}"
            read -r respuesta
            
            if [[ "$respuesta" =~ ^[Ss]$ ]]; then
                rm -f "$lock_file"
                echo -e "${YELLOW}Lock forzado a liberar${NC}"
                create_lock "$file_name" "$agent_name"
                return 0
            else
                return 1
            fi
        fi
    done
}

################################################################################
# FUNCIÓN: Crear un lock para un archivo
################################################################################
function create_lock() {
    local file_name="$1"
    local agent_name="$2"
    local lock_file="${LOCKS_DIR}/${file_name}.lock"
    
    # Crear archivo lock con información del agente
    cat > "$lock_file" << EOF
AGENTE: $agent_name
ARCHIVO: $file_name
TIMESTAMP: $(date '+%Y-%m-%d %H:%M:%S')
PID: $$
EOF

    # Pequeña pausa para asegurar que el archivo se escribió
    sleep 0.1
}

################################################################################
# FUNCIÓN: Liberar un lock de un archivo
################################################################################
function release_lock() {
    local file_name="$1"
    local lock_file="${LOCKS_DIR}/${file_name}.lock"
    
    if [ -f "$lock_file" ]; then
        rm -f "$lock_file"
        echo -e "${GREEN}🔓 Lock liberado: $file_name${NC}"
    fi
}

################################################################################
# FUNCIÓN: Verificar si un archivo está bloqueado
################################################################################
function is_file_locked() {
    local file_name="$1"
    local lock_file="${LOCKS_DIR}/${file_name}.lock"
    
    if [ -f "$lock_file" ]; then
        return 0  # Está bloqueado
    else
        return 1  # No está bloqueado
    fi
}

################################################################################
# FUNCIÓN: Obtener el dueño de un lock
################################################################################
function get_lock_owner() {
    local file_name="$1"
    local lock_file="${LOCKS_DIR}/${file_name}.lock"
    
    if [ -f "$lock_file" ]; then
        cat "$lock_file" | grep "AGENTE:" | cut -d':' -f2 | xargs
    else
        echo "NINGUNO"
    fi
}

################################################################################
# FUNCIÓN: Limpiar locks viejos (por si un agente falló)
################################################################################
function cleanup_old_locks() {
    echo -e "${BLUE}🧹 Limpiando locks viejos...${NC}"
    
    # Buscar locks más viejos de 10 minutos
    find "$LOCKS_DIR" -name "*.lock" -type f -mmin +10 -delete
    
    echo -e "${GREEN}✓ Locks viejos limpiados${NC}"
}

################################################################################
# EJEMPLO DE USO
################################################################################
# Este script se usa con 'source' en otros scripts:
#
# source 11-wait-shared-files.sh
#
# # Esperar y obtener lock de TODO.md
# wait_for_file "TODO.md" "AGENTE-1-BACKEND"
#
# # Modificar el archivo de forma segura
# echo "Nueva tarea" >> tasks/TODO.md
#
# # Liberar el lock
# release_lock "TODO.md"

################################################################################
# Si se ejecuta directamente (no con source), mostrar ayuda
################################################################################
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║       SCRIPT 11/12: HELPER - WAIT FOR SHARED FILES        ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}⚠ Este es un script HELPER${NC}"
    echo -e "${YELLOW}No debe ejecutarse directamente.${NC}"
    echo ""
    echo -e "${BLUE}USO CORRECTO:${NC}"
    echo -e "   En otro script:"
    echo -e "   ${GREEN}source 11-wait-shared-files.sh${NC}"
    echo -e "   ${GREEN}wait_for_file \"TODO.md\" \"AGENTE-1-BACKEND\"${NC}"
    echo -e "   ${GREEN}# ... modificar archivo ...${NC}"
    echo -e "   ${GREEN}release_lock \"TODO.md\"${NC}"
    echo ""
    echo -e "${BLUE}FUNCIONES DISPONIBLES:${NC}"
    echo -e "   • wait_for_file <archivo> <agente>"
    echo -e "   • release_lock <archivo>"
    echo -e "   • is_file_locked <archivo>"
    echo -e "   • get_lock_owner <archivo>"
    echo -e "   • cleanup_old_locks"
    echo ""
fi
