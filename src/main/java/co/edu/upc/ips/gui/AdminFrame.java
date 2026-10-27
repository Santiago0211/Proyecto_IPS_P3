package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.CitaService;
import co.edu.upc.ips.bll.DoctorService;
import co.edu.upc.ips.bll.PacienteService;
import co.edu.upc.ips.entity.Cita;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.entity.Paciente;
import co.edu.upc.ips.entity.Sesion;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.util.List;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableModel;

public class AdminFrame extends JFrame {
    private final CitaService citaService = new CitaService();
    private final PacienteService pacienteService = new PacienteService();
    private final DoctorService doctorService = new DoctorService();

    private final DefaultTableModel mCitas = Ui.modeloCitas();
    private final JTable tCitas = Ui.tablaCitas(mCitas);
    private final DefaultTableModel mPacientes =
            Ui.modelo("Documento", "Nombre completo", "Edad", "Sexo", "Teléfono", "Correo");
    private final DefaultTableModel mDoctores =
            Ui.modelo("Documento", "Nombre completo", "Licencia", "Especialidad", "Teléfono", "Correo");

    private final JLabel lblPacientes = tarjeta();
    private final JLabel lblDoctores = tarjeta();
    private final JLabel lblPendientes = tarjeta();
    private final JLabel lblCompletadas = tarjeta();
    private final JLabel lblCanceladas = tarjeta();

    public AdminFrame(Sesion sesion) {
        super("HealthLink IPS - Administrador");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 600);
        setLocationRelativeTo(null);

        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(Ui.FUENTE);
        tabs.addTab("Resumen", panelResumen());
        tabs.addTab("Citas", panelCitas());
        tabs.addTab("Pacientes", panelTabla(mPacientes, null));
        JButton btnNuevoDoctor = Ui.botonPrimario("Registrar doctor");
        btnNuevoDoctor.addActionListener(e -> {
            RegistroDoctorDialog d = new RegistroDoctorDialog(this);
            d.setVisible(true);
            if (d.fueRegistrado()) {
                Ui.ejecutar(this, this::cargar);
            }
        });
        tabs.addTab("Doctores", panelTabla(mDoctores, btnNuevoDoctor));

        setLayout(new BorderLayout());
        add(Ui.encabezado(sesion.getNombre(), "Administrador", e -> cerrarSesion()), BorderLayout.NORTH);
        add(tabs, BorderLayout.CENTER);

        Ui.ejecutar(this, this::cargar);
    }

    private static JLabel tarjeta() {
        JLabel l = new JLabel("-", SwingConstants.CENTER);
        l.setFont(Ui.TITULO.deriveFont(30f));
        l.setForeground(Ui.AZUL_OSCURO);
        return l;
    }

    private JPanel panelResumen() {
        JPanel p = new JPanel(new GridLayout(2, 5, 12, 12));
        p.setBorder(BorderFactory.createEmptyBorder(30, 30, 30, 30));
        String[] titulos = {"Pacientes", "Doctores", "Citas pendientes", "Citas completadas", "Citas canceladas"};
        JLabel[] valores = {lblPacientes, lblDoctores, lblPendientes, lblCompletadas, lblCanceladas};
        for (String t : titulos) {
            JLabel l = new JLabel(t, SwingConstants.CENTER);
            l.setFont(Ui.FUENTE);
            p.add(l);
        }
        for (JLabel v : valores) {
            p.add(v);
        }
        JPanel contenedor = new JPanel(new BorderLayout());
        contenedor.add(p, BorderLayout.NORTH);
        return contenedor;
    }

    private JPanel panelCitas() {
        JButton btnActualizar = Ui.boton("Actualizar");
        btnActualizar.addActionListener(e -> Ui.ejecutar(this, this::cargar));
        JButton btnCompletar = Ui.botonPrimario("Completar");
        btnCompletar.addActionListener(e -> Ui.ejecutar(this, () -> {
            citaService.completar(Ui.citaSeleccionada(tCitas));
            cargar();
        }));
        JButton btnCancelar = Ui.boton("Cancelar");
        btnCancelar.addActionListener(e -> Ui.ejecutar(this, () -> {
            int id = Ui.citaSeleccionada(tCitas);
            if (Ui.confirmar(this, "¿Seguro que quieres cancelar la cita " + id + "?")) {
                citaService.cancelar(id);
                cargar();
            }
        }));
        JButton btnReactivar = Ui.boton("Reactivar");
        btnReactivar.addActionListener(e -> Ui.ejecutar(this, () -> {
            citaService.reactivar(Ui.citaSeleccionada(tCitas));
            cargar();
        }));

        JPanel barra = new JPanel();
        barra.add(btnActualizar);
        barra.add(btnCompletar);
        barra.add(btnCancelar);
        barra.add(btnReactivar);

        JPanel p = new JPanel(new BorderLayout());
        p.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        p.add(barra, BorderLayout.NORTH);
        p.add(new JScrollPane(tCitas), BorderLayout.CENTER);
        return p;
    }

    private JPanel panelTabla(DefaultTableModel modelo, JButton extra) {
        JPanel p = new JPanel(new BorderLayout());
        p.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        JPanel barra = new JPanel();
        JButton btnActualizar = Ui.boton("Actualizar");
        btnActualizar.addActionListener(e -> Ui.ejecutar(this, this::cargar));
        barra.add(btnActualizar);
        if (extra != null) {
            barra.add(extra);
        }
        p.add(barra, BorderLayout.NORTH);
        p.add(new JScrollPane(Ui.tabla(modelo)), BorderLayout.CENTER);
        return p;
    }

    private void cargar() {
        List<Cita> citas = citaService.todas();
        List<Paciente> pacientes = pacienteService.listar();
        List<Doctor> doctores = doctorService.listar();

        Ui.llenarCitas(mCitas, citas);

        mPacientes.setRowCount(0);
        for (Paciente p : pacientes) {
            mPacientes.addRow(new Object[]{p.getDocumento(), p.getNombreCompleto(), p.getEdad(),
                p.getSexo(), p.getTelefono(), p.getCorreo()});
        }
        mDoctores.setRowCount(0);
        for (Doctor d : doctores) {
            mDoctores.addRow(new Object[]{d.getDocumento(), d.getNombreCompleto(), d.getNumeroLicencia(),
                d.getEspecialidadNombre(), d.getTelefono(), d.getCorreo()});
        }

        lblPacientes.setText(String.valueOf(pacientes.size()));
        lblDoctores.setText(String.valueOf(doctores.size()));
        lblPendientes.setText(String.valueOf(Ui.contar(citas, CitaService.PENDIENTE)));
        lblCompletadas.setText(String.valueOf(Ui.contar(citas, CitaService.COMPLETADA)));
        lblCanceladas.setText(String.valueOf(Ui.contar(citas, CitaService.CANCELADA)));
    }

    private void cerrarSesion() {
        dispose();
        new LoginFrame().setVisible(true);
    }
}
