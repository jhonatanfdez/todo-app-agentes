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
