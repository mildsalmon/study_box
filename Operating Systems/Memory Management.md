# 1. Logical vs. Physical Address

- 주소 바인딩
	- 주소를 결정하는 것

Symbolic Address -> Logical Address --(이 시점이 언제인가?(next page))--> Physical address

- Symbolic Address
	- 프로그래머가 프로그램을 만들때는 메모리 주소(숫자 주소)를 가지고 프로그래밍을 하지는 않는다. 메모리의 특정 위치에 변수값을 저장하지만 메모리 주소를 지정하는 것이 아닌, 변수 이름을 주고 저장한다. 이때, 숫자로된 주소를 사용하지 않고 심볼로 된 주소를 사용한다.

## A. Logical address (=virtual address)

- 프로세스마다 독립적으로 가지는 주소 공간
- 각 프로세스마다 0번지부터 시작
- CPU가 보는 주소는 logical address임
	- 메모리에 올라갈때, 시작 위치는 바뀌지만 그 안에 있는 코드 상의 주소는 logical address로 남아있다.

> CPU가 메모리 몇 번지에 있는 내용을 달라고 요청하면, 그때 주소변환을 해서 물리적인 메모리 위치를 찾은 다음에 그 내용을 읽어서 CPU한테 전달한다.

## B. Physical address

- 메모리에 실제 올라가는 위치
- 아래부분에는 운영체제 커널, 상위 주소에는 여러 프로그램들이 섞여서 올라가있다.
 
# 2. 주소 바인딩 (Address Binding)

## A. Compile time Binding

> 컴파일시 바인딩

- 물리적 메모리 주소(physical address)가 컴파일 시 알려짐
- 시작 위치 변경시 재컴파일
- 컴파일러는 절대 코드(absolute cod) 생성

## B. Load time binding

> 실행이 시작될 때 바인딩

- Loader의 책임하에 물리적 메모리 주소 부여
- 컴파일러가 재배치가능코드(relocatable code)를 생성한 경우 가능

## C. Execution time binding (=Run time binding)

> 프로그램이 시작된 이후에도 실행하다가 중간에 물리적인 메모리 주소가 바뀔 수 있는 방법

- 수행이 시작된 이후에도 프로세스의 메모리 상 위치를 옮길 수 있음
- CPU가 주소를 참조할 때마다 binding을 점검 (address mapping table)
- 하드웨어적인 지원이 필요
	- e.g. base and limit registers, MMU

---

![[os_8_1.png]]

> CPU가 바라보는 주소도 Logical Address일 수밖에 없다.

- Symbolic address가 숫자로된 주소로 바뀐다.
	- 그 주소는 프로그램마다 가지는 주소이기 때문에 Logical address가 되는 것이다.
- 실행이 되려면 물리적 메모리에 올라가야한다.
	- 물리적인 메모리의 주소가 결정되는 것을 주소 바인딩이라고 부른다.
		- 물리적인 주소가 결정되는 시점
			- Compile time binding
				- 컴파일 시점에 이미 물리적인 주소가 결정되는 것
				- 프로그램을 물리적인 메모리에 올릴 때에는 이미 결정되어 있는 Logical address로 올려야한다.
				- **비효율적**, **지금의 컴퓨터 시스템에서는 사용하지 않는다.**
			- Load time binding
				- 프로그램이 시작되서 메모리에 올라갈 때, 물리적인 메모리 주소가 결정된다.
				- compile time에는 논리적인 주소까지만 결정됨, 
					- 실행시키게되면 물리적인 주소의 빈 공간에 올린다.
			- Run time binding
				- Load time binding처럼 실행시에 주소가 결정된다.
				- 주소가 실행 도중에 바뀔 수 있다.
				- **요즘의 컴퓨터**
				- CPU가 메모리를 요청할때마다 바인딩을 체크해야함.

### a. Memory-Management Unit (MMU)

> 주소변환을 지원해주는 하드웨어

- logical address를 physical address로 매핑해주는 Hardware device

#### ㄱ) MMU Scheme

