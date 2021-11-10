# 1. JVM과 JAVA 프로그램 실행 과정을 설명하라.

JVM이란 JAVA Virtual Machine (자바 가상 머신)의 약자로, 자바 프로그램을 자바 API를 기반으로 실행하는 역할을 한다.

JVM은 자바 바이트코드를 실행하는 실행기이다.

## A. JAVA 프로그램 실행 과정

- 프로그램이 실행되면 JVM이 OS로부터 해당 프로그램이 필요로 하는 메모리를 할당받고,
- 자바 바이트코드로 변환된 (.class) 파일을 class 로더를 통해 JVM에 로딩한다.
- 로딩된 class 파일은 execution engine을 통해 해석되고, 실행된다.
- 필요시 garbage collection을 수행해서, 불필요하게 할당된 메모리를 해제한다.

# 2. Garbage Collection이 필요한 이유

- JAVA 프로그램은 메모리를 명시적으로 지정해서 해제하지 않기 때문에, Garbage Collection Mechanism을 통해, 경우에 따라 더 이상 필요없는 객체를 찾아 지우는 작업을 수행한다.

## A. Garbage Collection 구조

- JVM 메모리 영역
	- JVM은 운영체제로부터 할당받은 메모리 영역을 세 영역으로 분리함.
		- 메소드 영역, JVM 스택, 힙 영역
		- 이 중에서 힙 영역에 생성된 객체가 저장되며, 사용하지 않는 객체를 GC를 통해  삭제함
			- JVM 힙 영역은 다음과 같이 나뉨
			- YOUNG, OLD, Permanent Generation
				- YOUNG generation
					- eden, S0, S1 (Survivor space)

## B. Garbage Collection 동작 방식

- 새롭게 생성된 객체는 YOUNG의 eden 영역에 들어가고, eden 영역이 다 차면 minor GC가 발생
- GC가 실행되면, GC를 실행하는 스레드 외에 나머지 스레드는 멈춘다.
- 불필요한 객체는 삭제되고 아직 필요한 객체는 S0으로 이동, S0에 있었던 객체는 S1로 이동, S1이 다 차면 S1에 아직 필요한 객체는 OLD generation으로 이동
- OLD generation은 크기가 크므로, 이 영역이 다 차는 경우는 자주 발생하지 않음.
	- 이 영역을 삭제할 떄 major GC (혹은 full GC) 발생
- minor GC는 자주 발생하지만, YOUNG 영역은 OLD 영역보다 적기 때문에, 프로그램 중지 시간(stop-the-world)은 짧아짐
- YOUNG 영역을 다 비우므로, YOUNG 영역에서는 연속된 여유 공간이 만들어짐.

# 3. Overriding VS Overloading

## A. Overriding

상위 클래스에 존재하는 메서드를 하위 클래스에 맞게 재정의하는 것

매서드 이름 및 파라미터 수 동일

## B. Overloading

두 메서드가 같은 이름을 가지고 있으나, 파라미터 수나 자료형이 다른 경우.

중복정의

# 4. abstract VS interface

## A. 추상 클래스

클래스 내부에 내용이 없는 abstract 메소드가 한 개 이상 있는 클래스.

extends를 통해 상속한다.

추상 메서드를 1개 이상 가진 클래스는 객체 생성이 안되므로, 추상 클래스를 상속받은 클래스의 객체 생성을 위해서 추상 메소드를 구현해야함.

**미완성 설계도**

## B. interface

클래스 내부가 내용이 없는 abstract 메소드로만 구성된 클래스.

implements를 통해 2개 이상 상속(다중 상속)받을 수 있음.

정의된 메소드를 implements 받은 곳에서 구현을 강제함.

**기본 설계도**

# 5. Call by value

자바는 call by reference가 없다.

> 매개변수를 넘기는 과정에서 직접적인 참조를 넘긴 게 아닌, 주소 값을 복사해서 넘기기 때문에 이는 call by value이다. 복사된 주소 값으로 참조가 가능하니 주소 값이 가리키는 객체의 내용이 변경되는 것이다.

[[Java] Java는 Call by reference가 없다 (tistory.com)](https://deveric.tistory.com/92)

# 6. 객체와 클래스의 차이점

# 7. JAVA 메모리 영역

# 8. private, protected, public, default 키워드

# 9. 객체지향 5대 원칙

# 10. 상수

final을 사용한다.

값을 수정하지 못하게 고정한다.

# 11. static (정적 변수, 메소드)

static은 보통 변수나 메소드 앞에 static 키워드를 붙여서 사용한다.

Static 키워드를 통해 static 영역에 할당된 메모리는 모든 객체가 공유하는 메모리이다. 하지만 garbage collector의 관리 영역 밖에 존재하므로 static을 자주 사용하면 프로그램의 종료시까지 메모리가 할당된 채로 존재하게 되어 시스템에 악영향을 준다.

메모리 할당이 딱 한 번만 하게 되어 여러 객체가 해당 메모리를 공유한다. 그리고 프로그램이 종료될 때 해제된다. 따라서 메모리 사용에 이점이 있다.

## A. static 변수

static 변수는 클래스 변수이다.

객체를 생성하지 않고도 static 자원에 접근이 가능하다.

## B. static 메소드

객체의 생성 없이 호출이 가능하다.

스태틱 메소드 안에는 인스턴스 변수 접근이 불가능하다. static 변수만 접근할 수 있다.

