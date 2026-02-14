#!/bin/bash

################################################################################
# SCRIPT 2 DE 12: CREAR ESTRUCTURA DE CARPETAS Y ARCHIVOS
# 
# PROPÓSITO:
#   Este script crea toda la estructura de carpetas y archivos base
#   del proyecto. Es como crear el "esqueleto" antes de poner la "carne".
#
# QUÉ HACE:
#   1. Crea las carpetas: tasks/, prompts/, docs/
#   2. Crea archivos vacíos: TODO.md, PROGRESS.md
#   3. Crea el .gitignore para ignorar archivos temporales
#   4. Crea un README.md básico
#
# PREREQUISITO: Haber ejecutado 1-clonar-repo.sh
# SE EJECUTA: Una sola vez, después del script 1
# SIGUIENTE PASO: Ejecutar 3-crear-prompts.sh
################################################################################

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

################################################################################
# FUNCIÓN: Mostrar banner inicial
################################################################################
function show_banner() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║      SCRIPT 2/12: CREAR ESTRUCTURA DE CARPETAS            ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar que estamos en la carpeta correcta
################################################################################
function check_location() {
    echo -e "${BLUE}🔍 Verificando ubicación...${NC}"
    
    # Verificamos que exista la carpeta .git (indica que es un repo)
    if [ ! -d ".git" ]; then
        echo -e "${RED}✗ ERROR: No estás en la carpeta del proyecto${NC}"
        echo -e "${YELLOW}Por favor ejecuta:${NC}"
        echo -e "   cd todo-app-agentes"
        echo -e "   ../2-crear-estructura.sh"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Ubicación correcta${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear carpetas principales
################################################################################
function create_directories() {
    echo -e "${BLUE}📁 Creando carpetas...${NC}"
    
    # mkdir -p crea la carpeta solo si no existe
    # -p también crea carpetas padres si son necesarias
    
    # Carpeta para archivos de coordinación entre agentes
    mkdir -p tasks/locks
    echo -e "${GREEN}   ✓ Carpeta creada: tasks/${NC}"
    echo -e "${GREEN}   ✓ Subcarpeta creada: tasks/locks/${NC}"
    
    # Carpeta para los prompts de cada agente
    mkdir -p prompts
    echo -e "${GREEN}   ✓ Carpeta creada: prompts/${NC}"
    
    # Carpeta para documentación (será llenada por Agente #4)
    mkdir -p docs
    echo -e "${GREEN}   ✓ Carpeta creada: docs/${NC}"
    
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo TODO.md (lista de tareas)
################################################################################
function create_todo_file() {
    echo -e "${BLUE}📝 Creando archivo TODO.md...${NC}"
    
    # Creamos el archivo con el contenido inicial
    # El símbolo << 'EOF' permite escribir texto multilínea
    cat > tasks/TODO.md << 'EOF'
# 📋 LISTA DE TAREAS - TODO APP

> Este archivo contiene todas las tareas pendientes del proyecto.
> Cada agente lee este archivo para saber qué hacer.
> Cuando un agente completa una tarea, la marca como [x].

---

## 🔨 Backend (NestJS + PostgreSQL)

### Módulo de Autenticación
- [ ] Crear entity User con campos: id, email, password, createdAt
- [ ] Crear AuthService con métodos: register(), login()
- [ ] Implementar hash de contraseñas con bcrypt
- [ ] Crear AuthController con endpoints POST /auth/register y /auth/login
- [ ] Implementar JWT para autenticación
- [ ] Crear middleware de autenticación para proteger rutas

### Módulo de Tareas
- [ ] Crear entity Task con campos: id, title, description, completed, userId, createdAt
- [ ] Crear TaskService con CRUD completo
- [ ] Crear TaskController con endpoints REST
- [ ] Implementar relación User -> Tasks (un usuario tiene muchas tareas)
- [ ] Agregar validaciones con class-validator

### Base de Datos
- [ ] Configurar TypeORM con PostgreSQL
- [ ] Crear migraciones automáticas
- [ ] Configurar variables de entorno (.env)

---

## ⚛️ Frontend (React + Vite + TypeScript)

### Configuración Inicial
- [ ] Configurar TailwindCSS
- [ ] Configurar React Router
- [ ] Crear estructura de carpetas (components, pages, services)
- [ ] Configurar variables de entorno para API

### Páginas de Autenticación
- [ ] Crear página Login (/login)
- [ ] Crear página Register (/register)
- [ ] Crear servicio authService para llamadas a API
- [ ] Implementar manejo de token en localStorage
- [ ] Crear ProtectedRoute component

### Páginas de Tareas
- [ ] Crear página TaskList (/) con listado de tareas
- [ ] Crear componente TaskCard para mostrar cada tarea
- [ ] Crear formulario para agregar nueva tarea
- [ ] Implementar funcionalidad para marcar tarea como completada
- [ ] Implementar funcionalidad para eliminar tarea
- [ ] Crear servicio taskService para llamadas a API

### UI/UX
- [ ] Diseñar header con logo y botón logout
- [ ] Implementar loading states
- [ ] Implementar mensajes de error
- [ ] Hacer responsive (mobile-first)

---

## 🧪 Testing

### Tests Backend
- [ ] Crear tests unitarios para AuthService
- [ ] Crear tests unitarios para TaskService
- [ ] Crear tests E2E para endpoints de autenticación
- [ ] Crear tests E2E para endpoints de tareas
- [ ] Configurar coverage mínimo de 80%

### Tests Frontend
- [ ] Configurar Vitest
- [ ] Crear tests para componentes de autenticación
- [ ] Crear tests para componentes de tareas
- [ ] Crear tests para servicios (mocks)

---

## 📚 Documentación

- [ ] Documentar endpoints de API en docs/API.md
- [ ] Crear guía de instalación en README.md
- [ ] Documentar estructura del proyecto
- [ ] Crear ejemplos de uso con curl
- [ ] Documentar variables de entorno necesarias

---

**Última actualización:** Generado automáticamente por script
EOF

    echo -e "${GREEN}   ✓ Archivo creado: tasks/TODO.md${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo PROGRESS.md (log de progreso)
################################################################################
function create_progress_file() {
    echo -e "${BLUE}📊 Creando archivo PROGRESS.md...${NC}"
    
    # Creamos el archivo de log donde cada agente escribe lo que hace
    cat > tasks/PROGRESS.md << 'EOF'
# 📊 LOG DE PROGRESO - TODO APP

> Este archivo registra todo lo que hace cada agente.
> Cada agente AGREGA líneas aquí después de completar una tarea.
> Formato: FECHA | AGENTE | DESCRIPCIÓN

---

## Historial de Cambios

<!-- Los agentes escribirán aquí en este formato: -->
<!-- 2026-02-14 10:30 | AGENTE-1-BACKEND | Creé entity User con todos los campos -->
<!-- 2026-02-14 10:35 | AGENTE-2-FRONTEND | Creé página de Login con formulario -->

**Inicio del proyecto:** 2026-02-14

EOF

    echo -e "${GREEN}   ✓ Archivo creado: tasks/PROGRESS.md${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear archivo .gitignore
################################################################################
function create_gitignore() {
    echo -e "${BLUE}🚫 Creando archivo .gitignore...${NC}"
    
    # Este archivo le dice a Git qué archivos NO subir a GitHub
    cat > .gitignore << 'EOF'
# ============================================
# GITIGNORE - TODO APP AGENTES
# ============================================

# ============================================
# Node.js
# ============================================
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json
yarn.lock

# ============================================
# Variables de entorno (contienen secretos)
# ============================================
.env
.env.local
.env.development
.env.production
*.env

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

# ============================================
# Sistema operativo
# ============================================
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# ============================================
# IDEs y editores
# ============================================
.vscode/
.idea/
*.sublime-*

# ============================================
# Build y distribución
# ============================================
dist/
build/
*.tgz

# ============================================
# Archivos temporales
# ============================================
tmp/
temp/
*.tmp

# ============================================
# Locks de agentes (archivos temporales de coordinación)
# ============================================
tasks/locks/*.lock
EOF

    echo -e "${GREEN}   ✓ Archivo creado: .gitignore${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Crear README.md básico
################################################################################
function create_readme() {
    echo -e "${BLUE}📖 Creando README.md...${NC}"
    
    cat > README.md << 'EOF'
# 🤖 TODO App - Desarrollo con 4 Agentes IA

> Aplicación TODO construida automáticamente por 4 agentes de Claude Code trabajando en paralelo.

---

## 📋 Descripción

Este proyecto es un **experimento de desarrollo multi-agente** donde 4 instancias de Claude Code trabajan simultáneamente en diferentes aspectos del proyecto:

- **Agente #1 (Backend):** Desarrolla la API con NestJS + PostgreSQL
- **Agente #2 (Frontend):** Desarrolla la UI con React + Vite
- **Agente #3 (Testing):** Crea tests unitarios y E2E
- **Agente #4 (Docs):** Escribe documentación técnica

Los agentes se coordinan mediante archivos compartidos (`tasks/TODO.md` y `tasks/PROGRESS.md`).

---

## 🏗️ Stack Tecnológico

### Backend
- NestJS
- TypeORM
- PostgreSQL
- JWT para autenticación
- bcrypt para hash de contraseñas

### Frontend
- React 18
- Vite
- TypeScript
- TailwindCSS
- React Router

### Testing
- Jest (Backend)
- Vitest (Frontend)

---

## 📂 Estructura del Proyecto

```
todo-app-agentes/
├── backend/          # API NestJS
├── frontend/         # React App
├── tasks/            # Coordinación de agentes
│   ├── TODO.md       # Lista de tareas
│   ├── PROGRESS.md   # Log de progreso
│   └── locks/        # Sistema de bloqueos
├── prompts/          # Instrucciones de cada agente
└── docs/             # Documentación generada
```

---

## 🚀 Instalación

**Prerrequisitos:**
- Node.js 18+
- PostgreSQL 14+
- Git

**Pasos:**

```bash
# Clonar repositorio
git clone https://github.com/jhonatanfdez/todo-app-agentes.git
cd todo-app-agentes

# Instalar backend
cd backend
npm install
# Configurar .env (ver backend/.env.example)
npm run start:dev

# Instalar frontend (en otra terminal)
cd frontend
npm install
npm run dev
```

---

## 📝 Estado del Proyecto

Este README será actualizado automáticamente por el Agente #4 conforme avance el desarrollo.

**Última actualización:** 2026-02-14
EOF

    echo -e "${GREEN}   ✓ Archivo creado: README.md${NC}"
    echo ""
}

################################################################################
# FUNCIÓN: Verificar estructura creada
################################################################################
function verify_structure() {
    echo -e "${BLUE}🔍 Verificando estructura creada...${NC}"
    
    # Mostramos el árbol de directorios y archivos
    echo -e "${BLUE}Estructura del proyecto:${NC}"
    echo ""
    
    # tree muestra la estructura, -L 2 limita a 2 niveles de profundidad
    # Si tree no está instalado, usamos find como alternativa
    if command -v tree &> /dev/null; then
        tree -L 2 -a
    else
        # Alternativa con find (menos bonito pero funciona)
        find . -maxdepth 2 -not -path '*/\.git/*' | sort
    fi
    
    echo ""
}

################################################################################
# FUNCIÓN: Mostrar resumen final
################################################################################
function show_summary() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✅ SCRIPT 2 COMPLETADO                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📊 RESUMEN:${NC}"
    echo -e "${GREEN}   ✓ Carpetas creadas: tasks/, prompts/, docs/${NC}"
    echo -e "${GREEN}   ✓ Archivos creados: TODO.md, PROGRESS.md${NC}"
    echo -e "${GREEN}   ✓ .gitignore configurado${NC}"
    echo -e "${GREEN}   ✓ README.md básico creado${NC}"
    echo ""
    echo -e "${YELLOW}📍 SIGUIENTE PASO:${NC}"
    echo -e "   ../3-crear-prompts.sh"
    echo ""
}

################################################################################
# EJECUCIÓN PRINCIPAL DEL SCRIPT
################################################################################

show_banner              # Mostrar título
check_location           # Verificar que estamos en la carpeta correcta
create_directories       # Crear carpetas
create_todo_file         # Crear lista de tareas
create_progress_file     # Crear log de progreso
create_gitignore         # Crear .gitignore
create_readme            # Crear README básico
verify_structure         # Mostrar estructura creada
show_summary             # Mostrar resumen

exit 0
