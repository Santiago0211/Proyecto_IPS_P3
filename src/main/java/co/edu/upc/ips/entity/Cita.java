package co.edu.upc.ips.entity;

import java.time.LocalDate;

public class Cita {
    private int id;
    private String pacienteDoc;
    private String doctorDoc;
    private LocalDate fecha;
    private String hora;
    private String estado;
    private int especialidadId;
    private String pacienteNombre;
    private String doctorNombre;
    private String especialidadNombre;

    public Cita() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPacienteDoc() { return pacienteDoc; }
    public void setPacienteDoc(String pacienteDoc) { this.pacienteDoc = pacienteDoc; }

    public String getDoctorDoc() { return doctorDoc; }
    public void setDoctorDoc(String doctorDoc) { this.doctorDoc = doctorDoc; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public String getHora() { return hora; }
    public void setHora(String hora) { this.hora = hora; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public int getEspecialidadId() { return especialidadId; }
    public void setEspecialidadId(int especialidadId) { this.especialidadId = especialidadId; }

    public String getPacienteNombre() { return pacienteNombre; }
    public void setPacienteNombre(String pacienteNombre) { this.pacienteNombre = pacienteNombre; }

    public String getDoctorNombre() { return doctorNombre; }
    public void setDoctorNombre(String doctorNombre) { this.doctorNombre = doctorNombre; }

    public String getEspecialidadNombre() { return especialidadNombre; }
    public void setEspecialidadNombre(String especialidadNombre) { this.especialidadNombre = especialidadNombre; }
}
