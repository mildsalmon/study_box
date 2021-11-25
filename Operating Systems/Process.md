# 1. 프로세스의 개념

> Process is a program in execution (실행중인 프로그램)

- 프로세스의 문맥(context)
	- CPU 수행 상태를 나타내는 하드웨어 문맥
		- Program Counter
		- 각종 register
	- 프로세스의 주소 공간
		- code, data, stack
	- 프로세스 관련 커널 자료 구조
		- PCB (Process Control Block)
		- Kernel stack

![](/bin/OS_image/os_3_1.png)

프로세스가 실행 시작되면, 그 프로세스만의 독자적인 주소 공간(code, data, stack)을 형성한다. 이 프로세스가 CPU를 잡게되면 PC(Program Counter register)가 프로세스의 code 어느 부분을 가리키고 인스트럭션(기계어)를 하나씩 읽어서 Register에 어떤 값을 넣고 ALU를 통해 연산을 하고 연산 결과를 register에 저장하거나 memory에 저장한다.

## A. 프로세스의 문맥

> 프로세스의 현재 상태를 나타내는데 필요한 모든 요소

> 현재 어디까지 실행되었는지, 프로세스의 문맥을 파악하고 있다가, 인터럽트 등이 종료된 후에 바로 다음 시점부터 인스트럭션을 실행할 수 있음.

현재 시점에 프로세스의 문맥을 나타내기 위해서는 PC가 어딜 가리키고 있는가(코드의 어느 부분까지 실행했는가?)와 이 프로세스 메모리에 어떤 내용을 담고 있는가(함수를 호출했으면 stack에 내용이 쌓여있을 것임, data 영역의 값을 바꾸거나 했을 경우 변수의 값은 얼마인가), 레지스터에 어떤 값을 넣었고 어떤 인스트럭션까지 실행했는가?를 알아야만 이 프로세스의 현재 상태를 나타낼 수 있다.

과거에 프로그램이 실행되면서, 현재 시점까지 왔을텐데. 현재 시점의 정확한 상태를 규명하기 위해서 필요한 요소들을 문맥이라고 부른다.

### a. 하드웨어 문맥

> CPU와 관련됨

- register가 현재 어떤 값을 가지고 있는가?를 나타낸다.

### b. 프로세스의 주소 공간

> 메모리와 관련됨.

현재 시점에 이 프로세스의 주소 공간(code, data, stack)에 어떤 내용이 들어있는가

### c. 프로세스 관련 커널 자료 구조

운영체제의 역할 중 하나가 현재 컴퓨터 안에서 돌아가고 있는 프로세스들을 관리하는 역할이 있음.

프로세스가 하나 실행될 때마다 프로세스의 PCB를 하나씩 만들고 자원을 관리함.

#### 1) kernel stack

프로세스가 실행할 수 없는 시스템 콜이 발생할 때, 커널에서 함수 호출이 발생하면, 커널 stack에 프로세스별로 스택을 별로도 두고 정보를 쌓는다.

# 2. 프로세스의 상태 (Process State)

프로세스는 상태(state)가 변경되며 수행된다.

- Running
	- CPU를 잡고 instruction을 수행중인 상태
- Ready
	- CPU를 기다리는 상태
		- 메모리 등 다른 조건을 모두 만족하고 CPU만 얻으면 인스트럭션을 실행할 수 있는 상태
	- 보통은 ready 상태에 있는 프로세스들이 번갈아가며 CPU를 제어하며 time sharing 구현한다.
- Blocked (wait, sleep)
	- CPU를 주어도 당장 instruction을 수행할 수 없는 상태
	- Process 자신이 요청한 event(예 : I/O)가 즉시 만족되지 않아 이를 기다리는 상태
		```ad-example

		디스크에서 file을 읽어와야 하는 경우

		```
- New
	- 프로세스가 생성중인 상태
- Terminated
	- 수행(execution)이 끝난 상태
	- 프로세스의 수행이 끝났지만, 정리할 것이 남아있는 상태

![](/bin/OS_image/os_3_2.png)

![](/bin/OS_image/os_3_3.png)

![](/bin/OS_image/os_3_4.png)

