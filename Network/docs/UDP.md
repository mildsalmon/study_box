# Table of Contents

- [1. UDP](#1-udp)
  - [A. 무연결 전송 계층](#a-무연결-전송-계층)
  - [B. 관리가 어렵다. (신뢰성이 낮다.)](#b-관리가-어렵다-신뢰성이-낮다)
  - [C. 데이터 순서가 역전될 수 있다.](#c-데이터-순서가-역전될-수-있다)
  - [D.최대 성능으로 패킷전송](#d최대-성능으로-패킷전송)
  - [E. 전송단위](#e-전송단위)
  - [F. 내용 변조 탐지](#f-내용-변조-탐지)

---

# 1. UDP

> 속도가 중요한 [[Application Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Application%20Layer.md)에 사용한다.

![](/bin/Network_image/network_2_7.png)

---

패킷보내라고 하면, 패킷 보낸다.

패킷을 받으면, [[Application Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Application%20Layer.md)로 올려주고

이 외에는 하는 일이 없다.

최대한 속도를 생각해서 만드는 프로토콜.

## A. 무연결 전송 계층

- 소켓을 열지만, 두 프로세스 사이에 연결 선이 없다.
- 연결이 없으니, 데이터를 아무곳에나 던진다. 
- 연결을 만들지 않고, 매 패킷마다 받는 사람의 주소를 써서 보낸다.


## B. 관리가 어렵다. (신뢰성이 낮다.)

- 데이터가 유실될 수 있다.


## C. 데이터 순서가 역전될 수 있다.

## D.최대 성능으로 패킷전송

- 속도가 빠름
	- 고의적 지연은 존재하지 않는다.
		- 1,2,3,4번 packet이 도착하고 5번 packet 없이 6번 packet만 도착하더라도 [[Application Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Application%20Layer.md)에 전달해준다.
	- 네트워크가 혼잡하더라도 패킷을 보낸다.
		- 네트워크가 너무 혼잡해진다면, 일부 패킷을 버리게 되어 유실이 발생한다.
- 실시간성이 중요한 통신에 사용

## E. 전송단위

- 패킷 (데이터그램)
	- 내용이 유실될 수 있다.
	- 내용이 유실되는 단위를 의미적 단위로만 유실될 수 있다고 이야기한다.
- send() 함수 호출 단위
	- send() 함수에서 보낸 데이터의 내용과 receive() 함수에서 받는 데이터 내용이 서로 대응 관계가 성립한다.

		![](/bin/Network_image/network_5_15.png)

## F. 내용 변조 탐지

- 잡음, 기계적인 결함으로 내용이 변하는 것, 간섭(interference)
- TCP/UDP에 존재한다.