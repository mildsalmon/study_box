# Table of Contents

- [1. 네트워크 계층 (Network Layer) (=우체국) - 3계층](#1-네트워크-계층-network-layer-우체국---3계층)
  - [A. 네트워크 계층이 하는 일](#a-네트워크-계층이-하는-일)
- [2. Routing](#2-routing)
- [3. IP](#3-ip)
- [4. 라우터](#4-라우터)
  - [A. 특징](#a-특징)
  - [B. NAT Router](#b-nat-router)

---

# 1. 네트워크 계층 (Network Layer) (=우체국) - 3계층

> 직접적으로 통신과 연결되어 있음

- Network Core의 끝단간 전송을 구현하기 위한 경로설정.
	- 양 끝단으로의 전달을 책임짐. 
	- 패킷을 끝에서 끝으로 경로를 설정하여 전달을 책임짐.
- 스위치 (교환기)가 관여함.

---

> 목적지까지 가지 위한 주소 개념을 지원한다.

- IP

---

> 주소가 주어지고, 패킷을 순차적으로 보내다보면, 최종적으로 목적지까지 가도록 만드는 역할을 함

---

IP 계층이 중간을 묶어준다.

어플리케이션 계층에서는 IP만 지원하면 되고 어떤 데이터 링크 계층도 IP만 지원하면 된다.

![](/bin/Network_image/network_8_1.png)

## A. 네트워크 계층이 하는 일

출발지에서 목적지까지 경로를 찾아준다.

주소 체계를 확립하고, 주소 체계에 맞는 주소가 주어졌을 때 출발지에서 목적지까지 패킷을 전달해줌

# 2. [Routing](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Routing.md)

# 3. [IP](http://github.com/mildsalmon/Study/blob/Network/Network/docs/IP.md)

# 4. 라우터

> 각각의 네트워크 장비들이 [Routing Table](https://github.com/mildsalmon/Study/blob/Network/Network/docs/Routing.md#3-routing-table)(포워딩 테이블)을 통해 경로를 찾는다.

- 길을 찾아주는 사람
- 중간중간에 있는 네트워크에서 IP 패킷이 왔을 때, 다음 hop으로 가게 해주는 장비

---

Network Layer 장비

- IP계층 그 이상을 봄
- 인터넷 전체를 관여
	- 라우팅 테이블을 통해 패킷을 어디로 보낼지 결정

목적지가 정해지면 다음 hop이 어디인지를 결정해야함.

그래서 ID가 있음

## A. 특징

포트를 구별함

## B. [NAT](http://github.com/mildsalmon/Study/blob/Network/Network/docs/NAT.md) Router

- local IP를 global IP로 바꿔줌

![](/bin/Network_image/network_8_3.png)