# 1. Go-Back-N

> N번 패킷까지는 받음. N+1번 패킷 받아야함 !

> 패킷을 연속적으로 받기 때문에 TCP와 연관.

- TCP는 내가 지금 몇번 패킷을 받을 차례라고 이야기한다.
	- 1,2,3,4번 바이트를 받고, 5번 바이트를 못받고, 6번 바이트를 받았다면.
	- 난 4번 바이트를 받았다고 말해야 한다.
		- 그래야지, 연속적으로 패킷을 받을 수 있다.
- 내가 몇 번째를 받을 차례라고만 이야기하고, 몇번 바이트는 받았고, 몇번 바이트는 받지 못했다는 것을 전달할 방법이 없음.

---

- 최대 N개의 패킷을  병렬적으로 처리하는 내용
- **송신측에서는 N개의 packet을 buffering**한다. (재전송하기 위해서)

	#### buffering의 의미

	> 수신이 확실하지 않은 packet을 재전송하기 위한 송신측의 보관소.

- 수신측에서는 **순차적**으로 잘 수신된 packet에 대하여 Ack을 송신하고 packet의 내용(payload, 실제 전송하고자 하는 내용)을 [[Application Layer]]으로 올려보낸다.
- 송신측에서는 (ack을 받아서)buffer의 여유가 생기면, 그만큼 추가로 pipelining한다.
	- ack을 받으면 해당 ack 패킷의 번호는 buffer에서 버린다. (지운다)
	- 그리고 빈 buffer에 새로운 packet을 추가해서 pipelining을 한다.

![](/bin/Network_image/network_5_22.png)

![](/bin/Network_image/network_5_23.png)

![](/bin/Network_image/network_5_24.png)

![](/bin/Network_image/network_5_25.png)

## A. 수신측에서 순서에 맞지 않는(이빨이 빠진) packet이 온 경우의 반응

![](/bin/Network_image/network_5_26.png)

1. 조용히 있는다. (아무것도 못받은 것처럼)
2. 잘 받은 마지막 packet에 대한 ack을 전송한다.

	![](/bin/Network_image/network_5_8.png)
		
## B. Go-back-N에서의 재전송 정책

- 각 packet 전송시에 packet을 위한 timer를 설정
	- timer는 ack을 받으면, ack에 해당하는 packet과 앞쪽 packet에 대한 timer를 소멸한다.
- Timer 이벤트 발생시(timer가 종료될때까지 ack packet을 받지 못함) 해당 packet부터 재전송한다.

![](/bin/Network_image/network_5_9.png)

### a. 추가 재전송 정책

- k번째 packet에 대한 ack이 반복적으로 오는 경우 k+1번째 packet의 유실을 함축(의미)하게 된다.
- n번정도 k패킷에 대한 ack이 오면 timer와 무관하게 k+1번째 packet부터 재전송한다.

![](/bin/Network_image/network_5_10.png)

# 2. 장점

- 단순하다.
	- 특히 수신측이 단순하다.
- 간단명료하게 시스템의 상태가 추상화된다.

---

2번 패킷에 대한 ack을 받지 못했지만, 3번 패킷을 받았다는 ACK를 보내서 받은 것과 동일하게 처리한다.

> 수신측에서 송신측에 보내는 ACK 패킷이 유실되었지만, 효용이 살아있다

중간에 패킷이 유실(2번 패킷의 ack)되어도 다음 패킷(3번 패킷의 ack)을 통해, 2번 패킷을 받은 것과 동일하게 처리할 수 있다.

# 3. 단점

- 패킷 유실에 대한 복구 비용이 많이 든다.

