# 1. 데이터의 접근

![](/bin/OS_image/os_6_1.png)

# 2. Race Condition

![](/bin/OS_image/os_6_2.png)

- 여러 주체가 하나의 데이터를 동시에 접근하려고 할 때를 Race Condition이라고 한다.
- 어떤 하나의 주체가 읽어갔는데, 그 동안 다른 주체가 또 읽어가면 원치 않는 결과를 얻을 수 있다. 그래서 이것을 조율해주는 방법이 필요하다.

## A. 예시

- CPU가 여러개 있는 시스템(Multiprocessor system)에서 메모리를 공유하고 있다면, Race Condition 문제가 발생할 수 있다.
- 프로세스들의 주소 공간 일부를 공유하는 공유 메모리 사용시, Race Condition 문제가 발생할 수 있다.
- **운영체제 커널과 관련해서 생기는 문제.** (더 중요한 문제)
	- 프로세스가 본인이 직접 실행할 수 없는 부분(운영체제한테 대신 요청해야 하는 부분)에 대해서는 System Call을 해야 한다. -> 커널의 코드가 그 프로세스를 대신해서 실행됨.(커널에 있는 데이터에 접근한다는 의미) -> 이때, CPU를 뺏겨서 다른 프로세스에 의해 System Call이 발생하고 커널의 데이터에 접근할 수 있다. (이럴 경우 Race Condition이 발생할 수 있다.)
	- 커널의 코드가 실행 중인데, 인터럽트가 들어올 수도 있다.
		- 인터럽트를 실행하는 코드도 커널에 존재
		- 이전에 운영체제 커널이 실행중이면서 커널의 데이터를 건들이는 도중에 인터럽트가 들어오면, 지금 하던 일은 잠시 잊고 인터럽트를 처리하는 코드를 실행할텐데 그것도 커널코드이기 때문에 커널의 데이터를 건들이게 된다.
			> 운영체제 커널에 있는 데이터는 공유데이터(여러 프로세스들이 동시에 사용할 수 있는)이기 때문에 문제가 발생할 수 있다.

# 3. OS에서 race condition은 언제 발생하는가?

1. kernel 수행 중 인터럽트 발생 시
2. Process가 system call을 하여 kernel mode로 수행 중인데 context switch가 일어나는 경우
3. Multiprocessor에서 shared memory 내의 kernel data

## A. interrupt handler v.s. kernel

![](/bin/OS_image/os_6_3.png)

- 커널모드 running 중 interrupt가 발생하여 인터럽트 처리루틴이 수행
	- 양쪽 다 커널 코드이므로 kernel address space 공유

```ad-example

커널의 코드가 수행 도중에 인터럽트가 발생해서 인터럽트 처리를 하게 되면, 커널에 있는 데이터를 양쪽에서 건들이는 도중에 CPU를 얻어가서 처리를 했기 때문에 발생하는 문제

---

- 문제를 해결하기 위해

이렇게 주요한 변수 값을 건들이는 동안에는 인터럽트가 들어와도 인터럽트 처리 루틴으로 넘기는 것이 아니라. 이 작업이 끝날때까지는 인터럽트 처리를 하지 않는다.

-> disable interrupt시켰다가 이런 작업이 끝난 다음에 enable interrupt하여 인터럽트 처리 루틴으로 넘겨서 race condition 문제가 발생하지 않게함.

```

## B. Preempt a process running in kernel?

![](/bin/OS_image/os_6_4.png)

- 두 프로세스의 address space 간에는 data sharing이 없음
- 그러나 system call을 하는 동안에는 kernel address space의 data를 access하게 됨(share)
- 이 작업 중간에 CPU를 preempt 해가면 race condition 발생

### a. If you preempt CPU while in kernel mode...

![](/bin/OS_image/os_6_5.png)

- 해결책
	- 커널 모드에서 수행중일 때는 CPU를 preempt하지 않음.
	- 커널 모드에서 사용자 모드로 돌아갈 때 preempt