- 사용자 프로세스가 CPU에서 수행되며 생성해내는 모든 주소값에 대해 base register (=relocation register)의 값을 더한다.
- 레지스터 두개를 이용한 간단한 MMU Scheme

##### 1) Dynamic Relocation

![[os_8_2.png]]

- 왼쪽 아래는 P1의 Logical Address
- CPU가 346번지를 달라고 했다면, process P1의 주소공간에서 0번지부터 346번지 떨어져있는 내용을 CPU가 요청한 상황이다.
- process P1이 physical memory 상에는 14000번지부터 올라가있는 상황임.

> 주소변환은 어떻게 해주는가?

- 프로그램이 물리적인 주소에 올라가있는 시작위치(14000)와 logical address(346)을 더해주면 된다.
	- 14000번지가 논리적인 주소 0번지이기 때문.
- 그래서, MMU Scheme에서는 base register(relocation register)에다가 프로그램(process P1)의 시작위치(14000)를 저장한다.
	- 주소변환을 할때는 논리주소(logical address)에 시작위치(base register)를 더해서 물리주소(physical address)인 14346을 얻게된다.

> 한가지 더 체크하는 방법 (limit register를 사용하는 방법)

- limit register는 프로그램(process P1)의 최대 크기(3000)를 가진다.
- 만약, 이 프로그램이 악성 프로그램이어서 최대 크기가 3000임에도 불구하고 중간에 4000번지에 있는 내용을 달라고 할 수 있기 때문.
	- 그러면 프로그램(process P1) 바깥에 존재하는 다른 프로그램의 메모리 위치를 요청할 수 있게된다.

##### 2) Hardware Support for Address Translation

![[os_8_3.png]]

```
- CPU가 메모리 몇 번지의 주소를 달라고 요청하면, 혹시 이 논리 주소가 프로그램의 크기보다 큰 논리 주소를 요청한 것은 아닌지 확인한다.
	- 만약, 크다면 trap이 걸린다.
		- trap이 걸리면, 이 프로그램이 CPU를 잡고 있었지만, 하던일을 잠시 멈추고 CPU제어권이 운영체제한테 넘어가게된다.
		- 이 경우 프로그램을 강제로 abort시킨다.
	- 작다면, base register의 값을 더해서 주소변환을 한 다음 physical address(물리적 메모리) 어딘가에 있는 내용을 읽어다가 CPU한테 전달해준다.

```

운영체제 및 사용자 프로세스 간의 메모리 보호를 위해 사용하는 레지스터

- Relocation register (=base register)
	- 접근할 수 있는 물리적 메모리 주소의 최소값
- Limit register
	- 논리적 주소의 범위

#### ㄴ) user program

- logical address만을 다룬다
- 실제 physical address를 볼 수 없으며 알 필요가 없다.

# 3. Some Terminologies

## A. Dynamic Loading

> Loading : 메모리로 올리는 것

> 원래 dynamic loading
> > 프로그래머가 명시적으로 dynamic loading해서 이루어지는 것
>
> 요즘 dynamic loading
> > 프로그래머가 명시하지 않고 운영체제가 알아서 올려놓고 쫒아내는 것도 dynamic loading이라고 섞어서 쓰기도 한다.

- 프로세스 전체를 메모리에 미리 다 올리는 것이 아니라 해당 루틴이 불려질 떄 메로리에 load하는 것
- memory utilization의 향상
- 가끔씩 사용되는 많은 양의 코드의 경우 유용
	- 예) 오류 처리 루틴
		- 이런 상황이 생기면, 그때 메모리에 올려서 처리한다.
- 운영체제의 특별한 지원없이 프로그램 자체에서 구현 가능
	- **OS는 라이브러리를 통해 지원 가능**

## B. Dynamic Linking

- Linking을 실행 시간(execution time)까지 미루는 기법

> 프로그램을 작성한 다음에 컴파일하고 링크해서 실행파일을 만든다.
> 링킹이라는 것은 여러군데 존재하는 컴파일된 파일들을 묶어서 하나의 실해파일을 만드는 과정
> > 소스 코드 파일을 따로 코딩을 해서 링킹하기도하고 또는 내가 작성하지 않은 코드(라이브러리)를 불러서 사용할 때 링킹을 통해 실행파일이 만들어진다. -> 내 코드 안에 라이브러리 코드가 포함이 되는 개념.

