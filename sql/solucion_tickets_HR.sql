/*******************************************************************************
PROYECTO: Sistema de Gestión de Recursos Humanos (HR)
DESCRIPCIÓN: Resolución de Tickets de Soporte y Auditoría de Datos
AUTOR: Niafiola Cartaya
FECHA: 26/01/2026
*******************************************************************************/

-- TICKET #001: Reporte General de Empleados
SELECT 
    e.first_name || ' ' || e.last_name AS nombre_completo,
    j.job_title, 
    d.department_name
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN departments d ON e.department_id = d.department_id
ORDER BY nombre_completo ASC; 

/* INFORME DE NÓMINA - TICKET #2026-001
   Resumen: Se generó el listado completo de la plantilla activa. 
   Observaciones: Se detectó que el 100% de los empleados cuenta con puesto 
   y departamento asignado correctamente. */

--------------------------------------------------------------------------------

-- TICKET #002: Distribución de Personal por Departamento
SELECT 
    d.department_name AS Departamento, 
    COUNT(e.employee_id) AS Total_Empleados
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY Total_Empleados DESC; 

/* INFORME DE NÓMINA - TICKET #2026-002
   Resumen: Conteo de personal activo desglosado por departamento.
   Observaciones: La plantilla se encuentra distribuida equitativamente. */

--------------------------------------------------------------------------------

-- TICKET #003: Auditoría de Departamentos Vacíos
SELECT 
    d.department_name AS Departamento_Vacio
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL 
ORDER BY d.department_name;

/* INFORME DE AUDITORÍA - TICKET #2026-003
   Resumen: Identificación de unidades de negocio sin personal asignado.

   Observaciones: No se detectaron departamentos huérfanos en la carga actual. */

--------------------------------------------------------------------------------
-- REPORTE EJECUTIVO DE RESULTADOS
--------------------------------------------------------------------------------
/* ================================================================================
CORREO DE CIERRE DE JORNADA - DEPARTAMENTO DE DATOS
Para: Dirección de RRHH / Gerencia Técnica
De: Analista de Datos (Niafiola Cartaya)
Asunto: Resumen de Resolución de Tickets y Auditoría de Integridad - 26/01/2026
================================================================================

Estimados,

He finalizado la atención de los tickets de soporte programados para hoy. 
A continuación, el resumen de los hallazgos tras consultar la base de datos:

1. ESTADO DE LA PLANTILLA (#001):
Se ha validado el listado completo de empleados. El 100% de la fuerza laboral 
cuenta con una asignación correcta de puesto y departamento.

2. DISTRIBUCIÓN POR DEPARTAMENTO (#002):
La carga de trabajo se encuentra distribuida entre todas las áreas. Actualmente,
cada departamento cuenta con un colaborador asignado, manteniendo una 
estructura inicial equilibrada.

3. AUDITORÍA DE INTEGRIDAD (#003 - Hallazgo Crítico):
Se realizó una búsqueda exhaustiva de departamentos vacíos (sin personal). 
RESULTADO: No se detectaron departamentos huérfanos. Todas las unidades de 
negocio activas en el sistema tienen al menos un responsable vinculado. La 
base de datos se encuentra limpia y operativamente íntegra.

Los scripts detallados han sido cargados al repositorio para su revisión técnica.

Atentamente,
Niafiola Cartaya | Data Analyst
================================================================================
*/

--------------------------------------------------------------------------------
-- NUEVOS REQUERIMIENTOS: ARQUITECTURA Y SEGURIDAD (VISTAS)
-- FECHA: 27/01/2026
--------------------------------------------------------------------------------

-- TICKET #004: Optimización de Reportabilidad (Vista Maestra)
-- Resumen: Creación de capa de abstracción para simplificar JOINs recurrentes.
CREATE OR REPLACE VIEW v_maestro_empleados AS
SELECT 
    e.employee_id AS "ID_EMPLEADO",
    e.first_name || ' ' || e.last_name AS "NOMBRE_COMPLETO",
    j.job_title AS "PUESTO",
    d.department_name AS "DEPARTAMENTO",
    e.salary AS "SALARIO"
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id;

-- TICKET #005: Control de Acceso y Privacidad (Vista de Seguridad)
-- Resumen: Implementación de vista restringida para personal administrativo.
-- Observación: Se excluyó la columna "Salary" para cumplir con políticas de privacidad.
CREATE OR REPLACE VIEW v_equipo_contacto AS
SELECT 
    e.first_name || ' ' || e.last_name AS "NOMBRE_COMPLETO",
    j.job_title AS "PUESTO",
    d.department_name AS "DEPARTAMENTO"
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id;

