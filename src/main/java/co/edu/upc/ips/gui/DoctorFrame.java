package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.CitaService;
import co.edu.upc.ips.entity.Cita;
import co.edu.upc.ips.entity.Sesion;
import java.awt.BorderLayout;
import java.util.List;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class DoctorFrame extends JFrame {
    private final Sesion sesion;
    private final CitaService citaService = new CitaService();
    private final DefaultTableModel modelo = Ui.modeloCitas();
    private final JTable tabla = Ui.tablaCitas(modelo);
    private final JLabel lblResumen = new JLabel(" ");

    public DoctorFrame(Sesion sesion) {
        super("HealthLink IPS - Doctor");
        this.sesion = sesion;
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(900, 560);
        setLocationRelativeTo(null);

        JButton btnActualizar = Ui.boton("Actualizar");
        btnActualizar.addActionListener(e -> Ui.ejecutar(this, this::cargar));
        JButton btnCompletar = Ui.botonPrimario("Marcar como completada");
        btnCompletar.addActionListener(e -> Ui.ejecutar(this, () -> {
            citaService.completar(Ui.citaSeleccionada(tabla));
            cargar();
        }));
        JButton btnCancelar = Ui.boton("Cancelar cita");
        btnCancelar.addActionListener(e -> Ui.ejecutar(this, () -> {
            int id = Ui.citaSeleccionada(tabla);
            if (Ui.confirmar(this, "¿Seguro que quieres cancelar la cita " + id + "?")) {
                citaService.cancelar(id);
                cargar();
            }
        }));

        lblResumen.setFont(Ui.FUENTE);
        JPanel barra = new JPanel();
        barra.add(btnActualizar);
        barra.add(btnCompletar);
        barra.add(btnCancelar);
        barra.add(lblResumen);

        JPanel centro = new JPanel(new BorderLayout());
        centro.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        centro.add(barra, BorderLayout.NORTH);
        centro.add(new JScrollPane(tabla), BorderLayout.CENTER);

        setLayout(new BorderLayout());
        add(Ui.encabezado(sesion.getNombre(), "Doctor", e -> cerrarSesion()), BorderLayout.NORTH);
        add(centro, BorderLayout.CENTER);

        Ui.ejecutar(this, this::cargar);
    }

    private void cargar() {
        List<Cita> citas = citaService.porDoctor(sesion.getDocumento());
        Ui.llenarCitas(modelo, citas);
        lblResumen.setText("   Pendientes: " + Ui.contar(citas, CitaService.PENDIENTE)
                + "   Completadas: " + Ui.contar(citas, CitaService.COMPLETADA)
                + "   Canceladas: " + Ui.contar(citas, CitaService.CANCELADA));
    }

    private void cerrarSesion() {
        dispose();
        new LoginFrame().setVisible(true);
    }
}
