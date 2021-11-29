# 1. CPU and I/O Bursts in Program Execution

![](/bin/OS_image/os_5_1.png)

```
CPU에서 인스트럭션을 실행하는 기계어

load store
add store
read from file
```

- CPU burst
	- CPU만 연속적으로 쓰면서 인스트럭션을 실행하는 일련의 단계
- I/O burst
	- I/O를 실행하는 단계

프로그램의 종류에 따라서 burst의 빈도나 길이가 다르다.

# 2. CPU-burst Time의 분포

![](/bin/OS_image/os_5_2.png)

- 여러 종류의 job(=process)이 섞여 있기 때문에 CPU 스케줄링이 필요하다.
	- Interactive job에게 적절한 response 제공 요망
		- Interactive job이 오래 기다리지 않도록 하기 위해 CPU 스케줄링이 필요함.
	- CPU와 I/O 장치 등 시스템 자원을 골고루 효율적으로 사용

---

- I/O bound job
	- CPU를 짧게 쓰고, 중간에 I/O가 끼어드는 작업
	- CPU를 짧게 쓰는데, 빈도가 많은 것
- CPU bound job
	- CPU만 오랫동안 쓰는 작업
	- CPU를 오래 쓰는 것

# 3. 프로세스의 특성 분류

프로세스는 그 특성에 따라 다음 두 가지로 나눔

## A. I/O-bound process

- CPU를 잡고 계산하는 시간보다 I/O에 많은 시간이 필요한 job
- many short CPU bursts

## B. CPU-bound process

- 계산 위주의 job
- few very long CPU bursts

# 4. CPU Scheduler & Dispatcher

## A. CPU Scheduler

> CPU Scheduler는 운영체제 내부에서 CPU Scheduling하는 코드가 있다. 이 부분을 CPU Scheduler라고 부름.

- Ready 상태의 프로세스 중에서 이번엔 CPU를 줄 프로세스를 고른다.

## B. Dispatcher

> CPU를 누구한테 줄지를 결정했으면(CPU Scheduler로), 그 친구한테 CPU를 넘겨주는 역할을 하는 운영체제 커널 코드

- CPU의 제어권을 CPU scheduler에 의해 선택된 프로세스에게 넘긴다.
- 이 과정을 context switch(문맥 교환)라고 한다.

## C. CPU 스케줄링이 필요한 경우

CPU 스케줄링이 필요한 경우는 프로세스에게 다음과 같은 상태 변화가 있는 경우이다.

1. Running -> Blocked
	- 예) I/O 요청하는 시스템 콜
2. Running -> Ready
	- 예) 할당시간만료로 timer interrupt
3. Blocked -> Ready
	- 예) I/O 완료후 인터럽트
4. Terminate

- 1, 4에서의 스케줄링은 nonpreemptive
	- 강제로 빼앗지 않고 자진 반납
	- 비선점
- All other scheduling is preemptive
	- 강제로 빼앗음
	- 선점

## C. CPU 스케줄링이 필요한 경우

CPU 스케줄링이 필요한 경우는 프로세스에게 다음과 같은 상태 변화가 있는 경우이다.

1. Running -> Blocked
	- 예) I/O 요청하는 시스템 콜
2. Running -> Ready
	- 예) 할당시간만료로 timer interrupt
3. Blocked -> Ready
	- 예) I/O 완료후 인터럽트
4. Terminate

- 1, 4에서의 스케줄링은 nonpreemptive
	- 강제로 빼앗지 않고 자진 반납
	- 비선점형
- All other scheduling is preemptive
	- 강제로 빼앗음
	- 선점형

# 5. Scheduling Algorithms

## A. FCFS (First-Come First-Served)

> 비선점형 스케줄링

- 효율적이지는 않음.
	- CPU를 오래 사용하는 작업이 나타나면, CPU를 적게 사용하는 작업도 오래 기다려야하기 때문.
- 앞에 진행중인 프로세스 시간에 따라 기다리는 시간에 상당한 영향을 줌.