```ad-example

A 프로세스가 본인의 코드를 실행하다가, system call을 해서 kernel에 코드를 실행한다. kernel의 count라는 값을 1 증가시키는 과정에서 A 프로세스에 할당된 시간이 끝났다. 그래서 B 프로세스에 CPU가 할당된다.

B 프로세스에서 system call이 발생하여 kernel에서 count를 1 증가시킴. 할당시간이 끝나서 A 프로세스에 CPU가 할당됨.

A 프로세스는 B 프로세스로 넘어가기 전 상태를 불러와서 kernel의 count 변수를 증가시킴

-> 이 경우 count는 1번만 증가됨.

----

- 이런 문제 해결 방법

프로세스가 커널 모드에 있을 때는, 할당 시간이 끝나도 CPU를 뺏기지 않도록한다.
커널 모드가 끝나고, user 모드로 빠져나올 때 CPU를 빼앗긴다.

이러면, 할당 시간이 정확하게 지켜지지는 않는다. 하지만 time sharing 시스템은 real time 시스템이 아니기 때문에 이런 문제를 쉽게 해결할 수 있다.

```

## C. multiprocessor

> 작업 주체가 여럿이기 때문에 발생하는 문제

![](/bin/OS_image/os_6_6.png)

어떤 CPU가 마지막으로 count를 store했는가? -> race condition

multiprocessor의 경우 interrupt enable/disable로 해결되지 않음

(방법 1) 한번에 하나의 CPU만이 커널에 들어갈 수 있게 하는 방법
(방법 2) 커널 내부에 있는 각 공유 데이터에 접근할 때마다 그 데이터에 대한 lock / unlock을 하는 방법

```ad-example

- (커널 전체를 하나의 lock으로 막고, 커널을 빠져나올 때 lock을 풀어준다.)
	- 커널에 접근하는 CPU를 매 순간 하나만 접근할 수 있게하여 문제를 해결한다.
	- CPU가 어러개여도, 매 순간 커널에 접근할 수 있는 CPU는 1개라서 매우 비효율적임

- (개별 데이터마다 lock을 거는 방법)
	- 데이터에 접근할 때, lock을 걸어서 다른 프로세서가 접근하지 못하게 만든다. 그 다음 데이터를 변경하고, 데이터 저장이 끝나면 lock을 풀어서 다른 프로세서가 접근할 수 있게 한다.

```

# 4. Process Synchronization 문제

- 공유 데이터(shared data)의 동시 접근 (concurrent access)은 데이터의 불일치 문제(inconsistency)를 발생시킬 수 있다.
- 일관성(consistency) 유지를 위해서는 협력 프로세스(cooperating process)간의 실행 순서(orderly execution)를 정해주는 메커니즘 필요

## A. Race condition

- 여러 프로세스들이 동시에 공유 데이터를 접근하는 상황
- 데이터의 최종 연산 결과는 마지막에 그 데이터를 다룬 프로세스에 따라 달라짐

> Race condition을 막기 위해서는 concurrent process는 동기화(synchronize)되어야 한다.

## B. Example of a Race Condition

![](/bin/OS_image/os_6_7.png)

- 사용자 프로세스 P1 수행중 timer interrupt가 발생해서 context switch가 일어나서 P2가 CPU를 잡으면?
	- 문제가 생기지 않는다
- 문제가 생기려면?
	- 두 프로세스 간의 공유 데이터를 수정하는 도중 인터럽트가 발생할 경우.
	- 실행 도중 커널 영역의 데이터를 수정하던 중 time 초과로 하드웨어 인터럽트가 발생할 경우.

# 5. The Critical-Section Problem

- n개의 프로세스가 공유 데이터를 동시에 사용하기를 원하는 경우
- 각 프로세스의 code segment에는 공유 데이터를 접근하는 코드인 critical section이 존재

```ad-note

- Problem
	- 하나의 프로세스가 critical section에 있을 때 다른 모든 프로세스는 critical section에 들어갈 수 없어야 한다.

```

![](/bin/OS_image/os_6_8.png)

