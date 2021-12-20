# 1. Allocation of File Data in Disk

> Disk에 File을 저장하는 3가지 방법

파일은 크기가 균일하지 않다.

디스크에 파일을 저장할때는 동일한 크기의 Sector 단위로 나누어서 저장한다.

파일 시스템이나 디스크 외부에서 볼 때 각각의 동일한 크기의 저장단위를 논리적인 블럭이라 부른다.

즉, 임의의 크기의 파일을 동일한 크기의 블럭단위로 나누어서 저장한다.

## A. Contiguous Allocation (연속 할당)

> 하나의 파일이 디스크 상에 연속해서 저장되는 방법

```ad-example

블럭 2개로 구성되는 파일은 첫번째 블럭과 두번째 블럭이 인접한 번호를 갖게 된다.

```

![](/bin/OS_image/os_11_1.png)

디렉토리에는 파일의 메타 데이터를 저장하기 때문에 파일의 이름, 위치 정보 등을 가지고 있게 된다.

- 장점
	- Fast I/O
		- 한번의 seek/rotation으로 많은 바이트 transfer
			- 하드디스크와 같은 매체는 대부분의 접근 시간이 disk head가 이동하는 시간임.
		- Realtime file용
			- 영구적인 저장 공간
			- realtime은 deadline이 있고 빠른 I/O가 필요함
		- 또는 이미 run 중이던 process의 swapping 용 (swap area)
			- 임시 저장 저장 공간
			- 프로세스가 끝나면 의미가 없는 정보
			- 대용량의 크기를 빠르게 디스크로 쫒아냈다가 필요하면 빨리 메모리로 올려야하는 것. (공간 효율성보다 속도 효율성이 중요함)
	- Direct access(=random access) 가능
		- mail의 앞에서부터 5번째 블럭을 보고 싶을 경우
			- 앞의 4개의 블럭을 다 접근해야지만 5번째 블럭을 볼 수 있는 것이 아님.
			- 연속할당인 경우 mail 파일은 19번 블럭에서부터 연속적으로 6개가 저장되어 있기 때문에 19 + 4 하면 바로 23번째 블럭(5번째 블럭)에 접근할 수 있음.
				- 따라서 직접 접근이 가능함. 
- 단점
	- external fragmentation (외부단편화 발생)
	- File grow(파일이 커지는 것)가 어려움
		- file 생성시 얼마나 큰 hole을 배당할 것인가?
			- 미리 파일이 커질 것을 대비하여 용량을 할당하는 것.
				- 미리 할당된 크기만큼만 파일이 커지고 더 이상 커지기는 어려움.
				- 내부 단편화 발생 (공간의 낭비 발생)
		- grow 가능 vs 낭비 (internal fragmentation)

## B. Linked Allocation (연결 할당)

> 빈 위치이면 아무곳이나 들어갈 수 있게 배치한다.

파일의 시작 위치만 디렉터리가 가지고 있고 그 다음 위치는 실제로 그 위치에 가야지만 알 수 있음.

![](/bin/OS_image/os_11_2.png)

- 장점
	- External fragmentation 발생 안 함
- 단점
	- No random access, 순차 접근만 가능함.
		- 4번째 블럭에 가기 위해서는 첫번째 블럭부터 접근해서 다음 블럭의 위치를 알아내야함.
		- disk head가 이동해야하기 때문에 seek를 위한 시간이 오래 걸린다. (순차 접근으로 인해 시간이 오래 걸림)
	- Reliability 문제
		- 한 sector가 고장(bad sector)나 pointer가 유실되면 많은 부분을 잃음
	- Pointer를 위한 공간이 block의 일부가 되어 공간 효율성을 떨어뜨림 (practical한 문제)
		- 512 bytes/sector, 4 bytes/pointer
			- 보통 disk에서 1개의 sector는 512 byte로 구성된다.
				- 하나의 sector의 512 byte에서 다음 위치를 가리키는 pointer를 제외하면 508byte에만 데이터를 저장할 수 있다.
				- 보통 512byte를 저장하라고 하기 때문에 하나의 sector에서 처리될 수 있는 내용(512byte)이 pointer때문에 2개의 sector에 저장되는 문제가 생길 수 있다.
			- disk 바깥쪽에서 disk로 접근할 때 disk에 데이터를 저장하라는 단위가 512byte의 배수로 구성된다.
- 변형
	- File-allocation table (FAT) 파일 시스템
		- 포인터를 별도의 위치에 보관하여 reliability와 공간효율성 문제 해결

## C. Indexed Allocation (인덱스 할당)

