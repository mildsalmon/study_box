# Table of Contents

- [1. Selective Repeat](#1-selective-repeat)
- [장점](#장점)
- [단점](#단점)

---

# 1. Selective Repeat

> 수신측에 buffer를 사용한다.

- selective repeat은 지금 몇번째 패킷을 받았는지에 대해 알려줘야한다.
	- 1,2,3,4번 패킷을 받고, 5번 패킷은 못받고, 6번 패킷은 받았다.
	- 6번 패킷을 받았다는 것을 알려줘야한다.

---

![](/bin/Network_image/network_5_11.png)

- Go-back-N의 단점을 보완하였다.
- **수신측에 버퍼**를 둔다.
	- 빠진 packet이 있을 경우 그 뒤쪽의 잘 도착한 packet들은 버퍼에 보관한다.
	- 빠진 packet이 추후 도착하면, buffer에 저장한 이후 packet들까지 순차적으로 [[Application Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Application%20Layer.md)에 전달한다.

![](/bin/Network_image/network_5_27.png)

![](/bin/Network_image/network_5_28.png)

![](/bin/Network_image/network_5_29.png)

![](/bin/Network_image/network_5_30.png)

# 장점

- **실패한 packet만 재전송**한다.
	- 성능이 향상된다.

# 단점

- 시스템 추상화가 복잡해진다.
- 수신측에도 버퍼가 필요하다.
