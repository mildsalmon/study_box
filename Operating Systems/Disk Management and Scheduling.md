# 1. Disk Structure

## A. logical block

> Disk 외부(컴퓨터 호스트)에서 Disk에 접근할 때 logical block 단위로 접근한다.

- 디스크의 외부에서 보는 디스크의 단위 정보 저장 공간들
- 주소를 가진 1차원 배열처럼 취급
- 정보를 전송하는 최소 단위

## B. Sector

- Logical block이 물리적인 디스크에 매핑된 위치
- Sector 0은 최외곽 실린더의 첫 트랙에 있는 첫 번째 섹터이다.
	- Sector 0은 논리적인 디스크 상에서도 logical block 0번에 해당함.
	- Sector 0은 부팅과 관련된 내용 저장

# 2. Disk Management

## A. physical formatting (Low-level formatting)

> 하드디스크를 구매하면 physical formatting이 되어서 옴

- 디스크를 컨트롤러가 읽고 쓸 수 있도록 섹터들로 나누는 과정
- 각 섹터는 **header** + **실제 data**(보통 512 bytes) + **trailer**로 구성
	- disk controller가 데이터를 읽고 쓰다보면 부가적으로 필요한 정보가 header, trailer에 저장된다.
	- 데이터의 메타 데이터와 비슷함.
- header와 trailer는 sector number, ECC (Error-Correcting Code) 등의 정보가 저장되며 controller가 직접 접근 및 운영
	- ECC는 해쉬함수와 같은 것.
		- header와 trailer에 저장된 ECC 값과 실제 data의 ECC 값이 같은지 비교하여 bad sector가 안나고 제대로 저장되었는지를 확인한다.
		- ECC는 축약본이기 때문에 모든 오류를 다 잡아내지는 못할 것이다. (해쉬 함수의 콜리전과 같이)
		- ECC의 규모에 따라 에러를 수정까지 할 수 있는 경우와 에러를 검출만 하고 수정은 못하는 경우가 있다.
			- Error가 일정 수준 이하에서 발생하면 ECC를 통해서 데이터를 수정도 할 수 있음.

## B. Partitioning

> physical formatting이 끝난 다음에 Sector 영역들을 묶어서 하나의 독립적인 Disk (logical disk)로 만들어주는 것.

- 디스크를 하나 이상의 실린더 그룹으로 나누는 과정
- OS는 이것을 독립적 disk로 취급 (logical disk)
- partition이 끝나면 각각의 partition을 file system 용도 또는 swap area 용도로 쓸 수 있다.

## C. Logical formatting

- 파일 시스템을 만드는 것
- FAT, inode, free space 등의 구조 포함

## D. Booting

- ROM에 있는 "small bootstrap loader"의 실행
- sector 0 (boot block)을 load하여 실행
- sector 0은 "full Bootstrap loader program"
- OS를 디스크에서 load하여 실행

---

cpu는 메모리만 접근할 수 있고 하드디스크는 접근하지 못하는 장치이다.

그럼 어떻게 부팅이 이루어지는가?

메모리 영역 중에서 전원이 꺼져도 내용이 유지되는 소량의 메모리 부분(ROM)이 있다.

ROM에 부팅을 위한 아주 간단한 loader가 저장되어 있다.

컴퓨터 전원을 켜면 CPU의 제어권이 ROM을 가리키고, ROM에서 small bootstrap loader가 CPU에서 인스트럭션 형태로 실행된다.

small bootstrap loader는 하드디스크에서 0번 sector에 있는 내용을 메모리에 올리고 그것을 실행하라고 지시한다. 그리고 그 메모리 영역을 실행하면, boot block은 file system에서 운영체제 커널의 위치를 찾아서 메모리에 올려서 실행한다.

운영체제 커널의 위치는 Sector 0번이 알아서 지시한다.(file system에 따라 해당하는 운영체제 커널의 file을 메모리에 올려서 실행함)

이렇게 되면 운영체제가 메모리에 올라가서 부팅이 이루어지게 된다.

# 3. Disk Scheduling

![](/bin/OS_image/os_12_1.png)

## A. Access time의 구성

> 고속 입출력이 필요한 경우에 1번의 Seek로 많은 양을 Transfer하면 상당히 이득이다.

### a. Seek time

- 실린더
	- 같은 트랙에 위치한 것들을 모아서 실린더라 부른다.

> disk head가 read/write 요청을 한 트랙(실린더)으로 이동하는데 걸리는 시간.