shared data가 critical section이 아니라, 공유 데이터를 접근하는 코드가 critical section이다.

P1 프로세스가 critical section에 들어가 있으면(공유 데이터를 접근하는 코드를 실행 중이면), CPU를 뺏겨서 다른 프로세스한테 CPU가 넘어가더라도 공유데이터를 접근하는 critical section에 들어가지 못하게 한다. critical section을 빠져나왔을 때, P2 프로세스는 공유 데이터에 접근할 수 있다.

# 6. 프로그램적 해결법의 충족 조건

## A. Mutual Exclusion

- 프로세스 Pi가 critical section 부분을 수행 중이면 다른 모든 프로세스들은 그들의 critical section에 들어가면 안된다.

## B. Progress

- 아무도 critical section에 있지 않은 상태에서 critical section에 들어가고자 하는 프로세스가 있으면 critical section에 들어가게 해주어야 한다.

## C. Bounded Waiting

- 프로세스가 critical section에 들어가려고 요청한 후부터 그 요청이 허용될 때까지 다른 프로세스들이 critical section에 들어가는 횟수에 한계가 있어야 한다.


```ad-note

- 가정
	- 모든 프로세스의 수행 속도는 0보다 크다
	- 프로세스들 간의 상대적인 수행 속도는 가정하지 않는다.

```

# 7. Initial Attempts to Solve Problem

- 두 개의 프로세스가 있다고 가정 P0, P1
- 프로세스들의 일반적인 구조

```c

do {
	entry section // 공유데이터를 그냥 접근하게 하면, 동시접근을 통해서 문제가 발생할 수 있다. 그래서 공유데이터를 접근하는 코드 이전에 entry section을 넣어서 lock을 걸어준다.
		// 여러 프로세스가 동시에 critical section에 들어가는 것을 막음
	critical section // 공유데이터를 접근하는 코드
	exit section // critical section이 끝났으면 lock을 풀어서 다른 프로세스가 critical section에 들어갈 수 있게 해준다.
	remainder section 
} while (1);

```

- 프로세스들은 수행의 동기화(synchronize)를 위해 몇몇 변수를 공유할 수 있다.
	- synchronization variable

## A. Algorithm 1

> 교차로에서 내 신호등 돌고 상대 신호등이 돌게끔 설계되었을 때, 상대 신호등이 갑자기 꺼져버려서 무한 대기하는 것

Synchronization variable

```c

int turn; // 누구 차례인지 알려줌, turn이 0이면 -> 0번 프로세스 차례
initially turn = 0; => Pi can enter its critical section if (turn == i)

```

- Process $P_0$

	```c

	do{
		while (turn != 0); // My turn? // 내 차례가 아니면, while을 돌면서 기다림
		critical section
		turn = 1;			// Now it's your turn
		remainder section
	}while (1);

	```
	
- Process $P_1$

	```c

	do{
		while (turn != 0); // My turn? // 내 차례가 아니면, while을 돌면서 기다림
		critical section
		turn = 0;			// Now it's your turn
		remainder section
	}while (1);

	```

- Satisfies mutual exclusion, but not progress
	- 상호배제는 만족하지만, 진행(progress)는 만족하지 않는다.

- 즉, 과잉양보 
	- 반드시 한 번씩 교대로 들어가야만 함 (swap-turn) 
	- 그가 turn을 내 값으로 바꿔줘야만 내가 들어갈 수 있음. 
	- 프로세스 1은 빈번히 critical section을 들어가고 싶고, 프로세스 2는 한 번만 들어가고 안들어간다면?
		- 상대방이 turn을 바꿔주지 않기 때문에, 프로세스 0도 영원히 들어가지 않는다.

## B. Algorithm 2

> 비보호 좌회전 교차로에서 서로 깜빡이를 켜고 상대방 깜빡이가 꺼지면 출발하려고 대기하는 것

Synchronization variables

```c

boolean flag[2];	// 본인이 critical section에 들어가고자 한다는 의중을 표시하는 것
initially flag [모두] = false; // no one is in CS

"Pi ready to enter its critical section" if (flag[i] == true)

```