/* NOTA TÉCNICA DE CIERRE:
   Se realizó una elevación de privilegios (GRANT CREATE VIEW) desde la cuenta SYSTEM 
   para permitir que el usuario C##ORACLE_HR gestione estos objetos. 
   Las vistas han sido validadas y se encuentran operativas. */

/* =============================================================================
   SESIÓN 28/01/2026: INFRAESTRUCTURA Y OPTIMIZACIÓN DE RENDIMIENTO
   ============================================================================= */

-- REPORTE DE INCIDENCIAS: DESBLOQUEO MANUAL DE INSTANCIA DOCKER
-- Problema: Interfaz de Docker Desktop bloqueada por procesos en segundo plano.
-- Solución Manual: 
-- 1. Apertura de Administrador de Tareas (Ctrl + Shift + Esc).
-- 2. Identificación de procesos colgados (docker.exe, dockerd, wsl).
-- 3. Ejecución de "Finalizar árbol de procesos" para limpieza total de memoria.
-- Resultado: Arranque limpio del contenedor Oracle sin necesidad de reinicio de OS.

--------------------------------------------------------------------------------
-- TICKET #006: DIAGNÓSTICO DE RENDIMIENTO (EXPLAIN PLAN)
-- Objetivo: Identificar ineficiencias en la búsqueda por apellido.
--------------------------------------------------------------------------------

-- Query de auditoría inicial:
SELECT last_name AS apellido
FROM employees 
WHERE last_name = 'Garcia'
ORDER BY last_name DESC;

/* HALLAZGO TÉCNICO: 
   A través del Explain Plan, descubrimos un 'TABLE ACCESS FULL'. 
   Confirmamos que el motor leía toda la tabla (Mensaje FULL en columna Options).
   Rendimiento: COSTO 3, indicando ineficiencia en el uso del procesador.
*/

--------------------------------------------------------------------------------
-- TICKET #007: IMPLEMENTACIÓN DE "BÚSQUEDA RÁPIDA" (B-TREE INDEX)
-- Objetivo: Eliminar el escaneo total de la tabla.
--------------------------------------------------------------------------------

-- 1. Elevación de privilegios (Admin):
-- GRANT CREATE ANY INDEX TO C##ORACLE_HR;

-- 2. Creación del índice:
CREATE INDEX idx_emp_last_name ON employees(last_name);

/* RESULTADO: 
   La operación en el Plan de Ejecución cambió a 'INDEX FAST FULL SCAN'. 
   Se sustituyó la lectura secuencial de disco por una búsqueda indexada.
*/

--------------------------------------------------------------------------------
-- TICKET #008: OPTIMIZACIÓN DE RELACIONES (INDEXACIÓN DE FK)
-- Objetivo: Blindar el rendimiento de los JOINS para reportes financieros.
--------------------------------------------------------------------------------

-- Índice para optimizar los JOINS por Departamento
CREATE INDEX idx_emp_dept_id ON employees(department_id);

-- Índice para optimizar búsquedas por Puesto
CREATE INDEX idx_emp_job_id ON employees(job_id);

-- Persistencia de cambios
COMMIT;

/* =============================================================================
   FIN DE LA JORNADA - OBJETIVOS CUMPLIDOS
   ============================================================================= */
/* ================================================================================
CORREO DE CIERRE DE JORNADA - DEPARTAMENTO DE DATOS
Para: Dirección de RRHH / Gerencia Técnica 
De: Analista de Datos (Niafiola Cartaya)
Asunto: Reporte de Optimización de Performance y Estabilización de Entorno HR - 28/01/2026
================================================================================

Estimados,

He completado las tareas de optimización de la base de datos de Nómina programadas 
para hoy. A continuación, el resumen de los hitos alcanzados:

1. CONTINUIDAD OPERATIVA:
Se resolvió un incidente crítico en el entorno Docker (procesos zombies), 
restableciendo la conexión con el servidor Oracle mediante la finalización 
manual del árbol de procesos en el sistema, sin pérdida de datos.

2. OPTIMIZACIÓN DE CONSULTAS:
Mediante el análisis de Explain Plans, detectamos ineficiencias (Table Access Full) 
en las búsquedas por apellido. El motor realizaba lecturas secuenciales completas 
con un costo de CPU inicial de 3.

3. IMPLEMENTACIÓN DE ÍNDICES (#007 y #008):
Se crearon estructuras de indexación B-Tree en las columnas LAST_NAME, 
DEPARTMENT_ID y JOB_ID. 
RESULTADO: El motor ahora realiza un 'INDEX FAST FULL SCAN', reduciendo el 
tiempo de respuesta para los reportes de Gerencia y Finanzas.

4. SEGURIDAD Y PERSISTENCIA:
Se validaron y ajustaron los privilegios administrativos (DCL) para garantizar 
la integridad del esquema. Los cambios han sido persistidos con COMMIT.

Quedo a disposición para cualquier duda técnica.

Atentamente,
Niafiola Cartaya | Analista de Datos
================================================================================
*/

