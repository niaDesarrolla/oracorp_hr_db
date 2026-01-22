# 📔 Notas Técnicas y Convenciones MD

## 🛠️ Bitácora de Incidencias (Troubleshooting)

### Error 01: Insuficientes privilegios en esquema SYSTEM
* **Problema:** Al intentar crear tablas, se estaban guardando en el esquema del administrador.
* **Solución:** Se creó un usuario dedicado `C##ORACLE_HR` con roles `CONNECT` y `RESOURCE`.

### Error 02: ORA-01950 (no privileges on tablespace 'USERS')
* **Problema:** El usuario no podía insertar datos a pesar de tener permisos de recurso.
* **Solución:** Se ejecutó `ALTER USER C##ORACLE_HR QUOTA UNLIMITED ON USERS;`.

---

## 📖 Convenciones MD

* **Refactorizar:** Proceso de reestructurar código existente para mejorar su calidad y legibilidad sin alterar su comportamiento externo.
* **Naming Convention:** Conjunto de reglas para nombrar objetos (tablas, columnas) de forma consistente.
* **Hardcoding:** Práctica de escribir datos fijos directamente en el código en lugar de usar variables.
* **Deploy (Despliegue):** Proceso de llevar el código a un entorno de ejecución (ej. de GitHub a Docker).
* **Mensajes de Commit (Imperativo):** Convención de redactar cambios como órdenes (ej. "Agregar" en lugar de "Agregué") para describir la acción del commit.