- 헤드를 해당 실린더로 움직이는데 걸리는 시간

Seek time이 Disk를 접근하는 시간에서 가장 큰 시간 구성 요소이다.

기계 장치가 이동하는 것이기 때문에 반도체에 접근하는 메모리 접근에 비해 시간이 오래 걸린다.

### b. Rotational latency

> 원판이 회전해서 sector위치가 disk head 한테 가는데 걸리는 시간

- 헤드가 원하는 섹터에 도달하기까지 걸리는 회전지연시간

Seek time보다 1/10 정도로 적은 시간 규모를 차지한다.

### c. Transfer time

> 실제로 head가 data를 read/write하는 시간

- 실제 데이터의 전송 시간 

시간이 얼마 안걸린다.
 
## B. Disk bandwidth

- 단위 시간 당 전송된 바이트의 수

disk bandwidth가 높아지려면(disk가 효율적으로 동작하려면) 가능한 Seek time을 줄이는 것이 좋다.

왜냐하면 disk를 접근하는 시간은 거의 seek time에 좌우되기 때문이다.

그래서 disk scheduling이 필요한 것이다.

## C. Disk Scheduling

> disk 외부에서 read/write 요청이 들어왔을 때 가능한 Seek time을 줄여서 disk bandwidth를 높여보자고 하는 것.

- seek time을 최소화하는 것이 목표
- Seek time = seek distance

요청이 들어오면 요청이 들어온 순서대로 처리하는 것이 아닌, 순서를 바꿔서 늦게 들어온 요청이라도 안쪽에 있는 요청이 queue에 쌓여있으면 그것을 먼저 처리하면서 disk head가 밖으로 나가면 전체적인 seek time을 줄일 수 있다. 

# 4. Disk Scheduling Algorithm

스케줄링 알고리즘이 구현되는 곳이 disk 내부가 아니기 때문에 I/O 스케줄러가 disk보다는 윗쪽에 운영체제 쪽에 존재하기 때문에 실린더의 정확한 disk 상의 위치는 모를 수 있다.

logical block 번호가 sector로 매핑되고 

disk scheduler는 logical block 번호를 보고 스케줄링을 한다.

그럼 이 정보가 어느정도는 disk 상의 sector 위치하고 맞아 떨어지기 때문에 이렇게 스케줄링해서 해결한다.

또한, disk 내부에서 sector 단위의 스케줄링을 할 수 있는 방법도 있다.

이런 방식은 실제 구현에서는 잘 쓰지 않음.

```ad-example

큐에 다음과 같은 실린더 위치의 요청이 존재하는 경우 디스크 헤드 53번에서 시작한 각 알고리즘의 수행 결과는? (실린더 위치는 0-199)

98, 183, 37, 122, 14, 124, 65, 67

```

## A. FCFS (First Come First Service)

> 들어온 순서대로 처리해주는 알고리즘 

![](/bin/OS_image/os_12_2.png)

queue에 실린더 위치의 요청이 안쪽 트랙과 바깥쪽 트랙이 번갈아 요청이 오면 disk head가 상당히 많이 이동을 해야한다.

즉, head의 이동 거리가 길어지기 때문에 상당히 비효율적이게 된다.

## B. SSTF (Shortest Seek Time First)

> 현재 head 위치에서 제일 가까운 요청을 처리한다.

![](/bin/OS_image/os_12_3.png)

가까운 요청부터 처리하니까 disk head의 이동 거리가 줄어든다.

starvation(기아)가 발생할 수 있다.

```ad-example

큐에서 가까운 것을 처리하고 멀리 있는 것을 처리하려고 할 때, 큐에 가까운 위치의 요청이 추가되면 head가 멀리 있는 쪽으로 못가게 된다.

```


## C. SCAN

> 엘리베이터 스케줄링이라고도 부름

> 현재 큐에 들어온 요청의 순서에 상관없이, 디스크 head는 가장 안쪽 위치에서 바깥쪽 위치로 이동하면서 가는 길목에 요청이 있으면 처리하고 지나간다.
> 제일 바깥쪽에 도달하면 방향을 바꿔서 요청을 처리한다.

- disk arm이 디스크의 한쪽 끝에서 다른쪽 끝으로 이동하며 가는 길목에 있는 모든 요청을 처리한다.
- 다른 한 쪽 끝에 도달하면 역방향으로 이동하며 오는 길목에 있는 모든 요청을 처리하며 다시 반대쪽 끝으로 이동한다.
- 문제점
	- 실린더 위치에 따라 대기 시간이 다르다.
		- 최악의 경우 가운데 지점은 반바퀴만 기다리면 되는데, 가장자리 지점은 한바퀴를 기다려야한다.
		```ad-example

		20층에 있는데, 엘리베이터가 19층에서 내려가는 경우

		```


