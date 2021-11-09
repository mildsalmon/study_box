# 1. Linked List

각 노드는 데이터 필드와 다음 노드의 주소인 링크 필드로 구성되어 있다.

각 노드들이 물리적으로 떨어져있어도, 다음 노드의 주소를 알기 때문에 다음 노드의 위치를 알 수 있다.

특정 위치에 원소를 삽입, 삭제하기 위해서는 다음 노드의 주소만 바꾸면 되기 때문에 삽입, 삭제가 쉽다. 다만 접근 연산은 비효율적이다.

```python

class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Linked_List:
    def __init__(self, data):
        self.head = Node(data)

    def append(self, data):
        current_node = self.head

        while current_node.next is not None:
            current_node = current_node.next

        current_node.next = Node(data)

    def insert_node(self, index, value):
        temp = Node(value)

        if index == 0:
            temp.next = self.head
            self.head = temp

            return
        else:
            current_node = self._get_node(index - 1)

            temp.next = current_node.next
            current_node.next = temp

    def print_all(self):
        current_node = self.head

        while current_node is not None:
            print(current_node.data)
            current_node = current_node.next

    def _get_node(self, index):
        count = 0
        current_node = self.head

        while count < index:
            count += 1
            current_node = current_node.next

        return current_node

    def delete_node(self, index):
        if index == 0:
            target_node = self.head
            self.head = self.head.next

            del target_node
            return
        else:
            current_node = self._get_node(index - 1)
            target_node = current_node.next
            current_node.next = target_node.next

            del target_node

if __name__ == "__main__":
    a = Linked_List(1)

    a.print_all()
    print()

    a.append(2)
    a.append(3)

    a.print_all()
    print()

    a.insert_node(1, 10)
    a.insert_node(3, 20)
    a.insert_node(0, 30)

    a.print_all()
    print()

    a.delete_node(0)
    a.delete_node(3)
    a.delete_node(1)
    
    a.print_all()
    print()

```

# 2. Array List

각 원소들이 순차적으로 나열되어 있다.
다음 원소의 위치는 바로 옆에 있기 때문에 접근이 쉽다.

특정 위치에 원소를 삽입, 삭제하는 속도가 느리다. 특정 위치의 원소를 탐색하는 속도는 빠르다.

# 3. Array

## A. 역전 알고리즘

회전시키는 수에 대해 구간을 나누어 reverse로 구현하는 방법

```

d = 2

1, 2 / 3, 4, 5, 6, 7 로 구간을 나눈다.

첫 번째 구간 reverse -> 2, 1
두 번째 구간 reverse -> 7, 6, 5, 4, 3

합치기 -> 2, 1, 7, 6, 5, 4, 3

합친 배열을 reverse -> 3, 4, 5, 6, 7, 1, 2

```

```python

def reverse_arr(arr, start, end):
	while start < end:
		arr[start], arr[end] = arr[end], arr[start]
		
		start += 1
		end -= 1
		
result = reverse_arr(arr, 0, d-1) + reverse_arr(arr, d, len(arr)-1)
answer = reverse_arr(result, 0, len(arr)-1)

```

# 4. Stack

```python

class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Stack:
    def __init__(self):
        self.head = None

    def _check_empty(self):
        if self.head is None:
            return True
        return False

    def push(self, data):
        temp = Node(data)
        temp.next = self.head
        self.head = temp

    def pop(self):
        if self._check_empty():
            return None
        else:
            temp = self.head
            self.head = temp.next

            return temp.data

    def peek(self):
        """
        top을 출력
        """
        if self.head is None:
            return None
        return self.head.data

if __name__ == "__main__":
    s = Stack()


    s.push(1)
    s.push(2)
    s.push(3)
    s.push(4)
    s.push(5)

    print("peek of data : {}".format(s.peek())) # 5

    while True:
        check = s.pop()

        if check is None:
            break
        else:
            print(check) # 5, 4, 3, 2, 1


```

