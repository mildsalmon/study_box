# 1. 교착상태(deadlock)

![[os_7_1.png]]

> 각자 일부 자원은 가지고 있으면서, 상대방이 가지고 있는 자원을 요구하고 있는데. 상대방도 자신이 가지고 있는 것을 내놓지 않고 상대방이 가진 것을 요구하는 것.

## A. The Deadlock Problem

### a. Deadlock

- 일련의 프로세스들이 서로가 가진 자원을 기다리며 block된 상태

### b. Resource (자원)

- 하드웨어, 소프트웨어 등을 포함하는 개념

```ad-example

I/O device, CPU cycle, memory space, semaphore 등

```

- 프로세스가 자원을 사용하는 절차
	- Request, Allocate, Use, Release

### c. Deadlock Example

#### 1) Example 1

- 시스템에 2개의 tape drive가 있다.
	- A tape에서 읽어서 B tape으로 copy를 하는 작업을 생각해보자.
	- 두 프로세스가 각각 tape 2개를 점유해야지만 다른쪽에 copy를 할텐데, 프로세스 각자가 tape을 하나씩 가지고 있는 상태에서 상대방이 가진 자원을 요구하면,
		- 어느 누구도 더 이상 진행되지 않는 상태를 deadlock 상태에 도달한다고 한다.
	- => 이 경우 하드웨어 장치를 기다리면서 deadlock이 된 상태
- 프로세스 P1과 P2 각각이 하나의 tape drive를 보유한 채 다른 하나를 기다리고 있다.

#### 2) Example 2

- Binary semaphore A and B

![[os_7_2.png]]

## B. Deadlock의 발생 4가지 조건

### a. Mutual exclusion (상호배제)

- 매 순간 하나의 프로세스만이 자원을 사용할 수 있음

### b. No preemption (비선점)

- 프로세스는 자원을 스스로 내어놓을 뿐 강제로 빼앗기지 않음

### c. Hold and wait (점유와 대기)

- 자원을 가진 프로세스가 다른 자원을 기다릴 때 보유 자원을 놓지 않고 계속 가지고 있음

### d. Circular wait (순환대기)

- 자원을 기다리는 프로세스간에 사이클이 형성되어야 함
- 프로세스 P0, P1, Pn이 있을 때
	- P0은 P1이 가진 자원을 기다림
	- P1은 P2가 가진 자원을 기다림
	- Pn-1은 Pn이 가진 자워을 기다림
	- Pn은 P0이 가진 자원을 기다림

## C. Resource-Allocation Graph (자원할당 그래프)

- Vertex
	- Process P = {P1, P2, ... , Pn}
	- Resource R = {R1, R2, ... , Rm}
- Edge
	- request edge Pi -> Rj
	- assignment edge Rj -> Pi

![[os_7_3.png]]

> cycle이 없으므로 deadlock이 아님.

- 자원 -> 프로세스
	- 이 프로세스가 이 자원을 가지고 있다.
- 프로세스 -> 자원
	- 이 프로세스가 이 자원을 요청한 것
- 자원 안의 점들
	- 자원의 수(인스턴스)

![[os_7_4.png]]

> 1번은 deadlock 
> 2번은 deadlock 아님

- 그래프에 cycle이 없으면 deadlock이 아니다.
- 그래프에 cycle이 있으면
	- if only one instance per resource type, then deadlock
		- 자원당 인스턴스(점)이 하나밖에 없다면, cycle은 deadlock을 의미한다.
		- 내가 가진 자원은 다른사람이 가지고 있고, 다른 사람이 필요로 하는 자원은 내가 가지고 있음. 
	- if several instances per resource type, possibility of deadlock  
		- 자원당 인스턴스가 여러개라면, deadlock일수도 있고 아닐수도 있다.

## D. Deadlock의 처리 방법

### a. Deadlock Prevention

- 자원 할당 시 Deadlock의 4가지 필요 조건 중 어느 하나가 만족되지 않도록 하는 것

> 자원에 대한 Utilization(이용률) 저하, 전체 시스템에 대한 throughput(처리량) 감소, starvation(기아) 문제

> 비효율적임

> 생기지도 않을 deadlock을 미리 생각해서 제약조건을 많이 달아두기 때문에 상당히 비효율적이다.

#### 1) Mutual Exclusion

- 공유해서는 안되는 자원의 경우 반드시 성립해야 함.
	- 한번에 하나의 프로세스만 사용할 수 있는 자원이라면, 배제할 수 있는 조건은 아니다.

#### 2) Hold and Wait

- 프로세스가 자원을 요청할 때 다른 어떤 자원도 가지고 있지 않아야 한다.
- 방법 1.
	- 프로세스 시작 시 모든 필요한 자원을 할당받게 하는 방법
		- 자원이 한번에 모든게 필요한게 아니라, 매시점마다 필요로하는 자원이 다를텐데, 미리 전부 보유하게되면 자원의 비효율성이 발생한다.
- 방법 2.
	- 자원이 필요할 경우 보유 자원을 모두 놓고 다시 요청

#### 3) No Preemption

- process가 어떤 자원을 기다려야 하는 경우 이미 보유한 자원이 선점됨
- 모든 필요한 자원을 얻을 수 있을 때 그 프로세스는 다시 시작된다.
- State를 쉽게 save하고 restore할 수 있는 자원에서 주로 사용 (CPU, memory)

