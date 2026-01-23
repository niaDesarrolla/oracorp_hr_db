-- ==========================================================
-- ESTRUCURA INICIAL DEL PROYECTO HR
-- Descripción: Creación de usuario, tablas e integridad
-- Autor: [Niafiola Cartaya/C##ORACLE_HR]
-- Fecha: 23 de Enero de 2026
-- ==========================================================

--- 1. CONFIGURACIÓN DE USUARIO (Ejecutar como SYSTEM) ---
-- Creación del usuario común para el contenedor
CREATE USER C##ORACLE_HR IDENTIFIED BY mi_password_aqui;

-- Permisos de conexión y recursos
GRANT CONNECT, RESOURCE TO C##ORACLE_HR;

-- Permitir que el usuario guarde datos en el storage
ALTER USER C##ORACLE_HR QUOTA UNLIMITED ON USERS;


--- 2. CREACIÓN DE TABLAS (DDL) ---
-- Cambiar a la conexión del usuario C##ORACLE_HR antes de ejecutar esto

-- 1. Limpieza total del esquema
-- Usamos CASCADE CONSTRAINTS para que no importe el orden en que se borren
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE jobs CASCADE CONSTRAINTS;

-- 2. Creamos Departamentos (tabla Padre 1)
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY, 
    department_name VARCHAR2(50) NOT NULL
);

-- 3. Creamos Jobs (Padre 2)
CREATE TABLE jobs (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50) NOT NULL,
    min_salary NUMBER,
    max_salary NUMBER
);

-- 3. Creamos la tabla de Empleados (La tabla "Hija")
-- Aquí aplicamos la Naming Convention para la Foreign Key
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER,
    hire_date DATE,
    department_id NUMBER,
    job_id VARCHAR2(10),
    -- Definimos la relación con un nombre descriptivo: fk_emp_dept
    CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT fk_job FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);


-- ==========================================================
-- CARGA DE DATOS INICIAL (DML)
-- ==========================================================
 
-- 1. Inserción de Departamentos
INSERT INTO departments (department_id, department_name) VALUES (1, 'IT'); 
INSERT INTO departments (department_id, department_name) VALUES (2, 'HR');
INSERT INTO departments (department_id, department_name) VALUES (3, 'Finance');
INSERT INTO departments (department_id, department_name) VALUES (4, 'Sales');
 
-- 2. Inserción de Puestos de Trabajo (Jobs)
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('DEV_JR', 'Junior Developer', 3000, 6000);
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('HR_ASST', 'HR Assistant', 2500, 4500);
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('FIN_ANLY', 'Financial Analyst', 4000, 9000);
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('SALES_REP', 'Sales Representative', 2000, 8000);
 
-- 3. Inserción de Empleados
-- Nota: El empleado 4 (Lucía) se inserta con departamento NULL para pruebas de integridad.
INSERT INTO employees (employee_id, first_name, last_name, salary, hire_date, department_id, job_id)
VALUES (1, 'Carlos', 'García', 5000, TO_DATE('2024-01-21', 'YYYY-MM-DD'), 1, 'DEV_JR');
 
INSERT INTO employees (employee_id, first_name, last_name, salary, hire_date, department_id, job_id)
VALUES (2, 'Marta', 'Sánchez', 4500, TO_DATE('2023-05-15', 'YYYY-MM-DD'), 2, 'HR_ASST');
 
INSERT INTO employees (employee_id, first_name, last_name, salary, hire_date, department_id, job_id)
VALUES (3, 'Roberto', 'Sosa', 7500, TO_DATE('2022-11-20', 'YYYY-MM-DD'), 3, 'FIN_ANLY');
 
INSERT INTO employees (employee_id, first_name, last_name, salary, hire_date, department_id, job_id)
VALUES (4, 'Lucía', 'Pérez', 3200, TO_DATE('2024-02-01', 'YYYY-MM-DD'), NULL, 'SALES_REP');
 
INSERT INTO employees (employee_id, first_name, last_name, salary, hire_date, department_id, job_id)
VALUES (5, 'Jorge', 'Ramírez', 3800, TO_DATE('2021-08-12', 'YYYY-MM-DD'), 4, 'SALES_REP');

COMMIT;