# 5. Queue

```python

class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Queue:
    def __init__(self):
        self.head = None
        self.tail = None

    def _is_empty(self):
        if self.head is None:
            return True
        return False

    def enqueue(self, data):
        temp = Node(data)

        if self._is_empty():
            self.head = temp
            self.tail = temp
        else:
            self.tail.next = temp
            self.tail = temp

    def dequeue(self):
        if self._is_empty():
            return None
        else:
            temp = self.head.data
            self.head = self.head.next

            return temp

    def peek(self):
        if self._is_empty():
            return None
        else:
            return self.head.data

if __name__ == "__main__":
    q = Queue()

    q.enqueue(1)
    print("deleted data : {}".format(q.dequeue())) # deleted data : 1

    q.enqueue(2)
    q.enqueue(3)
    q.enqueue(4)
    q.enqueue(5)

    while True:
        answer = q.dequeue()

        if answer is None:
            break
        else:
            print(answer) # 2, 3, 4, 5
			
```

# 6. 힙 (Heap)

여러 값 중, 최댓값과 최솟값을 빠르게 찾아내도록 만들어진 자료구조

힙 트리는 중복된 값 허용

## A. 최대 힙 (max heap)

부모 노드의 키 값이 자식 노드의 키 값보다 크거나 같은 완전 이진 트리

## B. 최소 힙 (min heap)

부모 노드의 키 값이 자식 노드의 키 값보다 작거나 같은 완전 이진 트리

## C. 구현

- 왼쪽 자식 index = 부모 index \* 2
- 오른쪽 자식 index = 부모 index \* 2 + 1
- 부모 index = 자식 index / 2

### a. 힙의 삽입

1. 힙에 새로운 요소가 들어오면, 일단 새로운 노드를 힙의 마지막 노드에 삽입
2. 새로운 노드를 부모 노드들과 교환

```python

def push(x):
	maxHeap.append(x)
	
	for i in range(len(maxHeap), 1, i//2):
		if maxHeap[i//2] < maxHeap[i]:
			maxHeap[i//2], maxHeap[i] = maxHeap[i], maxHeap[i//2]
		else:
			break

```

### b. 힙의 삭제

1. 최대 힙에서 최댓값은 루트 노드이므로 루트 노드가 삭제됨
2. 삭제된 루트 노드에는 힙의 마지막 노드를 가져옴
3. 힙을 재구성

```python

def pop():
	if len(maxHeap) == 1:
		return
	
	max_value = maxHeap[1]
	maxHeap[1] = maxHeap[len(maxHeap)-1]
	maxHeap[len(maxHeap)-1] = 0

	for i in range(1, i*2 <= len(maxHeap)):
		if maxHeap[i] > maxHeap[i*2] && maxHeap[i] > maxHeap[i*2 + 1]:
			break
		elif maxHeap[i*2] > maxHeap[i*2+1]:
			maxHeap[i], maxHeap[i*2] = maxHeap[i*2], maxHeap[i]
			i = i * 2
		else:
			maxHeap[i], maxHeap[i*2+1] = maxHeap[i*2+1], maxHeap[i]
			i = i * 2 + 1
		
	
```

# 7. 우선순위 큐

힙은 우선순위 큐를 위해 만들어진 자료구조다.

큐에 우선순위의 개념을 도입한 자료구조

# 8. 트리

값을 가진 Node와 노드들을 연결해주는 Edge로 구성된 자료구조.

사이클이 없음.

최상위 노드가 루트(root) 노드이다.

모든 노드들은 0개 이상의 자식 노드를 가지고 있으며 보통 부모-자식 관계로 부른다.

노드의 개수가 N개면, 간선은 N-1개를 가진다.

## A. 트리 순회 방식

### a. 전위 순회 (pre-order)

각 루트를 순차적으로 먼저 방문하는 방식이다.

M - L - R

### b. 중위 순회 (in-order)

왼쪽 하위 트리를 방문 후 루트를 방문하는 방식이다.

