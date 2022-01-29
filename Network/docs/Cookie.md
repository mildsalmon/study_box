# 1. Cookie (쿠키)

## A. 웹 응용의 구조

- 웹 클라이언트
	- HTML 엔진을 가지고 있음.
	![](/bin/Network_image/network_3_13.png)
	
- 웹 서버
	- [[stateless protocol]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/stateless%20protocol.md)은 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md) (HTTP)에만 적용되고, 서버 응용([[Application Layer]])은 [[stateless protocol]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/stateless%20protocol.md) 가 아님.
	- HTTP ([[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md))
		- 바둑판, 바둑알, 규칙
	- 서버응용 ([[Application Layer]])
		- 바둑을 두는 사람
	- 밑에 있는 Layer들([[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md) )이 서버 응용이 여러가지 일을 할 수 있는 자유도를 주기 때문에 여러가지 서비스를 즐길 수 있다.

	![](/bin/Network_image/network_3_14.png)

## B. 쿠키란?	

> 쿠키는 기억해야할 정보를 클라이언트에게 주고 클라이언트가 그 정보를 서버에게 주면 그 정보를 이용하여 내용을 가공해서 응답을 한다.

- 쿠키는 **상태정보를 담는 도구**이다.
	- 서버는 상태 정보를 가지고 있지 않지만, **클라이언트가 상태 정보를 가지고 있는** 것. 그게 쿠키
- 서버응용이 **클라이언트의 이전 작업정보(state)를 파악하기 위한 도구**
	- 서버 응용이 이전에 접근한 사람이 다시 왔는지를 구별하기 위해 쿠키를 사용한다.
- 클라이언트가 쿠키를 서버에게 보여주면 서버는 내가 누구인지 기억해낼 수 있다.

![](/bin/Network_image/network_3_15.png)

## C. 프로토콜

- HTTP Response 헤더 (서버 -> 클라이언트)
	- Set-cookie라는 필드가 있음.
- HTTP Request 헤더 (클라이언트 -> 서버)
	- Cookie라는 필드가 있음.

### a. 쿠키없이 server에 Request

![](/bin/Network_image/network_3_18.png)

![](/bin/Network_image/network_3_16.png)

![](/bin/Network_image/network_3_17.png)

### b. server에서 전달해준 쿠키로 server에 Request

![](/bin/Network_image/network_3_19.png)

![](/bin/Network_image/network_3_20.png)

![](/bin/Network_image/network_3_21.png)

[[Application Layer]]에서 이런 쿠키들이 왔다갔다 하고 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md) 에서는 그 정보를 이용하지 않는다. 쿠키를 [[Application Layer]]으로 던져줄 뿐이다.

## D. 문제

- 클라이언트에게 너무 많은 권한과 정보를 준다.
	- 해결책
		- 이 문제를 해결하는 방법이 [[Session]]