- Process $P_i$

	```c
	
	do {
		flag[i] = true;		// Pretend I am in // 본인이 critical section에 들어가려는 의사표시를 한다.
		while (flag[j]);	// Is he also is? then wait // 상대방 flag를 체크한다. -> 상대방도 체크되어 있으면, 상대방이 critical section에 들어가있을 수 있겠구나 하고 대기한다.
		critical section	// 상대방이 flag를 셋팅하지 않았다면 critical section에 들어감
		flag[i] = false;	// I am out now // critical section에 들어갔다 나올 때, 본인의 flag를 false로 만들어준다. 
		remainder section
	} while (1);
	
	```
	
- Process $P_j$

	```c
	
	do {
		flag[j] = true;		// Pretend I am in // 본인이 critical section에 들어가려는 의사표시를 한다.
		while (flag[i]);	// Is he also is? then wait // 상대방 flag를 체크한다. -> 상대방도 체크되어 있으면, 상대방이 critical section에 들어가있을 수 있겠구나 하고 대기한다.
		critical section	// 상대방이 flag를 셋팅하지 않았다면 critical section에 들어감
		flag[j] = false;	// I am out now // critical section에 들어갔다 나올 때, 본인의 flag를 false로 만들어준다. 
		remainder section
	} while (1);
	
	```

- Satisfies mutual exclusion, but not progress requirement
	- 둘 다 2행까지 수행 후 끊임 없이 양보하는 상황 발생 가능

## C. Algorithm 3 (Peterson's Algorithm)

> 신호등과 깜빡이가 같이 있는 것, 신호등이 갑자기 꺼져도 깜빡이를 통해 들어가는 것을 표시

Combined Synchronization variables of algorithm 1 and 2.

- Process $P_i$

	```c

	do{
		flag[i] = true;		// My interntion is to enter...
		turn = j;			// Set to his turn
		while(flag[j] && turn == j);	// wait only if
		critical section
		flag[i] = false;
		remainder section
	} while (1);

	```
	
- Process $P_j$

	```c

	do{
		flag[j] = true;		// My interntion is to enter...
		turn = i;			// Set to his turn
		while(flag[j] && turn == i);	// wait only if
		critical section
		flag[j] = false;
		remainder section
	} while (1);

	```
	
- Meets all three requirements; solves the critical section problem for two processes.
- Busy Waiting (=spin lock)
	- 계속 CPU와 memory를 쓰면서 wait
	- spin(계속 회전하면서), lock(락을 걸어서 다른 프로세스가 진입하지 못하게 함)
		- while문을 돌려서 상대가 못들어가게 lock을 건다.
		- 한 프로세스가 critical section에 들어가 있는 상태에서, 다른 프로세스가 CPU를 잡으면 while문을 돈다(분명히 while문을 빠져나가지 못함에도 불구하고 본인의 CPU 할당시간에 계속 while문을 돌면서 조건을 체크한다. 하지만 체크한다고 조건이 만족할리는 없다. 조건이 만족하려면, 상대방이 CPU를 잡아서 변수를 바꿔줘야함.).
			- 이것을 Busy Waiting이라고 한다.
	
상호배제(mutual exclusion), 진행(progress), 한정 대기(bounded waiting)를 모두 만족한다.

> 단순히 critical section에 들어갈 때 lock을 걸고, 나올 때 lock을 풀면 되는데, 코드가 복잡한 이유는 고급 언어의 문장 하나가 실행되는 도중에 CPU를 빼앗길 수 있다는 가정 하에 코드를 짜다보니까 복잡해진 것.

## D. Synchronization Hardware

> 하드웨어적으로 하나의 인스트럭션만 주어지면 critical section문제는 쉽게 해결할 수 있다.

하드웨어적으로 Test & modify를 atomic하게 수행할 수 있도록 지원하는 경우 앞의 문제는 간단히 해결

![](/bin/OS_image/os_6_9.png)

