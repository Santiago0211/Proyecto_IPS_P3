package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.CatalogoService;
import co.edu.upc.ips.bll.CitaService;
import co.edu.upc.ips.bll.DoctorService;
import co.edu.upc.ips.entity.Cita;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.entity.Opcion;
import co.edu.upc.ips.entity.Sesion;
import co.edu.upc.ips.util.AppException;
import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.util.List;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class PacienteFrame extends JFrame {
    private final Sesion sesion;
    private final CitaService citaService = new CitaService();
    private final DoctorService doctorService = new DoctorService();
    private final CatalogoService catalogo = new CatalogoService();

    private final DefaultTableModel modelo = Ui.modeloCitas();
    private final JTable tabla = Ui.tablaCitas(modelo);
    private final JLabel lblResumen = new JLabel(" ");

    private final JComboBox<Opcion> cmbEspecialidad = new JComboBox<>();
    private final JComboBox<Doctor> cmbDoctor = new JComboBox<>();
    private final JSpinner spFecha = Ui.selectorFecha();
    private final JComboBox<String> cmbHora = new JComboBox<>();
    private boolean cargando = false;

    public PacienteFrame(Sesion sesion) {
        super("HealthLink IPS - Paciente");
        this.sesion = sesion;
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(900, 560);
        setLocationRelativeTo(null);

        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(Ui.FUENTE);
        tabs.addTab("Mis citas", panelMisCitas());
        tabs.addTab("Agendar cita", panelAgendar());

        setLayout(new BorderLayout());
        add(Ui.encabezado(sesion.getNombre(), "Paciente", e -> cerrarSesion()), BorderLayout.NORTH);
        add(tabs, BorderLayout.CENTER);

        Ui.ejecutar(this, () -> {
            cargarCitas();
            for (Opcion o : catalogo.especialidades()) {
                cmbEspecialidad.addItem(o);
            }
            cargarDoctores();
        });
    }

    private JPanel panelMisCitas() {
        JButton btnActualizar = Ui.boton("Actualizar");
        btnActualizar.addActionListener(e -> Ui.ejecutar(this, this::cargarCitas));
        JButton btnCancelar = Ui.boton("Cancelar cita seleccionada");
        btnCancelar.addActionListener(e -> Ui.ejecutar(this, () -> {
            int id = Ui.citaSeleccionada(tabla);
            if (Ui.confirmar(this, "¿Seguro que quieres cancelar la cita " + id + "?")) {
                citaService.cancelar(id);
                cargarCitas();
            }
        }));

        JPanel barra = new JPanel();
        barra.add(btnActualizar);
        barra.add(btnCancelar);
        lblResumen.setFont(Ui.FUENTE);
        barra.add(lblResumen);

        JPanel p = new JPanel(new BorderLayout());
        p.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        p.add(barra, BorderLayout.NORTH);
        p.add(new JScrollPane(tabla), BorderLayout.CENTER);
        return p;
    }

    private JPanel panelAgendar() {
        JPanel p = new JPanel(new GridBagLayout());
        p.setBorder(BorderFactory.createEmptyBorder(24, 40, 24, 40));
        GridBagConstraints g = new GridBagConstraints();
        g.insets = new Insets(8, 6, 8, 6);
        g.anchor = GridBagConstraints.WEST;
        g.fill = GridBagConstraints.HORIZONTAL;

        cmbEspecialidad.addActionListener(e -> {
            if (!cargando) {
                Ui.ejecutar(this, this::cargarDoctores);
            }
        });
        cmbDoctor.addActionListener(e -> {
            if (!cargando) {
                Ui.ejecutar(this, this::cargarHoras);
            }
        });
        spFecha.addChangeListener(e -> Ui.ejecutar(this, this::cargarHoras));

        agregar(p, g, 0, "Especialidad", cmbEspecialidad);
        agregar(p, g, 1, "Doctor", cmbDoctor);
        agregar(p, g, 2, "Fecha (aaaa-mm-dd)", spFecha);
        agregar(p, g, 3, "Hora disponible", cmbHora);

        JButton btnAgendar = Ui.botonPrimario("Agendar cita");
        btnAgendar.addActionListener(e -> Ui.ejecutar(this, this::agendar));
        g.gridx = 0;
        g.gridy = 4;
        g.gridwidth = 2;
        p.add(btnAgendar, g);

        JPanel contenedor = new JPanel(new BorderLayout());
        contenedor.add(p, BorderLayout.NORTH);
        return contenedor;
    }

    private void agregar(JPanel p, GridBagConstraints g, int fila, String texto, java.awt.Component c) {
        g.gridwidth = 1;
        g.gridy = fila;
        g.gridx = 0;
        JLabel l = new JLabel(texto);
        l.setFont(Ui.FUENTE);
        p.add(l, g);
        g.gridx = 1;
        g.weightx = 1;
        p.add(c, g);
        g.weightx = 0;
    }

    private void cargarCitas() {
        List<Cita> citas = citaService.porPaciente(sesion.getDocumento());
        Ui.llenarCitas(modelo, citas);
        lblResumen.setText("   Pendientes: " + Ui.contar(citas, CitaService.PENDIENTE)
                + "   Completadas: " + Ui.contar(citas, CitaService.COMPLETADA)
                + "   Canceladas: " + Ui.contar(citas, CitaService.CANCELADA));
    }

    private void cargarDoctores() {
        Opcion esp = (Opcion) cmbEspecialidad.getSelectedItem();
        cargando = true;
        try {
            cmbDoctor.removeAllItems();
            if (esp != null) {
                for (Doctor d : doctorService.porEspecialidad(esp.getId())) {
                    cmbDoctor.addItem(d);
                }
            }
        } finally {
            cargando = false;
        }
        cargarHoras();
    }

    private void cargarHoras() {
        cmbHora.removeAllItems();
        Doctor d = (Doctor) cmbDoctor.getSelectedItem();
        for (String h : citaService.horasDisponibles(d, Ui.fecha(spFecha))) {
            cmbHora.addItem(h);
        }
    }

    private void agendar() {
        Opcion esp = (Opcion) cmbEspecialidad.getSelectedItem();
        Doctor doctor = (Doctor) cmbDoctor.getSelectedItem();
        if (esp == null) {
            throw new AppException("Selecciona una especialidad");
        }
        if (doctor == null) {
            throw new AppException("No hay doctores disponibles para esa especialidad");
        }
        Cita c = new Cita();
        c.setPacienteDoc(sesion.getDocumento());
        c.setDoctorDoc(doctor.getDocumento());
        c.setEspecialidadId(esp.getId());
        c.setFecha(Ui.fecha(spFecha));
        c.setHora((String) cmbHora.getSelectedItem());
        citaService.agendar(c);
        Ui.info(this, "Cita agendada para el " + c.getFecha() + " a las " + c.getHora()
                + " con " + doctor.getNombreCompleto() + ".");
        cargarCitas();
        cargarHoras();
    }

    private void cerrarSesion() {
        dispose();
        new LoginFrame().setVisible(true);
    }
}