L - M - R

### c. 후위 순회 (post-order)

왼쪽 하위 트리부터 하위를 모두 방문 후 루트를 방문하는 방식이다.

R - L - M

### d. 레벨 순회 (level-order)

루트부터 계층 별로 방문하는 방식이다.

# 9. 이진탐색트리 (Binary Search Tree)

이진탐색트리의 목적은 **이진 탐색 + 연결리스트**

- 이진탐색
	- 탐색에 소요되는 시간복잡도는 O(logN)
	- 삽입 삭제가 불가능
- 연결리스트
	- 삽입, 삭제의 시간복잡도는 O(1)
	- 탐색하는 시간복잡도가 O(N)

위 두 가지 장점을 합한 것이 **이진탐색트리**

> 효율적인 탐색 능력을 가지고, 자료의 삽입 삭제도 가능하게 만들자.

## A. 특징

- 각 노드의 자식이 2개 이하
- 각 노드의 왼쪽 자식은 부모보다 작고, 오른쪽 자식은 부모보다 큼
- 중복된 노드가 없어야 함.
	- 검색 목적 자료구조인데, 굳이 중복이 많은 경우에 트리를 사용하여 검색 속도를 느리게 할 필요가 없음

## B. BST 핵심연산

- 검색
- 삽입
- 삭제
- 트리 생성
- 트리 삭제

## C. 시간 복잡도

- 균등 트리
	- O(logN)
- 편향 트리
	- O(N)

## D. 삭제의 3가지 Case

1. 자식이 없는 leaf 노드일 때 -> 그냥 삭제
2. 자식이 1개인 노드일 때 -> 지워진 노드에 자식을 올리기
3. 자식이 2개인 노드일 때 -> 오른쪽 자식 노드에서 가장 작은 값 or 왼쪽 자식 노드에서 가장 큰 값 올리기

# 10. 해시 (Hash)

데이터를 효율적으로 관리하기 위해, 임의의 길이 데이터를 고정된 길이의 데이터로 매핑하는 것

해시 함수를 구현하여 데이터 값을 해시 값으로 매핑한다.

**데이터가 많아지면, 다른 데이터가 같은 해시 값으로 충돌나는 현상이 발생함. (Collision 현상)**

## A. 그래도 해시 테이블을 사용하는 이유는?

- 적은 자원으로 많은 데이터를 효율적으로 관리하기 위해
- 하드디스크나 클라우드에 존재하는 무한한 데이터들을 유한한 개수의 해시값으로 매핑하면 적은 메모리로도 프로세스 관리가 가능해짐

---

- 언제나 동일한 해시값 리턴, index를 알면 빠른 데이터 검색이 가능해짐
- 해시테이블의 시간복잡도 O(1) - (이진탐색트리는 O(logN))

## B. 충돌 문제 해결

- 체이닝
	- 연결리스트로 노드를 계속 추가해나가는 방식
- Open Addressing
	- 해시 함수로 얻은 주소가 아닌 다른 주소에 데이터를 저장할 수 있도록 허용
- 선형 탐사
	- 정해진 고정 폭으로 옮겨 해시값의 중복을 피함
- 제곱 탐사
	- 정해진 고정 폭을 제곱수로 옮겨 해시값의 중복을 피함

# 11. 트라이 (Trie)

문자열에서 검색을 빠르게 도와주는 자료구조

> 정수형에서 이진탐색트리를 이용하면 시간복잡도 O(logN)
> 하지만, 문자열에서 적용했을 때 문자열의 최대 길이가 M이면 O(M\*logN)이 된다.
> 트라이를 활용하면? O(M)으로 문자열 검색이 가능함.


# 12. B Tree & B+ Tree

이진 트리는 하나의 부모가 두 개의 자식밖에 가지질 못하고, 균형이 맞지 않으면 검색 효율이 선형검색 급으로 떨어진다. 하지만 이진 트리 구조의 간결함과 균형만 맞다면 검색, 삽입, 삭제 모두 O(logN)의 성능을 보이는 장점이 있기 때문에 계속 개선시키기 위한 노력이 이루어지고 있다.