```ad-example

은행 번호표, 화장실

```

| Process | Burst Time |
| ------- | ---------- |
| P1      | 24         |
| P2      | 3          |
| P3      | 3          |

프로세스의 도착 순서 P1, P2, P3

스케줄 순서를 Gantt Chart로 나타내면 다음과 같다.

![](/bin/OS_image/os_5_3.png)

- Waiting time for
	- P1 = 0, P2 = 24, P3 = 27
- Average waiting time
	- (0 + 24 + 27) / 3 = 17

---

| Process | Burst Time |
| ------- | ---------- |
| P1      | 24         |
| P2      | 3          |
| P3      | 3          |

프로세스의 도착 순서 P2, P3, P1

스케줄 순서를 Gantt Chart로 나타내면 다음과 같다.

![](/bin/OS_image/os_5_4.png)

- Waiting time for
	- P1 = 6, P2 = 0, P3 = 3
- Average waiting time
	- (6 + 0 + 3) / 3 = 3

```

- Much better than previous case.
- Convoy effect : short process behind long process
	- 콘보이 효과 : 긴 프로세스가 하나 도착해서, 짧은 프로세스들이 지나치게 오래 기다려야하는 현상

```

## B. SJF (Shortest-Job-First) / SRTF (Shortest-Remaining-Time-First)

- 각 프로세스의 다음번 CPU burst time을 가지고 스케줄링에 활용
- CPU burst time이 가장 짧은 프로세스를 제일 먼저 스케줄
- Two schemes:
	- Nonpreemptive
		- 일단 CPU를 잡으면 이번 CPU burst가 완료될 때까지 CPU를 선점(preemption) 당하지 않음
	- Preemptive
		- 현재 수행중인 프로세스의 남은 burst time보다 더 짧은 CPU burst time을 가지는 새로운 프로세스가 도착하면 CPU를 빼앗김
		- 이 방법을 Shortest-Remaining-Time-First (SRTF)이라고도 부른다.
- SJF is optimal
	- 주어진 프로세스들에 대해 minimum average waiting time을 보장
		- preemptive 버전이 average waiting time을 최소화함

> 평균 대기 시간을 최소화하는 스케줄링 알고리즘

- 문제점
	- Starvation(기아 현상)가 발생할 수 있음.
		- SJF는 CPU 사용량이 극단적으로 짧은 job을 선호한다. CPU 사용량이 긴 프로세스는 영원히 서비스를 못받을 수도 있다.
	- CPU 사용 시간을 미리 알 수 없다.
		- 과거에 CPU를 사용한 흔적으로 추정할 수는 있다.

| Process | Arrival Time | Burst Time |
| ------- | ------------ | ---------- |
| P1      | 0.0          | 7          |
| P2      | 2.0          | 4          |
| P3      | 4.0          | 1          |
| P4      | 5.0          | 4          |

### a. SJF (non-preemptive)

> CPU 스케줄링은 어제 이루어지는가?
> > CPU를 다 사용하고 나가는 시점에 CPU를 스케줄링할지, 안할지를 결정한다.

![](/bin/OS_image/os_5_5.png)

- Average waiting time
	- (0 + 6 + 3 + 7) / 4 = 4

### b. SRTF (preemptive)

> CPU 스케줄링은 어제 이루어지는가?
> > 새로운 프로세스가 도착하면(지금 작업중인 프로세스보다 burst time이 작다면) 스케줄링이 이루어진다.

![](/bin/OS_image/os_5_6.png)

- Average waiting time
	- (9 + 1 + 0 + 2) / 4 = 3

### c. 다음 CPU Burst Time의 예측

- 다음번 CPU burst time을 어떻게 알 수 있는가?
	- input data, branch, user ...
