-- Te pedirá la clave del usuario SYSTEM (la que pusiste al instalar Oracle XE)
CONNECT system/&clave_system@localhost:1521/XEPDB1;

CREATE TABLESPACE proyecto_ips
-- Te pedirá la ruta COMPLETA del archivo, ej: C:\app\TuUsuario\product\18.0.0\oradata\XE\XEPDB1\proyecto_ips.dbf
DATAFILE '&ruta_datafile' 
SIZE 20M;

CREATE ROLE rol_admin;

GRANT CREATE ANY TABLE, CREATE VIEW,
CREATE SEQUENCE, CREATE PUBLIC SYNONYM,
CREATE ANY PROCEDURE, CREATE TRIGGER,
EXECUTE ANY PROCEDURE,
CREATE SESSION, CREATE USER,
CREATE ROLE, GRANT ANY PRIVILEGE TO rol_admin;

CREATE USER admin_ips IDENTIFIED BY Ips_admin_2026
DEFAULT TABLESPACE proyecto_ips
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON proyecto_ips;

GRANT rol_admin TO admin_ips WITH ADMIN OPTION;

CONNECT admin_ips/Ips_admin_2026@localhost:1521/XEPDB1;

CREATE ROLE rol_usuario_ips;

GRANT CREATE SESSION TO rol_usuario_ips;

CREATE USER usuario_ips IDENTIFIED BY usuario_ips123
DEFAULT TABLESPACE proyecto_ips
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON proyecto_ips;

CREATE TABLE Ciudades (
    ciudad_id NUMBER,
    nombre VARCHAR2(30) NOT NULL,
    departamento VARCHAR2(30) NOT NULL,
    pais VARCHAR2(30) NOT NULL
);

CREATE TABLE EPS (
    eps_id NUMBER,
    nombre VARCHAR2(30) NOT NULL,
    nit VARCHAR2(15) NOT NULL,
    telefono VARCHAR2(15),
    correo VARCHAR2(50),
    direccion VARCHAR2(50),
    tipo_regimen VARCHAR2(20)
);

CREATE TABLE Especialidades (
    especialidad_id NUMBER,
    nombre VARCHAR2(30) NOT NULL
);

CREATE TABLE Pacientes (
    documentoid VARCHAR2(20),
    primer_nombre VARCHAR2(20) NOT NULL,
    segundo_nombre VARCHAR2(20),
    primer_apellido VARCHAR2(20) NOT NULL,
    segundo_apellido VARCHAR2(20),
    telefono VARCHAR2(15),
    correo VARCHAR2(50),
    direccion VARCHAR2(30),
    barrio VARCHAR2(30),
    calle VARCHAR2(30),
    ciudad_id NUMBER,
    edad NUMBER(3),
    sexo CHAR(1),
    eps_id NUMBER,
    tipo_sangre VARCHAR2(2),
    rh CHAR(1),
    documento_responsable VARCHAR2(20),
    usuario_id NUMBER
);

CREATE TABLE Responsables (
    documentoid VARCHAR2(20) NOT NULL,
    primer_nombre VARCHAR2(20) NOT NULL,
    segundo_nombre VARCHAR2(20),
    primer_apellido VARCHAR2(20) NOT NULL,
    segundo_apellido VARCHAR2(20),
    telefono VARCHAR2(15),
    correo VARCHAR2(50),
    direccion VARCHAR2(30),
    barrio VARCHAR2(30),
    calle VARCHAR2(30),
    ciudad_id NUMBER,
    ocupacion VARCHAR2(50)
);

CREATE TABLE Parentescos (
    parentesco_id NUMBER NOT NULL,
    tipo_parentesco VARCHAR2(20) NOT NULL,
    documento_paciente VARCHAR2(20) NOT NULL,
    documento_responsable VARCHAR2(20) NOT NULL
);

CREATE TABLE Doctores (
    documentoid VARCHAR2(20),
    numero_licencia VARCHAR2(15) NOT NULL,
    primer_nombre VARCHAR2(20) NOT NULL,
    segundo_nombre VARCHAR2(20),
    primer_apellido VARCHAR2(20) NOT NULL,
    segundo_apellido VARCHAR2(20),
    telefono VARCHAR2(15),
    correo VARCHAR2(50),
    especialidad_id NUMBER,
    horaatencion VARCHAR2(200),
    usuario_id NUMBER
);

CREATE TABLE Credenciales (
    usuario_id NUMBER NOT NULL,
    nombre_usuario VARCHAR2(20) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    tipo_usuario VARCHAR2(20) NOT NULL,
    estado VARCHAR2(10) DEFAULT 'Activo'
);

CREATE TABLE Citas (
    cita_id NUMBER,
    paciente_documentoid VARCHAR2(20) NOT NULL,
    doctor_documentoid VARCHAR2(20) NOT NULL,
    fecha DATE NOT NULL,
    hora VARCHAR2(8) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Pendiente',
    especialidad_id NUMBER
);

CREATE TABLE Historias_clinicas (
    historia_id NUMBER,
    paciente_documentoid VARCHAR2(20) NOT NULL,
    doctor_documentoid VARCHAR2(20) NOT NULL,
    cita_id NUMBER NOT NULL,
    especialidad_id NUMBER NOT NULL,
    diagnostico VARCHAR2(500),
    tratamiento VARCHAR2(500),
    observaciones VARCHAR2(500)
);

