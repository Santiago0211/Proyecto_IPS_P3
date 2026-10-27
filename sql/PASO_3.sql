--Creacion de secuencias

CREATE SEQUENCE seq_historia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_especialidad START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_eps START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ciudad START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cita START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_credenciales START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_parentesco START WITH 1 INCREMENT BY 1;

--Creacion de paquetes

--Paquete cita

create or replace PACKAGE pkg_cita AS
    PROCEDURE SP_INSERTAR_CITA (
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_ACTUALIZAR_CITA (
        p_cita_id IN NUMBER,
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_CAMBIAR_ESTADO_CITA (
        p_cita_id IN NUMBER,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_CITAS_POR_ESPECIALIDAD_MES (
        p_desde   IN  DATE DEFAULT NULL,
        p_hasta   IN  DATE DEFAULT NULL,
        p_cursor  OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_CITAS_DOCTOR (
        p_doctor_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_CITAS_ESTADO (
        p_estado IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_CITAS_FECHA (
        p_fecha IN DATE,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_CITAS_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_CITAS_PENDIENTES_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_TOTAL_CITAS_MES(
        p_anio   IN  NUMBER DEFAULT NULL,   
        p_cursor OUT SYS_REFCURSOR
    );
    FUNCTION FN_EXISTE_CITA_HORARIO (
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2
    )RETURN NUMBER;
    FUNCTION FN_EXISTE_CITA_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2
    ) RETURN NUMBER;
END pkg_cita;
/

create or replace PACKAGE BODY pkg_cita AS
    PROCEDURE SP_INSERTAR_CITA (
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_citas (
            paciente_documentoid, doctor_documentoid,
            fecha, hora, estado, especialidad_id
        ) VALUES (
            p_paciente_doc, p_doctor_doc,
            p_fecha, p_hora, p_estado, p_especialidad_id
        );
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_ACTUALIZAR_CITA (
        p_cita_id IN NUMBER,
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_citas SET
            paciente_documentoid = p_paciente_doc,
            doctor_documentoid = p_doctor_doc,
            fecha = p_fecha,
            hora = p_hora,
            especialidad_id = p_especialidad_id,
            estado = p_estado
        WHERE cita_id = p_cita_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_CAMBIAR_ESTADO_CITA (
        p_cita_id IN NUMBER,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_citas
        SET estado = p_estado
        WHERE cita_id = p_cita_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_CITAS_POR_ESPECIALIDAD_MES (
        p_desde   IN  DATE DEFAULT NULL,
        p_hasta   IN  DATE DEFAULT NULL,
        p_cursor  OUT SYS_REFCURSOR
    ) AS
        v_desde DATE := NVL(p_desde, TRUNC(SYSDATE, 'MM'));
        v_hasta DATE := NVL(p_hasta, ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1));
    BEGIN
        OPEN p_cursor FOR
            SELECT
                e.ESPECIALIDAD_ID,
                e.NOMBRE AS ESPECIALIDAD,
                COUNT(c.CITA_ID) AS TOTAL
            FROM
                S_CITAS c
                JOIN S_ESPECIALIDADES e
                  ON c.ESPECIALIDAD_ID = e.ESPECIALIDAD_ID
            WHERE
                c.FECHA >= v_desde
                AND c.FECHA < v_hasta
            GROUP BY
                e.ESPECIALIDAD_ID, e.NOMBRE
            ORDER BY
                TOTAL DESC;

    EXCEPTION
        WHEN OTHERS THEN
            OPEN p_cursor FOR
                SELECT NULL AS ESPECIALIDAD_ID, 'ERROR' AS ESPECIALIDAD, 0 AS TOTAL FROM DUAL;
    END;

    PROCEDURE SP_OBTENER_CITAS_DOCTOR (
        p_doctor_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_citas
            WHERE doctor_documentoid = p_doctor_doc
            ORDER BY fecha DESC, hora DESC;
    END;

    PROCEDURE SP_OBTENER_CITAS_ESTADO (
        p_estado IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_citas
            WHERE estado = p_estado
            ORDER BY fecha DESC, hora DESC;
    END;

    PROCEDURE SP_OBTENER_CITAS_FECHA (
        p_fecha IN DATE,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_citas
            WHERE TRUNC(fecha) = TRUNC(p_fecha)
            ORDER BY hora;
    END;

    PROCEDURE SP_OBTENER_CITAS_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_citas
            WHERE paciente_documentoid = p_paciente_doc
            ORDER BY fecha DESC, hora DESC;
    END;

    PROCEDURE SP_OBTENER_CITAS_PENDIENTES_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_citas
            WHERE paciente_documentoid = p_paciente_doc
            AND estado = 'Pendiente'
            AND fecha >= TRUNC(SYSDATE)
            ORDER BY fecha, hora;
    END;

    PROCEDURE SP_TOTAL_CITAS_MES(
        p_anio   IN  NUMBER DEFAULT NULL,  
        p_cursor OUT SYS_REFCURSOR
    ) AS
        v_anio NUMBER := NVL(p_anio, EXTRACT(YEAR FROM SYSDATE));
    BEGIN
        OPEN p_cursor FOR
            WITH meses AS (
                SELECT ADD_MONTHS(TRUNC(TO_DATE(v_anio, 'YYYY'), 'YYYY'), LEVEL - 1) AS mes_ini,
                       LEVEL AS mes_num
                FROM dual
                CONNECT BY LEVEL <= 12
            )
            SELECT
                m.mes_num AS MES,                         
                NVL(COUNT(c.cita_id), 0) AS TOTAL
            FROM meses m
            LEFT JOIN s_citas c
                   ON c.fecha >= m.mes_ini
                  AND c.fecha <  ADD_MONTHS(m.mes_ini, 1)
            GROUP BY m.mes_num
            ORDER BY m.mes_num;
    END;

    FUNCTION FN_EXISTE_CITA_HORARIO (
        p_doctor_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM s_citas
        WHERE doctor_documentoid = p_doctor_doc
        AND TRUNC(fecha) = TRUNC(p_fecha)
        AND hora = p_hora
        AND estado != 'Cancelada';

        RETURN v_count;
    END;

    FUNCTION FN_EXISTE_CITA_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_fecha IN DATE,
        p_hora IN VARCHAR2
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM s_citas
        WHERE paciente_documentoid = p_paciente_doc
        AND TRUNC(fecha) = TRUNC(p_fecha)
        AND hora = p_hora
        AND estado != 'Cancelada';

        RETURN v_count;
    END;
END pkg_cita;
/

--Paquete ciudad

create or replace PACKAGE pkg_ciudad AS
    PROCEDURE SP_ACTUALIZAR_CIUDAD (
        p_ciudad_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_INSERTAR_CIUDAD (
        p_nombre IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_resultado OUT NUMBER
    );
END pkg_ciudad;
/

create or replace PACKAGE BODY pkg_ciudad AS
    PROCEDURE SP_ACTUALIZAR_CIUDAD (
        p_ciudad_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE ciudades SET
            nombre = p_nombre,
            departamento = p_departamento,
            pais = p_pais
        WHERE ciudad_id = p_ciudad_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
    PROCEDURE SP_INSERTAR_CIUDAD (
        p_nombre IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_ciudades (nombre, departamento, pais)
        VALUES (p_nombre, p_departamento, p_pais);
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_ciudad;
/

--Paquete credenciales

create or replace PACKAGE pkg_credenciales AS
    PROCEDURE SP_INSERTAR_CREDENCIALES (
        p_nombre_usuario IN VARCHAR2,
        p_password       IN VARCHAR2,
        p_tipo_usuario   IN VARCHAR2,
        p_usuario_id     OUT NUMBER,    
        p_resultado      OUT NUMBER
    );
    PROCEDURE SP_ACTUALIZAR_CREDENCIALES (
        p_usuario_id IN NUMBER,
        p_nombre_usuario IN VARCHAR2,
        p_password IN VARCHAR2,
        p_tipo_usuario IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_CAMBIAR_ESTADO_USUARIO (
        p_username IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_CAMBIAR_PASSWORD (
        p_username IN VARCHAR2,
        p_nueva_password IN VARCHAR2,
        p_resultado OUT NUMBER
    );
     FUNCTION FN_EXISTE_USUARIO (
        p_username IN VARCHAR2
    ) RETURN NUMBER;
    FUNCTION FN_OBTENER_TIPO_USUARIO (
        p_username IN VARCHAR2
    ) RETURN VARCHAR2;
    FUNCTION FN_VERIFICAR_CREDENCIALES (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN NUMBER;
END pkg_credenciales;
/

create or replace PACKAGE BODY pkg_credenciales AS
    PROCEDURE SP_INSERTAR_CREDENCIALES (
        p_nombre_usuario IN VARCHAR2,
        p_password IN VARCHAR2,
        p_tipo_usuario IN VARCHAR2,
	p_usuario_id OUT NUMBER,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_credenciales (nombre_usuario, password, tipo_usuario)
        VALUES (p_nombre_usuario, p_password, p_tipo_usuario)
        RETURNING usuario_id INTO p_usuario_id;
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_ACTUALIZAR_CREDENCIALES (
        p_usuario_id IN NUMBER,
        p_nombre_usuario IN VARCHAR2,
        p_password IN VARCHAR2,
        p_tipo_usuario IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_credenciales SET
            nombre_usuario = p_nombre_usuario,
            password = p_password,
            tipo_usuario = p_tipo_usuario,
            estado = p_estado
        WHERE usuario_id = p_usuario_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_CAMBIAR_ESTADO_USUARIO (
        p_username IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_credenciales
        SET estado = p_estado
        WHERE nombre_usuario = p_username;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_CAMBIAR_PASSWORD (
        p_username IN VARCHAR2,
        p_nueva_password IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_credenciales
        SET password = p_nueva_password
        WHERE nombre_usuario = p_username;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    FUNCTION FN_EXISTE_USUARIO (
        p_username IN VARCHAR2
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM s_credenciales
        WHERE nombre_usuario = p_username;

        RETURN v_count;
    END;

    FUNCTION FN_OBTENER_TIPO_USUARIO (
        p_username IN VARCHAR2
    ) RETURN VARCHAR2 AS
        v_tipo_usuario VARCHAR2(50);
    BEGIN
        SELECT tipo_usuario
        INTO v_tipo_usuario
        FROM s_credenciales
        WHERE nombre_usuario = p_username;

        RETURN v_tipo_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;

    FUNCTION FN_VERIFICAR_CREDENCIALES (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM s_credenciales
        WHERE nombre_usuario = p_username
        AND LOWER(password) = LOWER(p_password)
        AND estado = 'Activo';

        RETURN v_count;
    END;
END pkg_credenciales;
/

--Paquete doctor

create or replace PACKAGE pkg_doctor AS
    PROCEDURE SP_ACTUALIZAR_DOCTOR (
        p_documento IN VARCHAR2,
        p_numero_licencia IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_hora_atencion IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_INSERTAR_DOCTOR (
        p_documento IN VARCHAR2,
        p_numero_licencia IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_hora_atencion IN VARCHAR2,
        p_usuario_id IN NUMBER,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_OBTENER_DOCTORES_ESP (
        p_especialidad_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
END pkg_doctor;
/

create or replace PACKAGE BODY pkg_doctor AS
    PROCEDURE SP_ACTUALIZAR_DOCTOR (
        p_documento IN VARCHAR2,
        p_numero_licencia IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_hora_atencion IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_doctores SET
            numero_licencia = p_numero_licencia,
            primer_nombre = p_primer_nombre,
            segundo_nombre = p_segundo_nombre,
            primer_apellido = p_primer_apellido,
            segundo_apellido = p_segundo_apellido,
            telefono = p_telefono,
            correo = p_correo,
            especialidad_id = p_especialidad_id,
            horaatencion = p_hora_atencion
        WHERE documentoid = p_documento;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_INSERTAR_DOCTOR (
        p_documento IN VARCHAR2,
        p_numero_licencia IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_hora_atencion IN VARCHAR2,
        p_usuario_id IN NUMBER,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_doctores (
            documentoid, numero_licencia, primer_nombre, segundo_nombre,
            primer_apellido, segundo_apellido, telefono, correo,
            especialidad_id, horaatencion, usuario_id
        ) VALUES (
            p_documento, p_numero_licencia, p_primer_nombre, p_segundo_nombre,
            p_primer_apellido, p_segundo_apellido, p_telefono, p_correo,
            p_especialidad_id, p_hora_atencion, p_usuario_id
        );
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_OBTENER_DOCTORES_ESP (
        p_especialidad_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_doctores
            WHERE especialidad_id = p_especialidad_id
            ORDER BY primer_nombre;
    END;
END pkg_doctor;
/

--Paquete 

create or replace PACKAGE pkg_eps AS
    PROCEDURE SP_INSERTAR_EPS (
        p_nombre IN VARCHAR2,
	p_nit IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
	p_direccion IN VARCHAR2,
	p_regimen IN VARCHAR2,
        p_resultado OUT NUMBER
    ); 
    PROCEDURE SP_ACTUALIZAR_EPS (
        p_eps_id IN NUMBER,
        p_nombre IN VARCHAR2,
	p_nit IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
	p_direccion IN VARCHAR2,
	p_regimen IN VARCHAR2,
        p_resultado OUT NUMBER
    );
END pkg_eps;
/

create or replace PACKAGE BODY pkg_eps AS
    PROCEDURE SP_INSERTAR_EPS (
        p_nombre IN VARCHAR2,
	p_nit IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
	p_direccion IN VARCHAR2,
	p_regimen IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_eps (nombre, nit, telefono, correo, direccion, tipo_regimen)
        VALUES (p_nombre, p_nit, p_telefono, p_correo, p_direccion, p_regimen);
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

     PROCEDURE SP_ACTUALIZAR_EPS (
        p_eps_id IN NUMBER,
        p_nombre IN VARCHAR2,
	p_nit IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
	p_direccion IN VARCHAR2,
	p_regimen IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_eps SET
            nombre = p_nombre,
	    nit = p_nit,
            telefono = p_telefono,
            correo = p_correo,
	    direccion = p_direccion,
	    tipo_regimen = p_regimen
        WHERE eps_id = p_eps_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_eps;
/

--Paquete especialidad

create or replace PACKAGE pkg_especialidades AS
    PROCEDURE SP_INSERTAR_ESPECIALIDAD (
        p_nombre IN VARCHAR2,
        p_resultado OUT NUMBER
    ); 
    PROCEDURE SP_ACTUALIZAR_ESPECIALIDAD (
        p_especialidad_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_resultado OUT NUMBER
    );
END pkg_especialidades;
/

create or replace PACKAGE BODY pkg_especialidades AS
    PROCEDURE SP_INSERTAR_ESPECIALIDAD (
        p_nombre IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_especialidades (nombre)
        VALUES (p_nombre);
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

     PROCEDURE SP_ACTUALIZAR_ESPECIALIDAD (
        p_especialidad_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_especialidades SET
            nombre = p_nombre
        WHERE especialidad_id = p_especialidad_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_especialidades;
/

--Paquete parentesco

create or replace PACKAGE pkg_parentescos AS
    PROCEDURE SP_INSERTAR_PARENTESCO (
        p_tipo IN VARCHAR2,
	p_paciente IN VARCHAR2,
	p_responsable IN VARCHAR2,
        p_resultado OUT NUMBER
    ); 
    PROCEDURE SP_ACTUALIZAR_PARENTESCO (
        p_parentesco_id IN NUMBER,
        p_tipo IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    FUNCTION FN_GET_PARENTESCO (
        p_paciente    IN VARCHAR2,
        p_responsable IN VARCHAR2
    ) RETURN SYS_REFCURSOR;
END pkg_parentescos;
/

create or replace PACKAGE BODY pkg_parentescos AS
    PROCEDURE SP_INSERTAR_PARENTESCO (
        p_tipo IN VARCHAR2,
	p_paciente IN VARCHAR2,
	p_responsable IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_parentescos (tipo_parentesco, documento_paciente, documento_responsable)
        VALUES (p_tipo, p_paciente, p_responsable);
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

     PROCEDURE SP_ACTUALIZAR_PARENTESCO (
        p_parentesco_id IN NUMBER,
        p_tipo IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_parentescos SET
            tipo_parentesco = p_tipo
        WHERE parentesco_id = p_parentesco_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    FUNCTION FN_GET_PARENTESCO (
    	p_paciente    IN VARCHAR2,
    	p_responsable IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS v_cursor SYS_REFCURSOR;
    BEGIN
      OPEN v_cursor FOR
        SELECT parentesco_id,
               tipo_parentesco,
               documento_paciente,
               documento_responsable
        FROM   s_parentescos
        WHERE  documento_paciente    = p_paciente
        AND    documento_responsable = p_responsable;

      RETURN v_cursor;
    END FN_GET_PARENTESCO;

END pkg_parentescos;
/

--Paquete historia

create or replace PACKAGE pkg_historia AS
    PROCEDURE SP_INSERTAR_HISTORIA (
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_cita_id IN NUMBER,
        p_especialidad_id IN NUMBER,
        p_diagnostico IN VARCHAR2,
        p_tratamiento IN VARCHAR2,
        p_observaciones IN VARCHAR2,
        p_resultado OUT NUMBER
    ); 
    PROCEDURE SP_ACTUALIZAR_HISTORIA (
        p_historia_id IN NUMBER,
        p_diagnostico IN VARCHAR2,
        p_tratamiento IN VARCHAR2,
        p_observaciones IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_OBTENER_HISTORIA_CITA (
        p_cita_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_HISTORIAS_DOCTOR (
        p_doctor_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_HISTORIAS_ESP (
        p_paciente_doc IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE SP_OBTENER_HISTORIAS_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
    FUNCTION FN_EXISTE_HISTORIA_CITA (
        p_cita_id IN NUMBER
    ) RETURN NUMBER;
END pkg_historia;
/

create or replace PACKAGE BODY pkg_historia AS
    PROCEDURE SP_INSERTAR_HISTORIA (
        p_paciente_doc IN VARCHAR2,
        p_doctor_doc IN VARCHAR2,
        p_cita_id IN NUMBER,
        p_especialidad_id IN NUMBER,
        p_diagnostico IN VARCHAR2,
        p_tratamiento IN VARCHAR2,
        p_observaciones IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_historias_clinicas (
            paciente_documentoid, doctor_documentoid,
            cita_id, especialidad_id, diagnostico, tratamiento, observaciones
        ) VALUES (
            p_paciente_doc, p_doctor_doc,
            p_cita_id, p_especialidad_id, p_diagnostico, p_tratamiento, p_observaciones
        );
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_ACTUALIZAR_HISTORIA (
        p_historia_id IN NUMBER,
        p_diagnostico IN VARCHAR2,
        p_tratamiento IN VARCHAR2,
        p_observaciones IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_historias_clinicas
        SET diagnostico = p_diagnostico,
            tratamiento = p_tratamiento,
            observaciones = p_observaciones
        WHERE historia_id = p_historia_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_OBTENER_HISTORIA_CITA (
        p_cita_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM s_historias_clinicas
            WHERE cita_id = p_cita_id;
    END;

    PROCEDURE SP_OBTENER_HISTORIAS_DOCTOR (
        p_doctor_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT h.*
            FROM s_historias_clinicas h
            INNER JOIN s_citas c ON h.cita_id = c.cita_id
            WHERE h.doctor_documentoid = p_doctor_doc
            ORDER BY c.fecha DESC;
    END;

    PROCEDURE SP_OBTENER_HISTORIAS_ESP (
        p_paciente_doc IN VARCHAR2,
        p_especialidad_id IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT h.*
            FROM s_historias_clinicas h
            INNER JOIN s_citas c ON h.cita_id = c.cita_id
            WHERE h.paciente_documentoid = p_paciente_doc
            AND h.especialidad_id = p_especialidad_id
            ORDER BY c.fecha DESC;
    END;

    PROCEDURE SP_OBTENER_HISTORIAS_PACIENTE (
        p_paciente_doc IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT h.*
            FROM s_historias_clinicas h
            INNER JOIN s_citas c ON h.cita_id = c.cita_id
            WHERE h.paciente_documentoid = p_paciente_doc
            ORDER BY c.fecha DESC;
    END;

    FUNCTION FN_EXISTE_HISTORIA_CITA (
        p_cita_id IN NUMBER
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM s_historias_clinicas
        WHERE cita_id = p_cita_id;
        RETURN v_count;
    END;
END pkg_historia;
/

--Paquete paciente

create or replace PACKAGE pkg_paciente AS
    PROCEDURE SP_ACTUALIZAR_PACIENTE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_edad IN NUMBER,
        p_sexo IN CHAR,
        p_tipo_sangre IN VARCHAR2,
        p_rh IN CHAR,
        p_direccion IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_eps_id IN NUMBER,
        p_documento_responsable IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_INSERTAR_PACIENTE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_edad IN NUMBER,
        p_sexo IN CHAR,
        p_tipo_sangre IN VARCHAR2,
        p_rh IN CHAR,
        p_direccion IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_eps_id IN NUMBER,
        p_documento_responsable IN VARCHAR2,
        p_usuario_id IN NUMBER,
        p_resultado OUT NUMBER
    );
END pkg_paciente;
/

create or replace PACKAGE BODY pkg_paciente AS

    PROCEDURE SP_ACTUALIZAR_PACIENTE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_edad IN NUMBER,
        p_sexo IN CHAR,
        p_tipo_sangre IN VARCHAR2,
        p_rh IN CHAR,
        p_direccion IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_eps_id IN NUMBER,
        p_documento_responsable IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_pacientes SET
            primer_nombre = p_primer_nombre,
            segundo_nombre = p_segundo_nombre,
            primer_apellido = p_primer_apellido,
            segundo_apellido = p_segundo_apellido,
            telefono = p_telefono,
            correo = p_correo,
            edad = p_edad,
            sexo = p_sexo,
            tipo_sangre = p_tipo_sangre,
            rh = p_rh,
            direccion = p_direccion,
        calle = p_calle,
        barrio = p_barrio,
            ciudad_id = p_ciudad_id,
            eps_id = p_eps_id,
            documento_responsable = p_documento_responsable
        WHERE documentoid = p_documento;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_INSERTAR_PACIENTE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_edad IN NUMBER,
        p_sexo IN CHAR,
        p_tipo_sangre IN VARCHAR2,
        p_rh IN CHAR,
        p_direccion IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_eps_id IN NUMBER,
        p_documento_responsable IN VARCHAR2,
        p_usuario_id IN NUMBER,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_pacientes (
            documentoid, primer_nombre, segundo_nombre, primer_apellido,
            segundo_apellido, telefono, correo, edad, sexo,
            tipo_sangre, rh, direccion, calle, barrio, ciudad_id, eps_id, documento_responsable, usuario_id
        ) VALUES (
            p_documento, p_primer_nombre, p_segundo_nombre, p_primer_apellido,
            p_segundo_apellido, p_telefono, p_correo, p_edad, p_sexo,
            p_tipo_sangre, p_rh, p_direccion, p_calle, p_barrio, p_ciudad_id, p_eps_id, p_documento_responsable, p_usuario_id
        );
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_paciente;
/

--Paquete responsable

create or replace PACKAGE pkg_responsable AS
    PROCEDURE SP_ACTUALIZAR_RESPONSABLE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_ocupacion IN VARCHAR2,
        p_resultado OUT NUMBER
    );
    PROCEDURE SP_INSERTAR_RESPONSABLE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_ocupacion IN VARCHAR2,
        p_resultado OUT NUMBER
    );
END pkg_responsable;
/

create or replace PACKAGE BODY pkg_responsable AS

    PROCEDURE SP_ACTUALIZAR_RESPONSABLE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_ocupacion IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        UPDATE s_responsables SET
            primer_nombre = p_primer_nombre,
            segundo_nombre = p_segundo_nombre,
            primer_apellido = p_primer_apellido,
            segundo_apellido = p_segundo_apellido,
            telefono = p_telefono,
            correo = p_correo,
            direccion = p_direccion,
            barrio = p_barrio,
            calle = p_calle,
            ciudad_id = p_ciudad_id,
            ocupacion = p_ocupacion
        WHERE documentoid = p_documento;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;

    PROCEDURE SP_INSERTAR_RESPONSABLE (
        p_documento IN VARCHAR2,
        p_primer_nombre IN VARCHAR2,
        p_segundo_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_barrio IN VARCHAR2,
        p_calle IN VARCHAR2,
        p_ciudad_id IN NUMBER,
        p_ocupacion IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO s_responsables (
            documentoid, primer_nombre, segundo_nombre, primer_apellido,
            segundo_apellido, telefono, correo, direccion, barrio,
            calle, ciudad_id, ocupacion
        ) VALUES (
            p_documento, p_primer_nombre, p_segundo_nombre, p_primer_apellido,
            p_segundo_apellido, p_telefono, p_correo, p_direccion,
            p_barrio, p_calle, p_ciudad_id, p_ocupacion
        );
        p_resultado := 1;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_responsable;
/

--Paquete utilidad

create or replace PACKAGE pkg_utilidad AS
    FUNCTION FN_EXISTE_GENERICO (
        p_tabla IN VARCHAR2,
        p_campo_id IN VARCHAR2,
        p_valor_id IN VARCHAR2
    ) RETURN NUMBER;
    PROCEDURE SP_ELIMINAR_GENERICO (
        p_tabla IN VARCHAR2,
        p_campo_id IN VARCHAR2,
        p_valor_id IN VARCHAR2,
        p_resultado OUT NUMBER
    );
END pkg_utilidad;
/

create or replace PACKAGE BODY pkg_utilidad AS
    FUNCTION FN_EXISTE_GENERICO (
        p_tabla IN VARCHAR2,
        p_campo_id IN VARCHAR2,
        p_valor_id IN VARCHAR2
    ) RETURN NUMBER AS
        v_count NUMBER;
        v_query VARCHAR2(500);
    BEGIN
        v_query := 'SELECT COUNT(*) FROM ' || p_tabla || ' WHERE ' || p_campo_id || ' = :1';
        EXECUTE IMMEDIATE v_query INTO v_count USING p_valor_id;
        RETURN v_count;
    END;

    PROCEDURE SP_ELIMINAR_GENERICO (
        p_tabla IN VARCHAR2,
        p_campo_id IN VARCHAR2,
        p_valor_id IN VARCHAR2,
        p_resultado OUT NUMBER
    ) AS
        v_query VARCHAR2(500);
    BEGIN
        v_query := 'DELETE FROM ' || p_tabla || ' WHERE ' || p_campo_id || ' = :1';
        EXECUTE IMMEDIATE v_query USING p_valor_id;

        IF SQL%ROWCOUNT > 0 THEN
            p_resultado := 1;
        ELSE
            p_resultado := 0;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_resultado := 0;
            ROLLBACK;
    END;
END pkg_utilidad;
/


--Creacion Triggers

create or replace TRIGGER trg_cita_id
BEFORE INSERT ON s_citas
FOR EACH ROW
BEGIN
    IF :NEW.cita_id IS NULL THEN
        SELECT seq_cita.NEXTVAL
        INTO :NEW.cita_id
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_ciudad_id
BEFORE INSERT ON s_ciudades
FOR EACH ROW
BEGIN
    IF :NEW.ciudad_id IS NULL THEN
        SELECT seq_ciudad.NEXTVAL
        INTO :NEW.ciudad_id
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_credenciales_id
BEFORE INSERT ON s_credenciales
FOR EACH ROW
BEGIN
    IF :NEW.usuario_id IS NULL THEN
        SELECT seq_credenciales.NEXTVAL
        INTO :NEW.usuario_id
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_eps_id
BEFORE INSERT ON s_eps
FOR EACH ROW
BEGIN
    IF :NEW.eps_id IS NULL THEN
        SELECT seq_eps.NEXTVAL
        INTO :NEW.eps_id
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_especialidad_id
BEFORE INSERT ON s_especialidades
FOR EACH ROW
BEGIN
    IF :NEW.especialidad_id IS NULL THEN
        SELECT seq_especialidad.NEXTVAL
        INTO :NEW.especialidad_id
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_historia_id
BEFORE INSERT ON s_historias_clinicas
FOR EACH ROW
BEGIN
    IF :NEW.HISTORIA_ID IS NULL THEN
        SELECT seq_historia.NEXTVAL
        INTO :NEW.HISTORIA_ID
        FROM dual;
    END IF;
END;
/

create or replace TRIGGER trg_parentesco_id
BEFORE INSERT ON s_parentescos
FOR EACH ROW
BEGIN
   IF :NEW.parentesco_id IS NULL THEN
       SELECT seq_parentesco.NEXTVAL
       INTO :NEW.parentesco_id
       FROM dual;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_normalizar_paciente
BEFORE INSERT OR UPDATE ON s_pacientes
FOR EACH ROW
BEGIN
    :NEW.primer_nombre    := UPPER(TRIM(:NEW.primer_nombre));
    :NEW.segundo_nombre   := UPPER(TRIM(NVL(:NEW.segundo_nombre, '')));
    :NEW.primer_apellido  := UPPER(TRIM(:NEW.primer_apellido));
    :NEW.segundo_apellido := UPPER(TRIM(NVL(:NEW.segundo_apellido, '')));

    :NEW.direccion := UPPER(TRIM(:NEW.direccion));
    :NEW.barrio    := UPPER(TRIM(:NEW.barrio));
    :NEW.calle     := UPPER(TRIM(:NEW.calle));
END;
/

CREATE OR REPLACE TRIGGER trg_validar_correo_paciente
BEFORE INSERT OR UPDATE ON s_pacientes
FOR EACH ROW
BEGIN
    IF :NEW.correo IS NOT NULL THEN
        IF NOT REGEXP_LIKE(
               :NEW.correo,
               '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
           )
        THEN
            RAISE_APPLICATION_ERROR(
                -20100,
                'El correo electrónico del paciente no tiene un formato válido.'
            );
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_normalizar_doctor
BEFORE INSERT OR UPDATE ON s_doctores
FOR EACH ROW
BEGIN
    :NEW.primer_nombre    := UPPER(TRIM(:NEW.primer_nombre));
    :NEW.segundo_nombre   := UPPER(TRIM(NVL(:NEW.segundo_nombre, '')));
    :NEW.primer_apellido  := UPPER(TRIM(:NEW.primer_apellido));
    :NEW.segundo_apellido := UPPER(TRIM(NVL(:NEW.segundo_apellido, '')));
END;
/

CREATE OR REPLACE TRIGGER trg_validar_correo_doctor
BEFORE INSERT OR UPDATE ON s_doctores
FOR EACH ROW
BEGIN
    IF :NEW.correo IS NOT NULL THEN
        IF NOT REGEXP_LIKE(
               :NEW.correo,
               '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
           )
        THEN
            RAISE_APPLICATION_ERROR(
                -20100,
                'El correo electrónico del paciente no tiene un formato válido.'
            );
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_normalizar_responsable
BEFORE INSERT OR UPDATE ON s_responsables
FOR EACH ROW
BEGIN
    :NEW.primer_nombre    := UPPER(TRIM(:NEW.primer_nombre));
    :NEW.segundo_nombre   := UPPER(TRIM(NVL(:NEW.segundo_nombre, '')));
    :NEW.primer_apellido  := UPPER(TRIM(:NEW.primer_apellido));
    :NEW.segundo_apellido := UPPER(TRIM(NVL(:NEW.segundo_apellido, '')));

    :NEW.direccion := UPPER(TRIM(:NEW.direccion));
    :NEW.barrio    := UPPER(TRIM(:NEW.barrio));
    :NEW.calle     := UPPER(TRIM(:NEW.calle));

    :NEW.ocupacion := UPPER(TRIM(:NEW.ocupacion));
  END;
/

CREATE OR REPLACE TRIGGER trg_validar_correo_responsable
BEFORE INSERT OR UPDATE ON s_responsables
FOR EACH ROW
BEGIN
    IF :NEW.correo IS NOT NULL THEN
        IF NOT REGEXP_LIKE(
               :NEW.correo,
               '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
           )
        THEN
            RAISE_APPLICATION_ERROR(
                -20100,
                'El correo electrónico del paciente no tiene un formato válido.'
            );
        END IF;
    END IF;
END;
/









