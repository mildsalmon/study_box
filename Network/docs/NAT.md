# Table of Contents

- [1. NAT (Network Address Translation)](#1-nat-network-address-translation)
  - [A. Port Mapping Table](#a-port-mapping-table)
    - [a. Endpoint Independent Mapping Table (EIM)](#a-endpoint-independent-mapping-table-eim)
      - [ㄱ) EIM의 예시](#ㄱ-eim의-예시)
      - [ㄴ) EIM의 단점](#ㄴ-eim의-단점)
    - [b. Endpoint Dependent Mapping Table (EDM)](#b-endpoint-dependent-mapping-table-edm)
      - [ㄱ) EDM의 예시](#ㄱ-edm의-예시)
      - [ㄴ) EDM의 단점](#ㄴ-edm의-단점)
        - [1) 해결책](#1-해결책)
          - [가) static map 사용](#가-static-map-사용)
          - [나) Relay host](#나-relay-host)
          - [다) hole puncturing](#다-hole-puncturing)

---

# 1. NAT (Network Address Translation)

- local IP는 아무거나 쓰면 안됨.
	- 사용할 수 있는 subnet 구간이 있음

![](/bin/Network_image/network_7_17.png)

- NAT GW는 되게 복잡함
	- IP layer만 보는게 아니라 TCP layer까지 같이 봐야함
		- 왜냐하면, LAN 환경 안에 IP가 다른애가 같은 포트번호를 사용할 수도 있음
	- 서로 다른 기계에서 같은 포트번호로 하나의 서버에 접속하면, NAT GW를 통과할때 같은 IP로 대표가 되니까 서로 다른 포트번호를 사용해야함.
		- TCP의 포트번호까지 같이 바꿔줘야함.

---

- 원래는 router를 지나도 패킷의 ip헤더와 tcp헤더를 건들이지 않음.
	- 다만, NAT은 편법이기 때문에 NAT의 영역을 지나갈때는 IP헤더와 TCP헤더가 바뀐다.
	- NAT은 **IP 주소가 모자르기 때문에 사용하는 편법**임

![](/bin/Network_image/network_7_18.png)

## A. Port Mapping Table

### a. Endpoint Independent Mapping Table (EIM)

> Endpoint에 독립적으로 global port 번호를 mapping해줌

- port mapping table에 의해서 NAT router 밖으로 나갈때 port가 바뀐다.
	- local 영역에서 IP는 다르고 port는 같은 경우가 있을 수 있기 때문
	- 이 경우 NAT을 통해 같은 IP로 나가게 되는데, port 번호가 같으면 어떤 host에서 보낸 요청인지 구분할 수 없다.

#### ㄱ) EIM의 예시

![](/bin/Network_image/network_7_19.png)
![](/bin/Network_image/network_7_20.png)
![](/bin/Network_image/network_7_21.png)

#### ㄴ) EIM의 단점

- local 영역에서 사용할 수 있는 서비스의 개수가 포트 개수(65,536)만큼으로 제한됨.

### b. Endpoint Dependent Mapping Table (EDM)

> 서로 다른 외부 서버로 접속하는 것이라면 굳이 src global port 번호를 구분할 필요가 없다.
> 
> Endpoint가 무엇이냐에 따라 port 번호 mapping이 의존한다.

- global port 번호를 재사용할 수 있음
- 같은 src local ip를 가지고 다른 src local port 번호를 가지면 같은 src global port 번호를 가질 수 있음
- 하나의 global port 번호가 하나의 local port 번호를 대표하는 것이 아닌, 여러 개의 local port 번호를 대표할 수 있다.

#### ㄱ) EDM의 예시

![](/bin/Network_image/network_7_22.png)

#### ㄴ) EDM의 단점

- NAT에서의 P2P 지원을 가정
	- host가 NAT 뒤에 숨어 있으면 host들끼리 직접 연결이 불가능하다.

![](/bin/Network_image/network_7_23.png)

##### 1) 해결책

###### 가) static map 사용

- 사전 설정 필요
	- 사용자가 지식을 가지고 설정해줘야 함.
	- 일반인들이 사용하기 힘듬
- 같은 port번호에 대해서는 NAT안에서 하나의 장비만 static mapping이 가능한 점도 문제

![](/bin/Network_image/network_7_24.png)

###### 나) Relay host

- NAT 내부의 노드는 사전에 global IP를 가지는 Relay host와 영구적 연결을 설정
- EDM, EIM 모두 사용 가능

![](/bin/Network_image/network_7_25.png)

![](/bin/Network_image/network_7_26.png)

![](/bin/Network_image/network_7_27.png)

![](/bin/Network_image/network_7_28.png)

![](/bin/Network_image/network_7_29.png)

###### 다) hole puncturing

- global IP를 가지는 서버와 NAT 내부의 client가 사전 여결을 가짐
	- 각 NAT router의 port mapping table에 등록
- 노드가 연결을 시도할 때 해당 port를 알려준다.
- EIM만 가능하고, EDM은 불가능

![](/bin/Network_image/network_7_30.png)

![](/bin/Network_image/network_7_31.png)

![](/bin/Network_image/network_7_32.png)