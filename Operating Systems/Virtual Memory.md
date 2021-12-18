> Virtual Memory기법은 운영체제가 물리적인 메모리의 주소변환에 관여한다.
 
# 1. Demand Paging

- 실제로 필요할 때 page를 메모리에 올리는 것 (요청이 있으면, 페이지를 메모리에 올린다.)
	- I/O 양의 감소
	- Memory 사용량 감소
	- 빠른 응답 시간
	- 더 많은 사용자 수용
- Valid / Invalid bit의 사용
	- Invalid의 의미
		- 사용되지 않는 주소 영역인 경우
		- 페이지가 물리적 메모리에 없는 경우
	- 처음에는 모든 page entry가 invalid로 초기화
	- address translation 시에 invalid bit이 set되어 있으면
		- **page fault**

## A. Memory에 없는 Page의 Page Table

![](/bin/OS_image/os_9_1.png)

당장 필요한 부분은 Demand paging에 의해서 물리적인 메모리에 올라가 있는다.

그렇지 않은 부분은 backing store(swap 영역)에 내려가있게 된다.

- Invalid
	- Invalid는 페이지가 물리적인 메모리에 없는 경우를 의미.
		```ad-example

		위 사진에서는 A, C, F가 물리적인 메모리에 있음. B, D, E가 물리적인 메모리에 없고 DISK(Swap Area)에 내려가있음.

		```

	- 이 프로그램이 사용하지 않는 주소 영역이 있을 수 있다.
		- 페이지 테이블의 entry는 주소 공간의 크기만큼 만들어지기 때문에 사용하지 않는 주소 영역은 Invalid로 표시를 한다.
		```ad-example

		위 사진에서는 A~F까지가 프로그램을 구성하는 페이지, G~H는 사용되지 않는 페이지

		```

- Page Fault
	- CPU가 논리적인 주소를 주소변환하려고 페이지 테이블을 봤을 때, Invalid인 경우(해당 페이지가 메모리에 없다는 이야기) 해당 페이지를 DISK에서 메모리로 올려야 한다. 
		- 이건 I/O 작업 (사용자 프로세스가 직접 못함)
	- 주소변환을 하려고 페이지 테이블을 봤을 때, Invalid인 경우를 page fault 현상이라고 말한다.
		- 요청한 페이지가 물리적인 메모리에 없는 경우
	- Page Fault가 발생하면, CPU는 자동으로 운영체제한테 넘어가게 된다. (Page Fault에 Trap이 걸렸다고 이야기한다.)
		- 그럼, 운영체제는 CPU를 가지고 Fault가 발생한 페이지를 메모리에 올리는 작업이 필요하다.

## B. Page Fault

- invalid page를 접근하면 MMU(주소변환을 해주는 하드웨어)가 trap을 발생시킴 (page fault trap)
- Kernel mode로 들어가서 page fault handler가 invoke됨
- 다음과 같은 순서로 page fault를 처리한다.

	1. Invalid reference? (eg. bad address, protection violation) => abort process
	2. Get an empty page frame (빈 페이지가 없으면 뺏어온다. : replace)
	3. 해당 페이지를 disk에서 memory로 읽어온다.
		1. disk I/O가 끝나기까지 이 프로세스는 CPU를 preempt 당함 (block)
		2. Disk read가 끝나면 page tables entry 기록, valid/invalid bit = "valid"
		3. ready queue에 process를 insert -> dispatch later
	4. 이 프로세스가 CPU를 잡고 다시 running
	5. 아까 중단되었던 instruction을 재개

### a. Steps in Handling a Page Fault

![](/bin/OS_image/os_9_2.png)

### b. Free frame이 없는 경우

- Page replacement
	- 어떤 frame을 빼앗아올지 결정해야 함
	- 곧바로 사용되지 않을 page를 쫓아내는 것이 좋음
	- 동일한 페이지가 여러 번 메모리에서 쫓겨났다가 다시 들어올 수 있음
- Replacement Algorithm
	- page-fault rate을 최소화하는 것이 목표
	- 가급적이면 page fault rate가 0에 가깝도록 해주는 것이 이 알고리즘의 목표이다.
	- 알고리즘의 평가
		- 주어진 page reference string에 대해 page fault를 얼마나 내는지 조사
	- reference string의 예
		- 1, 2, 3, 4, 1, 2, 5, 1, 2, 3, 4, 5

