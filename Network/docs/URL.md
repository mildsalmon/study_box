# Table of Contents

- [b. URL (Universal Resource Locator)](#b-url-universal-resource-locator)
  - [예) http://formal.kau.ac.kr/comnet/](#예-httpformalkauackrcomnet)
  - [예2) http://formal.kau.ac.kr:8080/](#예2-httpformalkauackr8080)

---

# b. URL (Universal Resource Locator)

> 네트워크 상에서 자원이 어디 있는지(위치)를 알려주기 위한 규약

> Web Server의 특정 프로세스에 접근하기 위해서는 IP주소와 Port번호를 알아야 한다.
> > 호스트 이름을 통해서 IP를 추적할 수 있다.
> > 포트번호를 따로 입력하지 않으면, 프로토콜의 약속된 포트번호를 사용한다.

- URL 뒤에(? 뒤에) 인자가 없음

#### 예) http://formal.kau.ac.kr/comnet/

1. http:
	- 프로토콜 이름
		- 이 리소스를 이용하고자 할때, 사용하는 세션 layer의 프로토콜 이름
		- 프로토콜 이름이 바뀌면 resource locator의 뒷부분도 다 바뀐다.
2. //formal.kau.ac.kr
	- //
		- url의 시작을 의미
	- formal.kau.ac.kr
		- 호스트 이름
		- IP주소를 사람이 기억하기 쉽게 표현
		- 큰 개념은 뒤에 있음.
			- kr이 맨 뒤에 있는 것처럼.
3. /comnet/
	- 호스트 안에서 실제로 자원이 존재하는 위치(path)
	- 최상위 디렉토리 밑에 있는 comnet 디렉토리를 가져온다.
		- comnet 뒤에 /가 있어서 디렉토리를 의미함.

#### 예2) http://formal.kau.ac.kr:8080/

1. http:
	- 프로토콜 이름
		- 이 리소스를 이용하고자 할때, 사용하는 세션 layer의 프로토콜 이름
		- 프로토콜 이름이 바뀌면 resource locator의 뒷부분도 다 바뀐다.
2. /formal.kau.ac.kr:8080
	- 호스트 이름\[:포트번호\]
		- 포트번호는 생략할 수 있다.
		- 1번에 http를 사용하는데, 이는 기본적으로 80번 포트를 사용하기 때문.
3. /
	- root 디렉토리