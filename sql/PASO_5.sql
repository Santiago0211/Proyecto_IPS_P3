--Admin
insert into credenciales (nombre_usuario, password, tipo_usuario, estado) values ('admin', '240BE518FABD2724DDB6F04EEB1DA5967448D7E831C08C8FA822809F74C720A9', 'ADMIN', 'Activo');

-- Doctores credenciales 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('jperez', STANDARD_HASH('jperez123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('mlopez', STANDARD_HASH('mlopez123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('cgomez', STANDARD_HASH('cgomez123', 'SHA256'), 'DOCTOR', 'Activo');
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('lmartinez', STANDARD_HASH('lmartinez123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('rrodriguez', STANDARD_HASH('rrodriguez123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('ahernandez', STANDARD_HASH('ahernandez123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('sgarcia', STANDARD_HASH('sgarcia123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('dcastillo', STANDARD_HASH('dcastillo123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('mvega', STANDARD_HASH('mvega123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('jtorres', STANDARD_HASH('jtorres123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('pmorales', STANDARD_HASH('pmorales123', 'SHA256'), 'DOCTOR', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('nramirez', STANDARD_HASH('nramirez123', 'SHA256'), 'DOCTOR', 'Activo'); 
-- Pacientes credenciales 

INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('amarquez', STANDARD_HASH('amarquez123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('cmendoza', STANDARD_HASH('cmendoza123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('lsanchez', STANDARD_HASH('lsanchez123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('rdiaz', STANDARD_HASH('rdiaz123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('gortiz', STANDARD_HASH('gortiz123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('jruiz', STANDARD_HASH('jruiz123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('mvargas', STANDARD_HASH('mvargas123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('acastro', STANDARD_HASH('acastro123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('sromero', STANDARD_HASH('sromero123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('jhernandez', STANDARD_HASH('jhernandez123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('lflores', STANDARD_HASH('lflores123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('pgutierrez', STANDARD_HASH('pgutierrez123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('rmiranda', STANDARD_HASH('rmiranda123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('cvelasquez', STANDARD_HASH('cvelasquez123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('anavarro', STANDARD_HASH('anavarro123', 'SHA256'), 'PACIENTE', 'Activo'); 
INSERT INTO Credenciales (nombre_usuario, password, tipo_usuario, estado) VALUES ('dmolina', STANDARD_HASH('dmolina123', 'SHA256'), 'PACIENTE', 'Activo');

--Doctores

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234567', 'MED-20151234', 'Juan', 'Carlos', 'Perez', 'Gonzalez', '+573001234567', 'jperez@hospital.com', 1, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'jperez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234568', 'MED-20162345', 'Maria', 'Elena', 'Lopez', 'Ramirez', '+573001234568', 'mlopez@hospital.com', 7, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'mlopez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234569', 'ODO-20173456', 'Carlos', 'Alberto', 'Gomez', 'Suarez', '+573001234569', 'cgomez@hospital.com', 2, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'cgomez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234570', 'PSI-20184567', 'Laura', 'Cristina', 'Martinez', 'Ortiz', '+573001234570', 'lmartinez@hospital.com', 3, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'lmartinez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234571', 'MED-20195678', 'Roberto', 'Luis', 'Rodriguez', 'Diaz', '+573001234571', 'rrodriguez@hospital.com', 6, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'rrodriguez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234572', 'MED-20206789', 'Andrea', 'Paola', 'Hernandez', 'Castro', '+573001234572', 'ahernandez@hospital.com', 8, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'ahernandez'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234573', 'MED-20217890', 'Sergio', 'Antonio', 'Garcia', 'Moreno', '+573001234573', 'sgarcia@hospital.com', 9, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'sgarcia'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234574', 'MED-20228901', 'Diana', 'Carolina', 'Castillo', 'Vargas', '+573001234574', 'dcastillo@hospital.com', 10, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'dcastillo'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234575', 'NUT-20230123', 'Monica', 'Isabel', 'Vega', 'Rojas', '+573001234575', 'mvega@hospital.com', 5, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'mvega'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234576', 'MED-20241234', 'Jorge', 'Andres', 'Torres', 'Silva', '+573001234576', 'jtorres@hospital.com', 11, '14:00,14:20,14:40,15:00,15:20,15:40,16:00,16:20,16:40,17:00,17:20,17:40,18:00,18:20,18:40,19:00,19:20,19:40,20:00,20:20,20:40,21:00,21:20,21:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'jtorres'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234577', 'FIS-20252345', 'Patricia', 'Alejandra', 'Morales', 'Pineda', '+573001234577', 'pmorales@hospital.com', 12, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'pmorales'));

INSERT INTO Doctores (documentoid, numero_licencia, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, especialidad_id, horaatencion, usuario_id)
VALUES ('1065234578', 'ENF-20263456', 'Natalia', 'Sofia', 'Ramirez', 'Aguilar', '+573001234578', 'nramirez@hospital.com', 4, '06:00,06:20,06:40,07:00,07:20,07:40,08:00,08:20,08:40,09:00,09:20,09:40,10:00,10:20,10:40,11:00,11:20,11:40,12:00,12:20,12:40,13:00,13:20,13:40', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'nramirez'));


--Responsables

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100001', 'Pedro', 'Antonio', 'Marquez', 'Lopez', '+573101234567', 'pmarquez@gmail.com', 'Carrera 15 #20-30', 'Centro', 'Calle 20', 1, 'Comerciante');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100002', 'Rosa', 'Maria', 'Mendoza', 'Garcia', '+573101234568', 'rmendoza@gmail.com', 'Carrera 9 #18-45', 'La Nevada', 'Calle 18', 1, 'Docente');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100003', 'Luis', 'Fernando', 'Sanchez', 'Diaz', '+573101234569', 'lfsanchez@hotmail.com', 'Calle 12 #25-60', 'Sicarare', 'Calle 12', 1, 'Ingeniero');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100004', 'Carmen', 'Elena', 'Diaz', 'Ruiz', '+573101234570', 'cdiaz@yahoo.com', 'Carrera 7 #15-20', 'Centro', 'Calle 15', 1, 'Enfermera');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100005', 'Jose', 'Miguel', 'Ortiz', 'Martinez', '+573101234571', 'jmortiz@gmail.com', 'Carrera 20 #30-15', 'La Pola', 'Calle 30', 1, 'Contador');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100006', 'Angela', 'Patricia', 'Ruiz', 'Herrera', '+573101234572', 'aruiz@gmail.com', 'Calle 8 #12-40', 'Primero de Mayo', 'Calle 8', 2, 'Abogada');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100007', 'Ricardo', 'Andres', 'Vargas', 'Gomez', '+573101234573', 'rvargas@hotmail.com', 'Carrera 5 #10-25', 'El Centro', 'Calle 10', 2, 'Agricultor');

INSERT INTO Responsables (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, ocupacion)
VALUES ('1065100008', 'Gloria', 'Ines', 'Castro', 'Perez', '+573101234574', 'gcastro@gmail.com', 'Calle 6 #8-15', 'San Jose', 'Calle 6', 3, 'Ama de casa');


--Pacientes

INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300001', 'Ana', 'Maria', 'Marquez', 'Perez', '+573201234567', 'amarquez@gmail.com', 'Carrera 15 #20-30', 'Centro', 'Calle 20', 1, 28, 'F', 1, 'O', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'amarquez'));

-- Paciente 2 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300002', 'Carlos', 'Enrique', 'Mendoza', 'Torres', '+573201234568', 'cmendoza@gmail.com', 'Carrera 9 #18-45', 'La Nevada', 'Calle 18', 1, 35, 'M', 2, 'A', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'cmendoza'));

-- Paciente 3 - Niño (necesita responsable)
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300003', 'Laura', 'Sofia', 'Sanchez', 'Mendoza', '+573201234569', 'lsanchez@gmail.com', 'Calle 12 #25-60', 'Sicarare', 'Calle 12', 1, 8, 'F', 3, 'B', '+', '1065100003', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'lsanchez'));

-- Paciente 4 - Adulto mayor
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300004', 'Roberto', 'Carlos', 'Diaz', 'Hernandez', '+573201234570', 'rdiaz@gmail.com', 'Carrera 7 #15-20', 'Centro', 'Calle 15', 1, 67, 'M', 4, 'AB', '+', '1065100004', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'rdiaz'));

-- Paciente 5 - Joven
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300005', 'Gabriela', 'Andrea', 'Ortiz', 'Silva', '+573201234571', 'gortiz@hotmail.com', 'Carrera 20 #30-15', 'La Pola', 'Calle 30', 1, 22, 'F', 5, 'O', '-', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'gortiz'));

-- Paciente 6 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300006', 'Jorge', 'Luis', 'Ruiz', 'Castro', '+573201234572', 'jruiz@gmail.com', 'Calle 8 #12-40', 'Primero de Mayo', 'Calle 8', 2, 42, 'M', 6, 'A', '-', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'jruiz'));

-- Paciente 7 - Mujer embarazada
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300007', 'Monica', 'Alejandra', 'Vargas', 'Lopez', '+573201234573', 'mvargas@yahoo.com', 'Carrera 5 #10-25', 'El Centro', 'Calle 10', 2, 29, 'F', 7, 'B', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'mvargas'));

-- Paciente 8 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300008', 'Andres', 'Felipe', 'Castro', 'Ramirez', '+573201234574', 'acastro@gmail.com', 'Calle 6 #8-15', 'San Jose', 'Calle 6', 3, 31, 'M', 8, 'O', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'acastro'));

-- Paciente 9 - Adolescente (necesita responsable)
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300009', 'Sofia', 'Carolina', 'Romero', 'Gomez', '+573201234575', 'sromero@hotmail.com', 'Carrera 10 #14-20', 'La Esperanza', 'Calle 14', 1, 15, 'F', 9, 'A', '+', '1065100001', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'sromero'));

-- Paciente 10 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300010', 'Javier', 'Augusto', 'Hernandez', 'Vega', '+573201234576', 'jhernandez@gmail.com', 'Calle 22 #17-35', 'San Martin', 'Calle 22', 1, 45, 'M', 10, 'B', '-', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'jhernandez'));

-- Paciente 11 - Joven
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300011', 'Lucia', 'Fernanda', 'Flores', 'Reyes', '+573201234577', 'lflores@yahoo.com', 'Carrera 12 #19-40', 'Altos del Rosario', 'Calle 19', 1, 26, 'F', 1, 'O', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'lflores'));

-- Paciente 12 - Adulto mayor
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300012', 'Pablo', 'Emilio', 'Gutierrez', 'Mora', '+573201234578', 'pgutierrez@gmail.com', 'Calle 11 #13-25', 'Los Mayales', 'Calle 11', 4, 72, 'M', 2, 'AB', '-', '1065100005', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'pgutierrez'));

-- Paciente 13 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300013', 'Rosa', 'Elena', 'Miranda', 'Cruz', '+573201234579', 'rmiranda@hotmail.com', 'Carrera 8 #16-50', 'Santander', 'Calle 16', 5, 38, 'F', 3, 'A', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'rmiranda'));

-- Paciente 14 - Niño (necesita responsable)
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300014', 'Camilo', 'Andres', 'Velasquez', 'Ruiz', '+573201234580', 'cvelasquez@gmail.com', 'Calle 9 #11-30', 'Villa Rosa', 'Calle 9', 1, 10, 'M', 4, 'O', '-', '1065100006', 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'cvelasquez'));

-- Paciente 15 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300015', 'Andrea', 'Milena', 'Navarro', 'Ospina', '+573201234581', 'anavarro@yahoo.com', 'Carrera 14 #21-45', 'Popular', 'Calle 21', 1, 33, 'F', 5, 'B', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'anavarro'));

-- Paciente 16 - Adulto
INSERT INTO Pacientes (documentoid, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, correo, direccion, barrio, calle, ciudad_id, edad, sexo, eps_id, tipo_sangre, rh, documento_responsable, usuario_id)
VALUES ('1065300016', 'Diego', 'Alberto', 'Molina', 'Suarez', '+573201234582', 'dmolina@gmail.com', 'Calle 13 #18-20', 'Alfonso Lopez', 'Calle 13', 2, 40, 'M', 6, 'A', '+', NULL, 
        (SELECT usuario_id FROM Credenciales WHERE nombre_usuario = 'dmolina'));

--Parentescos

INSERT INTO Parentescos (tipo_parentesco, documento_paciente, documento_responsable)
VALUES ('Padre', '1065300003', '1065100003');

INSERT INTO Parentescos (tipo_parentesco, documento_paciente, documento_responsable)
VALUES ('Esposa', '1065300004', '1065100004');

INSERT INTO Parentescos (tipo_parentesco, documento_paciente, documento_responsable)
VALUES ('Padre', '1065300009', '1065100001');

INSERT INTO Parentescos (tipo_parentesco, documento_paciente, documento_responsable)
VALUES ('Hijo', '1065300012', '1065100005');

INSERT INTO Parentescos (tipo_parentesco, documento_paciente, documento_responsable)
VALUES ('Madre', '1065300014', '1065100006');

--CITAS

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300001', '1065234567', TO_DATE('2025-05-15', 'YYYY-MM-DD'), '09:00', 'Completada', 1);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300002', '1065234568', TO_DATE('2025-05-18', 'YYYY-MM-DD'), '10:00', 'Completada', 7);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300003', '1065234568', TO_DATE('2025-06-20', 'YYYY-MM-DD'), '08:00', 'Completada', 7);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300004', '1065234576', TO_DATE('2025-06-22', 'YYYY-MM-DD'), '09:30', 'Completada', 11);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300005', '1065234569', TO_DATE('2025-06-25', 'YYYY-MM-DD'), '14:00', 'Completada', 2);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300006', '1065234570', TO_DATE('2025-07-28', 'YYYY-MM-DD'), '11:00', 'Completada', 3);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300007', '1065234571', TO_DATE('2025-08-30', 'YYYY-MM-DD'), '10:00', 'Completada', 6);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300008', '1065234572', TO_DATE('2025-09-02', 'YYYY-MM-DD'), '15:00', 'Completada', 8);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300009', '1065234570', TO_DATE('2025-09-05', 'YYYY-MM-DD'), '13:00', 'Completada', 3);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300010', '1065234573', TO_DATE('2025-09-08', 'YYYY-MM-DD'), '09:00', 'Completada', 9);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300011', '1065234575', TO_DATE('2025-10-10', 'YYYY-MM-DD'), '10:30', 'Completada', 5);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300012', '1065234567', TO_DATE('2025-10-12', 'YYYY-MM-DD'), '11:00', 'Completada', 1);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300013', '1065234574', TO_DATE('2025-11-20', 'YYYY-MM-DD'), '09:00', 'Pendiente', 10);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300014', '1065234568', TO_DATE('2025-11-22', 'YYYY-MM-DD'), '14:00', 'Pendiente', 7);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300015', '1065234571', TO_DATE('2025-11-25', 'YYYY-MM-DD'), '10:00', 'Pendiente', 6);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300016', '1065234577', TO_DATE('2025-11-27', 'YYYY-MM-DD'), '15:00', 'Pendiente', 12);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300001', '1065234569', TO_DATE('2025-11-28', 'YYYY-MM-DD'), '16:00', 'Pendiente', 2);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300004', '1065234573', TO_DATE('2025-11-29', 'YYYY-MM-DD'), '08:00', 'Pendiente', 9);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300007', '1065234571', TO_DATE('2025-12-02', 'YYYY-MM-DD'), '11:00', 'Pendiente', 6);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300010', '1065234567', TO_DATE('2025-12-05', 'YYYY-MM-DD'), '09:30', 'Pendiente', 1);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300005', '1065234570', TO_DATE('2025-10-10', 'YYYY-MM-DD'), '10:00', 'Cancelada', 3);

INSERT INTO Citas (paciente_documentoid, doctor_documentoid, fecha, hora, estado, especialidad_id)
VALUES ('1065300011', '1065234572', TO_DATE('2025-10-12', 'YYYY-MM-DD'), '14:00', 'Cancelada', 8);

-- 7. HISTORIAS CLÍNICAS

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300001', '1065234567', 
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300001' AND doctor_documentoid = '1065234567' AND fecha = TO_DATE('2025-05-15', 'YYYY-MM-DD')), 
        1, 'Resfriado común con síntomas leves. Paciente presenta congestión nasal y tos seca.',
        'Acetaminofén 500mg cada 8 horas por 5 días. Abundantes líquidos y reposo.',
        'Control en 7 días si los síntomas persisten. Evitar cambios bruscos de temperatura.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300002', '1065234568',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300002' AND doctor_documentoid = '1065234568' AND fecha = TO_DATE('2025-05-18', 'YYYY-MM-DD')),
        7, 'Control pediátrico rutinario. Desarrollo acorde a la edad. Esquema de vacunación completo.',
        'Continuar con alimentación balanceada. Suplemento de vitaminas según edad.',
        'Próximo control en 6 meses. Mantener hábitos saludables.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300003', '1065234568',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300003' AND doctor_documentoid = '1065234568' AND fecha = TO_DATE('2025-06-20', 'YYYY-MM-DD')),
        7, 'Faringitis aguda. Dolor al tragar y fiebre de 38.5°C.',
        'Amoxicilina 500mg cada 12 horas por 7 días. Ibuprofeno para fiebre.',
        'Reposo y dieta blanda. Control si fiebre persiste más de 3 días.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300004', '1065234576',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300004' AND doctor_documentoid = '1065234576' AND fecha = TO_DATE('2025-06-22', 'YYYY-MM-DD')),
        11, 'Hipertensión arterial controlada. Presión arterial 130/85 mmHg.',
        'Continuar con Losartán 50mg una vez al día. Dieta baja en sodio.',
        'Control mensual de presión arterial. Ejercicio moderado 30 minutos diarios.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300005', '1065234569',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300005' AND doctor_documentoid = '1065234569' AND fecha = TO_DATE('2025-06-25', 'YYYY-MM-DD')),
        2, 'Caries en molar inferior derecho. Higiene oral deficiente.',
        'Obturación dental. Limpieza profunda. Instrucciones de higiene oral.',
        'Control en 15 días para revisión. Cepillado 3 veces al día.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300006', '1065234570',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300006' AND doctor_documentoid = '1065234570' AND fecha = TO_DATE('2025-07-28', 'YYYY-MM-DD')),
        3, 'Trastorno de ansiedad generalizada. Dificultad para conciliar el sueño.',
        'Terapia cognitivo-conductual. Técnicas de relajación y respiración.',
        'Sesiones semanales. Evitar cafeína después de las 2pm.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300007', '1065234571',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300007' AND doctor_documentoid = '1065234571' AND fecha = TO_DATE('2025-08-30', 'YYYY-MM-DD')),
        6, 'Control prenatal - Semana 24 de embarazo. Desarrollo fetal normal.',
        'Ácido fólico y hierro. Calcio 1200mg diarios. Controles mensuales.',
        'Próxima ecografía en 4 semanas. Dieta balanceada rica en proteínas.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300008', '1065234572',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300008' AND doctor_documentoid = '1065234572' AND fecha = TO_DATE('2025-09-02', 'YYYY-MM-DD')),
        8, 'Dermatitis seborreica en cuero cabelludo. Descamación y prurito leve.',
        'Champú de ketoconazol 2% tres veces por semana. Loción humectante.',
        'Evitar agua muy caliente. Control en 3 semanas.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300009', '1065234570',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300009' AND doctor_documentoid = '1065234570' AND fecha = TO_DATE('2025-09-05', 'YYYY-MM-DD')),
        3, 'Dificultades de adaptación escolar. Estrés por presión académica.',
        'Terapia individual y familiar. Técnicas de manejo del estrés.',
        'Involucrar padres en proceso terapéutico. Sesiones quincenales.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300010', '1065234573',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300010' AND doctor_documentoid = '1065234573' AND fecha = TO_DATE('2025-09-08', 'YYYY-MM-DD')),
        9, 'Esguince de tobillo grado II. Inflamación y dolor al caminar.',
        'Inmovilización con férula por 10 días. Antiinflamatorios. Compresas frías.',
        'Reposo absoluto primera semana. Fisioterapia después de inmovilización.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300011', '1065234575',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300011' AND doctor_documentoid = '1065234575' AND fecha = TO_DATE('2025-10-10', 'YYYY-MM-DD')),
        5, 'Sobrepeso. IMC 28.5. Hábitos alimenticios irregulares.',
        'Plan nutricional personalizado 1800 kcal/día. Ejercicio 4 veces por semana.',
        'Control mensual. Meta: reducir 2-3 kg al mes de forma saludable.');

INSERT INTO Historias_clinicas (paciente_documentoid, doctor_documentoid, cita_id, especialidad_id, diagnostico, tratamiento, observaciones)
VALUES ('1065300012', '1065234567',
        (SELECT cita_id FROM Citas WHERE paciente_documentoid = '1065300012' AND doctor_documentoid = '1065234567' AND fecha = TO_DATE('2025-10-12', 'YYYY-MM-DD')),
        1, 'Diabetes tipo 2 controlada. Glicemia en ayunas 115 mg/dL.',
        'Metformina 850mg dos veces al día. Dieta para diabéticos.',
        'Control trimestral de hemoglobina glicosilada. Ejercicio regular.');

COMMIT;

-- ============================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ============================================

PROMPT '';
PROMPT '============================================';
PROMPT 'RESUMEN DE DATOS INSERTADOS';
PROMPT '============================================';

SELECT 'Credenciales insertadas: ' || COUNT(*) AS total FROM Credenciales;
SELECT 'Doctores insertados: ' || COUNT(*) AS total FROM Doctores;
SELECT 'Responsables insertados: ' || COUNT(*) AS total FROM Responsables;
SELECT 'Pacientes insertados: ' || COUNT(*) AS total FROM Pacientes;
SELECT 'Parentescos insertados: ' || COUNT(*) AS total FROM Parentescos;
SELECT 'Citas insertadas: ' || COUNT(*) AS total FROM Citas;
SELECT 'Historias clínicas insertadas: ' || COUNT(*) AS total FROM Historias_clinicas;

PROMPT '';
PROMPT '============================================';
PROMPT 'DISTRIBUCIÓN DE DATOS';
PROMPT '============================================';

PROMPT 'Citas por estado:';
SELECT estado, COUNT(*) as cantidad 
FROM Citas 
GROUP BY estado 
ORDER BY estado;

PROMPT '';
PROMPT 'Pacientes por EPS:';
SELECT e.nombre, COUNT(p.documentoid) as cantidad
FROM EPS e
LEFT JOIN Pacientes p ON e.eps_id = p.eps_id
GROUP BY e.nombre
ORDER BY cantidad DESC;

PROMPT '';
PROMPT 'Doctores por especialidad:';
SELECT es.nombre, COUNT(d.documentoid) as cantidad
FROM Especialidades es
LEFT JOIN Doctores d ON es.especialidad_id = d.especialidad_id
GROUP BY es.nombre
ORDER BY cantidad DESC;

PROMPT '';
PROMPT '============================================';
PROMPT 'DATOS DE PRUEBA PARA LOGIN';
PROMPT '============================================';
PROMPT 'Usuario Doctor: jperez / Contraseña: jperez123';
PROMPT 'Usuario Paciente: amarquez / Contraseña: amarquez123';
PROMPT '============================================';
PROMPT 'FIN DEL SCRIPT';
PROMPT '============================================';