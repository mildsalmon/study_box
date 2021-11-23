# 1. 운영체제 (Operating System, OS)

컴퓨터 하드웨어 바로 위에 설치되어 사용자 및 다른 모든 소프트웨어와 하드웨어를 연결하는 소프트웨어 계층

![](/bin/OS_image/os_1_1.png)

- 협의의 운영체제 (커널) -> 좁은 의미
	- 운영체제의 핵심 부분으로 메모리에 상주하는 부분
- 광의의 운영체제 -> 넓은 의미
	- 커널 뿐 아니라 각종 주변 시스템 유틸리티를 포함한 개념

## A. 운영 체제의 목표

- 컴퓨터 시스템을 편리하게 사용할 수 있는 환경을 제공
	- 하드웨어를 직접 다루는 복잡한 부분을 운영체제가 대행
	- 운영체제는 동시 사용자/프로그램들이 각각 독자적 컴퓨터에서 수행되는 것 같은 환상을 제공
- 컴퓨터 시스템의 **자원을 효율적으로 형평성있게 관리**
	- 프로세서(CPU), 기억장치(Memory), 입출력 장치 등의 효율적 관리
		- 사용자간의 형평성 있는 자원 분배
		- 주어진 자원으로 최대한의 성능을 내도록 관리
	- 사용자 및 운영체제 자신의 보호
	- 프로세스, 파일, 메시지 등을 관리
	
		```ad-note

		- 실행중인 프로그램들에게 짧은 시간씩 CPU를 번갈아 할당
		- 실행중인 프로그램들에 메모리 공간을 적절히 분배

		```

## B. 운영 체제의 분류

### a. 동시 작업 가능 여부

#### 1) 단일 작업 (Single tasking)

- 한 번에 하나의 작업만 처리

```ad-example

MS-DOS 프롬프트 상에서는 한 명령의 수행을 끝내기 전에 다른 명령을 수행시킬 수 없음

```


#### 2) **다중 작업** (multi tasking)

- 동시에 두 개 이상의 작업 처리

```ad-example

UNIX, MS Windows 등에서는 한 명령의 수행이 끝나기 전에 다른 명령이나 프로그램을 수행할 수 있음

```

### b. 사용자의 수

#### 1) 단일 사용자 (single user)

```ad-example

MS-DOS, MS Windows

```

#### 2) **다중 사용자** (multi user)

```ad-example

UNIX, NT server

```

### c. 처리 방식

#### 1) 일괄 처리 (batch processing)

- 작업 요청의 일정량 모아서 한꺼번에 처리
- 작업이 완전 종료될 때까지 기다려야 함

```ad-example

초기 Punch Card 처리 시스템

```

#### 2) **시분할** (time sharing)

- 여러 작업을 수행할 때 컴퓨터 처리 능력을 일정한 시간 단위로 분할하여 사용
- 일괄 처리 시스템에 비해 짧은 응답 시간을 가짐
	```ad-example

	UNIX

	```
- interactive한 방식
- 범용 컴퓨터에서 사용

##### ㄱ. 목적

주어진 자원을 최대한으로 활용하면서 사람이 느끼기에 빠르게 작업을 처리해주는 것처럼 느끼게 하는 것.

#### 3) 실시간 (Realtime OS)

- deadline이 존재하여, 정해진 시간 안에 어떠한 일이 반드시 종료됨이 보장되어야하는 실시간시스템을 위한 OS
- 특수한 목적을 가진 시스템에서 사용
	```ad-example

	원자로/공장 제어, 미사일 제어, 반도체 장비, 로보트 제어

	```

##### ㄱ. 실시간 시스템의 개념 확장

- Hard realtime system (경성 실시간 시스템)
	```ad-example

	미사일

	```
- Soft realtime system (연성 실시간 시스템)
	```ad-example

	영화 송출 : 초당 24프레임을 송출할때 발생하는 약간의 드랍 현상

	```

## C. 용어 ETC

### a. CPU가 한개

- Multitasking
- Multiprogramming
- Time sharing
- Multiprocess

```ad-note

- 위 용어들은 컴퓨터에서 여러 작업을 동시에 수행하는 것을 뜻한다.
- Multiprogramming은 여러 프로그램이 **메모리**에 올라가 있음을 강조
- Time Sharing은 CPU의 시간을 분할하여 나누어 쓴다는 의미를 강조
- process는 실행중인 프로그램 + multi = 여러 프로그램이 동시에 실행된다.

```

### b. CPU가 여러개

- Multiprocessor
	- 하나의 컴퓨터에 CPU(Processor)가 여러 개 붙어 있음을 의미

## D. 운영체제의 예

### a. 유닉스 (UNIX)

- 코드의 대부분을 C언어로 작성
- 높은 이식성
- 최소한의 커널 구조
- 복잡한 시스템에 맞게 확장 용이
- 소스 코드 공개
- 프로그램 개발에 용이
- 다양한 버전
	- System V, FreeBSD, SunOS, Solaris
	- Linux

### b. DOS (Disk Operating System)

- MS사에서 1981년 IBM-PC를 위해 개발
- 단일 사용자용 운영체제, 메모리 관리 능력의 한계 (주 기억장치 : 640KB)

### c. MS Windows

- MS사의 다중 작업용 GUI기반 운영 체제
- Plug and Play, 네트워크 환경 강화
- DOS용 응용 프로그램과 호환성 제공
- 불안정성
- 풍부한 자원 소프트웨어

### d. Handheld device를 위한 OS

- PalmOS, Pocket PC (WinCE), Tiny OS

## E. 운영 체제의 구조

- CPU
	- 누구한테 CPU를 줄까?
	- **CPU 스케줄링**
- Memory
	- 한정된 메모리를 어떻게 쪼개어 쓰지?
	- **메모리 관리**
- Disk
	- 디스크에 파일을 어떻게 보관하지?
	- **파일 관리**
- I/O device
	- 각기 다른 입출력장치와 컴퓨터 간에 어떻게 정보를 주고 받게 하지?
	- **입출력 관리**
- 프로세스 관리
	- 프로세스의 생성과 삭제
	- 자원 할당 및 반환
	- 프로세스 간 협력
- 그 외
	- 보호 시스템
	- 네트워킹
	- 명령어 해석기 (command line interpreter)

![](/bin/OS_image/os_1_2.png)

# 참고자료

[1] 반효경, [Introduction to Operating Systems](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 23, 2021)