- Static linking
	- 라이브러리가 프로그램의 실행 파일 코드에 포함됨
	- 실행 파일의 크기가 커짐
	- 동일한 라이브러리를 각각의 프로세스가 메모리에 올리므로 메모리 낭비
		- e.g. printf 함수의 라이브러리 코드
- Dynamic linking
	- 라이브러리가 실행시 연결(link)됨
		- 내 코드 안에 실행파일을 만들 때 라이브러리를 포함시키는 것이 아닌, 실행 파일에는 라이브러리가 별도의 파일로 존재하고 그 라이브러리가 어디에 있는지 찾을 수 있는 작은 코드(stub)만 내 실행 파일에 두고 라이브러리 자체는 포함을 시키지 않는다.
	- 라이브러리 호출 부분에 라이브러리 루틴의 위치를 찾기 위한 stub이라는 작은 코드를 둠
	- 라이브러리가 이미 메모리에 있으면 그 루틴의 주소로 가고 없으면 디스크에서 읽어옴
	- 운영체제의 도움이 필요
	- dynamic linking을 해주는 라이브러리를 shared library(리눅스에서는 shared object, 윈도우에서는 DLL)라고 부른다.

## C. Overlays

- 메모리에 프로세스의 부분 중 실제 필요한 정보만을 올림
- 프로세스의 크기가 메모리보다 클 때 유용
- **운영체제의 지원없이 사용자에 의해 구현**
- 작은 공간의 메모리를 사용하던 초창기 시스템에서 수작업으로 프로그래머가 구현
	- **Manual Overlay**
	- 프로그래밍이 매우 복잡

## D. Swapping

### a. Swapping

> 프로세스를 메모리에서 하드디스크로 통째로 쫒아내는 것

- 프로세스를 일시적으로 메모리에서 **backing store**로 쫓아내는 것

> backing store

- 하드디스크같이 메모리에서 쫒겨난 것을 저장하는 곳을 backing store(=swap area)라고 한다. 

### b. Backing store (=swap area)

- 디스크
	- 많은 사용자의 프로세스 이미지를 담을 만큼 충분히 빠르고 큰 저장 공간

### c. Swap in / Swap out

> 메모리에 너무 많은 프로그램이 올라와있으면, 시스템이 굉장히 비효율적이 되기 때문에 중기 스케줄러가 일부 프로그램을 골라서 통째로 메모리에서 디스크로 쫓아내는 일을 한다.

- 일반적으로 중기 스케줄러(swapper)에 의해 swap out 시킬 프로세스 선정
- priority-based CPU scheduling algorithm
	- priority가 낮은 프로세스를 swapped out 시킴
	- priority가 높은 프로세스를 메모리에 올려 놓음
- Compile time 혹은 load time binding에서는 원래 메모리 위치로 swap in해야 함
- Execution time binding에서는 추후 빈 메모리 영역 아무 곳에나 올릴 수 있음
- swap time은 대부분 transfer time (swap되는 데이터의 양에 비례하는 시간, 전송시간)임

![[os_8_4.png]]

- Swap Out
	- 메모리에서 통째로 쫒겨나서 backing store(하드디스크)로 내려가는 것
- Swap in
	- backing store로 쫒겨났던 것이 메모리로 다시 올라오는 것

> Swapping이 효율적으로 진행되려면?

- Compile time binding이나 Load time binding일때는 이전에 할당받은 주소로 다시 올라가야하기 때문에 swapping의 효과를 발휘하기 어렵다.
- swapping이 효율적으로 동작하려면 run time binding이 지원되어야 한다.
	- 300번지부터 올라와있던 프로그램이 swap out을 당해서 쫓겨났으면, 나중에 다시 메모리에 올라올 때 다른 위치(700번지)로도 비어있다면 올라갈 수 있게 해준다.

![[os_8_5.png]]