![](/bin/OS_image/os_12_4.png)

디스크 head의 이동 거리가 짧아진다.

starvation 문제도 발생하지 않는다. (아무리 오래 걸려도 disk head가 쭉 scan해서 지나가는 동안에는 처리되기 때문.)

비교적 공정하면서도 disk head의 이동 거리 측면에서도 효율적인 특징을 가지고 있다.

![](/bin/OS_image/os_12_5.png)

## D. C-SCAN (Circular-Scan)

- 헤드가 한쪽 끝에서 다른쪽 끝으로 이동하며 가는 길목에 있는 모든 요청을 처리
- 다른쪽 끝에 도달했으면 요청을 처리하지 않고 곧바로 출발점으로 다시 이동
- SCAN보다 균일한 대기 시간을 제공한다.

![](/bin/OS_image/os_12_6.png)

이동 거리는 길어질 수 있지만, 큐에 들어온 요청들에 대기 시간이 조금 더 균일해진다.

![](/bin/OS_image/os_12_7.png)

## E. Other Algorithm

> 기본적으로 disk scheduling algorithm은 SCAN에 기반한 알고리즘을 사용한다.

### a. N-SCAN

> SCAN을 하는데, 현재 큐에 들어와 있는 요청만 처리한다. SCAN이 진행되는 도중에 들어온 요청은 다음번(되돌아올 때) 처리한다.

- SCAN의 변형 알고리즘
- 일단 arm이 한 방향으로 움직이기 시작하면 그 시점 이후에 도착한 job은 되돌아올 때 service

대기시간의 편차를 줄일 수 있다.

### b. LOOK and C-LOOK

> SCAN, C-SCAN의 비효율적인 측면을 개선한 것.

- SCAN이나 C-SCAN은 요청이 있건 없건, 헤드가 디스크 끝에서 끝으로 이동
- LOOK과 C-LOOK은 헤드가 진행 중이다가 그 방향에 더 이상 기다리는 요청이 없으면 헤드의 이동방향을 즉시 반대로 이동한다.

![](/bin/OS_image/os_12_8.png)

# 5. Disk-Scheduling Algorithm의 결정

- SCAN, C-SCAN 및 그 응용 알고리즘은 LOOK, C-LOOK 등이 일반적으로 디스크 입출력이 많은 시스템에서 효율적인 것으로 알려져 있음
- File의 할당 방법에 따라 디스크 요청이 영향을 받음
	- 연속 할당을 할 경우 요청이 연속된 실린더 위치에 있어서 이동거리를 줄일 수 있음.
- 디스크 스케줄링 알고리즘은 필요할 경우 다른 알고리즘으로 쉽게 교체할 수 있도록 OS와 별도의 모듈로 작성되는 것이 바람직하다.

# 6. Swap-Space Management

- Disk를 사용하는 두 가지 이유
	- memory의 volatile(휘발성)한 특성 -> file system
		- 전원이 꺼지면 dram memory는 내용이 사라진다.
		- file system처럼 영속적으로 데이터를 유지해야하는 것은 dram memory에 유지하면 안되기 때문에 비휘발성의 disk를 사용한다.
	- 프로그램 실행을 위한 memory 공간 부족 -> swap space (swap area)
		- 프로그램의 주소 공간 전체를 물리적인 메모리에 올려놓기에는 메모리 공간이 부족하다.
		- memory의 연장 공간으로 disk를 사용한다.
			- swap space (swap area) 용도로 disk를 사용한다.
- Swap-space
	- Virtual memory system에서는 디스크를 memory의 연장 공간으로 사용
	- 파일시스템 내부에 둘 수도 있으니 별도 partition 사용이 일반적
		- 공간효율성보다는 속도 효율성이 우선
		- 일반 파일보다 훨씬 짧은 시간만 존재하고 자주 참조됨
		- 따라서, block의 크기 및 저장 방식이 일반 파일시스템과 다름

![](/bin/OS_image/os_12_9.png)

물리적 disk를 파티셔닝하여 logical disk를 만든다.

운영체제는 각각의 logical disk를 독립적인 disk로 간주한다.

각각의 logical disk는 file system을 설치해서 사용하거나 swap area 용도로 사용할 수도 있다.

