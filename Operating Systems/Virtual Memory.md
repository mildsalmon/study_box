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
- 캐쉬 운영의 시간 제약
	- 교체 알고리즘에서 삭제할 항목을 결정하는 일에 지나치게 많은 시간이 걸리는 경우 실제 시스템에서 사용할 수 없음
	- Buffer caching이나 Web caching의 경우
		- O(1)에서 O(logn) 정도까지 허용
	- Paging system인 경우
		- page fault인 경우에만 OS가 관여함
		- 페이지가 이미 메모리에 존재하는 경우 참조시각 등의 정보를 OS가 알 수 없음
		- O(1)인 LRU의 list 조작조차 불가능

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140408134626290222?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 2, 2021)
