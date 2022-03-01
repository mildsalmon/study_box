# 1. IP

## A. IPv6

- 128bit 주소체계
- 8bit를 16진수로 끊어서 사용
	- 2001:0DB8:0000:0000:0000:0000:1428:57ab

## B. IPv4

- 32bit 주소체계
- 8bit를 10진수로 끊어서 사용
	- 192.67.132.45

# 2. IP 주소체계

## A. 주민등록번호처럼 부여하면?

```ad-example

- 전화 (Circuit Switching)
  - 경로를 미리 만들어놓고 나중에 재사용한다.
  - 연결비용과 무관

```

### a. 문제점

- **IP 개수가 부족**함.

### b. 만약 IP 개수가 충분하다면?

- 개별 등록 엔트리 수가 너무 많다.
- 라우팅 테이블이 너무 커진다. (관리가 어렵다.)

## B. 우편주소체계(보편주소체계)로 만들면?

> 국가/도시/동/...

### a. 문제점

- IP가 ISP에 따라 바뀔 수 있다.
- 고정 IP의 경우 모든 컴퓨터 설정을 바꿔야 한다.
- IP 갯수 부족
	- 넉넉한 IP 할당이 요구됨

## C. Classless Inter Domain Routing (CIDR)

- 계층적
	- 목적지에서 멀리 떨어져 있으면, 상대적으로 큰 범위를 보고, 목적지에서 가까우면 상대적으로 좁은 범위를 보고 목적지를 찾아간다.

### a. 문제점

- 계층적인 방법을 사용하면 보편주소체계의 문제점이 그대로 적용된다.
	- IP를 새로 할당받기는 어려우니, 기존에 사용하던 IP를 재사용하되 위치를 옮겨야하는 경우에 발생하는 문제.

### b. 해결방안

- 계층 예외를 두는 것을 가능하게 한다.
	- 완전히 계층적이지 않음.
- [[subnet]]

# 3. IP 헤더

![](/bin/Network_image/network_7_12.png)

## A. 헤더 길이

- 맨 마지막에 optional 필드가 생길 수 있기 때문에 헤더 길이를 고정적으로 줌

## B. fragment

