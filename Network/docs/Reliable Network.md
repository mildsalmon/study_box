# Table of Contents

- [1. Reliable Network](#1-reliable-network)
  - [A. 구현 방법](#a-구현-방법)
  - [B. TCP에서 Reliable Network](#b-tcp에서-reliable-network)
    - [a. 패킷 유실](#a-패킷-유실)
      - [1) ack 패킷을 보내서, 패킷이 잘 도착했는지 확인한다.](#1-ack-패킷을-보내서-패킷이-잘-도착했는지-확인한다)
      - [2) ack 패킷이 도착하지 않으면, 재전송한다.](#2-ack-패킷이-도착하지-않으면-재전송한다)
    - [b. 패킷 순서가 바뀔 수 있다.](#b-패킷-순서가-바뀔-수-있다)
  - [C. 성능향상](#c-성능향상)
    - [a. Pipelining](#a-pipelining)
      - [1) Pipelining 구현 방법](#1-pipelining-구현-방법)
        - [ㄱ) [[Go-Back-N]]](#ㄱ-go-back-n)
        - [ㄴ) [[Selective Repeat]]](#ㄴ-selective-repeat)

---

# 1. Reliable Network

## A. 구현 방법

1. sequence number를 보낸다.
	- 패킷에 번호를 붙인다.
2. acknowledgement 패킷
	- 잘 받았다는 패킷이 필요하다.
3. time out
	- ack 패킷이 안오면, 패킷을 다시 보내야한다.
	- 각 패킷마다 ack이 오는지를 판독하는 타이머를 통해 ack 패킷이 안왔다는 것을 확인한다.

## B. TCP에서 Reliable Network

1. 무한한 흐름 X
2. 패킷 유실
	1. ack 패킷을 보내서, 패킷이 잘 도착했는지 확인한다.
	2. ack 패킷이 도착하지 않으면, 재전송한다.
3. 패킷 순서가 바뀔 수 있다.
4. 패킷이 변조될 수 있다.

![](/bin/Network_image/network_5_1.png)

---

### a. 패킷 유실

- Ack신호가 Timeout내에 오지 않음.
	- ACK 신호
		- 받은 사람(수신측)이 보내주는 패킷
	- timer를 동작시켜서 정해진 시간안에 ACK 패킷이 오는지를 확인.

#### 1) ack 패킷을 보내서, 패킷이 잘 도착했는지 확인한다.

![](/bin/Network_image/network_5_4.png)

#### 2) ack 패킷이 도착하지 않으면, 재전송한다.

Timeout이 만료될 동안 ACK신호가 도착하지 않는다면, 패킷 유실이라 생각하게 된다.

![](/bin/Network_image/network_5_2.png)

1. 송신측에서 보낸 패킷이 수신측에 도착하지 않음, timeout이 발생한다.	
2. 수신측에서 보낸 ACK패킷이 송신측에 도착하지 않음, timeout이 발생한다.
3. ACK이 도착했지만, 너무 늦게 도착하여 timeout이 발생했다.
	- 송신측에서 무한정 기다릴 수 없기 때문에, timeout 안에 ACK이 오지 않는다면, 패킷이 유실되었다고 판단한다.

### b. 패킷 순서가 바뀔 수 있다.

패킷 넘버에 몇 바이트를 할당할지를 결정해야한다.  
패킷의 순서가 바뀌지 않는다면, 1비트(0, 1)로도 패킷을 구분지을 수 있다.

![](/bin/Network_image/network_5_3.png)

## C. 성능향상

네트워크의 성능을 측정하는 2가지 요소

1. [[전송률]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/%EC%A0%84%EC%86%A1%EB%A5%A0.md)
2. [[지연시간]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/%EC%A7%80%EC%97%B0%EC%8B%9C%EA%B0%84.md)

### a. Pipelining

> 병렬성을 가진다.

> 연속된 대량의 작업이 순차성을 갖고 있으나 앞의 일이 종료하지 않고도 다음 일을 시작할 수 있는 병렬성을 가진 경우의 성능향상 기법

![](/bin/Network_image/network_5_5.png)

각각의 패킷들이 잘 도착한 것과 전송하는 것은 독립적임.  
1번 패킷이 잘 도착하는 것과 2번 패킷을 전송하는 것은 독립적인 것처럼.

![](/bin/Network_image/network_5_6.png)

#### 1) Pipelining 구현 방법

##### ㄱ) [[Go-Back-N]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Go-Back-N.md)

##### ㄴ) [[Selective Repeat]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Selective%20Repeat.md)