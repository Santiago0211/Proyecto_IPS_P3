-- ============================================
-- ELIMINAR SINÓNIMOS PÚBLICOS
-- ============================================
DROP PUBLIC SYNONYM s_ciudades;
DROP PUBLIC SYNONYM s_eps;
DROP PUBLIC SYNONYM s_especialidades;
DROP PUBLIC SYNONYM s_pacientes;
DROP PUBLIC SYNONYM s_pacientes;
DROP PUBLIC SYNONYM s_responsables;
DROP PUBLIC SYNONYM s_responsables;
DROP PUBLIC SYNONYM s_doctor;
DROP PUBLIC SYNONYM s_doctores;
DROP PUBLIC SYNONYM s_credenciales;
DROP PUBLIC SYNONYM s_citas;
DROP PUBLIC SYNONYM s_historias_clinicas;
DROP PUBLIC SYNONYM s_parentescos;

-- ============================================
-- ELIMINAR USUARIOS (CASCADE borra objetos)
-- ============================================
DROP USER admin_ips CASCADE;
DROP USER usuario_ips CASCADE;

-- ============================================
-- ELIMINAR ROLES
-- ============================================
DROP ROLE rol_admin;
DROP ROLE rol_usuario_ips;

-- ============================================
-- ELIMINAR TABLESPACE (con archivos)
-- ============================================
DROP TABLESPACE proyecto_ips INCLUDING CONTENTS AND DATAFILES;

-- ============================================
-- VERIFICACIÓN DE LIMPIEZA
-- ============================================

PROMPT '============================================';
PROMPT 'VERIFICANDO LIMPIEZA...';
PROMPT '============================================';

-- Verificar que no existen usuarios
SELECT 'Usuario: ' || username FROM dba_users 
WHERE username IN ('ADMIN_IPS', 'USUARIO_IPS');

-- Verificar que no existen roles
SELECT 'Rol: ' || role FROM dba_roles 
WHERE role IN ('ROL_ADMIN', 'ROL_USUARIO_IPS');

-- Verificar que no existe tablespace
SELECT 'Tablespace: ' || tablespace_name FROM dba_tablespaces 
WHERE tablespace_name = 'PROYECTO_IPS';

PROMPT '============================================';
PROMPT 'Si no aparece nada arriba, la limpieza fue exitosa';
PROMPT '============================================';