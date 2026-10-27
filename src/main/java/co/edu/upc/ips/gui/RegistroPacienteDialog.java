package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.CatalogoService;
import co.edu.upc.ips.bll.PacienteService;
import co.edu.upc.ips.entity.Opcion;
import co.edu.upc.ips.entity.Paciente;
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
import javax.swing.JScrollPane;
import javax.swing.JTextField;

public class RegistroPacienteDialog extends JDialog {
    private final PacienteService service = new PacienteService();

    private final JTextField txtDocumento = new JTextField(16);
    private final JTextField txtPrimerNombre = new JTextField(16);
    private final JTextField txtSegundoNombre = new JTextField(16);
    private final JTextField txtPrimerApellido = new JTextField(16);
    private final JTextField txtSegundoApellido = new JTextField(16);
    private final JTextField txtTelefono = new JTextField(16);
    private final JTextField txtCorreo = new JTextField(16);
    private final JTextField txtEdad = new JTextField(16);
    private final JComboBox<String> cmbSexo = new JComboBox<>(new String[]{"F", "M"});
    private final JComboBox<String> cmbSangre = new JComboBox<>(new String[]{"A", "B", "AB", "O"});
    private final JComboBox<String> cmbRh = new JComboBox<>(new String[]{"+", "-"});
    private final JTextField txtDireccion = new JTextField(16);
    private final JTextField txtBarrio = new JTextField(16);
    private final JTextField txtCalle = new JTextField(16);
    private final JComboBox<Opcion> cmbCiudad = new JComboBox<>();
    private final JComboBox<Opcion> cmbEps = new JComboBox<>();
    private final JTextField txtUsuario = new JTextField(16);
    private final JPasswordField txtClave = new JPasswordField(16);
    private final JPasswordField txtClave2 = new JPasswordField(16);

    public RegistroPacienteDialog(Window padre) {
        super(padre, "Registro de paciente", ModalityType.APPLICATION_MODAL);

        try {
            CatalogoService catalogo = new CatalogoService();
            for (Opcion o : catalogo.ciudades()) {
                cmbCiudad.addItem(o);
            }
            for (Opcion o : catalogo.eps()) {
                cmbEps.addItem(o);
            }
        } catch (AppException e) {
            Ui.error(padre, e.getMessage());
        }

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(14, 20, 6, 20));
        int fila = 0;
        fila = campo(form, fila, "Documento *", txtDocumento, "Edad *", txtEdad);
        fila = campo(form, fila, "Primer nombre *", txtPrimerNombre, "Segundo nombre", txtSegundoNombre);
        fila = campo(form, fila, "Primer apellido *", txtPrimerApellido, "Segundo apellido", txtSegundoApellido);
        fila = campo(form, fila, "Teléfono", txtTelefono, "Correo *", txtCorreo);
        fila = campo(form, fila, "Sexo", cmbSexo, "Tipo de sangre", cmbSangre);
        fila = campo(form, fila, "RH", cmbRh, "Dirección", txtDireccion);
        fila = campo(form, fila, "Barrio", txtBarrio, "Calle", txtCalle);
        fila = campo(form, fila, "Ciudad *", cmbCiudad, "EPS *", cmbEps);
        fila = campo(form, fila, "Usuario *", txtUsuario, "Contraseña *", txtClave);
        campo(form, fila, "Confirmar contraseña *", txtClave2, "", new JLabel());

        JButton btnGuardar = Ui.botonPrimario("Registrar");
        btnGuardar.addActionListener(e -> guardar());
        JButton btnCancelar = Ui.boton("Cancelar");
        btnCancelar.addActionListener(e -> dispose());
        JPanel botones = new JPanel();
        botones.add(btnGuardar);
        botones.add(btnCancelar);

        setLayout(new BorderLayout());
        add(new JScrollPane(form), BorderLayout.CENTER);
        add(botones, BorderLayout.SOUTH);
        pack();
        setLocationRelativeTo(padre);
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
            Paciente p = new Paciente();
            p.setDocumento(txtDocumento.getText());
            p.setPrimerNombre(txtPrimerNombre.getText());
            p.setSegundoNombre(txtSegundoNombre.getText());
            p.setPrimerApellido(txtPrimerApellido.getText());
            p.setSegundoApellido(txtSegundoApellido.getText());
            p.setTelefono(txtTelefono.getText());
            p.setCorreo(txtCorreo.getText());
            try {
                p.setEdad(Integer.parseInt(txtEdad.getText().trim()));
            } catch (NumberFormatException e) {
                throw new AppException("La edad debe ser un número");
            }
            p.setSexo((String) cmbSexo.getSelectedItem());
            p.setTipoSangre((String) cmbSangre.getSelectedItem());
            p.setRh((String) cmbRh.getSelectedItem());
            p.setDireccion(txtDireccion.getText());
            p.setBarrio(txtBarrio.getText());
            p.setCalle(txtCalle.getText());
            Opcion ciudad = (Opcion) cmbCiudad.getSelectedItem();
            Opcion eps = (Opcion) cmbEps.getSelectedItem();
            p.setCiudadId(ciudad == null ? 0 : ciudad.getId());
            p.setEpsId(eps == null ? 0 : eps.getId());

            service.registrar(p, txtUsuario.getText(),
                    new String(txtClave.getPassword()), new String(txtClave2.getPassword()));
            Ui.info(this, "Paciente registrado correctamente. Ya puedes iniciar sesión.");
            dispose();
        });
    }
}
