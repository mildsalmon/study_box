# 1. FTP (File Transfer Protocol)

![](/bin/Network_image/network_2_8.png]]

## A. 목적

원격 host에 있는 파일을 가져오거나 파일을 보내기(업로드)위한 프로토콜

## B. 특징

- 세션 로그인과 종료가 존재한다.
- 로그인을 통해 권한획득
- 로그인 정보를 서버가 관리
- **[[stateful protocol]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/stateful%20protocol.md)**
- 상태 관리를 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)에서 해줌.
	- [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)이 많은 일을 함.