# 1. 프로세스 생성 (Process Creation)

- 부모 프로세스(Parent process)가 자식 프로세스(children process)생성
- 프로세스의 트리(계층 구조)형성
- 프로세스는 자원을 필요로 함
	- 운영체제로부터 받는다.
	- 부모와 공유한다.
- 자원의 공유
	- 부모와 자식이 모든 자원을 공유하는 모델
		### Copy-on-write (COW)
		- 리눅스같은 운영체제는 부모와 자식이 공유할 수 있는 것은 copy하지 않고 공유한다. PC만 copy해서 똑같은 위치를 가리킨다.
		- 이렇게 실행하다가, 부모와 자식의 내용이 달라지면, 부모와 공유하던 메모리 공간을 copy해서 자식이 갖는다.
	- 일부를 공유하는 모델
	- 전혀 공유하지 않는 모델 (일반적인 모델)
- 수행 (Execution)
	- 부모와 자식은 공존하며 수행되는 모델
	- 자식이 종료(terminate)될 때까지 부모가 기다리는(wait) 모델
- 주소 공간 (Address space)
	- 자식은 부모의 공간을 복사함 (binary and OS data)
	- 자식은 복제한 공간에 새로운 프로그램을 올림
- 유닉스의 예
	- **fork()** 시스템 콜이 새로운 프로세스를 생성
		- 부모를 그대로 복사 (OS data except PID + binary)
		- 주소 공간 할당
	- fork 다음에 이어지는 **exec()** 시스템 콜을 통해 새로운 프로그램을 메모리에 올림

# 2. 프로세스 종료 (Process Termination)

### a. 자발적으로 스스로 프로세스가 종료될 때

- 프로세스가 마지막 명령을 수행한 후 운영체제에게 이를 알려줌 (**exit**)
	- 자식이 부모에게 output data를 보냄 (via **wait**)
		- 부모 프로세스보다 자식 프로세스가 먼저 죽어야함.
	- 프로세스의 각종 자원들이 운영체제에게 반납됨

### b. 비자발적으로 프로세스가 종료되는 경우

- 부모 프로세스가 자식의 수행을 종료시킴 (**abort**)
	- 자식이 할당 자원의 한계치를 넘어섬
	- 자식에게 할당된 테스크가 더 이상 필요하지 않음
	- 부모가 종료(exit)하는 경우
		- 운영체제는 부모 프로세스가 종료하는 경우 자식이 더 이상 수행되도록 두지 않는다.
		- 단계적인 종료
			- 부모가 죽을때, 자식의 자식까지 다 단계적으로 죽이고 부모를 죽임.

# 3. fork() 시스템 콜

- A process is created by the **fork()** system call
	- creates a new address space that is a duplicate of the caller.

> 프로세스의 fork를 통한 복제 생성은 부모 프로세스의 문맥(context, 정확히는 PC)을 복사해서 사용한다.

- fork를 하면 fork() 함수의 결과값으로 자식하고 부모를 구분해준다.
	- 부모 프로세스는 자식 프로세스의 pid(eg. 주민등록번호)를 얻는다.
	- 자식 프로세스는 fork() 함수의 결과값으로 0을 받는다.

```ad-note

Parent process
	pid > 0

Child process
	pid = 0

```


```c

int main()
{
	int pid;
	pid = fork();
	if (pid == 0) // this is child
		printf("\n Hello, I am child!\n");
	else if (pid > 0)  // this is parent
		print("\n Hello, I am parent!\n");
}

---

부모 프로세스 -> Hello, I am parent!
자식 프로세스 -> Hello, I am child!

```

```c

int main()
{
	int pid;
	printf("\n HaHa\n");
	pid = fork();
	if (pid == 0) // this is child
		printf("\n Hello, I am child!\n");
	else if (pid > 0)  // this is parent
		print("\n Hello, I am parent!\n");
}

---

부모 프로세스 -> HaHa
				Hello, I am parent!
자식 프로세스 -> Hello, I am child!

```

# 4. exec() 시스템 콜

- A process can execute a different program by the **exec()** system call.
	- replaces the memory image of the caller with a new program

> 어떤 프로그램을 새로운 프로세스로 태어나게 하는 역할을 한다.

- exec() 하면 프로그램의 시작 부분부터 실행하게 된다.
	- 한번 exec()하면 다시 되돌아갈 수 없다.
	- 반드시, 자식을 만들고 exec() 할 필요는 없다.
		- 부모 프로세스에서도 exec() 할 수 있다.
			- 이 경우, exec() 이후에 나오는 코드는 실행되지 않는다.

```c

int main()
{
	int pid;
	pid = fork();
	if (pid == 0) // this is child
	{
		printf("\n Hello, I am child! Now I'll run date\n");
		execlp("/bin/date", "/bin/date", (char *) 0);
	}
	else if (pid > 0)  // this is parent
		print("\n Hello, I am parent!\n");
}

---

부모 프로세스 -> Hello, I am parent!
자식 프로세스 -> Hello, I am child! Now I'll run date
				exec() 시스템 콜 호출됨.

```

