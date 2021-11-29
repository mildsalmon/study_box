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



# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140328151311578473?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 25, 2021)
