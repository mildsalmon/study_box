# 1. TCP 세그먼트 내 헤더 구성

> TCP는 [[패킷]]이 아닌 [[세그먼트]]라고 부른다.

TCP 세그먼트 내의 헤더는 바이너리 형태로 되어 있음.

32bit으로 끊어서 생각한다.

![](/bin/Network_image/network_5_31.png)

## A. Source/Destination Port Number (각 16 비트)

> IP 주소 + 포트 번호 = 소켓 주소
> > 양쪽 호스트 내 종단 프로세스 식별

- 포트([[Application Layer|응용]])을 구분하고, 거기에 들어가는 각각의 요청에 대한 소켓을 구분하기 위한 용도로 사용하는 것이 TCP의 포트번호임.

### a. 소켓 vs 포트

소켓 여러개가 하나의 포트에 연결될 수 있음.

![](/bin/Network_image/network_5_18.png)

하나의 웹 서버에 여러개의 클라이언트가 연결되는 것처럼.

#### 1) 예제

![](/bin/Network_image/network_5_32.png)

![](/bin/Network_image/network_5_33.png)

![](/bin/Network_image/network_5_34.png)

![](/bin/Network_image/network_5_35.png)

![](/bin/Network_image/network_5_36.png)

## B. Sequence Number (32 비트)

- 바이트 단위로 구분되어 순서화되는 번호
	- 이를 통해, TCP에서는 신뢰성 및 흐름제어 기능 제공
	- Byte마다 번호를 붙인다.
		- '몇번째 Byte인가?'에 해당하는 Byte번호
- 순서번호 의미
	- TCP 세그먼트의 첫번째 바이트에 부여되는 번호

## C. Acknowledgement Number (32 비트)

- 수신하기를 기대하는 다음 바이트 번호
	- 마지막 수신 성공 순서번호 + 1
- 바이트 단위로 구분되어 순서화되는 번호.

### a. Seq \#, Ack \#

![](/bin/Network_image/network_5_20.png)

---

- seq = 42
	- 42번 문자부터 보내고 있음
- ack = 77
	- 76번 Byte까지 받았고, 77번 Byte를 받을 차례
- Hello
	- 42 / 43 / 44 / 45 / 46번 문자

---

TCP 안에 아무런 문자도 갖지 않는 패킷도 보낼 수 있다.

> ACK만 존재하는 패킷

---

네트워크의 통신을 아끼기 위해서 0.5초 정도 기다린다.

---

- [[Go-Back-N]] 기법에 기반함

## D. 헤더 길이 필드 (Header Length / HLEN, 4 비트)

- TCP 헤더 길이를 4바이트 단위로 표시
	- 따라서, TCP 헤더 길이는 4 \* (2^4 - 1) = 60 바이트 이하

## E. flag bits (URG, ACK, PSH, RST, SYN, FIN)

- TCP 세그먼트 전달과 관련되어 TCP 회선 및 데이터 관리 제어 기능을 하는 플래그

### a. 관계된 기능

- 흐름제어
- 연결설정
- 연결종료
- 연결리셋
- 데이터전송모드

## F. 윈도우 크기 (Window size, 16 비트)

- 흐름 제어를 위해 사용
	- TCP 흐름제어를 위해 송신자에게 자신의 수신 버퍼 여유용량 크기를 지속적으로 통보
		- TCP 연결은 양방향이므로, 매 TCP 세그먼트를 보낼때 마다 통보함
		- 이 필드에 자신의 수신 버퍼 용량 값을 채워 보내게 됨
	- 결국, 양방향 각각의 수신측에 의해 능동적으로 흐름제어를 수행하게 됨.

---

- 수신 가능한 버퍼 크기
	- receive window의 크기가 크다면 (65,535 bytes)
		- 버퍼가 아주 크게 있으니까, 마음껏 보내라는 의미
	- receive window의 크기가 0이라면
		- 더 이상 받을 수 없으니 그만보내라고 송신쪽에 말하는 것.
		- 송신쪽에서 데이터를 보내도 내쪽에서는 받을 수 없음.

![](/bin/Network_image/network_5_17.png)

- 운영체제의 고전적인 특징
	- 패킷이 왔을때, 위쪽 계층에서 아래쪽 계층에 요청하기 전에, 아래쪽 계층에서 위쪽 계층에게 패킷을 보내주는 경우는 굉장히 드물다.

### a. 만약, 수신측의 buffer가 꽉 차면.

- 송신측에서 패킷을 더 보내봤자 그 패킷은 버려질수밖에 없음.
- 그렇기에 buffer에 공간이 부족한데도 패킷을 계속 보내게되면 네트워크가 낭비되게 된다.
- 이를 막기 위해 receive window 필드가 존재한다.

## G. checksum

> 검사합

- 내용 변조 탐지

---

TCP 세그먼트는 헤더와 payload(바디)로 나뉜다.

전체를 다 더했을때 최종 결과가 1로만 이루어져 있도록(11111111) checksum 부분을 조작한다.

checksum을 뺀 부분의 덧셈 결과(101101110100)를 반전시켜서(1의 보수) checksum(010010001011)을 만든다.

그리고 최종적으로 checksum을 뺀 부분의 덧셈과 checksum을 더하면 최종 결과는 1로만 꽉 차게 된다.

---

중간에 노이즈나 간섭(interference)을 제어하여 내용 변조를 탐지한다.

### a. 검사합 (checksum 더하기)

![](/bin/Network_image/network_5_21.png)

## H. payload

- 실제 의미를 갖는 내용