#### 4) Circular Wait

- 모든 자원 유형에 할당 순서를 정하여 정해진 순서대로만 자원 할당
- 예를 들어 순서가 3인 자원 Ri를 보유 중인 프로세스가 순서가 1인 자원 Rj를 할당받기 위해서는 우선 Ri를 release해야 한다.
	- A는 1번 자원을 가지고 있으면서 2번 자원을 기다리고, B는 2번 자원을 가지고 있으면서 1번 자원을 기다리는게 deadlock
	- 하지만, 여기서는 우선순위에 의해 1번 자원을 가지고 있는 애만 2번 자원을 기다림 , 그래서 cycle이 생길 우려가 없음.


### b. Deadlock Avoidance

- 자원 요청에 대한 부가적인 정보를 이용해서 자원 할당이 deadlock으로부터 안전(safe)한지를 동적으로 조사해서 안전한 경우에만 자원을 할당
- 시스템 state가 원래 state로 돌아올 수 있는 경우에만 자원 할당
- 가장 단순하고 일반적인 모델은 프로세스들이 필요로 하는 각 자원별 최대 사용량을 미리 선언하도록 하는 방법임

> prevention과 마찬가지로 deadlock을 미리 방지하는 방법

> 프로세스가 시작될 때, 이 프로세스가 평생에 쓸 자원의 최대량을 미리 알고있다고 가정하고 deadlock을 피해간다.

> 최악의 상황을 가정한다.

- safe state
	- 시스템 내의 프로세스들에 대한 **safe sequence**가 존재하는 상태

- safe sequence
	- 프로세스의 sequence\<P1, P2, ..., Pn\>이 safe하려면 Pi (1 <= i <= n)의 자원 요청이 **가용 자원 + 모든 Pj (j < i)의 보유 자원**에 의해 충족되어야 함
	- 조건을 만족하면 다음 방법으로 모든 프로세스의 수행을 보장
		- Pi의 자원 요청이 즉시 충족될 수 없으면 모든 Pj (j < i)가 종료될 때까지 기다린다.
		- $P_{i-1}$이 종료되면 Pi의 자원요청을 만족시켜 수행한다.

- 시스템이 safe state에 있으면
	- no deadlock
- 시스템이 unsafe state에 있으면
	- possibility of deadlock

![[os_7_5.png]] 

#### 1) Deadlock Avoidance

- 시스템이 unsafe state에 들어가지 않는 것을 보장
- 2가지 경우의 avoidance 알고리즘
	- Single instance per resource types
		- Resource Allocation Graph algorithm 사용
	- Multiple instances per resource types
		- Banker's Algorithm 사용

##### ㄱ) Resource Allocation Graph algorithm

> 자원당 인스턴스가 한개밖에 없는 경우

- Claim edge Pi -> Rj
	- 프로세스Pi가 자원 Rj를 미래에 요청할 수 있음을 뜻함 (점선으로 표시)
	- 프로세스가 해당 자원 요청시 request edge로 바뀜 (실선)
	- Rj가 release되면 assignment edge는 다시 claim edge로 바뀐다.
- request edge의 assignment edge 변경시 (점선을 포함하여) cycle이 생기지 않는 경우에만 요청 자원을 할당한다.
- Cycle 생성 여부 조사시 프로세스의 수가 n일 때 O(n^2) 시간이 걸린다.

![[os_7_6.png]]

- 프로세스 --점선--> 자원
	- 이 프로세스가 평생에 적어도 한번은 이 자원을 사용할 일이 있다는 의미.

##### ㄴ) Banker's Algorithm

> 자원당 인스턴스가 여러개 있는 경우

- 가정
	- 모든 프로세스는 자원의 최대 사용량을 미리 명시
	- 프로세스가 요청 자원을 모두 할당받은 경우 유한 시간 안에 이들 자원을 다시 반납한다.
- 방법
	- 기본 개념
		- 자원 요청시 safe 상태를 유지할 경우에만 할당
	- 총 요청 자원의 수가 가용 자원의 수보다 적은 프로세스를 선택
		- (그런 프로세스가 없으면 unsafe 상태)
	- 그런 프로세스가 있으면 그 프로세스에게 자원을 할당
	- 할당받은 프로세스가 종료되면 모든 자원을 반납
	- 모든 프로세스가 종료될 때까지 이러한 과정 반복

![[os_7_7.png]]

- 전체 자원에서 allocation(할당)된 자원을 빼면 available한 자원들이 나온다.
- Need 테이블
	- 추가 요청 가능량
	- 최대 요청 가능량(Max) - 현재 할당된 자원(allocation) = Need
- P1(프로세스 1번)이 추가 요청을 하면, 1번 프로세스의 Need가 Available(가용자원)으로 모두 충족이 가능한지 본다.
- P0이 B를 2개 요청할때, 만약 Need를 전부 요청할 경우를 생각해서 자원을 줄 수 없으면 자원을 할당하지 않는다.

### c. Deadlock Detection and recovery

- Deadlock 발생은 허용하되 그에 대한 detection 루틴을 두어 deadlock발견시 recover

### d. Deadlock Ignorance

- Deadlock을 시스템이 책임지지 않음
- UNIX를 포함한 대부분의 OS가 채택
	- 운영체제가 느려지면, 사람이 알아서 프로세스를 죽여서 해결함.




# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140408134626290222?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 2, 2021)
