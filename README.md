# 🏛️ Proyecto: Oracle Corp HR Database

Este repositorio contiene la configuración inicial, el diseño de la estructura y la carga de datos para un sistema de Recursos Humanos en **Oracle Database 21c (Dockerized)**.

## 🚀 Resumen del Proyecto
El objetivo de este proyecto es demostrar habilidades en la administración de bases de datos Oracle, incluyendo la gestión de usuarios, permisos, diseño de tablas (DDL) e inserción de datos (DML).

## 🛠️ Retos Técnicos Superados (Troubleshooting)
Durante el desarrollo, se resolvieron los siguientes incidentes críticos:
* **Gestión de Esquemas:** Se migró la estructura del esquema `SYSTEM` a un usuario dedicado `C##ORACLE_HR` para seguir las mejores prácticas de seguridad.
* **Cuotas de Almacenamiento:** Resolución del error de inserción mediante la asignación de `QUOTA UNLIMITED` en el Tablespace USERS.
* **Integridad Referencial:** Implementación de llaves foráneas para asegurar la relación lógica entre empleados, departamentos y puestos.
* **Consultas Multitabla y Agregaciones:** Resolución de tickets de soporte mediante el uso de JOINS complejos y funciones de agregado (GROUP BY) para generar reportes de nómina y distribución de personal.
* **Auditoría Preventiva de Datos:** Implementación de lógica de conjuntos (LEFT JOIN + IS NULL) para identificar registros huérfanos, garantizando una integridad del 100% en la asignación de departamentos.
* **Optimización de Base de Datos (Tuning SQL):** Identificación de cuellos de botella mediante EXPLAIN PLAN y resolución de lecturas ineficientes (TABLE ACCESS FULL) mediante la implementación de índices B-Tree, optimizando el rendimiento de busquedas y JOINS.
* **Resiliencia de Infraestructura:** Recuperación del entorno  operativo ante un bloqueo crítico de Docker Desktop mediante la finalización manual del árbol de procesos "zombies", asegurando la continuidad del servicio sin pérdida de datos.

## 📂 Estructura del Repositorio
* `/sql`: Contiene los scripts de configuración (`setup`) y carga de datos.
* `/notes`: Documentación teórica, reportes de incidencias y glosario técnico.

## 🔧 Tecnologías Utilizadas
* **Engine:** Oracle Database 21c XE.
* **Interface:** Oracle SQL Developer.
* **Environment:** Docker Containerization.

## 🛠️ Bitácora de Desarrollo

### Refactorización de Integridad y Estándares (23/01/2026)
Hoy se realizó una limpieza y mejora profunda del esquema para cumplir con estándares profesionales de bases de datos:

* **Estandarización de Constraints:** Se eliminaron los nombres automáticos de sistema (tipo `SYS_C...`) y se definieron nombres explícitos como `fk_dept` y `fk_job`. Esto permite identificar errores de integridad de forma inmediata.
* **Ajuste del Modelo de Datos:** Se añadió la columna `hire_date` a la tabla `employees`, esencial para métricas de Recursos Humanos.
* **Script de Despliegue Limpio:** Se estructuró el archivo SQL para incluir el borrado preventivo (`DROP CASCADE`), la creación de estructura (DDL) y la carga de datos inicial (DML) en un solo flujo.
* **Validación de Datos:** Se cargaron 5 registros de prueba, incluyendo un caso de borde (empleado sin departamento) para validar futuros reportes (JOINs).

### Resolución de Tickets y Análisis de Datos (26/01/2026)

* **Generación de Reportes:** Creación de queries para consolidar datos de empleados, puestos y departamentos en un solo flujo.
* **Validación de Casos de Borde:** Se utilizó el empleado de prueba creado anteriormente para validar el comportamiento de los JOINS y asegurar que los informes de auditoría detecten correctamente las ausencias de asignación.

---
### 🚀 Capa de Abstracción y Seguridad (27/01/2026)
Se implementaron **Vistas (Views)** para optimizar el acceso a la información y mejorar la integridad operativa:
* **v_maestro_empleados**: Reporte consolidado que unifica datos de empleados, puestos y departamentos mediante JOINS.
* **v_equipo_contacto**: Aplicación de seguridad lógica que permite el acceso a datos de contacto pero oculta información sensible (Salarios), cumpliendo con estándares de privacidad.

---

## 🚀 Optimización y Resolución (28/01/2026)

### 🛠️ Resolución de Incidencias de Infraestructura
- **Problema:** El entorno de base de datos (Docker Desktop) quedó inoperativo debido a procesos "zombies" en el sistema.
- **Solución:** Intervención manual mediante el Administrador de Tareas, realizando una finalización del árbol de procesos (`docker.exe`, `wsl`) para forzar un arranque limpio.
- **Aprendizaje:** Capacidad de gestión de capas de software (Docker/WSL2) para garantizar la continuidad operativa.

### 📈 Optimización de Base de Datos (Tuning SQL)
Se realizó una auditoría de rendimiento sobre el esquema de Recursos Humanos, detectando cuellos de botella en las consultas principales.

- **Diagnóstico:** Uso de `EXPLAIN PLAN` para identificar un `TABLE ACCESS FULL` en la tabla de empleados.
- **Acción:** Creación de índices estratégicos:
  - `idx_emp_last_name`: Optimización de búsquedas por apellidos.
  - `idx_emp_dept_id` & `idx_emp_job_id`: Optimización de integridad referencial y `JOINS`.
- **Resultado:** Migración de escaneos secuenciales a **INDEX FAST FULL SCAN**, reduciendo el costo de procesamiento y mejorando el tiempo de respuesta.

---
---
*Este es un proyecto educativo en constante evolución.*
