package co.edu.upc.ips.gui;

import co.edu.upc.ips.entity.Cita;
import co.edu.upc.ips.util.AppException;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.SpinnerDateModel;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

/** Utilidades comunes para todas las ventanas. */
public final class Ui {
    public static final Color AZUL = new Color(0x1F6FB2);
    public static final Color AZUL_OSCURO = new Color(0x154E7D);
    public static final Color FONDO = new Color(0xF4F7FA);
    public static final Font FUENTE = new Font("Segoe UI", Font.PLAIN, 13);
    public static final Font TITULO = new Font("Segoe UI", Font.BOLD, 20);

    private Ui() { }

    public static void error(Component padre, String mensaje) {
        JOptionPane.showMessageDialog(padre, mensaje, "Error", JOptionPane.ERROR_MESSAGE);
    }

    public static void info(Component padre, String mensaje) {
        JOptionPane.showMessageDialog(padre, mensaje, "HealthLink IPS", JOptionPane.INFORMATION_MESSAGE);
    }

    public static boolean confirmar(Component padre, String mensaje) {
        return JOptionPane.showConfirmDialog(padre, mensaje, "Confirmar",
                JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION;
    }

    /** Ejecuta una accion y muestra cualquier error de negocio o de base de datos en un cuadro de dialogo. */
    public static void ejecutar(Component padre, Runnable accion) {
        try {
            accion.run();
        } catch (AppException e) {
            error(padre, e.getMessage());
        } catch (RuntimeException e) {
            error(padre, "Ocurrió un error inesperado: " + e);
        }
    }

    public static JButton boton(String texto) {
        JButton b = new JButton(texto);
        b.setFont(FUENTE);
        b.setFocusPainted(false);
        return b;
    }

    public static JButton botonPrimario(String texto) {
        JButton b = boton(texto);
        b.setBackground(AZUL);
        b.setForeground(Color.WHITE);
        b.setOpaque(true);
        b.setBorderPainted(false);
        return b;
    }

    public static DefaultTableModel modelo(String... columnas) {
        return new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int fila, int columna) {
                return false;
            }
        };
    }

    public static JTable tabla(DefaultTableModel modelo) {
        JTable t = new JTable(modelo);
        t.setFont(FUENTE);
        t.setRowHeight(24);
        t.setAutoCreateRowSorter(true);
        t.getTableHeader().setFont(FUENTE.deriveFont(Font.BOLD));
        t.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        return t;
    }

    /** Tabla de citas con columnas ID, Fecha, Hora, Paciente, Doctor, Especialidad y Estado coloreado. */
    public static JTable tablaCitas(DefaultTableModel modelo) {
        JTable t = tabla(modelo);
        t.getColumnModel().getColumn(6).setCellRenderer(new DefaultTableCellRenderer() {
            @Override
            public Component getTableCellRendererComponent(JTable tabla, Object valor, boolean sel,
                                                           boolean foco, int fila, int col) {
                Component c = super.getTableCellRendererComponent(tabla, valor, sel, foco, fila, col);
                if (!sel) {
                    String estado = String.valueOf(valor);
                    if ("Completada".equals(estado)) {
                        c.setForeground(new Color(0x1E8449));
                    } else if ("Cancelada".equals(estado)) {
                        c.setForeground(new Color(0xC0392B));
                    } else {
                        c.setForeground(new Color(0xB9770E));
                    }
                }
                return c;
            }
        });
        t.getColumnModel().getColumn(0).setMaxWidth(60);
        return t;
    }

    public static DefaultTableModel modeloCitas() {
        return modelo("ID", "Fecha", "Hora", "Paciente", "Doctor", "Especialidad", "Estado");
    }

    public static void llenarCitas(DefaultTableModel modelo, List<Cita> citas) {
        modelo.setRowCount(0);
        for (Cita c : citas) {
            modelo.addRow(new Object[]{c.getId(), c.getFecha().toString(), c.getHora(),
                c.getPacienteNombre(), c.getDoctorNombre(), c.getEspecialidadNombre(), c.getEstado()});
        }
    }

    public static int citaSeleccionada(JTable tabla) {
        int fila = tabla.getSelectedRow();
        if (fila < 0) {
            throw new AppException("Selecciona primero una cita de la tabla");
        }
        return (Integer) tabla.getValueAt(fila, 0);
    }

    public static int contar(List<Cita> citas, String estado) {
        int n = 0;
        for (Cita c : citas) {
            if (estado.equals(c.getEstado())) {
                n++;
            }
        }
        return n;
    }

    public static JSpinner selectorFecha() {
        JSpinner s = new JSpinner(new SpinnerDateModel(new Date(), null, null, Calendar.DAY_OF_MONTH));
        s.setEditor(new JSpinner.DateEditor(s, "yyyy-MM-dd"));
        s.setFont(FUENTE);
        return s;
    }

    public static LocalDate fecha(JSpinner selector) {
        return ((Date) selector.getValue()).toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    public static JPanel encabezado(String nombre, String rol, ActionListener alSalir) {
        JPanel p = new JPanel(new BorderLayout());
        p.setBackground(AZUL);
        p.setBorder(BorderFactory.createEmptyBorder(12, 18, 12, 18));

        JLabel titulo = new JLabel("HealthLink IPS");
        titulo.setFont(TITULO);
        titulo.setForeground(Color.WHITE);

        JLabel usuario = new JLabel(nombre + "  |  " + rol + "   ");
        usuario.setFont(FUENTE);
        usuario.setForeground(Color.WHITE);
        usuario.setHorizontalAlignment(SwingConstants.RIGHT);

        JButton salir = boton("Cerrar sesión");
        salir.addActionListener(alSalir);

        JPanel derecha = new JPanel();
        derecha.setOpaque(false);
        derecha.add(usuario);
        derecha.add(salir);

        p.add(titulo, BorderLayout.WEST);
        p.add(derecha, BorderLayout.EAST);
        return p;
    }
}
