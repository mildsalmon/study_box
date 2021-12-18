# 1. File and File System

- File
	> 이름을 통해서 접근하는 단위
	- "A named collection of related information"
		- 관련된 정보를 이름을 가지고 저장함
	- 일반적으로 비휘발성의 보조기억장치에 저장
	- 운영체제는 다양한 저장 장치를 file이라는 동일한 논리적 단위로 볼 수 있게 해줌
	- Operation
		- create, read, write, reposition (lseek), delete, open, close 등
			- reposition
				- 현재 접근하고 있는 파일의 위치를 수정해주는 연산
				- 파일의 시작 부분 또는 현재의 위치 포인터 부분이 아니라 다른 부분부터 읽거나 쓰고 싶을때 
			- open
				- read, write를 하기 위해서는 먼저 open해야한다.
				- 파일의 metadata를 메모리로 올려놓는 작업
			- close
				- file의 read, write 연산이 끝나면 close해야한다.

---

- File attribute (혹은 파일의 metadata)
	- 파일 자체의 내용이 아니라 파일을 관리하기 위한 각종 정보들
		- 파일 이름, 유형, 저장된 위치, 파일 사이즈
		- 접근 권한(읽기/쓰기/실행), 시간(생성/변경/사용), 소유자 등

---

- File System
	- 운영체제에서 파일을 관리하는 부분
		- 파일 자체의 내용, 파일의 메타데이터를 저장
	- 파일 및 파일의 메타데이터, 디렉토리 정보 등을 관리
		- 보통 파일을 저장할 때, 루트 디렉토리부터 계층적으로 저장함.
	- 파일의 저장 방법 결정
	- 파일 보호 등

# 2. Directory and Logical Disk

- Directory
	- 파일의 메타데이터 중 일부를 보관하고 있는 일종의 특별한 파일
		- 디렉토리 파일의 내용은 해당 디렉토리 밑에 존재하는 파일들의 메타데이터를 내용으로 함.
		- 디렉토리 파일의 메타데이터 파일과 동일함 (디렉토리 파일 이름, 유형, 저장된 위치 등)
	- 그 디렉토리에 속한 파일 이름 및 파일 attribute들
	- operation
		- search for a file, create a file, delete a file
		- list a directory, rename a file, traverse the file system
			- traverse the file system
				- 파일 시스템 전체를 탐색

---

- Partition (=Logical Disk)
	> 운영체제가 보는 Disk(=Partition)
	- 하나의 (물리적) 디스크 안에 여러 파티션을 두는게 일반적
	- 여러 개의 물리적인 디스크를 하나의 파티션으로 구성하기도 함
	- (물리적) 디스크를 파티션으로 구성한 뒤 각각의 파티션에 file system을 깔거나 swapping 등 다른 용도로 사용할 수 있음
		- 디스크의 용도를 크게 File system 용도, swap area 용도로 나누어볼 수 있음.

# 3. Operation

## A. Open()

> 파일의 메타데이터를 메모리로 올려놓는 것.

파일의 메타데이터에는 파일의 저장 위치도 같이 저장되어 있다.

파일을 open하게 되면 file의 metadata가 메모리로 올라오게 된다.

!![](/bin/OS_image/os_10_1.png)

- open("/a/b/c")
	- 디스크로부터 파일 c의 메타데이터를 메모리로 가지고 옴
	- 이를 위하여 directory path를 search
		- 루트 디렉토리 "/"를 open하고 그 안에서 파일 "a"의 위치 획득
		- 파일 "a"를 open한 후 read하여 그 안에서 파일 "b"의 위치 획득
		- 파일 "b"를 open한 후 read하여 그 안에서 파일 "b"의 위치 획득
		- 파일 "c"를 open한다.
	- Directory path의 search에 너무 많은 시간 소요
		- Open을 read / write와 별도로 두는 이유임.
		- 한번 open한 파일은 read / write 시 directory search 불필요
	- Open file table
		- 현재 open된 파일들의 메타데이터 보관소 (in memory)
		- 디스크의 메타데이터보다 몇 가지 정보가 추가
			- Open한 프로세스의 수
			- File offset
				- 파일 어느 위치 접근 중인지 표시 (별도 테이블 필요)
	- File descriptor (file handle, file control block)
		- Open file table에 대한 위치 정보 (프로세스 별)

