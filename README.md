# 🏛️ Proyecto: Oracle Corp HR Database

Este repositorio contiene la configuración inicial, el diseño de la estructura y la carga de datos para un sistema de Recursos Humanos en **Oracle Database 21c (Dockerized)**.

## 🚀 Resumen del Proyecto
El objetivo de este proyecto es demostrar habilidades en la administración de bases de datos Oracle, incluyendo la gestión de usuarios, permisos, diseño de tablas (DDL) e inserción de datos (DML).

## 🛠️ Retos Técnicos Superados (Troubleshooting)
Durante el desarrollo, se resolvieron los siguientes incidentes críticos:
* **Gestión de Esquemas:** Se migró la estructura del esquema `SYSTEM` a un usuario dedicado `C##ORACLE_HR` para seguir las mejores prácticas de seguridad.
* **Cuotas de Almacenamiento:** Resolución del error de inserción mediante la asignación de `QUOTA UNLIMITED` en el Tablespace USERS.
* **Integridad Referencial:** Implementación de llaves foráneas para asegurar la relación lógica entre empleados, departamentos y puestos.

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

---
*Este es un proyecto educativo en constante evolución.*