- [Transport Layer](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Transport%20Layer.md)에서는 TCP를 세그먼트 단위로 쪼개서 길이를 조절할 수 있지만, [Network Layer](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Network%20Layer.md)에서는 TCP인지 UDP인지 모르는 상태로 한 조각을 받는다.
	- [TCP](http://github.com/mildsalmon/Study/blob/Network/Network/docs/TCP.md)는 조각내도 되지만, [UDP](http://github.com/mildsalmon/Study/blob/Network/Network/docs/UDP.md)는 조각내면 안됨.
- 각 layer는 위에 있는 layer가 준 내용이 어떤 내용인지 모르기 때문에 그대로 상위 layer에게 전달해야함.
	- 송신측에서 한 덩어리를 주면, 수신측에서도 한 덩어리를 올려줘야함.
		> 즉, 한 덩어리는 중간에 조각을 내더라도 한 덩어리로 올려줘야함
		> > fragment를 통해 임의로 조각낸 것을 수신측에서 조합하기 위함

---

- UDP는 UDP layer 내에서도 application layer가 내려준 패킷을 임의로 자를 수 없다.
	- 전송 단위가 패킷이기 때문
	- IP layer도 패킷을 임의로 자를 수 없음

### a. 라우터의 역할

> 서로 다른 [Data-Link Layer](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Data-Link%20Layer.md)를 연결해준다.

![](/bin/Network_image/network_7_13.png)

- IP 패킷의 크기가 4000 Byte라면
	- IP 패킷 헤더의 기본 크기는 20 Byte
	- IP 데이터그램의 본문은 3980 Byte

![](/bin/Network_image/network_7_14.png)

![](/bin/Network_image/network_7_15.png)

- IP Layer에서는 패킷이 잘 갔는지 안갔는지 관여하지 않는다.
	- time out될 때까지 뭔가 빠진게 있으면 그냥 버림
	- 그럼 TCP layer에서는 RTO 안에 ACK가 오지 않으니 패킷을 재전송한다.
- UDP는 하나라도 빠지면 전체를 버린다.
	- UDP는 fragment된 패킷이 전부 도착하지 않으면 버린다.
	- Whole OR Not thing (전부 가거나, 전부 가지 않거나)
- UDP는 datagram으로 송신측에서 보낸 것을 수신측에서 한번에 다 처리해야 한다.
	- 전송 단위가 datagram이기 때문에 중간것이 오지 않으면 전체를 버린다.

## C. TTL (Time to Live)

- 남은 수명
- 1 hop마다 1씩 감소
- 0이 되면 버림 (Trash)
- 패킷이 너무 오랫동안 살아남는 것을 막기 위해 사용
- broadcast packet의 범위를 조절하기 위해 사용
	- 목적지가 없는 패킷
	- 네트워크 전체로 뿌리는 패킷

## D. upper layer

- TCP인지 UDP인지?
- 상위 layer에는 어떤 것을 사용하는가?

## E. header checksum

- IPv6에서는 사라짐
	- TCP 헤더에도 checksum이 있음
		- TCP 헤더와 IP 헤더에서 checksum을 진행하다보니 checksum 연산이 너무 많아진다. (이중과세 처럼)
		- 그래서 TCP checksum을 계산할때는 IP에 있는 내용을 전부 포함해서 checksum을 만든다.
			- 원래 TCP layer에서는 IP layer를 보면 안되는데, IP layer의 중요한 부분을 포함해서 TCP checksum을 한다.
	- TCP 헤더의 checksum으로 퉁침
- 헤더 부분에 깨진 부분이 있으면 packet을 버림

## F. Source IP 주소

## G. Destination IP 주소

## H. option

- IPv6에는 본문에 넣어야함

## I. Data (본문)

- IP layer 입장에서의 본문
- TCP 헤더 + 본문 (HTTP 헤더 + 본문)

# 4. IP 할당

- ISP 혹은 기관에서 subnet 영역을 할당받아야지 자신에게 소속된 컴퓨터에게 IP를 할당할 수 있음
	- subnet 영역을 할당받으려면 ICANN^[IP를 관리하는 국제 기구, Internet Corporation for Assigned Name & Numbers]에 요청해야 함.
- 서버운영시 static IP를 ISP 또는 기관에 요청하여 할당받음
	- 기계에 수동으로 입력한다.

## A. DHCP (Dynamic Host Configuration Protocol)

> 컴퓨터를 여러대 사용하더라도 네트워크를 사용하지 않을 때에는 연결되어 있지 않기 때문에 조금 더 유동적으로 IP를 사용하여, IP 사용 효율을 높일 수 있다.

- 처음에는 IP가 없어서 IP packet으로는 통신할 수 없다.
	- IP packet은 그 안에 source addr가 들어가야 한다.

1. 클라이언트에서 DHCP 서버에게로 `Host ID / IP 요청 / Broadcast` 전송
	- `src : 0.0.0.0 / dest : 255.255.255.255`
	- IP 중에 특수 목적으로 지정된 IP들이 있음. 그 중 하나가 255.255.255.255
		- 255.255.255.255 (Broadcast, 모든 노드가 다 듣도록하는 IP 주소)
	- TCP는 1:1 통신밖에 안되기 때문에 UDP로 보내야 한다.
	- TTL을 설정하여 몇 hop까지 전송할지를 설정해야함.
	- 모든 노드가 듣게 되면, DHCP 서버도 듣게 될 것이다.
2. DHCP 서버에서 클라이언트에게로 `Host ID / IP 응답` 전송
	- DHCP 서버가 남는 IP 중 하나를 골라서 응답한다.
	- host가 처음에 IP를 할당해달라고 요청할 때 보낸 패킷의 `src가 0.0.0.0`이라서 DHCP도 `src : DHCP 서버 주소 / dest : 255.255.255.255`로 보낸다.
	- host가 요청할 때 보낸 ID로 보낸다.
	- host는 DHCP 서버가 Broadcast한 패킷이 자신의 ID로 보낸 것임을 인지하고 IP를 할당받는다.
3. 클라이언트에서 DHCP서버로 `confirm` 전송
	- Host가 broadcast한 범위 내에 여러 개의 DHCP 서버가 있을 수 있다. 그래서 어떤 IP를 사용할 것인지를 DHCP 서버에 전송해야 한다.
4. DHCP서버에서 클라이언트로 `ACK / lease time` 전송
	- DHCP 서버는 ACK 응답과 함께 lease time (계약 기간)을 보낸다.

![](/bin/Network_image/network_7_16.png)

## B. [[NAT]] (Network Address Translation)
