package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.CatalogoService;
import co.edu.upc.ips.bll.DoctorService;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.entity.Opcion;
import co.edu.upc.ips.util.AppException;
import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Window;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;

public class RegistroDoctorDialog extends JDialog {
    private final DoctorService service = new DoctorService();
    private boolean registrado = false;

    private final JTextField txtDocumento = new JTextField(16);
    private final JTextField txtLicencia = new JTextField(16);
    private final JTextField txtPrimerNombre = new JTextField(16);
    private final JTextField txtSegundoNombre = new JTextField(16);
    private final JTextField txtPrimerApellido = new JTextField(16);
    private final JTextField txtSegundoApellido = new JTextField(16);
    private final JTextField txtTelefono = new JTextField(16);
    private final JTextField txtCorreo = new JTextField(16);
    private final JComboBox<Opcion> cmbEspecialidad = new JComboBox<>();
    private final JComboBox<String> cmbJornada = new JComboBox<>(
            new String[]{DoctorService.JORNADA_MANANA, DoctorService.JORNADA_TARDE});
    private final JTextField txtUsuario = new JTextField(16);
    private final JPasswordField txtClave = new JPasswordField(16);

    public RegistroDoctorDialog(Window padre) {
        super(padre, "Registro de doctor", ModalityType.APPLICATION_MODAL);

        try {
            for (Opcion o : new CatalogoService().especialidades()) {
                cmbEspecialidad.addItem(o);
            }
        } catch (AppException e) {
            Ui.error(padre, e.getMessage());
        }

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(14, 20, 6, 20));
        int fila = 0;
        fila = campo(form, fila, "Documento *", txtDocumento, "N.º licencia *", txtLicencia);
        fila = campo(form, fila, "Primer nombre *", txtPrimerNombre, "Segundo nombre", txtSegundoNombre);
        fila = campo(form, fila, "Primer apellido *", txtPrimerApellido, "Segundo apellido", txtSegundoApellido);
        fila = campo(form, fila, "Teléfono", txtTelefono, "Correo *", txtCorreo);
        fila = campo(form, fila, "Especialidad *", cmbEspecialidad, "Jornada", cmbJornada);
        campo(form, fila, "Usuario *", txtUsuario, "Contraseña *", txtClave);

        JButton btnGuardar = Ui.botonPrimario("Registrar");
        btnGuardar.addActionListener(e -> guardar());
        JButton btnCancelar = Ui.boton("Cancelar");
        btnCancelar.addActionListener(e -> dispose());
        JPanel botones = new JPanel();
        botones.add(btnGuardar);
        botones.add(btnCancelar);

        setLayout(new BorderLayout());
        add(form, BorderLayout.CENTER);
        add(botones, BorderLayout.SOUTH);
        pack();
        setLocationRelativeTo(padre);
    }

    public boolean fueRegistrado() {
        return registrado;
    }

    private int campo(JPanel p, int fila, String et1, java.awt.Component c1, String et2, java.awt.Component c2) {
        GridBagConstraints g = new GridBagConstraints();
        g.insets = new Insets(4, 6, 4, 6);
        g.anchor = GridBagConstraints.WEST;
        g.fill = GridBagConstraints.HORIZONTAL;
        g.gridy = fila;
        g.gridx = 0;
        p.add(new JLabel(et1), g);
        g.gridx = 1;
        p.add(c1, g);
        g.gridx = 2;
        p.add(new JLabel(et2), g);
        g.gridx = 3;
        p.add(c2, g);
        return fila + 1;
    }

    private void guardar() {
        Ui.ejecutar(this, () -> {
            Doctor d = new Doctor();
            d.setDocumento(txtDocumento.getText());
            d.setNumeroLicencia(txtLicencia.getText());
            d.setPrimerNombre(txtPrimerNombre.getText());
            d.setSegundoNombre(txtSegundoNombre.getText());
            d.setPrimerApellido(txtPrimerApellido.getText());
            d.setSegundoApellido(txtSegundoApellido.getText());
            d.setTelefono(txtTelefono.getText());
            d.setCorreo(txtCorreo.getText());
            Opcion esp = (Opcion) cmbEspecialidad.getSelectedItem();
            d.setEspecialidadId(esp == null ? 0 : esp.getId());

            service.registrar(d, txtUsuario.getText(), new String(txtClave.getPassword()),
                    (String) cmbJornada.getSelectedItem());
            registrado = true;
            Ui.info(this, "Doctor registrado correctamente.");
            dispose();
        });
    }
}
