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

# 참고자료

[1] 반효경, [Process Management 1](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 25, 2021)
