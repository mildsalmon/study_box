
class Outer1{
	class Inner{
		int iv = 100;
	}
	static class Inner2{
		int iv = 200;
	}
}

public class Chap7_test_6 {
	public static void main(String[] args) {
		Outer1 o = new Outer1();
		Outer1.Inner i = o.new Inner();
		
		System.out.println(i.iv);
		
		Outer1.Inner2 i2 = new Outer1.Inner2();
		System.out.println(i2.iv);
	}
}