=> a라는 데이터를 읽고, a라는 데이터를 1로 바꿔주는 것을 하나의 인스트럭션으로 처리한다.

즉, 원래 값을 읽고, 그 자리에 1로 셋팅하는 작업을 atomic하게 하나의 인스트럭션으로 실행한다.

> 인스트럭션 하나를 가지고 데이터를 읽는 작업과 쓰는 작업을 동시에 수행할 수 있다면 (하드웨어적인 인스트럭션이 지원된다면) 간단하게 lock을 걸고 푸는 문제를 해결할 수 있다.
> > Test_and_Set() 인스트럭션이 있다.

- Mutual Exclusion with Test & Set

	```c

	Synchronization variable:
		boolean lock = false;

	Process Pi
		
		do {
			while (Test_and_Set(lock));
			critical section
			lock = false;
			remainder section
		}

	```

- Test_and_Set은 이미 lock이 걸려 있는지 체크하고, lock이 안걸려 있으면 내가 lock을 걸고 critical section에 들어가는 두 개의 작업을 Test_and_Set을 통해 동시에 수행한다.

## E. Semaphores

> 앞의 방식들을 추상화시킴

> 일종의 추상 자료형이다.
> > Semaphore S => 세마포어 변수 S는 정수 값을 가질 수있음, P와 V 오퍼레이션을 정의할 수 있음.

- Semaphore S
	- integer variable
		- 자원의 개수
	- 아래의 두 가지 atomic 연산에 의해서만 접근 가능

	```
	
	P(S):	// 세마포어 변수 값을 획득하는 과정 (공유 데이터를 획득하는 과정)
		while (S <= 0) do no-op; // (i.e. wait)
		S--;
		
	```
		
	- If positive, decrement-&-enter.
	- otherwise, wait until positive (busy-wait)
		- 어떤 자원이 없을 때, P연산을 하게 되면, while문을 돌아봤자. 자원이 없기 때문에 계속 기다리다가 본인의 CPU 시간을 다 쓰고 반납한다.
	
	```
		
	V(S):	// 다 사용하고 나서 반납하는 과정 
		S++;
	
	```

### a. 추상 자료형

추상 자료형은 object와 operation으로 구분된다.

추상 자료형은 논리적으로 정의될 뿐, 실제로 어떻게 구현되는지는 정의하지 않는다.

```ad-example

- 정수 추상 자료형	
	- 정수 숫자들
	- 숫자에 대해 정의된 연산 (덧셈, 뺄셈 등)

```


### b. 왜 사용하는가?

- lock을 걸고, lock을 풀는 것을 semaphore를 이용해서 프로그래머한테 간단하게 제공할 수 있다.
- 공유 자원을 획득하고 반납하는 것을 semaphore가 처리해준다. 

### c. 실행 예시

1. 변수 S에 대해서 P 연산을 하게 되면.
	- S값이 0 이하일 동안에 while문을 돌면서 아무일도 안하고 기다리게 된다.
		- 자원이 없는 상태
	- S값이 양수가 되면 S값에 1을 빼고 자원을 획득한다.
		- 누군가가 자원을 내어 놓으면.
2. 자원 사용이 끝나면 V 연산을 한다.
	- S값을 1 증가시켜서 반납을 한다.

> P연산과 V연산은 atomic하게 연산이 수행됨을 가정하고 있다.
> semaphore는 구체적인 구현을 나타내는 것이 아니고, 추상적으로 연산 자체를 정의해놓는 것이기 때문에 어떤식으로 atomic하게 연산이 실행되는 것은 이야기하지 않는다.

### d. Critical Section of n Processes

lock을 걸때(critical section에 들어가야 할 때)는 P연산을 해주고, 빠저나올때는 V연산을 해주면 critical section 문제가 자연스럽게 해결된다.

따라서 프로그래머는 세마포어가 지원이 된다면 P연산과 V연산만 해주면 된다. P연산과 V연산을 어떻게 구현할지는 그때그때 구현할 시스템에서 생각해야할 몫이다.

