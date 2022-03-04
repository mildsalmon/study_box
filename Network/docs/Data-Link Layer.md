# Table of Contents

- [1. 데이터 링크 계층 (Data-Link Layer) (=우체부, 기사) - 2계층](#1-데이터-링크-계층-data-link-layer-우체부-기사---2계층)
  - [A. 데이터 링크 계층이 단순하지만 중요한 이유](#a-데이터-링크-계층이-단순하지만-중요한-이유)
  - [B. 예시](#b-예시)
  - [C. 데이터 링크 계층의 서비스](#c-데이터-링크-계층의-서비스)
    - [a. Error detection (에러 탐지), Correction (보정)](#a-error-detection-에러-탐지-correction-보정)
      - [ㄱ) Correction](#ㄱ-correction)
        - [1) 문제](#1-문제)
      - [ㄴ) Error detection (에러 탐지)](#ㄴ-error-detection-에러-탐지)
        - [1) checksum](#1-checksum)
          - [가) detection performance](#가-detection-performance-1)
        - [2) CRC](#2-crc)
    - [b. 채널 공유 프로토콜](#b-채널-공유-프로토콜)
      - [ㄱ) 주파수분할 (FDMA, Frequency Division Multiple Access)](#ㄱ-주파수분할-fdma-frequency-division-multiple-access)
      - [ㄴ) 시 분할 (TDMA, Time Division Multiple Access)](#ㄴ-시-분할-tdma-time-division-multiple-access)
      - [ㄷ) 코드 분할 (CDMA, Code Division Multiple Access)](#ㄷ-코드-분할-cdma-code-division-multiple-access)
        - [1) FDMA, TDMA, CDMA 비교](#1-fdma-tdma-cdma-비교)
        - [2) FDMA, TDMA, CDMA 공통점](#2-fdma-tdma-cdma-공통점)
        - [3) FDMA, TDMA, CDMA 단점](#3-fdma-tdma-cdma-단점)
          - [가) 보통의 통신 패턴](#가-보통의-통신-패턴)
      - [ㄹ) CSMA (Carrier Sense Multiple Access)](#ㄹ-csma-carrier-sense-multiple-access)
        - [1) CSMA의 문제점](#1-csma의-문제점)
      - [ㅁ) 토큰 방식](#ㅁ-토큰-방식)
        - [1) 신호 없이 교차로를 만드는 방법](#1-신호-없이-교차로를-만드는-방법)
      - [ㅂ) 스위치 방식](#ㅂ-스위치-방식)
- [2. Ethernet](#2-ethernet)
  - [A. Frame 형식](#a-frame-형식)
  - [B. HW주소 (HW addr, MAC address)](#b-hw주소-hw-addr-mac-address)
    - [a. 재사용하면 문제되는거 아님?](#a-재사용하면-문제되는거-아님)
    - [b. 서버의 IP는 알고 HW주소를 모를 경우에는?](#b-서버의-ip는-알고-hw주소를-모를-경우에는)
    - [c. Hybrid한 Network](#c-hybrid한-network)
      - [ㄱ) 1번이 10번과 통신하려 할 때 (IP만 알고 HW주소를 모름)](#ㄱ-1번이-10번과-통신하려-할-때-ip만-알고-hw주소를-모름)
      - [ㄴ) 9번이 1번에게 보내려면?](#ㄴ-9번이-1번에게-보내려면)
- [3. Switch](#3-switch)
- [4. Router](#4-router)

---

# 1. 데이터 링크 계층 (Data-Link Layer) (=우체부, 기사) - 2계층

> 직접적으로 통신과 연결되어 있음

- 각 link의 규약
	- ![](/bin/Network_image/network_1_12.png)
- 다음단으로의 전달을 책임짐.
- 패킷을 다음 스위치까지의 전송을 책임지는 layer

---

목적지까지 가기 위해서는 여러 장비(라우터)를 거쳐서 가야함.

- 1 hop의 네트워크를 전송하기 위해서 사용하는 것이 데이터 링크 계층
	- 1 hop의 송신부와 다음 1 hop의 수신부의 통신 기법(프로토콜)은 동일하다

---

데이터 링크 계층은 위에 IP가 올라가는지 알 필요는 없다.  
IP가 아닌 다른 네트워크 계층이 올라갈 수도 있다.

> IP 계층에서 next hop이 어떤 것인지 결정되면 사용해야하는 data link에 맞는 link 헤더를 붙여서 보내주는게 전부임.

![](/bin/Network_image/network_8_2.png)

---

- Link Layer에서는 데이터를 0과 1로 본다.

## A. 데이터 링크 계층이 단순하지만 중요한 이유

전체적인 망의 효율성을 담보로 하는 것이 데이터 링크 계층과 물리 계층임.

링크 계층은 논리적인(송장 붙이기, 차에 적재하기 등) 부분이라면, 물리 계층은 물리적인 이동을 담당함

결과적으로 [Physical Layer](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Physical%20Layer.md)이 속도를 빠르게 하는 역할을 함

## B. 예시

- 이더넷
- wifi
- LTE
- 3G

## C. 데이터 링크 계층의 서비스

### a. Error detection (에러 탐지), Correction (보정)

#### ㄱ) Correction

> 특히 무선 (Turbo code, LDPC)

- 뭔가 안에 이상이 있다고 가정하고 안에 있는 내용들을 섞어서 부풀린다.
- 그럼 원래 문자열이 남아있지 않는 문자열이 만들어진다.

![](/bin/Network_image/network_8_4.png)

f(T)에 역함수를 취하면 $f^{-1}(T')$이라서 T가 나와야한다.

- $f^{-1}(T' + 적은 \space noise)$ 
	- 매개값에 noise가 적으면 원래 T값이 나온다.
- $f^{-1}(T' + 많은 \space noise)$ 
	- 매개값에 noise가 많으면 원래 T값이 나오지 않는다.

---

연산이 많아서 HW로 구현함

---

- Error Correction
	- Physical 계층으로 내려가는 중에 있음
		- Data를 analog로 본다.

##### 1) 문제

$f^{-1}()$ 역함수는 값에 noise가 많이 섞인 것인지 적게 섞인 것인지 모른다.
그냥 역함수만 취해서 원래 것이 복구되면 좋고, 아니면 말고.

그래서 값이 원래 것인지를 확인하는 함수는 따로 필요함.

#### ㄴ) Error detection (에러 탐지)

> CRC, checksum을 이용함

Correction에서 정확하게 탐지하지 못한 에러를 탐지함

##### 1) checksum

> checksum은 TCP와 IPv4에서 검사해줌

> word는 SW에 강점을 갖고 있음

- checksum은 SW에서 많이 사용한다.
	- 연산을 word 단위로 할 수 있기 떄문.
		- 2Byte, 4Byte를 한꺼번에 연산할 수 있음
		- word는 Byte, 16bit, 32bit 등 아무 word나 지정하면 됨.
	- checksum의 크기만큼 뭉텅이로 연산할 수 있음
		- checksum의 크기가 길면 긴 연산을 하면 됨.
		- checksum의 크기가 짧으면 짧은 연산을 하면 됨

###### 가) detection performance

> CRC에 비해서 detection performance가 떨어짐

- CRC가 상대적으로 checksum보다 error detection이 좋다.

##### 2) CRC

> 링크 layer에서는 CRC를 사용한다.

- CRC는 HW로 구현하기 좋음
	- 연산단위가 bit
		- Exclusive OR를 끊임없이 bit단위로 수행한다.
		- bit 단위로 exclusive OR를 하는 연산을 SW에서 빠르게 제공할 방법이 없음

###### 가) detection performance

- checksum에 비해 CRC가 더 좋음

### b. 채널 공유 프로토콜

- 채널
	- 동시에 한명만 사용할 수 있는 미디어의 단위

#### ㄱ) 주파수분할 (FDMA, Frequency Division Multiple Access)

- 주파수를 나눠서 여러명이 접근할 수 있도록 한다.

#### ㄴ) 시 분할 (TDMA, Time Division Multiple Access)

- 시간을 나눠서 여러명이 접근할 수 있도록 한다.

#### ㄷ) 코드 분할 (CDMA, Code Division Multiple Access)

- 코드를 나눠서 여러명이 접근할 수 있도록 한다.

![](/bin/Network_image/network_8_5.png)

![](/bin/Network_image/network_8_6.png)

CDMA는 자기가 사용하는 코드에 자기가 원하는 신호를 곱해서 보내는 방식

그럼 동시에 여러 사람이 이야기해도 원래 신호를 분리해낼 수 있다.

##### 1) FDMA, TDMA, CDMA 비교

FDMA와 TDMA는 사이에 guard freq, guard time을 가지고 있어야 하기 때문에, 더 많은 낭비가 발생한다.

CDMA는 guard가 없기 때문에 guard로 인한 손실이 없다고 할 수 있다.

##### 2) FDMA, TDMA, CDMA 공통점

누가 어떤 freq, time, code를 사용할지 미리 결정되어 있음.

##### 3) FDMA, TDMA, CDMA 단점

- burst 통신이 쉽지 않다.
	- 위 방식은 자원이 얇고 넓게 분포되어 있는데, 우리는 한번에 많이 쓰고, 조금 쉬다가 만힝 쓰는 것을 반복한다.
	- 위 방식은 음성 통신에서 많이 쓰는 방식

###### 가) 보통의 통신 패턴

![](/bin/Network_image/network_8_7.png)

#### ㄹ) CSMA (Carrier Sense Multiple Access)

> 요즘 Wifi나 Ethernet에서 많이 쓰는 시스템은 CSMA

- 이용하는 사람이 없으면 내가 쓰겠다는 것
- Carrier를 아무도 쓰지 않을 때 통신한다.

##### 1) CSMA의 문제점

- 충돌이 발생한다.
	- 충돌을 방지하는 방법은 랜덤한 시간 동안 기다리기.
	- 계속 충돌이 발생하면, 사람이 많다는 의미이니 랜덤한 시간을 늘린다.

#### ㅁ) 토큰 방식

> 충돌 방지를 위해 토큰을 돌려서 토큰이 있는 사람만 말한다.

할 이야기가 없으면 토큰만 돌리고, 할 이야기가 있으면 토큰에 붙여서 보낸다.

동시에 여러명이 이야기하는 충돌이 방지된다.

![](/bin/Network_image/network_8_8.png)

복잡하지 않아서 고속 통신에서 사용됨.

##### 1) 신호 없이 교차로를 만드는 방법

1. start line

	차들이 start line에 오면 무조건 정지하고 누가 있는지 확인하고 지나간다.

	동시에 여러대의 차가 있다면, 오른쪽 차부터 지나가는 등의 규칙이 있음

	![](/bin/Network_image/network_8_9.png)

	복잡도가 높음

2. 원형 교차로 (Roundabout)

	무조건 내가 가는 방향이 정해져 있음

	왼쪽에 차가 오는지 확인하고(roundabout을 도는 차량이 있는지 확인하고) roundabout을 도는 차량을 우선하여 진입한다.

	![](/bin/Network_image/network_8_10.png)

	한쪽 길만 보면 내가 갈지 말지를 알 수 있어서 복잡도가 낮음

---

옛날에는 컴퓨터가 느려서 복잡한 시스템을 구현하기가 어려웠음

복잡한 시스템을 구현하기가 어려웠는데, 고속 통신을 해야했을 떄 만든 것이 토큰링 방식

요즘은 Ethernet 방식을 이용한다.

#### ㅂ) 스위치 방식

> 고가도로라 생각하면 됨

길이 교차하지 않기 때문에 신호등이 필요없음

1. Dummy hub

	- 옛날에 쓰던 방식
	- 선을 직접 연결함
	- 동시에 한명만 통신할 수 있음
	- 토큰 방식도 아니라서 CSMA 방식임
		- 눈치껏 보내야함

	![](/bin/Network_image/network_8_11.png)

2. Switching hub

	> Full-Duplex Switching

	![](/bin/Network_image/network_8_12.png)

	- 서로 같은 곳을 가려고 하지 않으면 통신하게 해줌
	- 같은 곳을 가려고 하면, queue를 하나 만들어서 대기시켰다가 보내줌
	- 각각의 end node는 아무때나 보내도 됨.
		- 스위치의 버퍼가 넘쳐서 버퍼 오버플로우가 발생할 수 있어도, 같은 방향으로 동시에 나가는 충돌은 발생하지 않음

#  2. Ethernet

> LAN하고 동의어

- 규모의 경제학
- 90년대 중반까지
	- CSMA/CD 방식으로 모든 노드를 wire로 연결함
		- 문제점
			- propagation delay (전파 지연)
			- 노드 수가 증가하면 속도가 비례해서 감소한다.

## A. Frame 형식

![](/bin/Network_image/network_8_20.png)

- Preamble
	- 1010101010...10101011
	- 아무런 의미없이 1과 0이 반복됨
	- 상대방의 타이밍에 맞추고 제대로된 frame을 인지하기 위해서 1010이 반복된다.
	- 워밍업과 타이밍 sync를 맞추는 역할
- 목적지 주소
	- 누가 보냈느냐보다 어디로 갈지가 더 중요하기 때문에 출발지 주소보다 먼저 나옴
	- 전기 신호로 통신해야하기 때문에 패킷을 받으면 최대한 빨리 다음 목적지로 보내야 한다.
		- 따라서, 내가 들어야 하는 패킷인지 아닌지를 인지해야함.
	- 6 Byte HW주소
- 출발지 주소
	- 6 Byte HW주소
- 상위 type
	- [Network Layer](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Network%20Layer.md)
- CRC
	- error detection

## B. HW주소 (HW addr, MAC address)

- 6 Byte (48bit) 주소
- 원칙적으로 전세계에서 유일해야함
- 장비 주민번호 개념
	- 일부 업체에서는 재사용함

### a. 재사용하면 문제되는거 아님?

Link Layer의 동일한 subnet 안에서 HW 주소가 동일한 경우에만 문제가 됨

subnet을 나가면 HW주소는 중요하지 않음

### b. 서버의 IP는 알고 HW주소를 모를 경우에는?

![](/bin/Network_image/network_8_13.png)

- ARP(Address Resolution Protocol)을 함
- ARP 안에는 목적지 HW주소가 `FF:FF:FF:FF:FF:FF`로 되어 있음
	- broadcast
	- 모든 node가 다 들어야 한다는 의미
- **스위치는 모든 노드에게 ARP를 전달한다.**
	- 자신의 IP가 아닌 노드는 무시한다.
	- 자신의 IP가 맞는 노드는 HW주소를 알려준다.
		- 그럼 IP주소와 HW주소를 매핑할 수 있게되어, Ethernet frame을 보낼 수 있음

![](/bin/Network_image/network_8_14.png)

---

중요한 것은 스위치도 이 통신에 참여함.  
그래서 어디로 보내야할지 학습하게 됨  

### c. Hybrid한 Network

![](/bin/Network_image/network_8_15.png)

#### ㄱ) 1번이 10번과 통신하려 할 때 (IP만 알고 HW주소를 모름)

- 1번과 연결된 스위치에 ARP를 날림
	- 그럼 스위치는 1번 port에 1번 컴퓨터가 연결되어 있는 것을 알 수 있음
- ARP는 상위 스위치로도 날라감
	- 그럼 그 스위치는 1번 port에 1번 컴퓨터가 연결되어 있음을 알 수 있음
- 찾고자하는 IP와 동일한 IP를 가지고 있는 10번 컴퓨터가 HW주소를 스위치에게 알려줌
- 하위 스위치에서 10번 컴퓨터를 찾는 통신은 어디로 보낼지 알게됨

![](/bin/Network_image/network_8_16.png)
![](/bin/Network_image/network_8_17.png)

#### ㄴ) 9번이 1번에게 보내려면?

- 동일하게 ARP를 진행함
- 하위 스위치는 9번, 10번 컴퓨터가 다 동일한 포트로 나가는 것을 학습하게 됨

![](/bin/Network_image/network_8_18.png)

스위치에 존재할 수 있는 노드가 한정적이기 때문에 모든 노드에 대한 테이블을 만들어놔도 됨

# 3. Switch

- 스위치는 투명한 존재
- 공기같은 존재

---

Data-Link Layer 장비

- Ethernet 헤더만 봄
- LAN 내부만 관여함

Link Layer를 마치 하나의 네트워크인 것처럼 보이게 해줌

![](/bin/Network_image/network_8_19.png)

목적지로만 패킷을 전달해줌

Switch는 ID가 없음

# 4. [Router](https://github.com/mildsalmon/Study/blob/Network/Network/docs/Network%20Layer.md#4-%EB%9D%BC%EC%9A%B0%ED%84%B0)