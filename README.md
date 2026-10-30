# HealthLink IPS – versión Java (NetBeans)

Port a **Java + Swing + JDBC** del proyecto original en C#/WPF. Usa **la misma base de datos Oracle**
(tablas, paquetes PL/SQL y triggers de `sql/`), así que los datos de prueba son los mismos.

## 1. Requisitos
- JDK 17 o superior (sirve el 21)
- Apache NetBeans 17 o superior
- Oracle Database XE 18c o 21c (servicio `XEPDB1`)
- Internet la primera vez (Maven descarga el driver `ojdbc11`)

## 2. Crear la base de datos (SQL Developer)
1. Conéctate como **SYSTEM** al servicio `XEPDB1`.
2. Para saber la ruta del datafile, ejecuta: `SELECT file_name FROM dba_data_files WHERE tablespace_name = 'SYSTEM';`
   Usa esa misma carpeta y termina la ruta en `\proyecto_ips.dbf`.
3. Ejecuta `sql/PASO_1.sql` **solo si ya habías creado la base antes** (limpia lo anterior). La primera vez salta este paso.
4. Ejecuta `sql/PASO_2.sql` como script (F5). Te pedirá la clave de SYSTEM y la ruta del datafile.
   Crea el usuario `admin_ips` con clave `Ips_admin_2026` (puedes cambiarla, pero entonces cámbiala también en `config.properties`).
5. Crea una conexión nueva en SQL Developer con usuario `admin_ips`, servicio `XEPDB1`, y ejecuta en ese orden:
   `sql/PASO_3.sql`, `sql/PASO_4.sql`, `sql/PASO_5.sql`.

## 3. Abrir y ejecutar en NetBeans
1. `File > Open Project…` y elige la carpeta `HealthLinkIPS` (aparece con el icono de Maven).
2. Espera a que termine de descargar dependencias (barra abajo a la derecha).
3. Revisa `config.properties` (usuario, clave y puerto de Oracle).
4. Clic derecho en el proyecto > **Clean and Build**, y luego **Run** (F6).
   Si pregunta por la clase principal: `co.edu.upc.ips.Main`.

## 4. Usuarios de prueba (vienen de PASO_5)
| Rol | Usuario | Clave |
|---|---|---|
| Administrador | `admin` | `admin123` |
| Doctor | `jperez` | `jperez123` |
| Paciente | `amarquez` | `amarquez123` |

(Los demás siguen el mismo patrón `usuario` / `usuario123`.)

## 5. Qué incluye
- Inicio de sesión por rol (paciente, doctor, administrador)
- **Paciente:** registrarse, ver sus citas, agendar (especialidad → doctor → fecha → hora libre) y cancelar.
- **Doctor:** ver sus citas, marcarlas como completadas o cancelarlas.
- **Administrador:** resumen con contadores, todas las citas (completar, cancelar, reactivar), lista de pacientes y de doctores, registro de doctores.
- Reglas del original: no citas en fechas u horas pasadas, no doblar horario del doctor ni del paciente, transiciones de estado válidas.



## 8. Problemas frecuentes
- **ORA-12514 / no se puede conectar:** el servicio debe ser `XEPDB1` y el listener debe estar encendido.
- **ORA-01017:** usuario o clave incorrectos en `config.properties`.
- **No suitable driver:** Maven no descargó `ojdbc11`; haz *Clean and Build* con internet.
- **«No se encontró config.properties»:** ejecuta el proyecto desde NetBeans (usa la carpeta del proyecto) o copia el archivo junto al `.jar`.
