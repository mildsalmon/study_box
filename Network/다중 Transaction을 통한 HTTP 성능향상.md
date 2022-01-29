 # 1. 다중 Transaction을 통한 HTTP 성능향상
 
## a. 기본 HTTP

![](/bin/Network_image/network_3_26.png)

## b. Persistent HTTP

서버가 응답을 보내고 바로 TCP 종결을 하지 않고 기다림

![](/bin/Network_image/network_3_27.png)

## c. Pipelined HTTP

![](/bin/Network_image/network_3_28.png)

# 2. persistent HTTP vs pipelined HTTP 성능 비교

## A. 성능

1. 끝단간 [[지연시간]]
	- 100ms
2. [[전송률]]
	- 100KB/s
3. 전송받고자하는 정보
	- HTML 페이지
		- 문서, 이미지 3개
	- HTML 문서
		- 1KB
	- 이미지당 크기
		- 10KB
4. HTTP 헤더
	- Request
		- 1KB
	- Response
		- 1KB
5. TCP connection 연결 / 종결 시간
	- 연결
		- 400ms
	- 종결
		- 200ms

## B. 기본 HTTP

![](/bin/Network_image/network_3_31.png)

## C. persistent HTTP

TCP를 맺고 끝는 600ms가 아껴짐

![](/bin/Network_image/network_3_32.png)

## D. pipelined HTTP

![](/bin/Network_image/network_3_33.png)