운영체제 커널이 자료구조로 큐를 만들어놓고 프로세스 상태를 바꿔가면서 ready 상태에 있는 프로세스에 CPU를 주고, Blocked 상태에 있는 프로세스에는 CPU를 안주는 방식으로 운영을 함.

# 3. Process Control Block (PCB)

- 운영체제가 각 프로세스를 관리하기 위해 프로세스당 유지하는 정보
- 다음의 구성 요소를 가진다. (구조체로 유지)

1. OS가 관리상 사용하는 정보
	> 운영체제가 프로세스를 관리하기 위한 정보
	- Process state, Process ID
	- scheduling information, priority
2. CPU 수행 관련 하드웨어 값
	> 프로세스의 문맥을 표시하기 위한 정보들
	> CPU에 어떤 값을 넣어서 실행하고 있었는가.
	- Program counter, registers
3. 메모리 관련
	- Code, data, stack의 위치 정보
4. 파일 관련
	> 프로세스가 사용하고 있는 파일(리소스)들에 대한 정보
	- Open file descriptors

![](/bin/OS_image/os_3_5.png)

# 4. 문맥 교환 (Context Switch)

> 사용자 프로세스 하나로부터 또 다른 사용자 프로세스로 CPU가 넘어가는 과정

- CPU를 한 프로세스에서 다른 프로세스로 넘겨주는 과정
- CPU가 다른 프로세스에게 넘어갈 때 운영체제는 아래 과정을 수행
	- CPU를 내어주는 프로세스의 상태를 그 프로세스의 PCB에 저장
	- CPU를 새롭게 얻는 프로세스의 상태를 PCB에서 읽어옴

![](/bin/OS_image/os_3_6.png)

CPU가 현재의 프로세스를 빼앗겨야하는 상황이면, 다음 CPU 제어를 얻었을 때, 정확하게 이 시점부터 실행되게 하기 위해서 레지스터에 저장되어 있던 값, PC, Memory Map을 그 프로세스의 PCB에 저장(save)해둔다.

PCB는 커널에 프로세스마다 가지고 있음.

## A. System call이나 Interrupt 발생 시 반드시 context switch가 일어나는 것은 아님

> System call이나 Interrupt가 발생하면 CPU가 사용자 프로세스로부터 운영체제한테 넘어감.
	>> 이것은 context switch가 아님.

> System call이나 Interrupt가 발생한 이후에 운영체제가 CPU를 다른 프로세스한테 넘겨주는 경우는 context switch.

> System call이나 Interrupt가 발생하고 운영체제가 처리를 하고, 발생하기 이전의 프로세스한테 CPU가 다시 넘어가면 context switch가 아님.

![](/bin/OS_image/os_3_7.png)

(1)의 경우에도 CPU 수행 정보 등 context의 일부를 PCB에 save해야 하지만 문맥교환을 하는 (2)의 경우 그 부담이 훨씬 큼

timer interrupt는 CPU를 다른 프로세스한테 넘기기 위한 의도를 가진 인터럽트이다.

```ad-example

cache memory flush

```

# 5. 프로세스를 스케줄링하기 위한 큐

> 프로세스들은 각 큐를 오가며 수행된다.

- Job queue
	- 현재 시스템 내에 있는 모든 프로세스의 집합
	- Ready queue나 Device queues에 있는 프로세스들이 포함됨.
- Ready queue
	- 현재 메모리 내에 있으면서 CPU를 잡아서 실행되기를 기다리는 프로세스의 집합
	- Ready queue에 있으면 Device queue에 안들어가 있음.
- Device queue
	- I/O device의 처리를 기다리는 프로세스의 집합
	- Device queue에 있으면 Ready queue에서 빠진다.

## A. Ready Queue와 다양한 Device Queue

![](/bin/OS_image/os_3_8.png)

## B. 프로세스 스케줄링 큐의 모습

![](/bin/OS_image/os_3_9.png)