-- PRIMARY KEYS
ALTER TABLE Ciudades ADD CONSTRAINT PK_CIUDAD PRIMARY KEY (ciudad_id);
ALTER TABLE EPS ADD CONSTRAINT PK_EPS PRIMARY KEY (eps_id);
ALTER TABLE Especialidades ADD CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (especialidad_id);
ALTER TABLE Pacientes ADD CONSTRAINT PK_PACIENTE PRIMARY KEY (documentoid);
ALTER TABLE Responsables ADD CONSTRAINT PK_RESPONSABLE PRIMARY KEY (documentoid);
ALTER TABLE Doctores ADD CONSTRAINT PK_DOCTOR PRIMARY KEY (documentoid);
ALTER TABLE Credenciales ADD CONSTRAINT PK_CREDENCIAL PRIMARY KEY (usuario_id);
ALTER TABLE Citas ADD CONSTRAINT PK_CITA PRIMARY KEY (cita_id);
ALTER TABLE Historias_clinicas ADD CONSTRAINT PK_HISTORIA PRIMARY KEY (historia_id);
ALTER TABLE Parentescos ADD CONSTRAINT PK_PARENTESCO PRIMARY KEY (parentesco_id);

-- FOREIGN KEYS
ALTER TABLE Pacientes ADD CONSTRAINT FK_PACIENTE_CIUDAD FOREIGN KEY (ciudad_id) REFERENCES Ciudades(ciudad_id);
ALTER TABLE Pacientes ADD CONSTRAINT FK_PACIENTE_EPS FOREIGN KEY (eps_id) REFERENCES EPS(eps_id);
ALTER TABLE Responsables ADD CONSTRAINT FK_RESPONSABLE_CIUDAD FOREIGN KEY (ciudad_id) REFERENCES Ciudades(ciudad_id);
ALTER TABLE Doctores ADD CONSTRAINT FK_DOCTOR_ESPECIALIDAD FOREIGN KEY (especialidad_id) REFERENCES Especialidades(especialidad_id);
ALTER TABLE Citas ADD CONSTRAINT FK_CITA_PACIENTE FOREIGN KEY (paciente_documentoid) REFERENCES Pacientes(documentoid);
ALTER TABLE Citas ADD CONSTRAINT FK_CITA_DOCTOR FOREIGN KEY (doctor_documentoid) REFERENCES Doctores(documentoid);
ALTER TABLE Historias_clinicas ADD CONSTRAINT FK_HISTORIA_PACIENTE FOREIGN KEY (paciente_documentoid) REFERENCES Pacientes(documentoid);
ALTER TABLE Historias_clinicas ADD CONSTRAINT FK_HISTORIA_DOCTOR FOREIGN KEY (doctor_documentoid) REFERENCES Doctores(documentoid);
ALTER TABLE Historias_clinicas ADD CONSTRAINT FK_HISTORIA_CITA FOREIGN KEY (cita_id) REFERENCES Citas(cita_id);
ALTER TABLE Historias_clinicas ADD CONSTRAINT FK_HISTORIA_ESPECIALIDAD FOREIGN KEY (especialidad_id) REFERENCES Especialidades(especialidad_id);
ALTER TABLE Pacientes ADD CONSTRAINT FK_PACIENTE_CREDENCIAL FOREIGN KEY (usuario_id) REFERENCES Credenciales(usuario_id);
ALTER TABLE Doctores ADD CONSTRAINT FK_DOCTOR_CREDENCIAL FOREIGN KEY (usuario_id) REFERENCES Credenciales(usuario_id);
ALTER TABLE Parentescos ADD CONSTRAINT FK_PARENTESCO_PACIENTE FOREIGN KEY (documento_paciente) REFERENCES Pacientes(documentoid);
ALTER TABLE Parentescos ADD CONSTRAINT FK_PARENTESCO_RESPONSABLE FOREIGN KEY (documento_responsable) REFERENCES Responsables(documentoid);

-- CREAR SINÓNIMOS
CREATE PUBLIC SYNONYM s_ciudades FOR Ciudades;
CREATE PUBLIC SYNONYM s_eps FOR EPS;
CREATE PUBLIC SYNONYM s_especialidades FOR Especialidades;
CREATE PUBLIC SYNONYM s_pacientes FOR Pacientes;
CREATE PUBLIC SYNONYM s_responsables FOR Responsables;
CREATE PUBLIC SYNONYM s_doctores FOR Doctores;
CREATE PUBLIC SYNONYM s_credenciales FOR Credenciales;
CREATE PUBLIC SYNONYM s_citas FOR Citas;
CREATE PUBLIC SYNONYM s_historias_clinicas FOR Historias_clinicas;
CREATE PUBLIC SYNONYM s_parentescos FOR Parentescos;

-- PERMISOS
GRANT SELECT, INSERT ON Ciudades TO rol_usuario_ips;
GRANT SELECT, INSERT ON EPS TO rol_usuario_ips;
GRANT SELECT, INSERT ON Especialidades TO rol_usuario_ips;
GRANT SELECT, INSERT ON Pacientes TO rol_usuario_ips;
GRANT SELECT, INSERT ON Responsables TO rol_usuario_ips;
GRANT SELECT, INSERT ON Doctores TO rol_usuario_ips;
GRANT SELECT, INSERT ON Credenciales TO rol_usuario_ips;
GRANT SELECT, INSERT ON Citas TO rol_usuario_ips;
GRANT SELECT, INSERT ON Historias_clinicas TO rol_usuario_ips;
GRANT SELECT, INSERT ON Parentescos TO rol_usuario_ips;

GRANT rol_usuario_ips TO usuario_ips;

PROMPT '============================================';
PROMPT 'SCRIPT EJECUTADO EXITOSAMENTE';
PROMPT '============================================';
PROMPT 'Tablespace: proyecto_ips';
PROMPT 'Usuario Admin: admin_ips / Ips_admin_2026';
PROMPT 'Usuario Estándar: usuario_ips / usuario_ips123';
PROMPT 'Rol Admin: rol_admin';
PROMPT 'Rol Usuario: rol_usuario_ips';
PROMPT '============================================';