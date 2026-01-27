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
