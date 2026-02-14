#!/bin/bash

################################################################################
# SCRIPT 12 DE 12: HELPER - RELEASE SHARED FILES
# 
# PROPÓSITO:
#   Este es un script helper complementario al script 11.
#   Proporciona funciones adicionales para manejar locks y limpieza.
#
# QUÉ HACE:
#   1. Libera locks específicos
#   2. Libera todos los locks de un agente
#   3. Limpia locks huérfanos
#   4. Muestra estado de locks
#
# CÓMO SE USA:
#   source 12-release-shared-files.sh
#   release_all_agent_locks "AGENTE-1-BACKEND"
#
# PREREQUISITO: Script 11 (funciones base)
# SE EJECUTA: Lo llaman otros scripts
################################################################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Directorio de locks
LOCKS_DIR="tasks/locks"

################################################################################
# FUNCIÓN: Liberar todos los locks de un agente específico
################################################################################
# Útil cuando un agente termina su trabajo y quiere limpiar todos sus locks
################################################################################
function release_all_agent_locks() {
    local agent_name="$1"
    
    if [ -z "$agent_name" ]; then
        echo -e "${RED}✗ ERROR: Nombre de agente requerido${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🧹 Liberando locks de: $agent_name${NC}"
    
    local released_count=0
    
    # Buscar todos los locks en el directorio
    for lock_file in "${LOCKS_DIR}"/*.lock; do
        # Verificar si el archivo existe (evitar error si no hay locks)
        [ -e "$lock_file" ] || continue
        
        # Leer el dueño del lock
        local owner=$(grep "AGENTE:" "$lock_file" 2>/dev/null | cut -d':' -f2 | xargs)
        
        # Si el dueño coincide con el agente, liberar
        if [ "$owner" = "$agent_name" ]; then
            local file_name=$(basename "$lock_file" .lock)
            rm -f "$lock_file"
            echo -e "${GREEN}   ✓ Liberado: $file_name${NC}"
            released_count=$((released_count + 1))
        fi
    done
    
    if [ "$released_count" -eq 0 ]; then
        echo -e "${YELLOW}   ℹ No se encontraron locks de $agent_name${NC}"
    else
        echo -e "${GREEN}✓ Total liberados: $released_count${NC}"
    fi
}

################################################################################
# FUNCIÓN: Mostrar todos los locks activos
################################################################################
function show_all_locks() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                  LOCKS ACTIVOS                             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local lock_count=0
    
    # Buscar todos los locks
    for lock_file in "${LOCKS_DIR}"/*.lock; do
        # Verificar si existe
        [ -e "$lock_file" ] || continue
        
        lock_count=$((lock_count + 1))
        
        # Leer información del lock
        local file_name=$(basename "$lock_file" .lock)
        local agent=$(grep "AGENTE:" "$lock_file" | cut -d':' -f2 | xargs)
        local timestamp=$(grep "TIMESTAMP:" "$lock_file" | cut -d':' -f2- | xargs)
        
        echo -e "${CYAN}[$lock_count] Archivo: $file_name${NC}"
        echo -e "    Bloqueado por: $agent"
        echo -e "    Desde: $timestamp"
        echo ""
    done
    
    if [ "$lock_count" -eq 0 ]; then
        echo -e "${GREEN}✓ No hay locks activos${NC}"
    else
        echo -e "${YELLOW}Total de locks activos: $lock_count${NC}"
    fi
    echo ""
}

################################################################################
# FUNCIÓN: Forzar liberación de todos los locks
################################################################################
# PELIGROSO: Solo usar si sabes que ningún agente está trabajando
################################################################################
function force_release_all_locks() {
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                     ⚠ ADVERTENCIA                          ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Estás a punto de FORZAR la liberación de TODOS los locks${NC}"
    echo -e "${YELLOW}Esto puede causar problemas si hay agentes trabajando.${NC}"
    echo ""
    echo -e "${YELLOW}¿Estás seguro? (s/n)${NC}"
    read -r respuesta
    
    if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
        echo -e "${BLUE}Cancelado.${NC}"
        return 0
    fi
    
    echo -e "${BLUE}🗑️  Eliminando todos los locks...${NC}"
    
    # Eliminar todos los archivos .lock
    rm -f "${LOCKS_DIR}"/*.lock
    
    echo -e "${GREEN}✓ Todos los locks eliminados${NC}"
}

################################################################################
# FUNCIÓN: Verificar locks huérfanos (de agentes que ya no existen)
################################################################################
function check_orphaned_locks() {
    echo -e "${BLUE}🔍 Buscando locks huérfanos...${NC}"
    
    local orphaned_count=0
    local current_time=$(date +%s)
    
    for lock_file in "${LOCKS_DIR}"/*.lock; do
        [ -e "$lock_file" ] || continue
        
        # Obtener timestamp del lock
        local lock_time=$(stat -c %Y "$lock_file" 2>/dev/null || stat -f %m "$lock_file" 2>/dev/null)
        
        # Calcular diferencia en segundos
        local age=$((current_time - lock_time))
        
        # Si el lock tiene más de 15 minutos, es sospechoso
        if [ "$age" -gt 900 ]; then
            local file_name=$(basename "$lock_file" .lock)
            local agent=$(grep "AGENTE:" "$lock_file" | cut -d':' -f2 | xargs)
            local minutes=$((age / 60))
            
            echo -e "${YELLOW}   ⚠ Lock huérfano detectado:${NC}"
            echo -e "     Archivo: $file_name"
            echo -e "     Agente: $agent"
            echo -e "     Edad: $minutes minutos"
            echo ""
            
            orphaned_count=$((orphaned_count + 1))
        fi
    done
    
    if [ "$orphaned_count" -eq 0 ]; then
        echo -e "${GREEN}✓ No se encontraron locks huérfanos${NC}"
    else
        echo -e "${YELLOW}Total de locks huérfanos: $orphaned_count${NC}"
        echo ""
        echo -e "${YELLOW}¿Quieres limpiarlos? (s/n)${NC}"
        read -r respuesta
        
        if [[ "$respuesta" =~ ^[Ss]$ ]]; then
            cleanup_old_locks
        fi
    fi
}

################################################################################
# FUNCIÓN: Limpieza automática de locks viejos
################################################################################
function cleanup_old_locks() {
    echo -e "${BLUE}🧹 Limpiando locks viejos (>15 minutos)...${NC}"
    
    local cleaned=0
    local current_time=$(date +%s)
    
    for lock_file in "${LOCKS_DIR}"/*.lock; do
        [ -e "$lock_file" ] || continue
        
        local lock_time=$(stat -c %Y "$lock_file" 2>/dev/null || stat -f %m "$lock_file" 2>/dev/null)
        local age=$((current_time - lock_time))
        
        # Eliminar si tiene más de 15 minutos
        if [ "$age" -gt 900 ]; then
            rm -f "$lock_file"
            cleaned=$((cleaned + 1))
        fi
    done
    
    echo -e "${GREEN}✓ Locks limpiados: $cleaned${NC}"
}

################################################################################
# FUNCIÓN: Crear un lock temporal para debugging
################################################################################
function create_test_lock() {
    local file_name="${1:-TEST.md}"
    local agent_name="${2:-TEST-AGENT}"
    
    mkdir -p "$LOCKS_DIR"
    
    cat > "${LOCKS_DIR}/${file_name}.lock" << EOF
AGENTE: $agent_name
ARCHIVO: $file_name
TIMESTAMP: $(date '+%Y-%m-%d %H:%M:%S')
PID: $$
NOTA: Este es un lock de prueba
EOF

    echo -e "${GREEN}✓ Lock de prueba creado: $file_name${NC}"
}

################################################################################
# Si se ejecuta directamente, mostrar menú interactivo
################################################################################
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║      SCRIPT 12/12: HELPER - RELEASE SHARED FILES          ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}MENÚ DE OPCIONES:${NC}"
    echo ""
    echo -e "  1) Mostrar todos los locks activos"
    echo -e "  2) Verificar locks huérfanos"
    echo -e "  3) Limpiar locks viejos (>15 min)"
    echo -e "  4) Forzar liberación de TODOS los locks"
    echo -e "  5) Crear lock de prueba"
    echo -e "  6) Salir"
    echo ""
    echo -e "${YELLOW}Elige una opción (1-6):${NC} "
    read -r opcion
    
    case $opcion in
        1)
            show_all_locks
            ;;
        2)
            check_orphaned_locks
            ;;
        3)
            cleanup_old_locks
            ;;
        4)
            force_release_all_locks
            ;;
        5)
            echo -e "${BLUE}Nombre del archivo (ej: TODO.md):${NC} "
            read -r file
            echo -e "${BLUE}Nombre del agente (ej: TEST-AGENT):${NC} "
            read -r agent
            create_test_lock "$file" "$agent"
            ;;
        6)
            echo -e "${BLUE}Saliendo...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            exit 1
            ;;
    esac
fi
