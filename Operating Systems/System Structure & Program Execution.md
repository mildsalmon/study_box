# 1. 컴퓨터 시스템 구조

!![](/bin/OS_image/os_2_1.png)

!![](/bin/OS_image/os_2_2.png)

- I/O device
	- device controller가 I/O device의 CPU 역할.
	- local buffer가 I/O device의 Memory 역할.
- Computer
	- registers
		- Memory보다 빠르고 정보를 저장할 수 있는 작은 공간
	- mode bit
		- CPU에서 실행되고 있는 것이 운영체제인지, 사용자 프로그램인지를 구분해줌
	- Interrupt line
		- I/O 장비에서 무엇을 읽어오거나, 작업을 다 끝냇다는 것을 전달하기 위해서 존재함.
	- CPU
		- CPU는 Memory에 있는 인스트럭션만 실행한다.
			- 인스트럭션 하나가 실행되면, 인스트럭션의 주소값이 증가하여 다음번에 실행할 인스트럭션이 정해진다.
		- Memory에서 I/O 접근이 필요하면, I/O 장비에 있는 device controller에 명령을 보내고, 대기없이 Memory에서 다음 인스트럭션을 실행한다.
		- 인스트럭션 실행하고, interrupt line 확인하고, 인터럽트가 없으면 인스트럭션 실행한다.
	- timer
		- 특정 프로그램이 CPU를 독점(무한루프)하는 것을 막기 위해서 존재함.
		- 인스트럭션이 실행될 때, timer에 셋팅해둔 시간이 지나면 CPU에 interrupt를 걸어서 시간이 종료되었다고 알린다.
		- timer가 인터럽트를 걸어왔으면, CPU는 하던일을 잠시 멈추고, CPU의 제어권이 사용자 프로그램 -> OS(운영체제)로 넘어가게 되어 있다.
			- OS에서 사용자 프로그램으로 제어권이 넘어갈 수는 있지만, 뺏을 수는 없다.
				- 본인의 interrupt line이 없기 때문.
		- CPU의 time sharing을 구현하기 위해 존재.
	- 사용자 프로그램
		- 사용자 프로그램이 실행되는 중에 I/O 작업이 필요하면, OS(운영 체제)에 CPU 제어권을 넘겨준다.
			- 운영체제는 I/O 작업을 실행하고, time sharing을 위해 다른 사용자 프로그램을 실행한다.
	- DMA controller
		- I/O 장치가 CPU에 자주 인터럽트를 거니까, CPU가 너무 많이 방해를 받기에 그것을 막기 위해서 존재함.
		- I/O 장치의 작업이 끝났으면, DMA controller가 I/O 장치의 local buffer에 정보를 직접 Memory에 복사해주는 역할을 함.
			- 이 작업이 끝나면, CPU에 인터럽트를 한번만 걸어서 작업이 완료되었다고 알림.

## A. Mode bit

사용자 프로그램의 잘모소딘 수행으로 다른 프로그램 및 운영체제에 피해가 가지 않도록 하기 위한 보호 장치 필요

- Mode bit을 통해 하드웨어적으로 두 가지 모드의 operation 지원
	```ad-note

	- 1 (사용자 모드)
		- 사용자 프로그램 수행
	- 0 (모니터 모드 = 커널 모드, 시스템 모드)
		- OS 코드 수행

	```
	- 보안을 해칠 수 있는 중요한 명령어는 모니터 모드에서만 수행 가능한 **특권명령**으로 규정
	- Interrupt나 Exception 발생시 하드웨어가 mode bit을 0으로 바꿈
	- 사용자 프로그램에게 CPU를 넘기기 전에 mode bit을 1로 셋팅

!![](/bin/OS_image/os_2_3.png)

## B. Timer

- 타이머
	- 정해진 시간이 흐른 뒤 운영체제에게 제어권이 넘어가도록 인터럽트를 발생시킴
	- 타이머는 매 클럭 틱 때마다 1씩 감소
	- 타이머 값이 0이 되면 타이머 인터럽트 발생
	- CPU를 특정 프로그램이 독점하는 것으로부터 보호
