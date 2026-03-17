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
 * **Gestión de Integridad Referencial y Errores ORA:** Resolución de bloqueos de transacción mediante el diagnóstico técnico de errores **ORA-02291** (Foreign Key no encontrada) y **ORA-02292** (violación de registro hijo). Implementación de jerarquías "Padre-Hijo" para garantizar la consistencia de los datos.
* **Control de Transacciones Atómicas:** Sincronización de discrepancias entre auditorías visuales y ejecuciones de borrado. Gestión del estado de datos en el *buffer* de memoria mediante el uso estratégico de **COMMIT** y **ROLLBACK**, asegurando la persistencia de la información crítica.
* **Optimización de Consultas Agregadas:** Dominio del **Orden de Ejecución Lógico de SQL** para la resolución de conflictos de alcance de *Alias* y filtrado de grupos complejos, optimizando el procesamiento del motor de base de datos.
* **Sincronización de Datos mediante Subconsultas Correlacionadas (UPDATE):** Se superó la limitación de las actualizaciones masivas convencionales mediante el uso de subconsultas correlacionadas. Este enfoque permitió que la tabla oficial (EMPLOYEES) sincronizara atributos específicos (como salarios y nombres) basándose en una tabla de origen externa (EMPLOYEES_TEMP), garantizando que solo se modificaran los registros vinculados y manteniendo la integridad del resto de la data.
* **Garantía de Idempotencia en Procesos de Inserción (Filtro **NOT EXISTS**):** Se implementó un blindaje lógico en el comando **INSERT** mediante la cláusula **WHERE NOT EXISTS**. Esta técnica previene el error crítico **ORA-00001**(violación de Primary Key) al validar la preexistencia del registro antes de intentar la escritura. Este **filtro de seguridad** otorga resiliencia al script, permitiendo ejecuciones recurrentes sin generar duplicados ni interrupciones por errores de identidad.

## 📂 Estructura del Repositorio
* `/sql`: Contiene los scripts de configuración (`setup`) y carga de datos.
* `/notes`: Documentación teórica, reportes de incidencias y glosario técnico.

## 🔧 Tecnologías Utilizadas
* **Engine:** Oracle Database 21c XE.
* **Interface:** Oracle SQL Developer.
* **Environment:** Docker Containerization.

## 🛠️ Bitácora de Desarrollo

#### Refactorización de Integridad y Estándares (23/01/2026)

**1. Estandarización de Constraints**
* **Problema:** Dificultad para identificar fallos de integridad debido al uso de nombres automáticos del sistema (tipo `SYS_C...`).
* **Solución:** Se definieron nombres explícitos y estandarizados (ej. `fk_dept`, `fk_job`), permitiendo una depuración inmediata de errores.
* **Aprendizaje:** La nomenclatura explícita en objetos de esquema es una buena práctica de ingeniería que facilita el mantenimiento y la escalabilidad del modelo.

**2. Ajuste del Modelo y Script de Despliegue**
* **Problema:** Ausencia de atributos temporales críticos y falta de un flujo de despliegue automatizado.
* **Solución:** Se incorporó la columna `hire_date` y se estructuró un script integral que incluye borrado preventivo (`DROP CASCADE`), DDL y DML en un solo flujo.
* **Aprendizaje:** Un script de despliegue "limpio" garantiza la repetibilidad del entorno y asegura que el modelo de datos cumpla con los requisitos de negocio (KPIs de RRHH).

#### Resolución de Tickets y Análisis de Datos (26/01/2026)

**1. Consolidación de Reportes y Casos de Borde**
* **Problema:** Necesidad de visualizar información dispersa en múltiples tablas y validar la resiliencia de las consultas ante datos incompletos.
* **Solución:** Se desarrollaron queries complejas para consolidar empleados, puestos y departamentos, utilizando registros de prueba diseñados para testear el comportamiento de los `JOINs`.
* **Aprendizaje:** El análisis de "casos de borde" (como empleados sin departamento) es fundamental para asegurar que los informes de auditoría reflejen la realidad operativa sin pérdida de información.

#### Capa de Abstracción y Seguridad (27/01/2026)

**1. Implementación de Vistas (Views)**
* **Problema:** Complejidad en el acceso recurrente a reportes consolidados y exposición innecesaria de información sensible.
* **Solución:** Se implementaron vistas como `v_maestro_empleados` para simplificar el acceso a datos y `v_equipo_contacto` para ocultar campos críticos (salarios) mediante seguridad lógica.
* **Aprendizaje:** La creación de una capa de abstracción mejora la experiencia del usuario final y permite aplicar políticas de privacidad de datos sin alterar la estructura física de las tablas.

---

## 🚀 Optimización y Resolución (28/01/2026)

### 🛠️ Resolución de Incidencias de Infraestructura
- **Problema:** El entorno de base de datos (Docker Desktop) quedó inoperativo debido a procesos "zombies" en el sistema.
- **Solución:** Intervención manual mediante el Administrador de Tareas, realizando una finalización del árbol de procesos (`docker.exe`, `wsl`) para forzar un arranque limpio.
- **Aprendizaje:** Capacidad de gestión de capas de software (Docker/WSL2) para garantizar la continuidad operativa.

### 📈 Optimización de Base de Datos (Tuning SQL)
Se realizó una auditoría de rendimiento sobre el esquema de Recursos Humanos, detectando cuellos de botella en las consultas principales.