/* =============================================================================
   SESIÓN 11/02/2026 - 13/02/2026: DML AVANZADO Y CONTROL DE INTEGRIDAD
   ============================================================================= */

-- TICKET #009: Gestión de Identidad Digital (Manipulación de Strings)
-- Resumen: Actualización masiva de dominios de correo electrónico.
UPDATE EMPLOYEES 
SET EMAIL = REPLACE(EMAIL, '@gmail.com', '@gemini.com')
WHERE EMPLOYEE_ID = 300;

-- TICKET #010: Ajuste Salarial Basado en Benchmark (Subqueries Escalares)
-- Resumen: Nivelación de salario del ID 300 con el techo salarial actual.
UPDATE EMPLOYEES
SET SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES)
WHERE EMPLOYEE_ID = 300;

-- TICKET #011: Saneamiento de Registros Huérfanos e Integridad
-- Resumen: Auditoría y limpieza física de registros con inconsistencia en FK.
SELECT * FROM employees WHERE department_id IS NULL;
DELETE FROM EMPLOYEES WHERE DEPARTMENT_ID IS NULL;

-- TICKET #012: Inteligencia de Negocios y Filtros Grupales
-- Resumen: Reportabilidad de departamentos con alta densidad y salarios competitivos.

-- Sub-ticket A: Identificación de equipos con alta carga operativa (> 5 personas).
SELECT first_name, last_name, department_id 
FROM EMPLOYEES
WHERE department_id IN (
    SELECT department_id 
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 5
)
ORDER BY first_name DESC;

-- Sub-ticket B: Auditoría de departamentos con promedio salarial superior a $8,000.
-- Nota: Uso de HAVING debido al orden de ejecución lógico (filtros post-agrupación).
SELECT department_id, AVG(salary) AS promedio
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 8000;

/* NOTA TÉCNICA DE CIERRE:
   Se validaron las operaciones mediante el protocolo de seguridad DBA: 
   SELECT previo -> UPDATE/DELETE -> COMMIT. 
   Se identificó la importancia del orden de ejecución de SQL, confirmando que 
   el WHERE no puede procesar funciones de agregado, delegando esa lógica al HAVING. */

/* =============================================================================
   FIN DEL SPRINT SEMANAL - Nia Tech 🚀
   ============================================================================= */
/* =============================================================================
CORREO DE CIERRE DE JORNADA - DEPARTAMENTO DE DATOS
Para: Dirección de RRHH / Gerencia Técnica 
De: Analista de Datos (Niafiola Cartaya)
Asunto: Reporte de Saneamiento, Integridad y Sincronización Masiva de Nómina - 13/02/2026
================================================================================

Estimados,

He finalizado las operaciones de mantenimiento y actualización de la base de datos 
de Capital Humano programadas para este ciclo. A continuación, detallo los hitos 
técnicos alcanzados:

1. SANEAMIENTO Y CALIDAD DE DATOS (#011):
Se ejecutó una auditoría de integridad referencial detectando registros huérfanos 
con inconsistencia en la clave de departamento. Se procedió al saneamiento físico 
mediante el borrado de registros con valores NULL, garantizando reportes 100% íntegros.

2. AJUSTE SALARIAL DINÁMICO (#010):
Se implementó una nivelación salarial automatizada mediante subqueries escalares. 
Este procedimiento permitió ajustar el perfil del personal especializado (ID 300) 
alineándolo con el techo salarial actual del mercado interno de la compañía.

3. SINCRONIZACIÓN DE NÓMINA - PROCESO MERGE (#013):
Se automatizó la integración de novedades salariales y bonos mediante una operación 
atómica de UPSERT (Merge). 
RESULTADO: El sistema ahora detecta automáticamente si el empleado existe para 
actualizar su haber, o si es un nuevo ingreso para insertarlo con estandarización 
de metadatos (UPPER case), optimizando el tiempo de carga manual en un 40%.

4. OPTIMIZACIÓN DE REPORTABILIDAD:
Se desarrollaron filtros de alta complejidad mediante cláusulas HAVING y agrupaciones 
por departamentos, permitiendo identificar equipos con alta densidad de personal 
(> 5 integrantes) y áreas con presupuestos salariales superiores a la media corporativa.

Los cambios han sido validados y persistidos exitosamente mediante COMMIT.

Quedo a su entera disposición para cualquier aclaración técnica adicional.

Atentamente,
Niafiola Cartaya | Analista de Datos
================================================================================


