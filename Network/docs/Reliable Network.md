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

#### 1) ack 패킷을 보내서, 패킷이 잘 도착했는지 확인한다.

![](/bin/Network_image/network_5_4.png)

#### 2) ack 패킷이 도착하지 않으면, 재전송한다.

1. A가 패킷을 보내는 과정에서 유실되는 경우
2. B가 ack 패킷을 보내는데 패킷이 유실되는 경우
3. B가 ack 패킷을 보냈는데, delay가 심해서 A쪽의 타이머에 타임아웃이 걸려서 패킷이 유실되었다고 생각하는 경우

![](/bin/Network_image/network_5_2.png)

### b. 패킷 순서가 바뀔 수 있다.

패킷 넘버에 몇 바이트를 할당할지를 결정해야한다.  
패킷의 순서가 바뀌지 않는다면, 1비트(0, 1)로도 패킷을 구분지을 수 있다.

![](/bin/Network_image/network_5_3.png)

## C. 성능향상

네트워크의 성능을 측정하는 2가지 요소

1. [[전송률]]
2. [[지연시간]]

### a. Pipelining

> 병렬성을 가진다.

> 연속된 대량의 작업이 순차성을 갖고 있으나 앞의 일이 종료하지 않고도 다음 일을 시작할 수 있는 병렬성을 가진 경우의 성능향상 기법

![](/bin/Network_image/network_5_5.png)

각각의 패킷들이 잘 도착한 것과 전송하는 것은 독립적임.  
1번 패킷이 잘 도착하는 것과 2번 패킷을 전송하는 것은 독립적인 것처럼.

![](/bin/Network_image/network_5_6.png)

#### 1) Pipelining 구현 방법

##### ㄱ) [[Go-Back-N]]

##### ㄴ) [[Selective Repeat]]