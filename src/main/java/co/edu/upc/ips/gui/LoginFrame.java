package co.edu.upc.ips.gui;

import co.edu.upc.ips.bll.AuthService;
import co.edu.upc.ips.entity.Sesion;
import java.awt.Color;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.BorderFactory;

public class LoginFrame extends JFrame {
    private final AuthService auth = new AuthService();
    private final JTextField txtUsuario = new JTextField(18);
    private final JPasswordField txtClave = new JPasswordField(18);

    public LoginFrame() {
        super("HealthLink IPS - Iniciar sesión");
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBackground(Ui.FONDO);
        panel.setBorder(BorderFactory.createEmptyBorder(24, 36, 24, 36));
        GridBagConstraints g = new GridBagConstraints();
        g.insets = new Insets(6, 4, 6, 4);
        g.fill = GridBagConstraints.HORIZONTAL;
        g.gridx = 0;
        g.gridwidth = 2;

        JLabel titulo = new JLabel("HealthLink IPS", SwingConstants.CENTER);
        titulo.setFont(Ui.TITULO.deriveFont(26f));
        titulo.setForeground(Ui.AZUL_OSCURO);
        g.gridy = 0;
        panel.add(titulo, g);

        JLabel sub = new JLabel("Sistema de gestión para IPS", SwingConstants.CENTER);
        sub.setFont(Ui.FUENTE);
        sub.setForeground(Color.GRAY);
        g.gridy = 1;
        panel.add(sub, g);

        g.gridwidth = 1;
        g.gridy = 2;
        g.gridx = 0;
        panel.add(etiqueta("Usuario"), g);
        g.gridx = 1;
        panel.add(txtUsuario, g);

        g.gridy = 3;
        g.gridx = 0;
        panel.add(etiqueta("Contraseña"), g);
        g.gridx = 1;
        panel.add(txtClave, g);

        JButton btnIngresar = Ui.botonPrimario("Ingresar");
        btnIngresar.addActionListener(e -> ingresar());
        g.gridy = 4;
        g.gridx = 0;
        g.gridwidth = 2;
        panel.add(btnIngresar, g);

        JButton btnRegistro = Ui.boton("Registrarme como paciente");
        btnRegistro.addActionListener(e -> new RegistroPacienteDialog(this).setVisible(true));
        g.gridy = 5;
        panel.add(btnRegistro, g);

        getRootPane().setDefaultButton(btnIngresar);
        setContentPane(panel);
        pack();
        setResizable(false);
        setLocationRelativeTo(null);
    }

    private JLabel etiqueta(String texto) {
        JLabel l = new JLabel(texto);
        l.setFont(Ui.FUENTE);
        return l;
    }

    private void ingresar() {
        Ui.ejecutar(this, () -> {
            Sesion s = auth.login(txtUsuario.getText(), new String(txtClave.getPassword()));
            JFrame ventana;
            if (s.esPaciente()) {
                ventana = new PacienteFrame(s);
            } else if (s.esDoctor()) {
                ventana = new DoctorFrame(s);
            } else {
                ventana = new AdminFrame(s);
            }
            dispose();
            ventana.setVisible(true);
        });
    }
}