> 디렉토리에 파일의 위치 정보를 바로 저장하는 것이 아니라, 파일이 저장된 위치 정보를 가지고 있는 인덱스 블럭을 가리키게 한다.

![](/bin/OS_image/os_11_3.png)

- 장점
	- External fragmentation이 발생하지 않음
		- hole 문제 해결 (비어 있는 위치면 어디든지 활용이 가능해짐)
	- Direct access 가능
		- 인덱스 블럭을 통해 중간 위치에 직접 접근할 수 있음
- 단점
	- Small file의 경우 공간 낭비 (실제로 많은 file들이 small)
		- 아무리 작은 file도 블럭이 2개 필요함(index block, 실제 데이터를 저장하는 block)
	- Too Large file의 경우 하나의 block으로 index를 저장하기에 부족
		- 해결 방안
			1. linked scheme
				- 인덱스 블럭에 파일의 위치를 저장하다가 파일의 크기를 다 저장하지 못한 경우 마지막 위치에 또 다른 인덱스 블럭의 위치를 저장한다.
			2. multi-level index
				- 2단계 페이지 테이블처럼 인덱스가 실제 데이터를 가리키는 것이 아닌, 2번 거쳐야지만 가리키는 방식
				- 단, 인덱스를 위한 공간 낭비가 발생함.

# 2. UNIX 파일시스템의 구조

> 가장 기본적인 파일시스템 구조

>  inode를 가지고 있는 것이 UNIX 파일시스템의 핵심적이고 기본적인 구조이다.

![](/bin/OS_image/os_11_4.png)

![](/bin/OS_image/os_11_5.png)

- 유닉스 파일 시스템의 중요 개념
	- Boot block
		- 부팅에 필요한 정보 (bootstrap loader)
		- 어떤 파일시스템에서든 Boot block이 제일 앞에 위치한다.
			- 0번 블럭에 부팅에 필요한 정보를 저장
			- boot block이 시키는대로 하면서 운영체제의 커널의 위치가 어디인지 찾아서 메모리에 올린다.
	- Super block
		- 파일 시스템에 관한 총체적인 정보를 담고 있다.
			- 어디가 빈 블럭이고, 어디가 사용중인 블럭인지 관리한다.
			- 어디까지가 Inode block이고, 어디까지가 data block인지 관리한다.
	- Inode list (Index node)
		- 파일 이름을 제외한 파일의 모든 메타 데이터를 저장
			- 실제 파일의 메타 데이터를 별도의 Inode list 위치에 저장
			- 디렉토리에는 일부 메타 데이터만 저장
		- 파일 하나당 inode가 하나씩 할당된다.
			- inode는 그 파일의 메타데이터를 가지고 있는 구조이다.
				- 소유주, 수정 시간, 크기, 위치정보 등
			- 파일의 이름은 디렉토리가 가지고 있음.
		- 파일의 위치 정보는?
			- index allocation을 사용한다.
				- direct blocks
					- 파일 크기가 굉장히 작은 경우에 direct block만 가지고 표현한다.
				- single indirect
					- 위 경우보다 큰 파일의 경우 사용.
					- single indirect를 따라가면 index block이 있다.
					- index block에는 실제 파일의 내용을 가리키는 포인터가 여러개 들어간다.
				- double indirect
					- 위 경우보다 큰 파일의 경우 사용.
					- double indirect를 두번 따라가야지만 실제 파일의 위치를 가리키는 index block이 있다.
					- index block에 실제 파일의 위치가 저장되어 있다.
				- triple indirect
					- 위 경우보다 큰 파일의 경우
					- triple indirect를 3번 따라가야지만 실제 파일의 위치를 가리키는 index block이 있다.
			- inode의 크기는 정해져 있기 때문에 pointer 개수도 유한하다.
	- Data block
		- 파일의 실제 내용을 보관
			- 파일의 이름과 이 파일의 inode번호를 가지고 있음

> 위 inode 방식이 효율적인 이유?
> > 대부분의 파일들은 크기가 아주 작다. inode만 메모리에 올려두면, 작은 파일들은 한 번의 포인터 접근으로 파일의 위치를 바로 알 수 있다.
> > 가끔 발생하는 큰 파일은 indirect block들을 이용해서 인덱스를 disk에서 추가적으로 접근해서 파일의 위치를 찾는다.
> > 
> > 이러면 굉장히 큰 파일을 한정된 크기의 inode에서 지원할 수 있다.

# 3. FAT File System

MS사가 MS-Dos를 만들었을 때 만든 파일시스템