```c

Synchronization variable
semaphore mutex;	// initially 1 : 1개가 CS에 들어갈 수 있다.

Process Pi

do {
	P(mutex);		// If positive, dec-&-enter, Otherwise, wait
	critical section
	V(mutex);		// Increment semaphore
	remainder section
} while(1);

```

- busy-wait는 효율적이지 못함 (=spin lock)
	- lock을 획득 못한 프로세스는 계속 while문을 회전하면서 lock을 얻길 기다리는 것
- Block & Wakeup 방식의 구현 (=sleep lock)
	- lock을 못얻으면 그 프로세스는 쓸데없이 CPU를 사용하는 것이 아닌, Blocked 상태(잠들어버리게 한다.)

### e. Block / Wakeup Implementation

- Semaphore를 다음과 같이 정의

	```c

	typedef struct
	{
		int value;			// semaphore	// 실제 semaphore 변수 값
		struct process *L;	// process wait queue	// semaphore 때문에 잠들어 있는 변수들을 연결하기 위한 큐
	} semaphore;

	```

- block과 wakeup을 다음과 같이 가정
	- block
		> semaphore를 획득할 수 없으면, 그 프로세스를 block시킴
		- 커널은 block을 호출한 프로세스를 suspend시킴
		- 이 프로세스의 PCB를 semaphore에 대한 wait queue를 넣음
	- wakeup(P)
		> 누군가가 semaphore를 쓰고 나서 반납하게 되면, block된 프로세스 중에 하나를 깨워서 wakeup을 시키게 된다.
		- block된 프로세스 P를 wakeup시킴
		- 이 프로세스의 PCB를 ready queue로 옮김

![](/bin/OS_image/os_6_10.png)

#### 1) Implementation (block / wakeup version of P() & V())

Semaphore 연산이 다음과 같이 정의됨

```c

P(S):	// 자원을 획득하는 과정
		// 자원에 여분이 있다면, 바로 획득 / 자원에 여분이 없다면 잠든다(block).
	S.value--;	// prepare to enter / 먼저, semaphore 변수 값을 1 빼준다.
	if (S.value < 0)	// Oops, negative, I cannot enter / 만약, 그 값이 음수라면(자원의 여분이 없다는 이야기) 이 프로세스를 S.L에 연결시킨 다음 block을 시킨다.
	{
		add this process to S.L;
		block();	// block 상태에 있다가, 자원이 생기면 그때 깨어난다.
	}

```

```c

V(S):	// 자원을 다 사용하고나서 반납하는 것.
		// 혹시 이 자원을 기다리면서 block(잠들어있는)된 프로세스가 있다면, 그것을 깨워준다.
	S.value++;	// 자원을 쓰고 있는 프로세스가 자원을 다 쓰면, value를 1 증가시킨다.
	if(S.value <= 0){	// S.value가 0 이하이면(누군가가 자원을 기다리면서 block(잠들어 있다)된 상태라는 것) 잠들어 있는 프로세스 1개를 Semaphore의 list에서 빼서 깨워줘야한다.
		remove a process P from S.L;
		wakeup(P);
	}

```

> S.value가 음수이면, 누군가가 자원을 기다리고 있다는 의미.
> S.value가 양수이면, 자원의 여분이 있기 때문에 기다리지 않고 쓰고 있는 상황이라는 의미.

### f. Which is better?

Busy-wait vs Block/wakeup

> critical section의 길이가 긴 경우 Block/wakeup이 필수가 된다.
> critical section의 길이가 매우 짧은 경우 busy-wait 방식을 사용해도 크게 상관 없다.

- Block/wakeup overhead vs Critical section 길이
	- Critical section의 길이가 긴 경우 Block/Wakeup이 적당
	- Critical section의 길이가 매우 짧은 경우 Block/Wakeup 오버헤드가 busy-wait 오버헤드보다 더 커질 수 있음
		- Block/Wakeup의 오버헤드
			- 프로세스의 상태를 (ready에서 block), (block에서 ready)으로 바꿔야하기 때문에 오버헤드가 발생한다.
	- 일반적으로는 Block/wakeup 방식이 더 좋음