- file system
	- 보통 file system은 sector 1개당 512byte, unified buffer cache의 경우 buffer cache를 page cache처럼 관리해서 4KB.
- swap area
	- 프로그램이 실행되는 동안에 swap area에 머물러 있던 프로세스의 주소 공간이 프로그램이 끝나면 사라질 내용이다. 
	- 물리적인 memory의 연장 공간으로 쓰기 때문에 쫒겨날때도 가능한 빨리 disk에 써줘야하고 swap area에 있는 것을 page fault가 나서 다시 물리적인 memory에 올릴때도 굉장히 빨리 올려야한다.
	- disk에 접근하는 시간의 대부분은 디스크의 head가 움직이는 시간(seek time)
		- seek time을 줄여서 공간 효율성보다는 속도 효율성을 높이는 것이 중요하다.
			- 프로세스가 끝나면 사라지는 내용이라서 공간 효율성은 그다지 중요하지 않다.
	- swap area에 데이터를 올리고 내리는 단위는 굉장히 큰 단위를 순차적으로 할당한다.
		- 512KB.
		- 경우에 따라서는 크기를 다르게 할당한다.

# 7. RAID

## A. RAID (Redundant Array of Independent Disks)

> 여러개의 디스크에 데이터를 중복 or 분산 저장한다.

- 여러 개의 디스크를 묶어서 사용

### a. RAID의 사용 목적

- 디스크 처리 속도 향상
	- 여러 디스크에 block의 내용을 분산 저장
	- 병렬적으로 읽어 옴 (interleaving, striping)
- 신뢰성 (reliability) 향상
	- 동일 정보를 여러 디스크에 중복 저장
	- 하나의 디스크가 고장(fault)시 다른 디스크에서 읽어옴 (Mirroring, shadowing)
	- 단순한 중복 저장이 아니라 일부 디스크에 parity를 저장하여 공간의 효율성을 높일 수 있다.

![](/bin/OS_image/os_12_10.png)
 
## B. RAID 0 (스트라이핑)

- 일련의 데이터를 논리적 디스크 배열 하나에 일정한 크기로 나눠서 분산 저장하는 방법
- 하나의 디스크가 망가지면 전체 데이터에 손실이 발생한다.
- 속도는 디스크 갯수만큼 빨라짐, 용량도 디스크 갯수만큼 늘어남.
	- 안정성은 낮아짐

![](/bin/OS_image/os_12_11.png)

## C. RAID 1 (미러링)

- 디스크를 통째로 백업하는 방식
- 최소 디스크 갯수 2개

![](/bin/OS_image/os_12_12.png)

## D. RAID 2 (허밍코드를 이용한 중복)

- 데이터를 스트라이핑 방식으로 저장하고, 패리티 비트(허밍 코드)들은 ESS 디스크에 대응하는 위치에 ECC/Ax, ECC/Ay, ECC/Az를 저장한다.
- 디스크, 허밍코드 하나씩 망가지면 복구할 수 없다.
- 복구시 100% 완벽하게 복구된다.
- 최소 디스크 갯수 5개 이상 -> 데이터 2개, 허밍코드 3개

![](/bin/OS_image/os_12_17.png)

## E. RAID 3 (비트 인터리브된 패리티)

- 별도의 드라이브 한대를 패리티 드라이브로 사용한다.
- 복구시 90% 복구된다.
- 디스크 2개가 동시에 망가지면 살아날 확률이 줄어든다.
- 최소 디스크 갯수 3개 -> 데이터 2개, 패리티 1개

![](/bin/OS_image/os_12_13.png)

## F. RAID 4 (블록 인터리브된 패리티)

- 디스크(데이터, 패리티) 2개가 망가지면 복구하기 힘들다.
- RAID 3에서 패리티 비트를 블록 단위로 저장
- 최소 디스크 갯수 3개 -> 데이터 2개, 패리티 1개

![](/bin/OS_image/os_12_14.png)

## G. RAID 5 (블록 인터리브된 분산 패리티 블록)

- 별도의 패리티 드라이브 대신 모든 드라이브에 패리티 정보를 나눠서 저장
- 최소 디스크 갯수 3개

![](/bin/OS_image/os_12_15.png)

## H. RAID 0 + 1 / RAID 10

- 2개는 스트라이핑, 2개는 미러링
- 최소 디스크 4개 -> 디스크 2개, 미러링 디스크 2개

![](/bin/OS_image/os_12_16.png)

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140408134626290222?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 2, 2021)