프로세스가 시작되면, Ready queue에서 대기하다가, CPU가 할당되면 프로세스가 실행된다. CPU 할당 시간(timer)가 끝나면 다시 ready queue 뒤에 가서 대기한다. CPU를 가지고 있다가 오래 걸리는 작업(I/O)을 수행하면, 해당하는 작업 queue에 가서 줄서있다가 해당하는 작업이 끝나면 CPU를 얻을 수 있는 ready queue에 와서 줄서게 된다. 이것을 반복하다가, 프로세스가 끝나면 프로세스는 종료가 되서 빠져나간다.

# 6. 스케줄러 (Scheduler)

## A. Long-term scheduler (장기 스케줄러 or job scheduler)

- 시작 프로세스 중 어떤 것들을 ready queue로 보낼지 결정
- 프로세스에 memory(및 각종 자원)을 주는 문제
- degree of Multiprogramming을 제어
	- 메모리에 올라가있는 프로세스의 수를 제어
- time sharing system에는 보통 장기 스케줄러가 없음 (무조건 ready)
	- 지금의 시스템은 프로세스가 시작되면 무조건 메모리를 준다.

## B. Short-term scheduler (단기 스케줄러 or CPU scheduler)

- 어떤 프로세스를 다음번에 running시킬지 결정
- 프로세스에 CPU를 주는 문제
- 충분히 빨라야 함 (millisecond 단위)

## C. Medium-Term Scheduler (중기 스케줄러 or Swapper)

- 여유 공간 마련을 위해 프로세스를 통째로 메모리에서 디스크로 쫓아냄
	- 메모리에 너무 많은 프로그램이 동시에 올라가있으면 Swapper가 일부 프로그램을 골라서 메모리에서 통째로 쫓아낸다. 
- 프로세스에게서 memory를 뺏는 문제
- degree of Multiprogramming을 제어
	- 지금의 시스템은 프로세스가 시작되면 무조건 메모리를 준다. 그런데 메모리에 너무 많은 프로그램들이 동시에 올라가 있으면 문제가 된다. 이런 것을 조절하기 위해서 중기 스케줄러를 둔다.

### a. 프로세스의 상태 (process state)

> swapper(중기 스케줄러)에 의해 추가됨.

- Running
	- CPU를 잡고 instruction을 수행중인 상태
- Ready
	- CPU를 기다리는 상태 (메모리 등 다른 조건을 모두 만족하고)
- Blocked (wait, sleep)
	- I/O 등의 event를 (스스로) 기다리는 상태
		```ad-example

		디스크에서 file을 읽어와야하는 경우

		```
- Suspended (stopped)
	- 외부적인 이유(중기 스케줄러)로 프로세스의 수행이 정지된 상태
	- 프로세스는 통째로 디스크에 swap out된다.
		```ad-example

		사용자가 프로그램을 일시 정지시킨 경우 (break key - ctrl + z)
		시스템이 여러 이유로 프로세스를 잠시 중단시킴
		(메모리에 너무 많은 프로세스가 올라와 있을 때)

		```
		
		
```

- Blocked
	- 자신이 요청한 event가 만족되면 Ready
- Suspended
	- 외부에서 resume해 주어야 Active

```

#### 1) 프로세스(사용자 프로그램) 상태도

![](/bin/OS_image/os_3_10.png)

# 7. Thread

> A thread (or lightweight process) is a basic unit of CPU utilization
> 쓰레드는 CPU를 수행하는 단위

> 쓰레드는 프로세스 내부에 CPU 수행 단위가 여러개 있는 경우를 뜻함.

- 쓰레드의 개념
	- 메모리 공간을 하나만 띄워놓고, 각 프로세스마다 다른 부분의 코드를 실행하게 하는 것.
	- 프로세스는 하나만 띄워놓고, (코드, 데이터, 스택). 현재 CPU가 코드의 어느 부분을 실행하고 있는가(PC만 여러개 두는 것)
	- 프로세스 하나에 CPU 수행 단위만 여러개 두고 있는 것.
	- 각 쓰레드마다, 현재 register에 어떤 값을 넣고, PC가 코드의 어떤 부분을 가리키며 실행하고 있었는가 별도로 유지한다.
	- 쓰레드가 코드를 실행하면서 함수 호출을 하면, 함수를 호출하고 리턴하는 것과 관련된 정보를 별도의 쓰레드 스택에 저장한다.

