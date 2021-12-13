import java.awt.*;
import java.awt.event.*;

public class Chap7_test_9 {
	public static void main(String[] args) {
		Frame f = new Frame();
		f.addWindowListner(new WindowAdapter{
			public void windowClosing(WindowEvent e) {
				e.getWindow().setVisible(fasle);
				e.getWindow().dispose();
				System.exit(0);
			}
		});
	}
}