## A. B Tree

데이터베이스, 파일 시스템에서 널리 사용되는 트리 자료구조의 일종이다.

이진 트리를 확장해서, 더 많은 수의 지식을 가질 수 있게 일반화 시킨 것이 B-Tree


자식 수에 대한 일반화를 진행하면서, 하나의 레벨에 더 저장되는 것 뿐만 아니라 트리의 균형을 자동으로 맞춰주는 로직까지 갖추었다. 단순하고 효율적이며, 레벨로만 따지만 완전한 균형을 맞춘 트리다.

```
대량의 데이터를 처리해야 할 때, 검색 구조의 경우 하나의 노드에 많은 데이터를 가질 수 있다는 점은 상당히 큰 장점이다.

대량의 데이터는 메모리보다 블럭 단위로 입출력하는 하드디스크 or SSD에 저장해야하기 때문!

ex) 한 블럭이 1024 바이트면, 2바이트를 읽으나 1024바이트를 읽으나 똑같은 입출력 비용 발생. 따라서 하나의 노드를 모두 1024바이트로 꽉 채워서 조절할 수 있으면 입출력에 있어서 효율적인 구성을 갖출 수 있다.

→ B-Tree는 이러한 장점을 토대로 많은 데이터베이스 시스템의 인덱스 저장 방법으로 애용하고 있음
```

![[Pasted image 20211109144733.png]]

### a. 규칙

- 노드의 자료수가 N이면, 자식 수는 N + 1이어야 함
- 각 노드의 자료는 정렬된 상태여야 함.
- 루트 노드는 적어도 2개 이상의 자식을 가져야 함
- 루트 노드를 제외한 모든 노드는 적어도 M/2 개의 자료를 가지고 있어야함
- 외부 노드로 가는 경로의 길이는 모두 같음
- 입력 자료는 중복 될 수 없음

## B. B+ Tree

![](https://media.vlpt.us/images/emplam27/post/bcbce100-d475-4cda-aebe-946d1813949c/B%ED%94%8C%EB%9F%AC%EC%8A%A4%20%ED%8A%B8%EB%A6%AC%20%EA%B8%B0%EB%B3%B8%20%ED%98%95%ED%83%9C.jpg)

데이터의 빠른 접근을 위한 인덱스 역할만 하는 비단말 노드(not Leaf)가 추가로 있음

(기존의 B-Tree와 데이터의 연결리스트로 구현된 색인구조)

B-Tree의 변형 구조로, index 부분과 leaf 노드로 구성된 순차 데이터 부분으로 이루어진다. 인덱스 부분의 key 값은 leaf에 있는 key 값을 직접 찾아가는데 사용함.

링크드 리스트를 이용한다.

### a. 장점

블럭 사이즈를 더 많이 이용할 수 있음 (key 값에 대한 하드디스크 액세스 주소가 없기 때문)

leaf 노드끼리 연결 리스트로 연결되어 있어서 범위 탐색에 매우 유리함

### b. 단점

B-Tree의 경우 최상 케이스에서는 루트에서 끝날 수 있지만, B+ tree는 무조건 leaf 노드까지 내려가봐야 함

## B Tree & B+ Tree

B Tree는 각 노드에 데이터가 저장됨
B+ Tree는 index 노드와 leaf 노드로 분리되어 저장됨
(또한, leaf 노드는 서로 연결되어 있어서 임의접근이나 순차접근 모두 성능이 우수함)

B Tree는 각 노드에서 key와 data 모두 들어갈 수 있고, data는 disk block으로 포인터가 될 수 있음
B+ Tree는 각 노드에서 key만 들어감. 따라서 data는 모두 leaf 노드에만 존재. B+ Tree는 add와 delete가 모두 leaf 노드에서만 이루어짐.