```
- 프로세스의 자원과 상태 공유
- CPU 수행과 관련된 정보는 별도로 갖는다. (PC, register, stack)
```

- Thread의 구성
	- program counter
	- register set
	- stack space
- Thread가 동료 thread와 공유하는 부분 (= task)
	- code section
	- data section
	- OS resources

> 전통적인 개념의 heavyweight process는 하나의 thread를 가지고 있는 task로 볼 수 있다.

![](/bin/OS_image/os_3_11.png)

![](/bin/OS_image/os_3_12.png)

## A. 장점

- 다중 스레드로 구성된 테스크 구조에서는 하나의 서버 스레드가 blocked (waiting) 상태인 동안에도 동일한 테스크 내의 다른 스레드가 실행(running)되어 빠른 처리를 할 수 있다.
- 동일한 일을 수행하는 다중 스레드가 협력하여 높은 처리율(throughput)과 성능 향상을 얻을 수 있다.
- 스레드를 사용하면 병렬성을 높일 수 있다.

```ad-example

- 웹 브라우저를 여러개의 스레드를 사용하여 만들면, 웹 페이지를 불러올 때, 여러개의 스레드가 텍스트, 이미지를 따로 불러와서 출력한다.

=> 사용자에게 빠른 응답성을 제공한다.

- 동일한 프로세스 내의 스레드는 자원을 공유하므로 메모리를 절약할 수 있다.

- CPU가 여러개 달린 컴퓨터에서 얻을 수 있는 장점
	- 1000 * 1000 행렬에서 각 행과 열을 곱하는 독립적인 연산을 각 CPU에서 실행하고 합치면 더 빨리 결과가 나올 수 있다.
	- 이때, 여러개의 스레드를 사용하면, 각 스레드들이 서로 다른 CPU에서 실행되어 병렬적으로 실행되기 때문에 더 빨리 결과를 얻을 수 있음.

```

## B. Single and Multithreaded Process

![](/bin/OS_image/os_3_13.png)

## C. Benefits of Thread (쓰레드의 장점)

1. Responsiveness (응답성)
	- 사용자 입장에서 빠르다.
		```ad-example

		multi-threaded Web - if one thread is blocked (eg. network) another thread continues (eg. display)

		```
1. Resource Sharing (자원 공유)
	- n threads can share binary code, data, resource of the process
2. Economy (경제적이다.)
	- creating & CPU switching thread (rather than a process)
	- Solaris의 경우 위 두 가지 overhead가 각각 30배, 5배
		```ad-example

		- 프로세스를 만드는 것은 오버헤드가 큼, 그러나 프로세스 안에 스레드를 만드는 것은 숟가락 하나만 얹는 것과 같아서 오버헤드가 크지 않음.
		- context switching이 발생할 때, 하나의 프로세스에서 다른 프로세스로 CPU가 넘어가는 것은 오버헤드가 큼(현재 진행상태를 PCB에 저장하고 캐시 메모리를 flush하고), 프로세스 내부에서 쓰레드 간에 CPU 스위치가 발생하는 것은 간단함(동일한 주소공간을 쓰고 있기 때문에 대부분의 문맥은 그냥 사용할 수 있음)

		```
3. Utilization of MP(multi processor) Architectures (CPU가 여러개인 환경에서 얻을 수 있는 장점)
	- each thread may be running in parallel on a different processor

## D. Implementation of Threads

- Some are supported by kernel (**Kernel Threads**)
	- Windows 95/98/NT
	- Solaris
	- Digital UNIX, Mach
	> 쓰레드가 여러개 있다는 것을 운영체제 커널이 알고있다. 따라서 하나의 스레드에서 다른 스레드로 CPU가 넘어가는 것도 커널이 CPU 스케줄링하듯 넘겨준다.
- Other are supported by library (**User Threads**)
	- POSIX Pthreads
	- Mach C-threads
	- Solaris threads
	> 프로세스 안에 쓰레드가 여러개 있다는 사실을 운영체제는 모름. User 프로그램이 스스로 여러개의 쓰레드를 관리하는 것 (라이브러리의 지원을 받아서 관리함).
- Some are real-time threads

# 참고자료

[1] 반효경, [Process 1](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 24, 2021)
