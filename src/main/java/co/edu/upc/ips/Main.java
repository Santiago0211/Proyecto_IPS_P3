package co.edu.upc.ips;

import co.edu.upc.ips.gui.LoginFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

public class Main {
    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignorada) {
            // si falla, Swing usa su apariencia por defecto
        }
        SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true));
    }
}
