# Table of Contents

- [1. Web Cache (Proxy Server)](#1-web-cache-proxy-server)
  - [A. Web Cache가 주는 이득](#a-web-cache가-주는-이득)
  - [B. 실행 예시](#b-실행-예시)

---

# 1. Web Cache (Proxy Server)

ISP (Internet Service Provider)

많은 사용자가 요청할 것이라 생각되는 요청을 ISP(KT, 등의 통신사)가 가지고 있는 별도의 Web cache에 저장한다.

그리고 다른 사용자가 동일한 요청을 했을 때, Web cache에 있는 내용을 전달하여, 해외 ISP에 통신하는 비용(속도, 비용)을 절약한다.

---

- ISP에서 비용절감을 위하여 이전에 가져온적이 있는 문서(데이터)를 DB에 임시저장하고 동일 문서(데이터)가 다시 요청될 때 재사용. 
	- 동일 문서를 요청하는 클라이언트는 다른 클라이언트일 수도 있고 같은 클라이언트일 수도 있음

- 웹 캐시는 서버이자 클라이언트 역할을 한다.
	- 서버 입장에서는 웹 캐시가 클라이언트 역할
	- 사용자 입장에서는 서버 역할
	- Web Cache는 **중개상인**의 개념
		- **Server이자 Client 역할**

## A. Web Cache가 주는 이득

- 소비자가 얻는 이득
	- 요청에 대한 응답시간단축
- ISP가 얻는 이득
	- 제공하는 교통량 증가
		- 더 많은 사용자 수용
- 서버(웹 서버)가 얻는 이득
	- 더 적은 서버 용량으로 더 많은 사용자를 지원할 수 있음

## B. 실행 예시

![](/bin/Network_image/network_3_34.png)

바뀐적이 있다면, 일반적인 과정과 동일

![](/bin/Network_image/network_3_35.png)

![](/bin/Network_image/network_3_36.png)