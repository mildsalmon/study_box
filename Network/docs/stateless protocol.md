# stateless protocol

- 한번 요청이 들어오고 거기에 대한 응답을 하면, 클라이언트에 대한 정보를 잃어버린다.
- 단순함
	- 요청이 오고 응답을 하면 서버는 자신의 역할을 다 한 것
	- 추가적으로 **클라이언트에 대한 정보를 서버가 내부적으로 가지고 있을 필요는 없다**.

---

한번 요청을 해서 응답을 받으면, 서버쪽에 있는 [[Session Layer]](http://github.com/mildsalmon/Study/blob/Network/Network/docs/Session%20Layer.md)에서는 그 다음 요청이 들어오더라도 앞에 어떤 요청을 했는지에 대해서 기억하지 않는다.