- 추정(estimate)만이 가능하다.
- 과거의 CPU burst time을 이용해서 추정
	- (exponential averaging)

	1. $t_n$ = actual lenght of $n^{th}$CPU burst
	2. $\tau_{n+1}$ = predicted value for the next CPU burst
	3. $\alpha$, 0 <= $\alpha$ <= 1
	4. Define : $\tau_{n+1}$ = $\alpha t_{n}$ + (1-$\alpha$)$\tau_{n}$

		```ad-note

		t = 실제 CPU 사용 시간
		$\tau$ = CPU 사용을 예측한 시간
		
		$t_n$ = n번째 실제 CPU 사용 시간
		$\tau_{n+1}$ = n+1번째 CPU 사용을 예측한 시간	


		$\tau_{n+1}$ = $\alpha t_{n}$ + (1-$\alpha$)$\tau_{n}$
		=> n+1번째 CPU 사용 예측 시간은, n번째 실제 CPU 사용 시간과 n번째 예측했던 CPU 사용 시간을 일정 비율씩 곱해서 더한다.
		
		$\alpha$ = 일정 비율, ==> $\alpha$ + 1 - $\alpha$ = 1
		
		```

		```ad-note

		위 점화식을 푸는 방법
		
		- $\alpha$ = 0
			- $\tau_{n+1}$ = $\tau_{n}$
			- Recent history does not count
		- $\alpha$ = 1
			- $\tau_{n+1}$ = $t_{n}$
			- Only the actual last CPU burst counts
		- 식을 풀면 다음과 같다.
			- $\tau_{n+1}$ = $\alpha t_{n}$ + (1 - $\alpha$)$\alpha t_{n-1}$ + ... + $(1-\alpha)^j \alpha t_{n-j}$ + ... + $(1 - \alpha)^{n+1}\tau_{0}$

		```

- 미래를 예측하려고하는데, 과거에 똑같은 behavior가 있으면, 그것을 통해서 미래를 예측하는데 과거를 어떤 비율로 반영할 것인가.
	- 최근 것을 더 많이 반영하고, 과거 것을 적게 반영하는 방법이 exponential averaging

## C. Priority Scheduling

> 우선순위 스케줄링으로 우선순위가 제일 높은 프로세스에게 CPU를 할당하겠다.

- A priority number (integer) is associated with each process
- highest priority를 가진 프로세스에게 CPU 할당 (smallest integer = highest priority)
	- preemptive
		- 우선순위가 제일 높은 프로세스에게 CPU를 할당했는데, 우선순위가 더 높은 프로세스가 등장했을 때, CPU를 빼앗을 수 있는가.
	- nonpreemptive
		- 한 번 CPU를 할당하면, 더 높은 우선순위를 가지는 프로세스가 등장해도, CPU를 다 사용할 때까지는 빼앗을 수 없는 것.
- SJF는 일종의 priority scheduling이다. (priority = predicted next CPU burst time)
- Problem
	- Starvation (기아 현상)
		- low priority processes may **never execute**
		- 우선순위가 낮은 프로세스가 지나치게 오래 기다려서, 경우에 따라서는 영원히 실행되지 못하는 상황
	- Solution
		- Aging (노화)
			- as time progresses **increase the priority** of the process
			- 오래 기다리면, 우선순위를 조금씩 높여주자는 것.

## D. RR (Round Robin)

> 응답시간(Response time)이 빨라진다.

- 각 프로세스는 동일한 크기의 할당 시간(**time quantum**)을 가짐 (일반적으로 10-100 milliseconds)
- 할당 시간이 지나면 프로세스는 선점(preempted)당하고 ready queue의 제일 뒤에 가서 다시 줄을 선다.
- n개의 프로세스가 ready queue에 있고 할당 시간이 **q time unit**인 경우 각 프로세스는 최대 q time unit 단위로 CPU 시간의 1/n을 얻는다.
	- **어떤 프로세스도 (n-1) * (q time unit)  이상 기다리지 않는다.**
- Performance
	- q large
		- FCFS
	- q small
		- context switch 오버헤드가 커진다.
	- 따라서, 적당한 규모의 time quantum을 주는 것이 바람직하고, 보통은 10~100 millisecond임

