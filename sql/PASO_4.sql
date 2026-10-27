INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Valledupar', 'Cesar', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Aguachica', 'Cesar', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('La Paz', 'Cesar', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Agustin Codazzi', 'Cesar', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Bosconia', 'Cesar', 'Colombia');

-- Ciudades cercanas (Costa Caribe)
INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Santa Marta', 'Magdalena', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Barranquilla', 'Atlantico', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Riohacha', 'La Guajira', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Bogota', 'Cundinamarca', 'Colombia');

INSERT INTO Ciudades (nombre, departamento, pais) 
VALUES ('Bucaramanga', 'Santander', 'Colombia');



INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Nueva EPS', '900156264-1', '018000952020', 'contacto@nuevaeps.com.co', 
        'Calle 26 #69D-91', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Sanitas EPS', '800251440-6', '6018000519519', 'servicioalcliente@keralty.com', 
        'Av. El Dorado #69-76', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('SURA EPS', '800088702-7', '6014441234', 'atencioneps@sura.com.co', 
        'Calle 16 Sur #43A-49', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Salud Total EPS', '800130907-1', '6013077000', 'servicioalcliente@saludtotal.com.co', 
        'Calle 127A #53A-45', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Compensar EPS', '860066942-7', '6014441234', 'contactenos@compensar.com', 
        'Av. Calle 68 #49A-47', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Famisanar EPS', '830003564-5', '6015139000', 'servicioalafiliado@famisanar.com.co', 
        'Cra. 13 #32-76', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Coosalud EPS', '892300082-2', '6053853535', 'atencionalusuario@coosalud.com', 
        'Cra. 54 #59-129', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Mutual SER EPS', '830037950-0', '6013078000', 'contactenos@mutualser.com', 
        'Calle 67 #7-94', 'Contributivo');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Comfamiliar Cesar', '892300016-1', '6055742525', 'info@comfacesar.com', 
        'Calle 16 #9-52 Valledupar', 'Subsidiado');

INSERT INTO EPS (nombre, nit, telefono, correo, direccion, tipo_regimen)
VALUES ('Cajacopi EPS', '860028415-2', '6018000122122', 'servicio@cajacopi.com', 
        'Cra. 7 #24-89', 'Subsidiado');



INSERT INTO Especialidades (nombre)
VALUES ('Medicina General');

INSERT INTO Especialidades ( nombre)
VALUES ('Odontologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Psicologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Enfermeria');

INSERT INTO Especialidades ( nombre)
VALUES ('Nutricion y Dietetica');

INSERT INTO Especialidades ( nombre)
VALUES ('Ginecologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Pediatria');

INSERT INTO Especialidades ( nombre)
VALUES ('Dermatologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Traumatologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Oftalmologia');

INSERT INTO Especialidades ( nombre)
VALUES ('Medicina Interna');

INSERT INTO Especialidades ( nombre)
VALUES ('Fisioterapia');

COMMIT;

-- ============================================
-- VERIFICAR DATOS INSERTADOS
-- ============================================

PROMPT '============================================';
PROMPT 'DATOS INSERTADOS CORRECTAMENTE';
PROMPT '============================================';

-- Contar ciudades
SELECT 'Ciudades insertadas: ' || COUNT(*) AS total FROM Ciudades;

-- Contar EPS
SELECT 'EPS insertadas: ' || COUNT(*) AS total FROM EPS;

-- Contar Especialidades
SELECT 'Especialidades insertadas: ' || COUNT(*) AS total FROM Especialidades;

PROMPT '============================================';
PROMPT 'Verificación de datos:';
PROMPT '============================================';

-- Ver ciudades del Cesar
SELECT , nombre, departamento FROM Ciudades WHERE departamento = 'Cesar';

-- Ver todas las EPS
SELECT  nombre, tipo_regimen FROM EPS;

-- Ver todas las especialidades
SELECT  nombre FROM Especialidades;

PROMPT '============================================';
PROMPT 'FIN DEL SCRIPT';
PROMPT '============================================';