# 4. Allocation of Physical Memory

- 메모리는 일반적으로 두 영역으로 나뉘어 사용
	- OS 상주 영역
		- interrupt vector와 함께 낮은 주소 영역 사용
	- 사용자 프로세스 영역
		- 높은 주소 영역 사용

![[os_8_6.png]]

- 사용자 프로세스 영역의 할당 방법
	- Contiguous allocation (연속 할당)
		- 각각의 프로세스가 메모리의 연속적인 공간에 적재되도록 하는 것
		- 프로그램이 메모리에 올라갈때, 통째로 올라가는 방법
			- Fixed partition allocation
			- Variable partition allocation
	- Noncontiguous allocation (불연속 할당)
		- 하나의 프로세스가 메모리의 여러 영역에 분산되어 올라갈 수 있음
		- 프로그램을 구성하는 주소 공간을 잘게 쪼개서 나눠서 올라가있는 방법
			- Paging
			- Segmentation
			- Paged Segmentation

## A. Contiguous Allocation (연속 할당)

![[os_8_7.png]]

### a. Fixed partition (고정분할) 방식

> 프로그램이 들어갈 사용자 메모리 공간을 미리 partition으로 나눠놓는 것

> 위에서는 사용자 프로그램이 들어갈 물리적인 메모리를 분할 4개로 미리 나눠놓음. (분할의 크기는 균일하거나 가변적으로 만들 수 있다.)

- 물리적 메모리를 몇 개의 영구적 분할(partition)로 나눔
- 분할의 크기가 모두 동일한 방식과 서로 다른 방식이 존재
- 분할당 하나의 프로그램 적재
- 융통성이 없음
	- 동시에 메모리에 load되는 프로그램의 수가 고정됨
	- 최대 수행 가능 프로그램 크기 제한
- Internal fragmentation 발생 (external fragmentation도 발생)
	- 외부 조각(외부 단편화, External fragmentation)
		- 프로그램의 크기보다 분할의 크기가 작아서 발생
	- 내부 조각(내부 단편화, Internal fragmentation)
		- 분할의 크기보다 프로그램의 크기가 작아서 발생

### b.  Variable partition (가변분할) 방식

> 사용자 프로그램이 들어갈 영역을 미리 나눠놓지 않는 것

- 프로그램의 크기를 고려해서 할당
- 분할의 크기, 개수가 동적으로 변함
- 기술적 관리 기법 필요
- External fragmentation 발생

#### 1) External fragmentation (외부 조각)

- **프로그램 크기보다 분할의 크기가 작은 경우**
- 프로그램의 크기가 분할의 크기보다 클때
- 아무 프로그램에도 배정되지 않은 빈 곳인데도 프로그램이 올라갈 수 없는 작은 분할

#### 2) Internal fragmentation (내부 조각)

- **프로그램 크기보다 분할의 크기가 큰 경우**
- 프로그램의 크기가 분할의 크기보다 작을때
- 하나의 분할 내부에서 발생하는 사용되지 않는 메모리 조각
- 특정 프로그램에 배정되었지만 사용되지 않는 공간

### c. Hole

- 가용 메모리 공간
- 다양한 크기의 hole들이 메모리 여러 곳에 흩어져 있음
- 프로세스가 도착하면 수용가능한 hole을 할당
- 운영체제는 다음의 정보를 유지
	1. 할당 공간
	2. 가용 공간 (hole)

![[os_8_8.png]]

#### 1) Dynamic Storage-Allocation Problem (Dynamic Memory-Allocation Problem)

> 가변 분할 방식에서 size n인 요청을 만족하는 가장 적절한 hole을 찾는 문제

> First-fit과 best-fit이 worst-fit보다 속도와 공간 이용률 측면에서 효과적인 것으로 알려짐 (실험적인 결과)

##### ㄱ) First-fit

- Size가 n 이상인 것 중 최초로 찾아지는 hole에 할당

##### ㄴ) Best-fit

- Size가 n 이상인 가장 작은 hole을 찾아서 할당
- Hole들의 리스트가 크기순으로 정렬되지 않은 경우 모든 hole의 리스트를 탐색해야함.
- 많은 수의 아주 작은 hole들이 생성됨