```c

int main()
{
	printf("1");
	execlp("echo", "echo", "3", (char *) 0);
	printf("2");
}

---

1
3

```

# 5. wait() 시스템 콜

- 프로세스 A가 wait() 시스템 콜을 호출하면
	- 커널은 child가 종료될 때까지 프로세스 A를 sleep시킨다. (block 상태)
	- child process가 종료되면 커널은 프로세스 A를 깨운다. (ready 상태)

![](/bin/OS_image/os_4_1.png)

```ad-example

리눅스 쉘에서 프롬프트가 깜빡이는 것.
명령을 실행하면 자식 프로세스를 만들어서 실행하고, 부모 프로세스인 쉘의 프롬프트는 깜빡이지 않는다.
자식 프로세스의 작업이 끝나면, 쉘의 프롬프트가 다시 깜빡인다.

```

# 6. exit() 시스템 콜

## A. 프로세스의 종료

### a. 자발적 종료

- 마지막 statement 수행 후 exit() 시스템 콜을 통해 프로그램에 명시적으로 적어주지 않아도 main 함수가 리턴되는 위치에 컴파일러가 넣어줌

### b. 비자발적 종료

> 부모 프로세스 혹은 사람이 종료시킴, (외부에서 종료시킴)

- 부모 프로세스가 자식 프로세스를 강제 종료시킴
	- 자식 프로세스가 한계치를 넘어서는 자원 요청
	- 자식에게 할당된 테스크가 더 이상 필요하지 않음
- 키보드로 kill, break 등을 친 경우
- 부모가 종료하는 경우
	- 부모 프로세스가 종료하기 전에 자식들이 먼저 종료됨.

# 7. 프로세스와 관련한 시스템 콜

- fork()
	- create a child (copy)
- exec()
	- overlay new image
- wait()
	- sleep until child is done
- exit()
	- frees all the resources, notify parent

# 8. 프로세스 간 협력

## A. 독립적 프로세스 (Independent process)

프로세스는 각자의 주소 공간을 가지고 수행되므로 원칙적으로 하나의 프로세스는 다른 프로세스의 수행에 영향을 미치지 못함

## B. 협력 프로세스 (Cooperating process)

프로세스 협력 메커니즘을 통해 하나의 프로세스가 다른 프로세스의 수행에 영향을 미칠 수 있음

## C. 프로세스 간 협력 메커니즘 (IPC, Interprocess Communication)

### a. 메시지를 전달하는 방법

![](/bin/OS_image/os_4_2.png)

#### 1) message passing

> 커널을 통해 메시지 전달

```ad-example

프로세스 A가 프로세스 B한테 메시지를 전달하고, 그 영향을 받아서 프로세스 B가 실행되고, 프로세스 B가 실행되다가 필요하면 프로세스 A한테 메시지를 전달하는 것.

```

다만, 프로세스는 원래 독립적(자기 메모리 공간만 볼 수 있음)이다. 내가 다른 프로세스에 직접 메시지를 전달할 수 있는 방법도 원칙적으로는 없다. 

그래서 커널을 통해서 메시지를 전달한다. 중간에 커널이 메신저 역할을 해주는 것.

##### ㄱ) Message System

프로세스 사이에 공유 변수(shared variable)를 일체 사용하지 않고 통신하는 시스템

##### ㄴ) Direct Communication

통신하려는 **프로세스의 이름을 명시적**으로 표시

![](/bin/OS_image/os_4_3.png)

##### ㄷ) Indirect Communication

mailbox(또는 port)를 통해 **메시지를 간접 전달**

![](/bin/OS_image/os_4_4.png)


### b. 주소 공간을 공유하는 방법

> 커널한테 shared memory를 쓴다고 system call을 해서 맵핑을 해놓고 share를 하게 해놓은 다음에 사용자 프로세스끼리 영역을 공유한다.

> shared memory를 사용하려면, 두 프로세스는 서로 신뢰할 수 있는 관계여야만 한다.

- shared memory
	- 서로 다른 프로세스 간에도 일부 주소 공간을 공유하게 하는 shared memory 메커니즘이 있음

---

- thread
	- thread는 사실상 하나의 프로세스이므로 프로세스 간 협력으로 보기는 어렵지만 동일한 process를 구성하는 thread들 간에는 주소 공간을 공유하므로 협력이 가능.

 

# 참고자료

[1] 반효경, [Process Management 1](javascript:void(0);). kocw. [운영체제 - 이화여자대학교 | KOCW 공개 강의](http://www.kocw.net/home/cview.do?cid=3646706b4347ef09). (accessed Nov 25, 2021)
