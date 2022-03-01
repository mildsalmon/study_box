# Table of Contents

- [1. FTP (File Transfer Protocol)](#1-ftp-file-transfer-protocol)
  - [A. 목적](#a-목적)
  - [B. 특징](#b-특징)

---

# 1. FTP (File Transfer Protocol)

![](/bin/Network_image/network_2_8.png]]

- 접속을 해서 로그인한 다음, 다운받고자하는 디렉토리로 이동해서, 필요한 파일을 다운받고 등등, 로그아웃 할때까지가 하나의 세션
- TCP connection이 내가 로그인해서 로그아웃할 때까지의 모든 과정이 하나의 세션
- [[stateful protocol]]
- 사용자가 행동하는 모든 내용이 tracking됨
    - tracking을 서버가 해야한다.
    - 서버쪽에서 해야하는 일이 많은 프로토콜

## A. 목적

원격 host에 있는 파일을 가져오거나 파일을 보내기(업로드)위한 프로토콜

## B. 특징

- 세션 로그인과 종료가 존재한다.
- 로그인을 통해 권한획득
- 로그인 정보를 서버가 관리
- **[[stateful protocol]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/stateful%20protocol.md)**
- 상태 관리를 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)에서 해줌.
	- [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)이 많은 일을 함.