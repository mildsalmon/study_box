# Table of Contents

- [1. 전송 계층 (Transport Layer) (=비서) - 4계층](#1-전송-계층-transport-layer-비서---4계층)
- [2. 인터넷 전송계층의 서비스](#2-인터넷-전송계층의-서비스)
  - [A. [[TCP]]](#a-tcp)
  - [B. [[UDP]]](#b-udp)
- [3. [[Reliable Network]]](#3-reliable-network)

---

# 1. 전송 계층 (Transport Layer) (=비서) - 4계층

> 직접적으로 통신과 연결되어 있음

> 어떻게 두 단말(end-to-end) 사이에서 신뢰성있는 커뮤니케이션을 할지에 관한 내용이 전송 계층의 주된 내용. (Reliable Network)

- 양 끝단의 전송 품질보장
	- 네트워크는 잡음과 혼잡으로 인해 패킷이 사라질 수 있다.
	- 이때, 모든 패킷이 전송됨을 보장함.
- 신뢰성있는 네트워크의 품질을 제공
- 밑(물리, 데이터링크, 네트워크 계층)에가 부실해도 재전송을 통해서 신뢰성을 보장할 수 있다.

---

전송계층은 end-to-end 프로토콜이다. 전송계층은 중간 단계(네트워크 장비들)장비에 간섭하지 않는다. 양 끝단에 있는 장비에만 간섭한다.

비서같은 역할, 실제로 서비스를 제공하고 받는 부분에만 비서가 존재한다.

전송계층에서 이야기하는 모든 서비스는 양 끝단 해당하는 서비스이다.

# 2. 인터넷 전송계층의 서비스

## A. [[TCP]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/TCP.md)

## B. [[UDP]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/UDP.md)

# 3. [[Reliable Network]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Reliable%20Network.md)
