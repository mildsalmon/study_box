# 1. FTP (File Transfer Protocol)

![](/bin/Network_image/network_2_8.png]]

## A. 목적

원격 host에 있는 파일을 가져오거나 파일을 보내기(업로드)위한 프로토콜

## B. 특징

- 세션 로그인과 종료가 존재한다.
- 로그인을 통해 권한획득
- 로그인 정보를 서버가 관리
- **[[stateful protocol]]**
- 상태 관리를 [[Session Layer]]에서 해줌.
	- [[Session Layer]]이 많은 일을 함.