![](/bin/OS_image/os_9_3.png)

## C. Performance of Demand Paging

Page fault가 났을때 DISK를 접근하는 것은 대단히 오래걸리는 작업이기 때문에 Page fault가 얼마나 발생하는가에 따라서 메모리에 접근하는 시간이 크게 좌우된다.

> 실제 시스템에서 page fault rate는 0.0xxx로 나옴
> 대부분의 경우는 page fault가 발생하지 않고 메모리로부터 직접 주소변환을 할 수 있다. 하지만 page fault가 발생하면 엄청난 시간이 소요된다.

- Page Fault Rate 0 <= p <= 1.0
	- if p = 0 no page faults
		- page fault가 0이면, 절대 page fault가 발생하지 않고 메모리에서 다 참조가 되는 경우.
	- if p = 1, every reference is a fault
		- page fault가 1이면, 매번 메모리 참조할때마다 page fault가 난다는 것. 
- Effective Access Time
	- 메모리 접근 시간을 page fault까지 고려해서 계산한 것
	- **= (1-p) \* memory access + p `(OS & HW page fault overhead + [swap page out if needed] + swap page in + OS & HW restart overhead)`**

## D. Page Replacement Algorithm

### a. Optimal Algorithm

> 미래에 참조되는 페이지들을 미리 다 안다고 가정한다. 그래서 실제 프로그램에서 사용될 수는 없다.

- MIN (OPT)
	- 가장 먼 미래에 참조되는 page를 replace
- 4 frames example

![](/bin/OS_image/os_9_4.png)

- 미래의 참조를 어떻게 아는가?
	- Offline algorithm
- 다른 알고리즘의 성능에 대한 upper bound 제공
	- Belady's optimal algorithm, MIN, OPT 등으로 불림

### b. FIFO (First In First Out) Algorithm

- FIFO
	- 먼저 들어온 것을 먼저 내쫓음

![](/bin/OS_image/os_9_5.png)

