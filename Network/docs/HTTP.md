# 1. HTTP (Hyper Text Transfer Protocol)

- www를 위한 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)프로토콜
- HTML을 기본 [[Presentation Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Presentation%20Layer.md)으로 사용.
- **[[stateless protocol]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/stateless%20protocol.md)**
- 단순한 프로토콜

## A. 목적

전세계 인터넷에 있는 정보를 탐색하는 것

## B. 발명 (만들어진 계기)

Tim Berners-Lee가 CERN에서 1980년대 말 ~ 1990년대 초에 만듬.

## C. 동작

- Web 자료를 가져와서(GET) 보여주기.
- Web 에 자료를 Posting하기. (POST)

1. URL 입력
2. client가 web server에 요청(GET)
3. web server가 client에게 응답

---

![](/bin/Network_image/network_3_1.png)

이 프로토콜은 TCP를 기반으로 한다.

TCP는 연결이 존재하는 프로토콜이기 때문에, 사용자가 URL을 입력하면 TCP 연결을 위한 동작이 GET 요청 앞에 들어가야한다.

연결은 client가 server한테 한다. server는 서버 소켓을 열어두고 client는 열려있는 서버 소켓으로 TCP 연결을 한다.

server의 IP(host name), port(80번)을 통해서 web server 프로세스에 접근한다.

연결이 이루어지면, 연결을 통해서 get / post 요청을 한다.

응답이 끝나면 TCP 연결을 종료한다.

## D. URL & URI

### a. [[URI]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/URI.md)) (Universal Resource Identifier)

### b. [[URL]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/URL.md)) (Universal Resource Locator)

## E. [[HTTP Method]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/HTTP%20Method.md)

## F. HTTP 성능

### a. [[다중 Transaction을 통한 HTTP 성능향상]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/%EB%8B%A4%EC%A4%91%20Transaction%EC%9D%84%20%ED%86%B5%ED%95%9C%20HTTP%20%EC%84%B1%EB%8A%A5%ED%96%A5%EC%83%81.md)

### b. [[네트워크 구조를 통한 HTTP 성능향상]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC%20%EA%B5%AC%EC%A1%B0%EB%A5%BC%20%ED%86%B5%ED%95%9C%20HTTP%20%EC%84%B1%EB%8A%A5%ED%96%A5%EC%83%81.md)