### g. Two Types of Semaphores

#### 1) Counting semaphore

- 도메인이 0 이상인 임의의 정수값
	- 자원의 개수가 여러개 있어서, 여분이 있으면 가져다 쓸 수 있는 경우
- 주로 resource counting에 사용

#### 2) Binary semaphore (=mutex)

- 0 또는 1 값만 가질 수 있는 semaphore
	- lock을 걸때 자원의 개수를 하나로 셋팅해서 사용한다.
- 주로 mutual exclusion (lock/unlock)에 사용

### h. Deadlock and Starvation

#### 1) Deadlock

> 자신이 자원을 점유하고 있는 상황에서, 상대방이 가진 것을 영원히 기다리는 상태

둘 이상의 프로세스가 서로 상대방에 의해 충족될 수 있는 event를 무한히 기다리는 현상

##### ㄱ) 예시

- S와 Q가 1로 초기화된 semaphore라 하자.

	![](/bin/OS_image/os_6_11.png)

	semaphore S와 Q가 있다. 내가 어떠한 일을 하기 위해서, S와 Q를 모두 획득해야만하는 환경이다. 

	이런 연산을 P0도 하고, P1도 한다고 생각해보자. S와 Q는 배타적으로(프로세스 1개만 동시에 사용할 수 있는) 1로 초기화된 semaphore라고 하면 문제가 생길 수 있다.

	P0이 먼저 CPU를 얻어서 semaphore S를 먼저 획득한다. 그리고 CPU를 P1에게 뺏겨서 P1이 semaphore Q를 획득한다. 그리고 S를 획득하려고 보니, P0에서 가지고 있어서 획득하지 못하고 기다리게 된다. (언제까지? 영원히(P0이 S를 내놔야 P1에서 S를 획득할 수 있는데 P0에서 Q까지 획득해서 다 사용을 하고 반환할 때 S를 내놓는다.))

	> 즉, P0과 P1이 각각 자원을 1개씩 가지고 있는 상황에서 자원을 놓치는 않고 상대방이 가진 자원을 기다리면서 무한정 대기(영원히 조건이 충족되지 못하는)한다.

- 해결 방법
	
	![](/bin/OS_image/os_6_12.png)

	자원을 획득하는 순서를 똑같이 맞춰주면 해결할 수 있다.
	
	즉, Q를 획득하기 위해서는 S를 먼저 획득하고나서 Q를 획득하라는 의미.
	
	따라서, 둘이서 자원을 하나씩 가지고 있으면서, 영원히 내놓지 않는 문제는 발생하지 않는다.

#### 2) Starvation

> 특정 프로세스가 자원을 얻지 못하고 무한히 기다려야하는 상태인 것
> 특정 프로세스들끼리만 자원을 공유하면서 다른 프로세스는 영원히 자기 차례가 오지 못하게 하는 것

indefinite blocking.

프로세스가 suspend된 이유에 해당하는 세마포어 큐에서 빠져나갈 수 없는 현상

##### ㄱ) 예시

- 식사하는 철학자

	![](/bin/OS_image/os_6_13.png)

	식탁에 철학자 5명이 앉아있다. 젓가락을 공유하고, 왼쪽과 오른쪽 젓가락을 모두 잡아야만 식사를 할 수 있다.
	
	6시 방향 철학자가 밥을 먹으려고 할 때, 7시 방향 철학자가 먼저 먹으면, 7시 방향 철학자가 다 먹을 때까지 대기한다. 또한, 5시 방향 철학자가 밥을 먹으면, 5시 방향 철학자가 밥을 다 먹을 때까지 대기한다. 이렇게 7시 방향 철학자와 5시 방향 철학자가 6시 방향 철학자를 기아 상태로 만들 수 있다.
	
	- deadlock

		5명이 동시에 왼쪽 젓가락을 집으면, 오른쪽 젓가락을 상대방이 쥐고 있기 때문에 영원히 먹지 못한다.

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140328151311578473?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 25, 2021)