- FIFO Anomaly (Balady's Anomaly)
	- more frames => less page faults
		- 프레임을 증가시키면 오히려 page fault가 많이 발생하여 성능이 안좋아지는 경우가 발생할 수 있다.

### c. LRU (Least Recently Used) Algorithm

> 메모리 관리에서 가장 많이 사용되는 알고리즘

- LRU
	- 가장 오래 전에 참조된 것을 지움

![](/bin/OS_image/os_9_6.png)

### d. LFU (Least Frequently Used) Algorithm

- LFU
	- 참조 횟수(reference count)가 가장 적은 페이지를 지움

---

- 최저 참조 횟수인 page가 여럿 있는 경우
	- LFU 알고리즘 자체에서는 여러 page 중 임의로 선정한다.
	- 성능 향상을 위해 가장 오래 전에 참조된 page를 지우게 구현할 수도 있다.
- 장단점
	- LRU처럼 직전 참조 시점만 보는 것이 아니라 장기적인 시간 규모를 보기 때문에 page의 인기도를 좀 더 정확히 반영할 수 있음
	- 참조 시점의 최근성을 반영하지 못함
	- LRU보다 구현이 복잡함

![](/bin/OS_image/os_9_7.png)

#### 1) LRU와 LFU 알고리즘의 구현

- LRU

	![](/bin/OS_image/os_9_8.png)

	- 참조 시점에 따라서 줄세우기를 한다.
		- 맨 위에 있는 페이지 (LRU page)는 가장 오래전에 참조된 페이지
		- 맨 아래에 있는 페이지 (MRU page)는 가장 최근에 참조된 페이지
	- 더블 링크드 리스트 형태로 운영체제가 페이지들의 참조 시간 순서로 관리한다.

	![](/bin/OS_image/os_9_9.png)
	
	- 어떤 페이지 메모리에 들어오거나, 메모리 안에서 다시 참조가 되면. 해당 페이지는 맨 아래로 보내면 된다.
	- replacement(교체)되면 제일 위에 있는 페이지를 교체하면 된다.

	> 이런식으로 교체하면, `O(1) complextity`

- LFU

	![](/bin/OS_image/os_9_10.png)
	
	- LRU와 비슷하게 한줄로 줄세워서 비교할 수 있다.
		- 맨 위에 있는 페이지 (LFU page)는 가장 참조 횟수가 적은 페이지
		- 맨 아래에 있는 페이지 (MFU page)는 참조 횟수가 가장 많은 페이지

	![](/bin/OS_image/os_9_11.png)
	
	- 어떤 페이지가 참조됬을때, 그 페이지를 맨 아래로 내릴 수 없다.
		- `현재 참조 횟수 + 1`이 참조 횟수가 가장 많은 페이지보다 크다고 볼 수 없기 때문.
	- 따라서, 다음 페이지와 참조 횟수를 비교해서 내려가야한다.

	> `O(n) complexity`

	![](/bin/OS_image/os_9_12.png)
	
	![](/bin/OS_image/os_9_13.png)
	
	![](/bin/OS_image/os_9_14.png)
	
	- 힙을 이용해서 구현한다.
		- 맨 위에 참조 횟수가 적은 페이지를 두고 (최소힙) 밑으로 갈수록 참조 횟수가 많은 페이지를 둔다.
		- 쫒아낼때(replacement)는 root에 있는 노드를 쫒아내고 힙을 재구성하면 된다.

	> `O(logn) complexity`

# 2. 다양한 캐슁 환경

- 캐슁 기법
	- 한정된 빠른 공간(캐쉬)에 요청된 데이터를 저장해 두었다가 후속 요청시 캐쉬로부터 직접 서비스하는 방식
	- paging system 외에도 cache memory, buffer caching, Web caching 등 다양한 분야에서 사용
		- 단일 시스템에서 저장 매채들 간의 속도 차이가 나서 캐슁을 하는 것
			- paging system에서 느린 공간이 disk의 swap area
			- buffer caching에서 느린 공간이 disk의 file system
		- 서로 다른 시스템에서 데이터를 읽어오는데 시간이 오래걸려서 캐슁하는 것
			- web caching은 웹 서버에서 이전에 읽어온 데이터를 다시 요청할 때, cache에 저장해두었다가 보여줘서 더 빠름.
- 캐쉬 운영의 시간 제약
	- 교체 알고리즘에서 삭제할 항목을 결정하는 일에 지나치게 많은 시간이 걸리는 경우 실제 시스템에서 사용할 수 없음
	- Buffer caching이나 Web caching의 경우
		- O(1)에서 O(logn) 정도까지 허용
	- Paging system인 경우
		- page fault인 경우에만 OS가 관여함
		- 페이지가 이미 메모리에 존재하는 경우 참조시각 등의 정보를 OS가 알 수 없음
		- O(1)인 LRU의 list 조작조차 불가능

## A. Paging System에서 LRU, LFU 가능한가?

![](/bin/OS_image/os_9_15.png)

일반적으로 Process A가 CPU 제어권을 가지고 있을때, Process A의 논리적 메모리(logical memory)에서 인스트럭션을 하나씩 읽어와서 실행한다. CPU에서 Process A의 논리적 주소를 주면 page table을 통해서 물리적 메모리 주소로 변환해서 물리적 메모리에 있는 내용을 CPU로 읽어들인다. 
 
위 그림에서 Process A의 page table에 valid인 경우에는 OS가 호출되지 않는다(이 과정들은 하드웨어적으로 처리된다). invalid인 경우에는 page fault이기 때문에 backing store에 접근해야하기 한다. page fault가 발생하면 디스크 접근(I/O)을 필요로하기 때문에 trap(page fault trap)이 발생하여 CPU의 제어권이 Process A에서 OS로 넘어간다. 그리고 물리적 메모리(physical memory)가 가득 찻다면 운영체제의 페이징 교체 알고리즘이 동작해야한다.

그런데 여기서 OS는 어떤 페이지가 가장 최근에 접근했는지(LRU), 어떤 페이지가 가장 적은 빈도로 참조되었는지(LFU) 알 수 있을까?

> 알 수 없다.

Process A가 요청한 페이지가 이미 물리적인 메모리에 올라와있다면 OS에 CPU 제어권이 넘어가지 않는다(하드웨어적으로 주소변환이 이루어져서 CPU로 읽어들임). 그래서 페이지의 접근 시간, 참조 빈도를 운영체제(OS)는 모르게 된다.

page fault가 발생하면(CPU 제어권이 운영체제에 넘어오면), 운영체제는 디스크에 있던 페이지가 물리적 메모리로 올라온 시간을 알 수 있다.

이렇게, paging system에서는 운영체제한테 정보가 절반밖에 주어지지 않는다.

즉, LRU, LFU 같은 알고리즘은 Paging System(Virtual Memory System)에서는 사용할 수 없다.

그래서 아래와 같은 알고리즘을 사용한다.

### a. Clock Algorithm

> virtual memory (paging system)에서 일반적으로 사용하는 알고리즘이다.

- LRU의 근사(approximation) 알고리즘
- 여러 명칭으로 불림
	- Second chance algorithm
	- NUR (Not Used Recently) 또는 NRU (Not Recently Used)
		- 운영체제는 가장 오래전에 참조된 페이지가 어떤것인지 모른다. 따라서 최근에 참조되지 않은 페이지를 쫒아낸다.
- Reference bit을 사용해서 교체 대상 페이지 선정 (circular list)
- reference bit가 0인 것을 찾을 때까지 포인터를 하나씩 앞으로 이동
- 포인터 이동하는 중에 reference bit 1은 모두 0으로 바꿈
- Reference bit이 0인 것을 찾으면 그 페이지를 교체
- 한 바퀴 되돌아와서도 (=second chance) 0이면 그때에는 replace 당함
- 자주 사용되는 페이지라면 second chance가 올 때 1

![](/bin/OS_image/os_9_16.png)

각각의 사각형이 page frame (물리적인 메모리 안에 들어있는 페이지들)

어떤 페이지가 참조가되어 CPU가 그 페이지를 사용하게되면 하드웨어가 그 페이지의 reference bit을 1로 셋팅한다. -> 페이지가 현재 참조되면 그 페이지의 reference bit을 1로 셋팅해서 페이지가 참조되었다는 것을 표시한다. (이것은 운영체제가 하는 일이 아니고 하드웨어가 하는 일이다.)

만약 page fault가 발생하여 운영체제가 어떤 페이지를 쫒아내야한다면, 하드웨어가 셋팅해 놓은 reference bit을 참조한다. reference bit이 1이라면 0으로 바꾸고 그 다음 페이지를 본다. 만약 reference bit이 0이라면 해당 페이지를 쫓아낸다(교체한다).

reference bit이 0이라는 의미는 시계바늘이 한 바퀴 도는 동안에 이 페이지에 대한 참조가 없었다는 의미이다. reference bit이 1이라는 것은 시계바늘이 한 바퀴 도는 동안에 적어도 한번은 참조가 있었다는 의미이다.

하드웨어는 페이지를 참조할때 reference bit을 1로 만든다. OS(운영체제)는 하드웨어가 셋팅해둔 reference bit을 보면서 1이면 0으로 만들고 다음 페이지를 보고, 0이면 해당 페이지를 교체한다.

reference bit이 0인 것을 교체하기 때문에 가장 오래전에 참조된 페이지를 교체하는 것은 아니다. 따라서 완벽한 LRU는 아니지만, 시계 바늘이 한 바퀴 도는 동안에 참조가 안 된 페이지를 교체하는(오랫동안 참조가 안된 페이지를 교체) 것이라서 어느정도 LRU와 비슷한 효과를 냄.

#### 1) Clock algorithm의 개선

- reference bit과 modified bit (dirty bit)을 함께 사용
- reference bit = 1
	- 최근에 참조된 페이지
- modified bit = 1
	- 최근에 변경된 페이지 (I/O를 동반하는 페이지)
	- 어떤 페이지가 메모리에서 write가 발생하면, 하드웨어가 modified bit을 1로 셋팅한다.

어떤 페이지의 reference bit이 0이라서 해당 페이지를 쫒아내야할 때, modified bit이 0이면 해당 페이지는 write가 발생하지 않았기 때문에 backing store와 동일할 것이다. 그래서 메모리에서 쫒아내기만 하면 된다.

modified bit이 1이라면, 그 페이지는 메모리에 올라온 이후로 변경이 된 것이다. 이때 교체를 위해서는 backing store에 수정된 내용을 반영을 하고 지워야한다.

modified bit이 0인 페이지만 교체한다면, 변경된 내용을 disk에 반영하지 않아도 되기 때문에 더 빠르게 실행할 수 있다.

# 3. Page Frame의 Allocation

> 어떤 프로그램이 page fault가 잘 발생하지 않아서(원활하게 실행되기 위해서는) 이 프로그램이 실행될 때 일련의 페이지들이 메모리에 같이 올라와있어야 한다.

> 프로그램별로 page allocation을 해주지 않으면, memory에서 특정 프로그램이 페이지 프레임들을 장악해버리는 경우도 발생할 수 있다.

> allocation은 각각의 프로그램한테 어느 정도의 메모리 크기를 나누어주자는 것.

- Allocation problem
	- 각 process에 얼마만큼의 page frame을 할당할 것인가?
- Allocation의 필요성
	- 메모리 참조 명령어 수행시 명령어, 데이터 등 여러 페이지 동시 참조
		- 명령어 수행을 위해 최소한 할당되어야 하는 frame의 수가 있음
	- Loop를 구성하는 page들은 한꺼번에 allocate 되는 것이 유리함
		- 최소한의 allocation이 없으면 매 loop마다 page fault
		- 프로그램마다 적어도 몇개의 페이지는 줘야지 page fault가 잘 안나는 페이지 갯수가 존재한다.
		```ad-example

		for문을 반복할때, for문을 구성하는 페이지가 3개라고하면. 이 프로그램한테 3개의 페이지를 주면 for문을 반복하는 동안에 page fault가 발생하지 않는다.
		
		그런데 이 프로그램한테 2개의 페이지를 주면 for문을 반복하는 동안 page fault가 계속 발생하여 효율적이지 못하게된다.

		```

---

- Allocation Scheme
	- Equal allocation
		- 모든 프로세스에 똑같은 갯수 할당
	- Proportional allocation
		- 프로세스 크기에 비례하여 할당
	- Priority allocation
		- 프로세스의 priority에 따라 다르게 할당

# 4. Global vs Local Replacement

## A. Global replacement

> 다른 프로그램의 페이지도 쫒아낼 수 있는 방법

- Replace시 다른 process에 할당된 frame을 빼앗아 올 수 있다.
- Process별 할당량을 조절하는 또 다른 방법임
- FIFO, LRU, LFU 등의 알고리즘을 global replacement로 사용시에 해당
- Working set, PFF 알고리즘 사용

## B. Local replacement

> 자신에게 할당된 페이지만 쫒아냄

- 자신에게 할당된 frame 내에서만 replacement
- FIFO, LRU, LFU 등의 알고리즘을 process별로 운영시

# 5. Thrashing

> 어떤 프로그램한테 최소 메모리만큼 할당이 되지 않았을 때는 page fault가 자주 발생한다고 했다.
> 프로그램한테 메모리가 너무 적게 할당되어, page fault가 지나치게 자주 일어나는 (전체 시스템에서 page fault가 빈번히 일어나는) 상황을 Thrashing이라고 부른다.

> 어떤 프로세스가 CPU를 잡더라도 거의 무조건 page fault가 발생하고, 그러면 메모리에서 페이지를 쫒아내고 새로운 페이지를 올리는 작업을 하느라 시간이 다 가고 CPU는 할 일이 없어서 한가한 상태가 된다.

- 프로세스의 원할한 수행에 필요한 최소한의 page frame 수를 할당 받지 못한 경우 발생
- Page fault rate이 매우 높아짐
- CPU utilization이 낮아짐
- OS는 MPD (Multiprogramming degree)를 높여야 한다고 판단
- 또 다른 프로세스가 시스템에 추가됨 (higher MPD)
- 프로세스 당 할당된 frame의 수가 더욱 감소
- 프로세스는 page의 swap in / swap out으로 매우 바쁨
- 대부분의 시간에 CPU는 한가함
- low throughput

![](/bin/OS_image/os_9_17.png)

x축은 지금 메모리에 올라와있는 프로그램의 개수

> 즉, 메모리에 동시에 올라가있는 프로그램의 개수에 따라서 CPU 이용률은 어떻게 되는가?

> 메모리에 너무 많은 페이지를 가지고 있게 되면, 즉 MPD(Multiprogramming Degree)가 너무 높아지면 CPU Utilization이 뚝 떨어져서 시스템이 굉장히 비효율적인 상황이 된다.

이것을 막기 위해서는 Multiprogramming Degree(동시에 메모리에 올라가있는 프로세스의 개수)를 조절해줘야한다. 이렇게 함으로써 프로그램이 적어도 어느 정도는 메모리를 확보할 수 있도록 해줘야 한다.

이것을 해주는 알고리즘이 Working set Algorithm, PFF(Page Fault Frequency) Algorithm이다.

## A. Working-Set Model

> 프로그램들이 메모리에서 원활하게 실행되기 위해서는 어느 정도의 메모리 페이지는 가지고 있어야 한다.
> 프로그램들이 특정 시간에는 특정 메모리 위치만 집중적으로 참조하는 특징을 가지고 있다. (reference의 locality라고 부름)
> > (Loop, 함수)가 실행되고 있으면, (Loop, 함수)가 실행되는 동안에는 그 Loop를 구성하는 페이지만 집중적으로 참조가 된다.

- Locality of reference
	- 프로세스는 특정 시간 동안 일정 장소만을 집중적으로 참조한다.
	- 집중적으로 참조되는 해당 page들의 집합을 locality set이라 함.
		- Working set 알고리즘에서는 이러한 locality set을 working set이라고 부른다.

---

> Working set
> > 어떤 프로그램이 실행되면서, 그 순간에 메모리에 꼭 올라와 있어야 하는(빈번히 참조되는) 페이지들의 집합

Working set은 적어도 메모리에 한꺼번에 올라와있도록 보장해주는 기법이 있어야지만 page fault가 잘 안난다.

Multiprogramming Degree가 너무 높아지면(메모리에 너무 많은 프로그램들이 올라가 있으면) Working set을 메모리에 보장할 수 없는 상태가 발생한다.

```ad-example

이 프로그램의 Working set은 페이지 5개로 구성되는데, 페이지를 3개밖에 줄 수 없으면.

지금 가지고 있는 페이지 3개를 전부 반납하고 페이지 5개를 받을 수 있을때까지 기다린다.

```

위 예제처럼 thrashing을 방지하고 Multiprogramming Degree를 조절한다.

---

- Working-set Model
	- Locality에 기반하여 프로세스가 일정 시간 동안 원활하게 수행되기 위해 한꺼번에 메모리에 올라와 있어야 하는 page들의 집합을 Working Set이라 정의함
	- Working Set 모델에서는 process의 working set 전체가 메모리에 올라와 있어야 수행되고 그렇지 않을 경우 모든 frame을 반납한 후 swap out (suspend)
	- Thrashing을 방지함
	- Multiprogramming degree를 결정함

### a. Working-Set Algorithm

> Working set은 미리 알 수 없다. 따라서 과거를 통해 Working set을 추정한다.

> 현재부터 과거 Window 크기($\Delta$) 이내에 들어오는 페이지들을 Working Set 으로 간주해서 그 페이지들은 메모리에 유지를 시킨다.

이 프로그램이 과거 $\Delta$ 시간 동안 참조된 페이지들을 Working set이라고 간주해서 메모리에서 쫒아내지 않고 유지한다. 이 $\Delta$ 시간을 Window라고 부른다.

- Working set의 결정
	- Working set window를 통해 알아냄
	- window size가 $\Delta$인 경우
		- 시각 $t_i$에서의 working set WS ($t_i$)
			- Time interval \[$t_i - \Delta$, $t_i$ \] 사이에 참조된 서로 다른 페이지들의 집합
		- Working set에 속한 page는 메모리에 유지, 속하지 않은 것은 버림
			- (즉, 참조된 후 $\Delta$ 시간 동안 해당 page를 메모리에 유지한 후 버림)

![](/bin/OS_image/os_9_18.png)

window를 10으로 하면, 현재 시점부터 과거 10번째 참조된 페이지까지는 이 프로그램의 Working set이기 때문에 메모리에 올려놔야 한다. 반복되는 페이지의 중복을 제거하면 {1, 2, 5, 6, 7}이 현재 시점에서 이 프로그램의 Working Set이기 때문에 Working Set 알고리즘은 이 프로그램에게 5개의 페이지 프레임을 줄 수 있으면 {1, 2, 5, 6, 7}을 메모리에 올려두고. 

만약 메모리 공간이 부족해서 5개를 못주면, 전부 다 DISK로 swap out 시키고 이 프로그램은 suspend 상태로 바뀐다.

이 Working Set의 크기가 그때 그때 바뀐다.

뒤에 Working Set이 {3, 4}이면 그 시점에는 프로그램한테 2개의 페이지만 할당해주면 Working Set을 만족한다.

---

- Working-Set Algorithm
	- Process들의 working set size의 합이 page frame의 수보다 큰 경우
		- 일부 process를 swap out시켜 남은 process의 working set을 우선적으로 충족시켜 준다 (MPD를 줄임)
	- Working set을 다 할당하고도 page frame이 남는 경우
		- Swap out되었던 프로세스에게 working set을 할당 (MPD를 키움)

---

- Window size $\Delta$
	- Working set을 제대로 탐지하기 위해서는 window size를 잘 결정해야 함
	- $\Delta$ 값이 너무 작으면 locality set을 모두 수용하지 못할 우려
	- $\Delta$ 값이 크면 여러 규모의 locality set 수용
	- $\Delta$ 값이 $\infty$이면 전체 프로그램을 구성하는 page를 working set으로 간주

## B. PFF (Page-Fault Frequency) Scheme

> Multiprogramming Degree를 조절하면서 Thrashing을 조절하는 알고리즘

> Working Set 알고리즘처럼 Working Set을 추정하는 것이 아닌, 직접 Page Fault rate를 보는 방법이다. 

> 현재 시점에 이 시스템에서 page fault가 얼마나 나는지를 보고, 특정 프로그램이 page fault를 얼마나 내는지를 본다. 만약에 그 프로그램이 page fault를 많이 발생시키면(이 프로그램의 Working Set은 메모리에 다 보장되지 않은 상태이기 때문에) 페이지를 더 준다.

일반적으로 프로그램한테 할당되는 메모리의 크기가 커지게 되면 page fault rate는 줄어든다. 

> 반대로 어떤 프로그램은 page fault가 너무 발생하지 않을 수도 있다. 그럼 그 프로그램은 쓸데없이 페이지(메모리)를 너무 많이 가지고 있는 상태일 것이다. 그래서 그 프로그램으로부터 메모리를 빼앗아서 일정 수준의 page fault를 유지하게 하는 것.

만약에 page fault rate가 빈번해서 메모리를 더 줘야하는데, 더 줄 메모리가 없다면 그 프로그램을 통째로 swap out 시켜서 메모리에 남아있는 프로그램이라도 page fault rate가 일정 수준 이하로 유지되도록 하여 thrashing을 방지한다.

![](/bin/OS_image/os_9_19.png)

- page-fault rate의 상한값과 하한값을 둔다
	- Page fault rate이 상한값을 넘으면 frame을 더 할당한다
	- Page fault rate이 하한값 이하이면 할당 frame 수를 줄인다.
- 빈 frame이 없으면 일부 프로세스를 swap out

# 6. Page Size의 결정

> 메모리 크기가 커지면 (32bit -> 64bit) 페이지 사이즈도 키워줄 필요가 있다. 최근에는 큰 페이지 크기를 가지는 (4k보다 큰) 대용량 페이지를 사용하는 메모리 시스템에 대한 이야기도 나오고 있다.

- Page size를 감소시키면
	- 페이지 수 증가
	- 페이지 테이블 크기 증가
	- Internal fragmentation 감소
		- 내부 단편화가 줄어들기 때문에 더 효율적일 수도 있다.
	- Disk transfer의 효율성 감소
		- Seek/rotation vs transfer
	- 필요한 정보만 메모리에 올라와 메모리 이용이 효율적
		- Locality의 활용 측면에서는 좋지 않음

> page size를 감소시키면, 그때그때마다 page fault가 발생하고, disk head가 이동해야하는(seek) 시간이 길어져서 비효율적이 될 수 있다.

---

- Trend
	- Larger page size
	- 최근에는 page size를 키워주는 것이 추세이다.

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140408134626290222?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 2, 2021)