| Process | Burst Time |
| ------- | ---------- |
| P1      | 53         |
| P2      | 17         |
| P3      | 68         |
| P4      | 24         |

Time Quantum = 20

![](/bin/OS_image/os_5_7.png)

- 일반적으로 SJF보다 average turnaround time이 길지만 response time은 더 짧다.
	- 거의 모든 프로세스들이 마지막까지 CPU를 조금씩 서비스받으면서 waiting time이 굉장히 길어지기 때문에 안좋을 수 있다.

### a. Turnaround Times Varies With Time Quantum

![](/bin/OS_image/os_5_8.png)


## E. Multilevel Queue

> 여러 줄로 CPU를 기다린다.
> 태어난 출신(processes)에 따라 영원히 우선순위를 극복하지 못한다.

### a. 고려 사항

1. 프로세스를 어느 줄에 집어넣을 것인가?
2. 우선순위가 높은 줄에만 우선권을 주면, starvation 현상이 발생할 수 있다.

### b. 특징

- Read queue를 여러 개로 분할
	- foreground (interactive)
	- background (batch - no human interaction)
- 각 큐는 독립적인 스케줄링 알고리즘을 가짐
	> 줄의 특성에 맞는 스케줄링을 선택해야한다.
	- foreground
		- RR
			- 사람과 interaction하는 프로세스이기 때문에, RR을 사용하여 응답시간을 짧게할 수 있다.
	- background
		- FCFS
			- CPU만 오랫동안 사용하는 job이고, 응답시간이 빠르다고 좋을 것이 없는 batch형 job이기 때문에 context switching 오버헤드를 줄이기 위해서 FCFS 사용하는 것이 효율적일 수 있다.
- 큐에 대한 스케줄링이 필요
	- Fixed priority scheduling
		- serve all from foreground then from background
		- Possibility of starvation
	- Time slice
		- 각 큐에 CPU time을 적절한 비율로 할당
			```ad-example

			80% to foreground in RR, 20% to background in FCFS

			```
		- starvation을 막기 위해 각 줄별로 CPU 시간을 나누어서 주는 방법을 생각할 수 있다.

![](/bin/OS_image/os_5_9.png)

## F. Multilevel Feedback Queue

> 여러 줄로 CPU를 기다린다.
> 태어난 출신이 낮아도 우선순위가 승격될 수 있다. (프로세스가 경우에 따라서 줄 간에 이동할 수 있다.)

![](/bin/OS_image/os_5_10.png)

- 프로세스가 다른 큐로 이동 가능
- 에이징(Aging)을 이와 같은 방식으로 구현할 수 있다.
- Multilevel-feedback-queue scheduler를 정의하는 파라미터들
	- Queue의 수
	- 각 큐의 scheduling algorithm
	- Process를 상위 큐로 보내는 기준
	- Process를 하위 큐로 내쫓는 기준
	- 프로세스가 CPU 서비스를 받으려 할 때 들어갈 큐를 결정하는 기준

- queue의 위에서 아래로 갈수록 RR의 할당 시간을 점점 길게 준다.
	- 맨 마지막 queue는 FCFS

### a. Example of Multilevel Feedback Queue

- Three queues:
	- Q0
		- time quantum 8 milliseconds
	- Q1
		- time quantum 16 milliseconds
	- Q2
		- FCFS
- Scheduling
	- new job이 queue Q0로 들어감
	- CPU를 잡아서 할당 시간 8milliseconds 동안 수행됨
	- 8milliseconds 동안 다 끝내지 못했으면 queue Q1으로 내려감
	- Q1에 줄서서 기다렸다가 CPU를 잡아서 16ms 동안 수행됨
	- 16ms에 끝내지 못한 경우 queue Q2로 쫓겨남 

## G. Multiple-Processor Scheduling

