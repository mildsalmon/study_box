# Table of Contents

- [a. URI (Universal Resource Identifier)](#a-uri-universal-resource-identifier)
  - [예) http://formal.kau.ac.kr/comnet?id=kau&pw=kau&action=login](#예-httpformalkauackrcomnetidkaupwkauactionlogin)

---

# a. URI (Universal Resource Identifier)

> 인터넷에 있는 자원(정보)을 나타내는 유일한 주소

- URL보다 상위 개념
- URL 뒤에(? 뒤에) 인자(query string)가 있음

#### 예) http://formal.kau.ac.kr/comnet?id=kau&pw=kau&action=login

1. http:
	- 프로토콜 이름
		- 이 리소스를 이용하고자 할때, 사용하는 세션 layer의 프로토콜 이름
		- 프로토콜 이름이 바뀌면 resource locator의 뒷부분도 다 바뀐다.
2. //formal.kau.ac.kr
	- //
		- url의 시작을 의미
	- formal.kau.ac.kr
		- 호스트 이름
		- IP주소를 사람이 기억하기 쉽게 표현
		- 큰 개념은 뒤에 있음.
			- kr이 맨 뒤에 있는 것처럼.
3. /comnet/
	- 호스트 안에서 실제로 자원이 존재하는 위치(path)
	- 최상위 디렉토리 밑에 있는 comnet 디렉토리를 가져온다.
		- comnet 뒤에 /가 있어서 디렉토리를 의미함.
4. ?id=kau&pw=kau&action=login
	- query string
	- GET 방식에서 query를 하기 위해 사용함