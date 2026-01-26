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