# Table of Contents

- [1. Subnet](#1-subnet)
- [2. Routing Table과 subnet](#2-routing-table과-subnet)

---

# 1. Subnet

> IP를 묶어서 하나의 entry로 생각할 수 있도록 하는 개념

![](/bin/Network_image/network_7_1.png)

- subnet part까지 보내면 host part는 알아서 하겠지라고 생각한다.

---

- 단말 컴퓨터 라우팅시 subnet이 동일하지 않는 컴퓨터는 subnet 단위로 라우팅한다.
	- subnet이 동일한 경우에는 단말로 라우팅한다.

![](/bin/Network_image/network_7_3.png)

![](/bin/Network_image/network_7_4.png)

---

- 조직(ISP, 학교, 회사)에서 IP를 사용할 경우
	- subnet을 할당받는다.

		```ad-example

		173.26.22.xxx은 kau의 IP
		표현형) 173.26.22.0/24

		24 -> subnet의 bit 수 (MSB 부터)
		
		MSB(가장 중요한 bit부터) 24bit를 봤을때 위와 같으면 이 subnet이다.
		
		```
		- [MSB & LSB](http://github.com/mildsalmon/Study/blob/Network/Network/docs/MSB%20%26%20LSB.md)
	- subnet을 조각화할 수 있다.
	
		```ad-example

		항공대 본진 : 고양시 (173.26.226.0/24 고양 KT)
		항공대 부설기관 : 제주도 (173.26.226.64/26 제주 LGU+)

		173.26.226.0
		10101101.00011010.11100010.00000000

		/24
		10101101.00011010.11100010. 이 같으면 고양으로 감

		173.26.226.64
		10101101.00011010.11100010.01000000

		/26
		10101101.00011010.11100010.01이 같으면 제주로 감

		즉, 64 ~ 127까지는 제주도로 감

		```
		- ![](/bin/Network_image/network_7_33.png)
		
![](/bin/Network_image/network_7_6.png)

# 2. Routing Table과 subnet

- 라우팅 테이블에서 목적지 IP주소가 subnet을 통해 대폭 줄어들 수 있다.

![](/bin/Network_image/network_7_9.png)