> Linked Allocation을 활용한 것이지만, FAT만 확인하면 그 파일의 다음 위치를 알 수 있음
> > 직접 접근이 가능하다.
> > FAT 테이블을 메모리에 올려두고 따라가기만 하면 되기 때문에 곧바로 파일의 특정 위치를 찾을 수 있다. (디스크에서 3번째 블럭을 봐야지만 4번째 블럭을 알 수 있는 것이 아님.)

![](/bin/OS_image/os_11_6.png)

- Boot block
	- 부팅과 관련된 정보를 담고 있음
- FAT
	- 파일의 메타데이터 중 일부(위치정보만)를 FAT에 저장
	- 217번 블럭의 다음 블럭을 FAT이라는 별도의 테이블(배열)에 저장한다.
	- FAT 배열의 크기는 디스크가 관리하는 데이터 블럭의 개수만큼
		- n개의 데이터 블럭이 있으면, 배열의 크기가 n개가 된다.
	- FAT 배열에는 해당 블럭의 다음 블럭의 위치를 담고 있다.
- Root directory
	- 
- Data block
	- 나머지 메타데이터를 가지고 있음
		- 이름, 접근 권한, 사이즈, 소유주, 파일의 첫 번째 위치(linked allocation) 등 

---

- Linked Allocation의 단점을 전부 극복함.
	- random access 됨.
	- reliability 문제 해결
		- pointer 하나가 유실(bad sector)되더라도 FAT에 내용이 있음(Data block과 FAT은 분리가 되어 있음)
		- FAT은 하나의 copy만 두는 것이 아닌 디스크에 2 copy 이상을 저장한다. 
	- 512 byte 충분히 활용할 수 있음.

# 4. Free-Space Management

> 파일이 할당되지 않은 비어있는 block들을 관리하는 방법

## A. Bit map or bit vector

UNIX같은 경우 Super block에 비트를 두고 각 block이 사용중인지 비어있는지를 0과 1로 표시한다.

bit map의 크기는 data block의 개수만큼으로 구성됨.

![](/bin/OS_image/os_11_7.png)

- bit 값이 0이면 block은 비어있는 것이고, bit 값이 1이면 block은 사용중인 것이다.
- 파일 시스템이 관리하는 것
	- 파일이 새로 만들어지거나 파일의 크기가 커지면 비어 있는 block 중에 한 개를 할당한다.
	- 파일이 삭제되면 1로 되어 있던 bit를 0으로 바꿔주어야 한다.

---

- Bit map은 부가적인 공간을 필요로 함
	- block 하나당 1bit가 필요하기 때문에, 그렇게 많은 공간이 필요하지는 않다.
- 연속적인 n개의 free block(빈 블럭)을 찾는데 효과적
	- 연속할당을 사용하지 않아도 가능하면 연속적인 위치에 저장해야 좋다.
		- 디스크의 헤더가 이동할 필요가 없이 많은 양을 한꺼번에 읽어올 수 있다.
	- bit map을 쭉 scan하면 연속적으로 0인 곳이 어디인지 찾기가 쉬워서, 연속적인 빈 블럭을 찾는데 효과적임.

## B. Linked list

> 비어있는 block들을 연결해놓는 방법
> > 어차피 비어 있는 block이기 때문에 자기 자신에 다음 비어있는 block의 위치를 저장할 수 있음.

우리는 비어 있는 첫 번째 블럭의 위치만 가지고 있고, 해당 블럭에 가면 다음 비어 있는 위치를 알 수 있다.

![](/bin/OS_image/os_11_8.png)

- 모든 free block들을 링크로 연결 (free list)
- 연속적인 가용공간을 찾는 것은 쉽지 않다.
	- 연속적인 가용공간을 찾고자 한다면, Linked list는 사용하기 쉽지 않다.
- 공간의 낭비가 없다.

## C. Grouping

![](/bin/OS_image/os_11_9.png)

- linked list 방법의 변형
- 첫 번째 free block이 n개의 pointer를 가짐
	- n-1 pointer는 free data block을 가리킴
	- 마지막 pointer가 가리키는 block은 또 다시 n pointer를 가짐

비어있는 block을 한꺼번에 찾기에는 Linked list 방식보다는 효율적이지만, 연속적인 빈 블럭을 찾기에는 썩 효과적이지 않다.

## D. Counting

> 연속적인 빈 블럭을 찾는데 효과적인 방법

