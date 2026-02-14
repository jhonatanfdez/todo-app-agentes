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
