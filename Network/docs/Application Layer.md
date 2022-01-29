- [1. 응용 계층 (Application Layer) - 7계층, 5계층](#1-응용-계층-application-layer---7계층-5계층)
  - [A. OSI 7계층](#a-osi-7계층)
  - [B. TCP/IP 5계층](#b-tcpip-5계층)
- [2. 네트워크 응용의 구조](#2-네트워크-응용의-구조)
  - [A. Client - Server 구조](#a-client---server-구조)
  - [B. Peer - To - Peer (P2P) 구조](#b-peer---to---peer-p2p-구조)
  - [C. 하이브리드 구조](#c-하이브리드-구조)
- [3. 프로세스간 통신](#3-프로세스간-통신)
  - [A. 프로세스의 종류](#a-프로세스의-종류)
  - [B. 프로세스 주소](#b-프로세스-주소)
  - [C. [소켓 통신]](#c-소켓-통신)
- [4. Cookie (쿠키)](#4-cookie-쿠키)
  - [A. [Cookie](쿠키)](#a-cookie쿠키)
  - [B. [Session](세션)](#b-session세션)
  - [C. 예](#c-예)

---

# 1. 응용 계층 (Application Layer) - 7계층, 5계층

## A. OSI 7계층

> 직접적으로 통신과 연결되어 있지 않음

- 분산된 시스템을 하나의 통합된 응용 시스템으로 묶어주는 계층
	- 응용 시스템
		- 구글 검색 시스템
		- 학사정보시스템
		- 네이버 웹툰
		- LOL
	- 분산된 시스템
		- 사용자와 서비스 제공자가 멀리 떨어져 있는 시스템

## B. TCP/IP 5계층

- [[Application Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Application%20Layer.md), [[Presentation Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Presentation%20Layer.md), [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)를 묶어서 표현

---

# 2. 네트워크 응용의 구조

## A. Client - Server 구조

> 응용을 서비스해주는 컴퓨터를 따로 두는 구조

서비스가 안정적으로 동작하길 바라면 선택.

- 장점
	- 서버가 대기하고 있다가 사용자가 접속하면 서비스를 제공해준다.
- 단점
	- 모든 서비스에 서버가 관여할수록 서버에 부하가 높아진다.

- 예
	- 웹 검색

## B. Peer - To - Peer (P2P) 구조

- 예
	- 토렌트

## C. 하이브리드 구조

> 필요시에는 서버와 관리하지만, 클라이언트끼리 연결할 수 있으면, 그냥 연결한다.

서버에 대한 부하가 분산된다.

- 예
	- skype
	- 스타크래프트

# 3. 프로세스간 통신

## A. 프로세스의 종류

- 서버 프로세스
- 클라이언트 프로세스
- 피어 프로세스
	- p2p를 위한 프로세스

---

- 응용
	- 네트워크로 연결된 컴퓨터들이 협력하여 제공하는 서비스
	- 예
		- 구글 검색

		![](/bin/Network_image/network_2_3.png)

- 프로세스
	- 하나의 컴퓨터에서 독립된 메모리공간을 가지고 수행되고 있는 프로그램의 단위

	![](/bin/Network_image/network_2_4.png)

## B. 프로세스 주소

- IP 주소 + 포트 번호
- Server와 Client, 서로의 포트 번호와 IP 주소를 알면 통신이 가능해진다.

---

-  프로세스의 주소
	-  기계 주소 (IP)
		-  xxx.xxx.xxx.xxx
			-  0 ~ 255
			-  172.31.6.4
			-  256^{4} = 2^{32} = 약 40억
	- 포트번호
		- 2^32개
		- 2^16개 - TCP
		- 2^16개 - UDP
		
		![](/bin/Network_image/network_2_5.png)
		
## C. [[소켓 통신]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/%EC%86%8C%EC%BC%93%20%ED%86%B5%EC%8B%A0.md)

# 4. Cookie (쿠키)

## A. [[Cookie]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Cookie.md)(쿠키)

## B. [[Session]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session.md)(세션)

## C. 예

- 몇 번 방문했는지?
	- [[Cookie]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Cookie.md)(쿠키)
		- 클라이언트에 저장
	- [[Session]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session.md)(세션)
		- 서버에 저장
