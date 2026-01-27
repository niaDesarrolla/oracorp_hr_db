# 📔 Notas Técnicas y Convenciones MD

## 🛠️ Bitácora de Incidencias (Troubleshooting)

### Error 01: Insuficientes privilegios en esquema SYSTEM
* **Problema:** Al intentar crear tablas, se estaban guardando en el esquema del administrador.
* **Solución:** Se creó un usuario dedicado `C##ORACLE_HR` con roles `CONNECT` y `RESOURCE`.

### Error 02: ORA-01950 (no privileges on tablespace 'USERS')
* **Problema:** El usuario no podía insertar datos a pesar de tener permisos de recurso.
* **Solución:** Se ejecutó `ALTER USER C##ORACLE_HR QUOTA UNLIMITED ON USERS;`.

---
## 📈 Bitácora de Evolución y Casos de Soporte

### Refactorización de Integridad (23/01/2026)
* **Estandarización:** Se eliminaron nombres automáticos de sistema y se definieron nombres explícitos (`fk_dept`, `fk_job`).
* **Ajuste de Modelo:** Inclusión de la columna `hire_date` para métricas temporales de RRHH.

### Gestión de Ciclo de Vida del Esquema (23/01/2026)
* **Reconstrucción de Objetos:** Tras la refactorización de restricciones, se ejecutó un proceso de `DROP` y `CREATE` de tablas para limpiar nombres de sistema y aplicar nombres explícitos.
* **Carga de Datos DML con Integridad:** Se realizó la reinserción masiva de datos validando manualmente la jerarquía de carga (primero tablas maestras `DEPARTMENTS`/`JOBS`, luego tablas dependientes `EMPLOYEES`).
* **Validación de FK:** Se confirmó que todas las llaves foráneas bloquean correctamente registros con ID inexistentes, asegurando la calidad de la información desde el origen.

### Resolución de Tickets y Auditoría (26/01/2026)
* **Ticket #001 & #002 (Reportes):** Consolidación de datos de 3 tablas y generación de métricas de densidad de plantilla por departamento.
* **Ticket #003 (Auditoría):** Búsqueda proactiva de inconsistencias. Se confirmó que no existen departamentos sin personal asignado mediante validación de nulos.

## 🧠 Notas Técnicas y Validaciones (27/01/2026)

- **Gestión de Privilegios y Seguridad:** Se validó la restricción del "Principio de Menor Privilegio". Un usuario de esquema estándar requiere explícitamente el permiso `GRANT CREATE VIEW` otorgado por un DBA (SYSTEM) para gestionar objetos de abstracción.
- **Arquitectura vs. Rendimiento:** Se analizó que el uso de Vistas optimiza la **mantenibilidad** y legibilidad del código, aunque el rendimiento de las consultas sigue dependiendo de la indexación de las tablas base.
- **Implementación de Seguridad Lógica:** Se confirmó la efectividad de las vistas para el control de acceso a nivel de columna. Intentos de acceso a columnas no expuestas (como `salary`) resultan en `ORA-00904: invalid identifier`, garantizando la protección de datos sensibles.

## 📖 Convenciones MD

* **Refactorizar:** Proceso de reestructurar código existente para mejorar su calidad y legibilidad sin alterar su comportamiento externo.
* **Naming Convention:** Conjunto de reglas para nombrar objetos (tablas, columnas) de forma consistente.
* **Hardcoding:** Práctica de escribir datos fijos directamente en el código en lugar de usar variables.
* **Deploy (Despliegue):** Proceso de llevar el código a un entorno de ejecución (ej. de GitHub a Docker).
* * **Mensajes de Commit (Imperativo):** Convención de redactar cambios como órdenes (ej. "Agregar" en lugar de "Agregué") para describir la acción del commit.

* ### 📝 Convenciones de Naming y Estructura (27/01/2026)
* **Prefijos para Vistas:** Se establece el uso del prefijo `v_` para todos los objetos de tipo vista (ej. `v_maestro_empleados`). Esto permite diferenciar instantáneamente una tabla física de una lógica.
* **Alias de Columnas:** En las vistas destinadas a usuarios finales o reportes, se utilizarán alias en **MAYÚSCULAS** y con nombres descriptivos (ej. `first_name` AS `"NOMBRE"`) para mejorar la legibilidad del reporte final.
* **Uso de Operadores de Conciliación:** Para campos de nombre, se estandariza el uso del operador `||` con espacios intermedios para entregar resultados listos para su uso ejecutivo.
* **Documentación de Privilegios:** Toda elevación de permisos (como `GRANT`) debe quedar registrada en el script de carga o notas técnicas para asegurar la trazabilidad de la configuración del entorno.



