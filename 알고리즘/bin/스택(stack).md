# 1. Stack

선입후출(FILO), 후입선출(LIFO) 구조

입구와 출구가 동일한 형태로 시각화할 수 있다.

![stack](bin/PS_image/stack.png)

```python

# stack  
  
stack = []  
  
stack.append(5)  
stack.append(2)  
stack.append(3)  
stack.append(7)  
a = stack.pop()  
stack.append(4)  
  
print(stack)  
print(stack[::-1])

```

```

[5, 2, 3, 4]
[4, 3, 2, 5]

```

파이썬에서 스택을 이용할 때는 리스트에 append(), pop() 메소드를 이용하면 스택 자료구조와 동일하게 동작한다.

# 참고문헌

나동빈, "이것이 취업을 위한 코딩 테스트다 with 파이썬", 초판, 2쇄, 한빛미디어, 2020년


#자료구조 #스택 #이것이취업을위한코딩테스트다