* **Problema:** Se detectaron cuellos de botella en las consultas principales del esquema de Recursos Humanos, identificando un `TABLE ACCESS FULL` mediante el uso de `EXPLAIN PLAN` en la tabla de empleados.
* **Solución:** Se diseñaron e implementaron índices estratégicos (`idx_emp_last_name`, `idx_emp_dept_id` e `idx_emp_job_id`) para optimizar las búsquedas por apellidos, la integridad referencial y el rendimiento de los `JOINS`.
* **Aprendizaje:** La migración de escaneos secuenciales a **INDEX FAST FULL SCAN** permite reducir drásticamente el costo de procesamiento (CPU/IO) y mejorar los tiempos de respuesta, demostrando que un diseño físico orientado a la consulta es tan vital como el diseño lógico.

---
### 🔹 DML Dinámico y Refactorización (10/02/2026)
* **Problema:** Necesidad de actualizar dominios de correo masivos y asignar salarios basados en techos salariales dinámicos.
* **Solución:** Aplicación de `UPDATE` utilizando funciones de manipulación de strings (`REPLACE`) y **Subqueries Escalares** para parametrizar el nuevo salario con el `MAX` de la tabla de forma automática.
* **Aprendizaje:** Implementación de flujos de validación previa (`SELECT`) antes de la ejecución de cambios permanentes para mitigar riesgos de actualización masiva errónea.

### 🔹 Saneamiento e Integridad Referencial (11/02/2026)
* **Problema:** Existencia de registros huérfanos con claves foráneas nulas que comprometían la integridad de los reportes.
* **Solución:** Ejecución de sentencias `DELETE FROM` utilizando el operador `IS NULL` para realizar un saneamiento físico de la tabla `EMPLOYEES`.
* **Aprendizaje:** Identificación de la persistencia de datos en el buffer de sesión; comprensión de cómo el motor de Oracle reporta filas afectadas que no han sido consolidadas en el almacenamiento físico.

### 🔹 Lógica de Agregación y Filtrado Grupal (12/02/2026)
* **Problema:** Requerimiento de reportes gerenciales filtrados por métricas de grupo (promedios) que el comando `WHERE` no puede procesar.
* **Solución:** Estructuración de consultas con `GROUP BY` y `HAVING` para filtrar departamentos con promedios superiores a $8,000, integrando funciones anidadas como `MAX(AVG(salary))`.
* **Aprendizaje:** Jerarquía de ejecución de cláusulas SQL; validación de por qué los *Alias* del `SELECT` solo son accesibles en la etapa final de ordenamiento (`ORDER BY`).

### 🔹 Integración Masiva con MERGE (13/02/2026)
* **Problema:** Necesidad de sincronizar una tabla de novedades de nómina que incluye tanto actualizaciones de empleados existentes como inserciones de nuevos ingresos.
* **Solución:** Implementación de la sentencia **MERGE (UPSERT)** para realizar operaciones de `UPDATE` e `INSERT` de forma atómica, utilizando `UPPER` para estandarizar la entrada de metadatos.
* **Aprendizaje:** Gestión de inmutabilidad en tablas fuente; validación de que los procesos de integración no alteran los datos de origen mientras transforman el destino.

---
#### Sincronización Lógica y Validación de Integridad Referencial (17/03/2026)

**1. Implementación de Staging Area**
* **Problema:** Necesidad de manipular y sanear datos externos sin afectar directamente las tablas maestras de producción.
* **Solución:** Se crearon estructuras temporales (`EMPLOYEES_TEMP`) para actuar como una capa intermedia de preparación de datos.
* **Aprendizaje:** El uso de tablas de *Staging* permite realizar pruebas de carga y validaciones de tipos de datos de forma aislada, reduciendo el riesgo de corrupción en la base de datos oficial.

**2. Blindaje de Foreign Keys**
* **Problema:** Riesgo de interrupción de scripts masivos debido a errores de orfandad de datos (**ORA-02291**) al intentar insertar registros con departamentos inexistentes.
* **Solución:** Se aplicaron filtros proactivos mediante la cláusula `EXISTS` para validar la existencia de llaves foráneas en la tabla `DEPARTMENTS` antes de procesar cada fila.
* **Aprendizaje:** La validación lógica previa a la inserción es más eficiente que el manejo de excepciones, ya que permite que el script continúe procesando los registros válidos sin detener la ejecución.

**3. Gestión de Transacciones y Persistencia**
* **Problema:** Pérdida de volatilidad de datos en la tabla de *Staging* y falta de visibilidad de los cambios tras la ejecución de scripts.
* **Solución:** Se reforzó el flujo de trabajo mediante el uso mandatorio de sentencias `COMMIT` para asegurar la persistencia física de los datos en el motor Oracle XE.
* **Aprendizaje:** En Oracle, la gestión explícita de transacciones es vital; un script exitoso sin confirmación de cambios equivale a una operación no realizada en el almacenamiento persistente.

**4. Troubleshooting de Registros Existentes**
* **Problema:** Colisión de datos y errores de duplicidad al intentar insertar registros cuyos IDs ya se encontraban en la tabla de destino.
* **Solución:** Se realizó un diagnóstico de colisiones que derivó en un cambio de estrategia, pasando de un `INSERT` fallido a un `UPDATE` correlacionado para actualizar perfiles preexistentes.
* **Aprendizaje:** La flexibilidad para alternar entre inserción y actualización (lógica *Upsert*) es fundamental para mantener la sincronía entre tablas sin violar las restricciones de unicidad de la Primary Key.

---
*Este es un proyecto educativo en constante evolución.*
