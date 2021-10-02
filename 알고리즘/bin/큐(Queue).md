# 1. 큐

선입선출 (FIFO)

!db_imagequeue.png]]

입구와 출구가 모두 뚫려 있는 터널과 같은 형태로 시각화

```python

from collections import deque  
  
queue = deque()  
  
queue.append(1)  
queue.append(2)  
queue.append(3)  
queue.append(4)  
a = queue.popleft()  
queue.append(5)  
  
print(queue)  
queue.reverse()  
print(queue)  
print(list(queue))

```

```

deque([2, 3, 4, 5])
deque([5, 4, 3, 2])
[5, 4, 3, 2]

```

deque는 스택과 큐의 장점을 모두 채택한 것.

데이터를 넣고 빼는 속도가 리스트 자료형에 비해 효율적이며 간단하다.

# 참고문헌

나동빈, "이것이 취업을 위한 코딩 테스트다 with 파이썬", 초판, 2쇄, 한빛미디어, 2020년


#자료구조 #큐  #이것이취업을위한코딩테스트다