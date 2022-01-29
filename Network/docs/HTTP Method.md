# Table of Contents

- [E. HTTP Method](#e-http-method)
  - [a. GET Request](#a-get-request)
    - [ㄱ) 형식](#ㄱ-형식)
    - [ㄴ) GET Request](#ㄴ-get-request)
    - [ㄷ) GET Request에 대한 Response](#ㄷ-get-request에-대한-response)
    - [ㄹ) 예시](#ㄹ-예시)
  - [b. POST Request](#b-post-request)
    - [ㄱ) 형식](#ㄱ-형식-1)
    - [ㄴ) 용도](#ㄴ-용도)
    - [ㄷ) POST Request](#ㄷ-post-request)
    - [ㄹ) POST Response](#ㄹ-post-response)
    - [ㅁ) 예시](#ㅁ-예시)
- [참고문헌](#참고문헌)

---

# E. HTTP Method

어떤 형태의 HTTP Request한다고 하더라도, Response 형태는 동일하다. `HTTP/1.1 200 OK`

## a. GET Request

> 목적은 원하는 자원을 가져오는 것

### ㄱ) 형식

- 헤더
	- 첫 줄에는 내가 무엇을 할지 선언
	- 그 뒤에 매개변수를 통해 좀 더 자세한 정보를 전달
	- 헤더를 통해 내 정보를 전달한다.
		- `나는 어떤 파일을 받을 수 있다.` 등
- 헤더 뒤에 한줄 띄우면 GET 요청은 끝난다.

```http GET

GET /en-US/docs/Glossary/Simple_header HTTP/1.1
Host: developer.mozilla.org
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://developer.mozilla.org/en-US/docs/Glossary/Simple_header

```

### ㄴ) GET Request

![](/bin/Network_image/network_3_3.png)

### ㄷ) GET Request에 대한 Response

![](/bin/Network_image/network_3_4.png)

### ㄹ) 예시

- 전체 흐름

	![](/bin/Network_image/network_3_2.png)	

- HTTP GET Request
	- client가 server에 index.html 요청

	![](/bin/Network_image/network_3_5.png)

- HTTP GET Request에 대한 Response
	- server가 client에 index.html 응답.
	- 다만, client는 `~.gif`를 모르기 때문에 server에 `~.gif`를 요청

	![](/bin/Network_image/network_3_6.png)

- `~.gif` 파일을 따로 GET Request
	- server에 `~.gif` 파일을 요청

	![](/bin/Network_image/network_3_7.png)

- `~.gif` GET Request에 대한 Response

	![](/bin/Network_image/network_3_8.png)

## b. POST Request

### ㄱ) 형식

- 헤더
	- 헤더부분은 GET과 똑같음.
		- GET이 아닌 POST인 것만 다름
- 헤더 뒤에 한줄 띄고 바디를 넣는다.
- 바디
	- 바디에는 보내고자하는 내용을 넣는다.
	- 바디 내용이 짧을 경우 POST대신 GET으로 보내면서 URL 뒤에 바디 내용을 파라미터로 붙인다. (그럼 URI가 됨)
		- /comnet?id=kau&pw=kau&action=login

---

- 헤더 + 바디
- 바디
	- 여러개의 자원(제목, 내용 등)을 합쳐서 하나의 POST로 보낸다.

### ㄴ) 용도

- 자원을 서버에 게시하고 싶을 때
	- 게시판에 글올리기
	- 사진 올리기
	- 웹 브라우저를 이용해 e-mail 보내기
	- 로그인할때

### ㄷ) POST Request

![](/bin/Network_image/network_3_9.png)

### ㄹ) POST Response

![](/bin/Network_image/network_3_10.png)

### ㅁ) 예시

- HTTP POST Request
	- client가 server에 id와 pw를 body에 넣고 보냄.

	![](/bin/Network_image/network_3_11.png)
	
- HTTP GET Request
	- POST 방식은 id와 pw를 body에 넣고 보냈다면, GET 방식으로는 URL 맨 뒤에 query string으로 보냄.

	![](/bin/Network_image/network_3_12.png)

	- POST 방식을 GET 방식으로 보내면 발생할 수 있는 문제점
		- 내용이 긴 경우
			- 사진이나 이메일 등의 보내고자 하는 내용이 길면 GET으로 보내기 힘들다.
		- 숨기고 싶은 내용
			- URL에 내용들이 평문으로 보여지기 때문에 보안이 취약하다.


# 참고문헌

[[Web 통신] web 통신 과정(GET과 POST의 패킷 분석) (tistory.com)](https://c-i-s.tistory.com/entry/Web-%ED%86%B5%EC%8B%A0-web-%ED%86%B5%EC%8B%A0-%EA%B3%BC%EC%A0%95GET%EA%B3%BC-POST%EC%9D%98-%ED%8C%A8%ED%82%B7-%EB%B6%84%EC%84%9D)