##### ㄷ) Worst-fit

- 가장 큰 hole에 할당
- 모든 리스트를 탐색해야 함
- 상대적으로 아주 큰 hole들이 생성됨

#### 2) compaction (압축)

> 실행중인 메모리를 한군데로 모는 방법이기 때문에 쉽지 않은 작업임

> 한쪽으로 모두 모는 방법
> 최소 비용만큼만 한쪽으로 모는 방법

- external fragmentation 문제를 해결하는 한 가지 방법
- 사용 중인 메모리 영역을 한군데로 몰고 hole들을 다른 한 곳으로 몰아 큰 block을 만드는 것
- 매우 비용이 많이 드는 방법임
- 최소한의 메모리 이동으로 compaction하는 방법 (매우 복잡한 문제)
- Compaction은 프로세스의 주소가 실행 시간에 동적으로 재배치 가능한 경우에만 수행될 수 있다. (run time binding)

## B. Noncontiguous Allocation (불연속 할당)

> 메모리에 통째로 올리지 않고, 분할하여 올린다.

### a. Paging

> 하나의 프로그램을 구성하는 주소 공간(virtual memory)을 같은 크기의 page로 자르는 것. page단위로 물리적인 공간(physical memory)에 올려놓거나, backing store에 내려놓는다.
> 
> 물리적 공간(physical memory)도 page 하나가 들어갈 수 있는 크기로 미리 잘라놓는다. 이것을 page **frame**이라고 부른다.
> 
> page frame 하나하나에는 page들이 올라갈 수 있음.

```
장점

- hole들의 크기가 균일하지 않아서 발생하는 문제나, compation(hole들을 한군데로 몰아놓는)이 발생하지 않는다.

단점

- 주소 변환이 복잡해진다.
	- MMU에 의해 주소변할을 할때, 단지 시작주소만 더해서 주소변환을 하는게 아니라. 잘려진 각각의 page가 물리적인 memory에 어디에 올라가 있는지를 확인해야한다. 
	- 주소 변환을 page별로 해야하기 때문에 address binding이 더 복잡해진다.

```

- Process의 virtual memory를 동일한 사이즈의 page 단위로 나눔
- Virtual memory의 내용이 page 단위로 noncontiguous하게 저장됨
- 일부는 backing storage에, 일부는 physical memory에 저장

#### 1) Basic Method

- Physical memory를 동일한 크기의 frame으로 나눔
- logical memory를 동일 크기의 page로 나눔 (frame과 같은 크기)
- 모든 가용 frame들을 관리
- page table을 사용하여 logical address를 physical address로 변환
- External fragmentation 발생 안함
- Internal fragmentation 발생 가능
	- 프로그램을 page단위로 나누다보면, page단위보다 작은 조각이 생길 수 있다. 이것으로인해 내부 단편화(프로그램의 크기가 분할의 크기보다 작은 경우)가 발생할 수 있다.

### b. segmentation

프로그램의 주소공간을 같은 크기로 자르는게 아니라, 어떤 의미있는 단위로 자르는 것
프로그램의 주소공간은 코드, 데이터, 스택. 이런 크게 3가지의 의미있는 공간으로 구성된다. 코드 segment, 데이터 segment, 스택 segment로 잘라서 각각의 segment를 필요시에 물리적인 메모리의 다른 위치에 올려놓을 수 있다.

segment는 프로그램의 주소공간을 구성하는 의미있는 단위라고 했기에 코드, 데이터, 스택이 될 수도 있고 더 잘게 자를수도 있다(코드 중에서도 함수가 여러개 있기에, 각각의 함수들을 다른 segment로 나누면 segment 수가 많아진다.)

segment는 의미 단위로 자른것이기 때문에 크기가 균일하지않다.

크기가 균일하지 않기 때문에 dynamic storage-allocation problem이 발생할 수 있음.
Hole이 발생할 수 있음

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140425151219100144?vmode=f). (accessed Dec 3, 2021)