- 프로그램들이 종종 여러 개의 연속적인 block을 할당하고 반납한다는 성질에 착안
- (first free block, # of contiguous free blocks)을 유지
	- 빈 블럭의 첫 번째 위치와 거기서부터 몇 개가 빈 블럭인지를 쌍으로 관리

```ad-example

연속적으로 5개의 빈블럭을 찾고 싶으면, free block의 개수가 5 이상인 것만 찾으면 된다.

```

# 5. Directory Implementation

디렉토리는 디렉토리 밑에 있는 파일들의 메타데이터를 관리하는 파일이다.

디렉토리에 파일을 어떻게 저장할 것인가?

## A. Linear list

- \<file name, file의 metadata\>의 list
	- 메타데이터는 크기를 고정하여 관리한다.
- 구현이 간단
- 디렉토리 내에 파일이 있는지 찾기 위해서는 linear search 필요 (time-consuming)
	- 특정 파일을 찾을때까지 선형 탐색을 해야해서 비효율적임.

![](/bin/OS_image/os_11_10.png)

디렉토리에 있는 어떤 파일을 찾으라는 연산을 주면, 파일 이름의 필드가 어떤 단위(크기)로 구성되는지 알기 때문에 파일 이름만 순차적으로 탐색할 수 있음.

## B. Hash Table

> 파일의 해시함수 결과값에 해당하는 entry에 파일의 메타데이터를 저장한다.

- 해시함수
	- 어떤 값을 입력해도 결과값이 특정한 범위 안의 숫자로 치환된다.
	- 파일의 이름도 마찬가지로 적용할 수 있다.

---

- linear list + hashing
- Hash table은 file name을 이 파일의 linear list의 위치로 바꾸어줌
- search time을 없앰
	- O(1)
- Collision 발생 가능
	- 서로 다른 입력값에 대해서 결과값이 같은 entry로 매핑되는 것.

![](/bin/OS_image/os_11_11.png)

## C. File의 metadata의 보관 위치

- 디렉토리 내에 직접 보관
- 디렉토리에는 포인터를 두고 다른 곳에 보관
	- inode(파일의 이름을 제외한 모든 메타데이터 정보), FAT(파일의 다음 저장 위치) 등

![](/bin/OS_image/os_11_12.png)

## D. Long file name의 지원

- \<file name, file의 metadata\>의 list에서 각 entry는 일반적으로 고정 크기
- file name이 고정 크기의 entry 길이보다 길어지는 경우 entry의 마지막 부분에 이름의 뒷부분이 위치한 곳의 포인터를 두는 방법
- 이름의 나머지 부분은 동일한 directory file의 일부에 존재

![](/bin/OS_image/os_11_13.png)

파일 이름에 해당하는 필드의 길이를 한정해두고, 파일 이름의 길이가 길면 앞부분만 저장하고 포인터로 디렉토리 파일의 맨 끝에서부터 파일 이름이 꺼꾸로 저장되도록 한다.

```ad-example

파일 이름이 aaabb이고 파일 필드의 길이가 4라면,
저장할 수 있는 크기는 3글자이다. (마지막 위치는 pointer를 저장해야하기 때문)

따라서, aaa(pointer)를 저장하고 디렉토리의 끝(pointer)로 가서 bb를 꺼꾸로 저장한다.

```

# 6. VFS and NFS

![](/bin/OS_image/os_11_14.png)

## A. Virtual File System (VFS)

사용자가 파일 시스템에 접근하기 위해서는 system call을 사용해야한다.

다만, 파일 시스템의 종류가 여러가지여서, 파일 시스템 종류별로 서로 다른 파일 시스템 콜을 사용해야한다면 사용자는 혼란스러울 것이다.

그래서 보통은 개별 파일 시스템 윗 계층에 VFS 인터페이스를 둔다.

사용자가 파일 시스템에 접근할 때는 개별 파일 시스템의 종류와 상관없이 VFS 파일시스템 인터페이스를 사용하여 동일한 시스템 콜 인터페이스(API)를 사용하여 파일시스템에 접근할 수 있게 해주는 계층.

---

- 서로 다른 다양한 file system에 대해 동일한 시스템 콜 인터페이스(API)를 통해 접근할 수 있게 해주는 OS의 layer

## B. Network File System (NFS)

> 원격지에 저장되어 있는 파일시스템을 접근하는데 사용.

클라이언트와 서버 컴퓨터가 네트워크를 통해 연결되어 있다.

클라이언트가 어떤 파일시스템인가와 상관없이 VFS interface를 통해 접근하는데, 그 파일 시스템 중에는 자기 local 컴퓨터에 있는 파일 시스템도 접근 가능하고. 원격의 다른 컴퓨터에 있는 파일 시스템에도 접근할 수 있는 인터페이스(NFS, etc..)도 지원된다.

클라이언트가 server에 있는 파일 시스템에 접근하려면 NFS를 통해 RPC(remote processor call) 프로토콜을 통해 네트워크를 건너서 서버에 접근한다. 서버에서 RPC를 받는 프로토콜이 있고 NFS server 모듈을 통해 서버에서 서버의 사용자가 요청하는 것처럼 VFS interface를 통해서 system call을 해서 서버의 파일시스템에 접근해야한다. 

이렇게 접근한 내용을 역순으로 client에 전달한다.

---

NFS를 지원하려면 Server쪽에 NFS 모듈(NFS server)와 Client쪽에 NFS 모듈(NFS client)가 있고, 같은 약속을 가지고 접근할 수 있게 해주면 된다.

---

- 분산 시스템에서는 네트워크를 통해 파일이 공유될 수 있음
- NFS는 분산 환경에서의 대표적인 파일 공유 방법임

# 7. Page Cache and Buffer Cache

Virtual memory system 관점에서에서는 page cache라고 부름

파일 시스템 관점에서는 buffer cache라고 부름

## A. Page Cache

- Virtual memory의 paging system에서 사용하는 page frame을 caching의 관점에서 설명하는 용어
	- 물리적 메모리에 올라가는 page frame을 page cache라고 한다.
	- swap area보다 page frame이 빠르다.
	- 캐슁의 관점에서 보면 paging system에서 page frame을 page cache라고 한다.
- Memory-Mapped I/O를 쓰는 경우 file의 I/O에서도 page cache 사용

---

- 운영체제한테 제공되는 정보가 제한적이었음.
	- cache hit(이미 메모리에 존재하는 경우)가 나면 하드웨어적인 주소변환만 하기 때문에 접근 정보를 운영체제가 알 수 없음
		- 그래서 clock 알고리즘을 사용함.

## B. Memory-Mapped I/O

- File의 일부를 virtual memory에 mapping 시켜 놓고 사용함.
	- mapping을 해놓고 나면, 그 다음부터는 read / write system call을 하는 것이 아니라 memory에 read/write하는 것처럼 하는데, 실제로는 file에 read/write하는 효과가 나게 하는 방법
- 매핑시킨 영역에 대한 메모리 접근 연산은 파일의 입출력을 수행하게 함

## C. Buffer Cache

> 파일의 데이터를 사용자가 요청했을때, 운영체제가 읽어온 내용을 자기의 영역 중 일부에 저장하는 방법. 추후 똑같은 요청이 들어오면 logical disk에 가지 않고도 buffer cache에서 바로 읽어오는 것.

- 파일시스템을 통한 I/O연산은 메모리의 특정 영역인 buffer cache 사용
- File 사용의 locality 활용
	- 한 번 읽어온 bloc에 대한 후속 요청시 buffer cache에서 즉시 전달
- 모든 프로세스가 공용으로 사용
- Replacement algorithm 필요 (LRU, LFU 등)

---

- 운영체제한테 정보가 제공됨.
	- 파일 데이터가 메모리에 올라와있거나 disk에 있는 것에 상관없이 파일에 접근할 때는 system call을 해야하기 때문에 CPU 제어권이 운영체제한테 넘어감.
	- cache hit인 경우에도 파일에 대한 접근을 운영체제가 알 수 있음.
	- 이 정보를 활용하여 LRU 알고리즘을 사용할 수 있음.

## D. Unified Buffer Cache

> 최근에는 page cache와 buffer cache를 합쳐서 같이 관리하는 경우가 많다.

- 최근의 OS에서는 기존의 buffer cache가 page cache에 통합됨
	- buffer cache도 page 단위로 관리한다.
	- 운영체제에서 page frame(물리적 메모리)를 관리하는 루틴에 page cache와 buffer cache를 같이 관리한다.

![](/bin/OS_image/os_11_15.png)

- 사용자 메모리 영역
	- 페이지 단위로 필요한 데이터가 올라오고 내려가면서 관리됨.
	- 페이지는 보통 4KB 단위
- 커널 메모리 영역
	- 파일의 내용을 읽어오려면, 먼저 file의 내용을 buffer cache에 가져온 다음에 사용자한테 전달해줌.
	- block 하나는 512 byte로 구성

최근에는 page cache와 buffer cache가 합쳐졌기 때문에 buffer cache에서도 페이지 크기(4KB)로 block들을 관리한다.

- Swap area
	- 가상메모리에서 사용
	- 빠르게 데이터를 내려놓고 올려야하기 때문에 여러개의 block을 모아서 4KB 단위로 올리거나 내리는 방식을 사용한다.
	- 속도 효율성을 위해서 여러개의 페이지를 한꺼번에 올리고 내리기도 한다.

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140520134614002164?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 20, 2021)