- 타이머는 time sharing을 구현하기 위해 널리 이용됨
- 타이머는 현재 시간을 계산하기 위해서도 사용

## C. Device Controller

- I/O device controller
	- 해당 I/O 장치유형을 관리하는 일종의 작은 CPU
	- 제어 정보를 위해 control register, status register를 가짐
	- local buffer를 가짐 (일종의 data register)
- I/O는 실제 device와 local buffer 사이에서 일어남
- Device controller는 I/O가 끝났을 경우 interrupt로 CPU에 그 사실을 알림

### a. device driver (장치구동기)

- software
- OS 코드 중 각 장치별 처리루틴

### b. device controller (장치제어기)

- hardware
- 각 장치를 통제하는 일종의 작은 CPU

## D. 입출력(I/O)의 수행

- 모든 입출력 명령은 특권 명령
- 사용자 프로그램은 어떻게 I/O를 하는가?
	- 시스템콜 (system call)
		- 사용자 프로그램은 운영체제에게 I/O 요청(부탁하는 것)
		- 사용자 프로그램이 운영체제의 커널(함수)를 호출하는 것
	- trap을 사용하여 인터럽트 벡트의 특정 위치로 이동
	- 제어권이 인터럽트 벡터가 가리키는 인터럽트 서비스 루틴으로 이동
	- 올바른 I/O 요청인지 확인 후 I/O 수행
	- I/O 완료 시 제어권을 시스템콜 다음 명령으로 옮김

## E. 인터럽트 (Interrupt)

- 인터럽트
	- 인터럽트 당한 시점의 레지스터와 program counter를 save한 후 CPU의 제어를 인터럽트 처리 루틴에 넘긴다.
- Interrupt (넓은 의미)
	- Interrupt (하드웨어 인터럽트)
		- 하드웨어가 발생시킨 인터럽트
		- Timer, I/O Controller가 거는 인터럽트
	- Trap (소프트웨어 인터럽트)
		- Exception
			- 프로그램이 오류를 범한 경우
		- System call
			- 프로그램이 커널 함수를 호출하는 경우
- 인터럽트 관련 용어
	- 인터럽트 벡터
		- 해당 인터럽트의 처리 루틴 주소를 가지고 있음
		- 각 인터럽트 종류마다, 그 인터럽트가 생겼을 때 어디에 있는 함수를 실행해야하는지, 그 함수의 주소들을 정의해놓은 일종의 테이블
	- 인터럽트 처리 루틴 (Interrupt Service Routine, 인터럽트 핸들러)
		- 해당 인터럽트를 처리하는 커널 함수 
		- 인터럽트 종류마다 해야하는 일이 운영체제의 코드에 정의되어 있다.
			- 각 인터럽트마다 실제 실행해야 하는 코드를 인터럽트 처리 루틴이라 부른다.
			- 실제로 인터럽트 처리하는 부분.

```ad-note

I/O 요청을 할 때는 Trap(소프트웨어 인터럽트)가 발생하고, I/O가 다 끝났으면 interrupt(하드웨어 인터럽트)를 통해 인터럽트가 끝났음을 알려줌.

```

!![](/bin/OS_image/os_2_4.png)

- 현대의 운영체제는 인터럽트에 의해 구동된다.
	- 운영체제는 CPU를 사용할일이 없다. 인터럽트가 들어올 때만 CPU가 운영체제한테 넘어간다. 그렇지 않으면 CPU는 사용자 프로그램이 쓰게 된다.

## F. 시스템콜 (System Call)

사용자 프로그램이 운영체제의 서비스를 받기 위해 커널 함수를 호출하는 것.

!![](/bin/OS_image/os_2_5.png)


# 참고자료

[1] 반효경, [System Structure & Program Execution 1](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 23, 2021)