- CPU가 여러 개인 경우 스케줄링은 더욱 복잡해짐
- Homogeneous processor인 경우
	- Queue에 한 줄로 세워서 각 프로세서가 알아서 꺼내가게 할 수 있다.
	- 반드시 특정 프로세서에서 수행되어야 하는 프로세스가 있는 경우에는 문제가 더 복잡해짐
		- 특정 프로세스는 특정 프로세서에 할당을 하고 나머지 스케줄링 진행.
- Load sharing
	- 일부 프로세서에 job이 몰리지 않도록 부하를 적절히 공유하는 메커니즘 필요
	- 별개의 큐를 두는 방법 vs 공동 큐를 사용하는 방법
- Symmetric Multiprocessing (SMP)
	- 모든 CPU가 동등하기 떄문에 각 프로세서(CPU)가 각자 알아서 스케줄링 결정
- Asymmetric Multiprocessing
	- 하나의 프로세서가 시스템 데이터의 접근과 공유를 책임지고 나머지 프로세서는 거기에 따름.

## H. Real-Time Scheduling

### a. Hard real-time systems

- Hard real-time task는 정해진 시간 안에 반드시 끝내도록 스케줄링해야 함

### b. Soft real-time computing

- Soft real-time task는 일반 프로세스에 비해 높은 priority를 갖도록 해야 함
- dead line을 반드시 지키지 않아도 됨.

## I. Thread Scheduling

### a. Local Scheduling

- User level thread의 경우 사용자 수준의 thread library에 의해 어떤 thread를 스케줄할지 결정
- 운영체제는 프로세스한테 CPU를 줄지 말지만 결정
	- 프로세스는 프로세스 내부에서 어떤 스레드에 CPU를 할당할지 결정

#### 1) User level thread

사용자 프로세스가 직접 스레드를 관리하고, 운영체제는 스레드의 존재를 모름.

### b. Global Scheduling

- Kernel level thread의 경우 일반 프로세스와 마찬 가지로 커널의 단기 스케줄러가 어떤 thread를 스케줄할지 결정
- 운영체제가 알고리즘에 근거해서 어떤 스레드에 CPU를 할당할지를 결정

#### 2) Kernel level thread

운영체제가 스레드의 존재를 알고 있음.

# 6. Scheduling Criteria

> Performance Index (=Performance Measure, 성능 척도)

## A. 시스템 입장에서의 성능 척도

- CPU utilization (이용률)
	- keep the CPU as busy as possible
	- CPU는 가능한 바쁘게 일을 시켜라.
- Throughput (처리량)
	- # of processed that complete their execution per time unit
	- 주어진 시간에 몇 개의 작업을 완료했는가를 나타냄.

## B. 프로그램 입장에서의 성능 척도

- Turnaround time (소요시간, 반환시간)
	- amount of time to execute a particular process
	- CPU를 쓰러 들어와서, 나갈때까지 걸린 시간.
- Waiting time (대기 시간)
	- amount of time a process has been waiting in the ready queue
	- ready queue에 줄서서 기다린 시간의 합.
- Response time (응답 시간)
	- amount of time it takes from when a request was submitted until the first response is produced, not output (for time-sharing environment)
	- 요청이 제출된 시점부터 첫 번째 응답이 생성될 때까지 걸리는 시간.

# 7. Algorithm Evaluation


## A. Queueing models

> 이론적인 방법

- 확률 분포로 주어지는 arrival rate와 service rate 등을 통해 각종 performance index 값을 계산

![](/bin/OS_image/os_5_11.png)

Server -> CPU

## B. Implementation (구현) & Measurement (성능 측정)

> 실측하는 방법

- 실제 시스템에 알고리즘을 구현하여 실제 작업(workload)에 대해서 성능을 측정 비교

## C. Simulation (모의 실험)

> Implementation이 어려우면 사용

- 알고리즘을 모의 프로그램으로 작성 후 trace를 입력으로 하여 결과 비교
	- trace
		- 시뮬레이션 프로그램에 Input으로 들어갈 데이터

# 참고자료

[1] 반효경, [Process Management 1](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 25, 2021)