!![](/bin/OS_image/os_10_2.png)

1. 사용자 프로그램이 `/a/b`라는 파일을 open()하겠다.
	- open()도 system call이라서 CPU 제어권이 운영체제에게 넘어감.
		- 운영체제에는 각 프로세스별로 관리하기 위한 자료구조(PCB)가 있고, 전체 프로그램들이 Open한 파일들이 어떤 것인지를 관리하는 global한 테이블이 유지된다.
2. root 디렉토리의 metadata를 메모리에 올림.
	- 운영체제는 root 디렉토리의 metadata를 알고있음.
	- root를 먼저 open함
	- metadata에는 그 파일의 위치 정보가 있음.
3. root 디렉토리의 위치로 이동함.
	- root는 디렉토리 파일이기 때문에 내용으로 디렉토리 밑에 있는 파일들의 metadata를 가지고 있음
	- root 디렉토리의 내용에 가면 `a`라는 파일의 metadata가 있음.
4. a 파일의 metadata를 메모리에 올림.
	- a를 open한 것.
	- a의 file system 상의 위치 정보가 들어 있음
5. a의 file system상의 위치 정보로 이동함.
	- b 파일의 metadata를 가지고 있음
6. b 파일의 metadata를 메모리에 올림.
7. open이 끝난 것임.
8. `fd = open("/a/b")`로 system call을 했기 때문에 결과값을 리턴받음
	- 각 프로세스마다 그 프로세스가 open한 파일들에 대한 메타데이터 포인터를 가지고 있는 배열이 정의되어 있음 (PCB에)
	- 지금 open한 b라는 파일의 metadata의 위치를 가리키는 포인터가 PCB에 존재하는 배열에 만들어짐.
	- 이 배열에서 몇 번째 인덱스인지가 b라는 파일의 [[파일 디스크립터(file descriptor))가 되서 사용자 프로세스한테 리턴함 (`fd = open("/a/b")` 이 부분에서 `fd`로 리턴)
9.  이제부터는 b라는 파일에 대해서 read, write하기위해 논리적 디스크에 접근하지 않아도 됨.
	- b 파일의 위치는 b의 metadata를 보면 나와있음.
	- b의 metadata는 이미 메모리에 올라와있음.
		- 이 위치를 file descriptor가 가지고 있음
	- 사용자 프로세스는 file descriptor 숫자만 가지고 read, write 요청을 할 수 있음
10. 파일 이름을 read할 때 아규먼트(인자)로 적는게 아니라 open한 다음에 file descriptor를 적어준다.
	- 이때, 얼만큼 읽어오는지를 read System Call에 적어줌.
11. read() 요청은 System Call을 한거니까 CPU의 제어권이 운영체제한테 넘어감.
	- 프로세스 A가 fd(file descriptor)를 가지는 파일에서 무엇을 읽어오라고 했네?
	- 프로세스 A의 PCB에 가서 해당 descriptor에 대응하는 file의 metadata부분을 open file table에서 따라간 다음에 그 파일의 위치 정보(metadata에 저장되어 있음)로 가서 시작 위치부터 프로세스 A가 요청한 용량만큼 읽어온다.
12. b의 내용을 읽어서 사용자 프로세스한테 직접 주는 것이 아니고, 자신(운영체제)의 메모리 공간 일부에 먼저 읽어놓는다.
13. 그 후, 사용자 프로그램한테 12번의 내용을 copy해서 전달해준다.

---

- buffer cache
	- b의 내용이 운영체제 메모리 공간에 있을때, 다른 사용자 프로그램이 동일한 파일을 요청하면 DISK까지 가지 않고 이전에 운영체제가 읽어둔 내용을 알려줌.

---

- paging
	- 이미 메모리에 올라와있는 페이지에 대해서는 운영체제는 간섭하지 못하고 하드웨어가 주소변환을 해줌.
	- page fault가 발생하면 CPU 제어권이 운영체제한테 넘어가서 운영체제가 swap area에서 페이지를 읽어옴.
- file에 대한 read, write를 하는 system
	- buffer cache를 운영체제가 가지고 있음.
	- buffer cache는 요청한 내용이 buffer cache에 있든 없든, 운영체제한테 CPU 제어권이 넘어감.
		- open, read, write도 전부 System Call이기 때문에 CPU 제어권은 운영체제에 넘어감.
			- 운영체제가 판단하기에 이미 가져온 것이 있으면 그 내용을 전달.
			- 없으면 논리적 디스크에서 읽어와서 buffer cache에 올려두고 copy해서 사용함.
	- 모든 정보를 운영체제가 알 수 있기 때문에, LRU 알고리즘이나 LFU 알고리즘을 자연스럽게 사용할 수 있음.

---

위 그림에서

> 구현에 따라서 table이 2개 혹은 3개일 수 있음

- per-process file descriptor table
	- 프로세스마다 가지고 있는 file descriptor table
	- table이 프로세스마다 별개로 있음
- System-wide open file table
	- 파일들의 metadata를 가지는 table
		- 파일을 open하면 open된 파일들의 목록을 프로세스마다 가지고 있는 것이 아니라, system wide하게 한꺼번에 관리함.
		- 테이블이 global하게 한 개 있음
	- 프로세스마다 파일의 어느 위치를 가리키고 있는지에 대한 table
		- 현재 이 프로세스가 이 파일의 어느 위치를 가리키고 있는지에 대한 offset
		- table이 프로세스마다 별개로 있음

# 4. File Protection

> 파일의 접근 권한 (파일을 보호하는 것과 관련됨)

- 메모리에 대한 접근 권한 (Memory에 대한 protection)
	- read, write 권한이 있느냐 없느냐만 언급함.
	- 메모리는 프로세스마다 별도로 가지기 때문에 자기 혼자밖에 못봄
	- 메모리에 대한 protection은 접근 권한(연산)이 무엇인가? (write할 수 있는 페이지인가 read만할 수 있는 페이지인가)
- 파일에 대한 Protection
	- 이 파일을 여러 사용자 또는 여러 프로그램이 같이 사용할 수 있음
	- 따라서, 접근 권한이 누구한테 있느냐는 것과 접근 연산이 어떠한 것이 가능한가? 이 두가지를 같이 가지고 있어야함.

각 파일에 대해 누구에게 어떤 유형의 접근(read/write/execution)을 허락할 것인가?

## A. Access Control 방법

> 파일의 protection과 관련해서 접근 권한을 제어하는 방법은 크게 3가지가 있다.

### a. Access control Matrix

!![](/bin/OS_image/os_10_3.png)

> 행렬이 희소행렬(sparse matrix)가 될 것이다.

> 부가적인 오버헤드가 크다.

파일들이 엄청 많지만, 특정 사용자만 사용하려고 만든 파일들이 있을 경우 다른 사용자는 접근 권한이 전혀 없을 것이다. 근데 행렬의 칸을 다 만들면 낭비가 된다.

그래서 이런 방식으로 하지 않고, Linked List형태로 만드는 방법을 생각할 수 있다.

주체를 누구로 하느냐에 따라 2가지로 생각할 수 있다.

1. Access control list (ACL)
	- 파일별로 누구에게 어떤 접근 권한이 있는지 표시
	- 파일을 주체로 하여 그 파일에 대해 접근 권한이 있는 사용자들을 Linked List로 묶어놓는 것.
2. Capability
	- 사용자별로 자신이 접근 권한을 가진 파일 및 해당 권한 표시
	- 각각의 사용자를 중심으로 이 사용자에 대해서 접근 권한들이 있는 파일들을 Linked List 형태로 파일 목록을 연결해둠.

어떠한 경우에도 Access control list나 capability 중 하나만 있으면 됨. Access control list라면 파일을 기준으로 사용자가 접근 권한이 있는지를 확인하고, Capability면 사용자를 기준으로 파일에 접근 권한이 있는지를 확인한다.

### b. Grouping

> 일반적인 운영체제에서 사용하는 방식

- 전체 user를 owner, group, public의 세 그룹으로 구분
	- 이 파일의 소유주에 대해서 접근권한이 rwx 중 어떤 것이 있는지를 표시함.
	- 이 사용자와 동일 그룹에 속한 사용자들에 대해서 rwx 권한이 있는지 표시.
	- 나머지 외부 사용자에 대해서 rwx 권한이 있는지 표시.
- 각 파일에 대해 세 그룹의 접근 권한(rwx)을 3비트씩으로 표시
	- 파일 하나에 대해서 접근 권한을 나타내기 위해 9비트만 있으면 됨.

```ad-example

UNIX

!![](/bin/OS_image/os_10_4.png)

```

### c. Password

> 모든 파일, 디렉토리에 대해 패스워드를 둠.
> 접근 권한별로 패스워드를 둬야될 필요가 있을것임.
> > 패스워드가 굉장히 여러가지가 생겨서 사람들이 기억하기가 어려워짐.

- 파일마다 password를 두는 방법
	- 디렉토리 파일에 두는 방법도 가능
- 모든 접근 권한에 대해 하나의 password 
	- all-or-nothing
- 접근 권한별 password
	- 암기 문제, 관리 문제가 발생할 수 있음

# 5. File System의 Mounting

하나의 물리적 디스크는 여러개의 파티션(논리적 디스크)으로 나눌 수 있음

각각의 논리적 디스크에는 file system을 설치해서 사용할 수 있음

![](/bin/OS_image/os_10_5.png)
 
만약 다른 partition에 설치되어 있는 file system에 접근해야한다면. Mounting 연산을 사용한다.

- Mounting
	- 루트 file system의 특정 디렉토리 이름에 또 다른 partition에 있는 file system을 mount 해주면 된다.
	- 그 mount된 디렉토리에 접근하게 되면 또 다른 file system에 root 디렉토리에 접근하는 것이 된다.

!![](/bin/OS_image/os_10_6.png)

> 서로 다른 partition에 존재하는 file system을 접근할 수 있게 된다.

# 6. Access Methods

> 파일을 접근하는 방법에 대한 내용

- 시스템이 제공하는 파일 정보의 접근 방식
	- 순차 접근 (sequential access)
		- 카세프 테이프를 사용하는 방식처럼 접근
		- 읽거나 쓰면 offset은 자동적으로 증가
		```ad-example

		A, B, C가 있을때
		C를 듣기 위해서는 A, B를 들어야함.

		```

	- 직접 접근 (direct access, random access) (=임의 접근)
		- LP 레코드 판과 같이 접근하도록 함
		- 파일을 구성하는 레코드를 임의의 순서로 접근할 수 있음
		- 특정 위치에 접근한 다음에 다른 위치로 접근하는 것이 가능함
		```ad-example

		A, B, C가 있을때
		C를 듣기 위해서 A, B를 건너뛰고 바로 들을 수 있음.

		```
		- 직접 접근이 되는 매체라도 관리를 어떻게 하느냐에 따라서 순차접근만 가능한 경우도 있다.

# 참고자료

[1] 반효경, [이화여자대학교 :: CORE Campus (ewha.ac.kr)](https://core.ewha.ac.kr/publicview/C0101020140408134626290222?vmode=f). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Dec 2, 2021)
