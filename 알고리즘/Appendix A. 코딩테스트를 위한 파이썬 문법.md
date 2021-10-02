# 1. 자료형
 
### A. 수 자료형 (Number)

##### a. 정수형 (Integer)

정수형에는 양의 정수, 음의 정수, 0이 있다.

```python

a = 10  
print(a)  
  
b = -10  
print(b)  
  
c = 0  
print(c)

```

```

10
-10
0

```

##### b. 실수형 (Real Number)

소수점 아래의 데이터를 포함하는 수 자료형

소수부가 0이거나, 정수부가 0인 소수는 0을 생략할 수 있다.

```python

a = 123.45  
print(a)  
  
b = -123.45  
print(b)  
  
c = 123.  
print(c)  
  
d = .45  
print(d)

```

```

123.45
-123.45
123.0
0.45

```

e나 E를 이용한 지수 표현 방식도 이용한다. e 다음에 나오는 수는 10의 지수부를 의미한다.

`3e2 = 3 * 10^2`

```python

a = 1e9  
print(a)  
  
b = 123.45e1  
print(b)  
  
c = 123e-3  
print(c)

```


```

1000000000.0
1234.5
0.123

```

실수를 처리할 때 부동 소수점(Floating-point) 방식을 이용한다. IEEE754 표준에서는 실수형을 저장하기 위해 4바이트 OR 8바이트라는 고정된 크기의 메모리를 할당한다. 그래서 현대 컴퓨터 시스템은 실수 정보를 표현하는 정확도에 한계를 가진다.

```python

a = 0.3 + 0.6  
print(a)  
  
if a == 0.9:  
    print(True)  
else:  
    print(False)

```

```

0.8999999999999999
False

```

소수점 값을 비교하는 작업이 필요한 문제라면 **round() 함수**를 이용한다.

round() 함수의 인자는 1. 실수형 데이터, 2. 반올림하고자 하는 위치 -1 이다. 2번째 인자는 생략 가능하다.

보통 코딩테스트 문제에서는 실수형 데이터를 비교할 때 소수점 다섯 번째 자리에서 반올림한 결과가 같으면 정답으로 인정하는 식으로 처리한다.

```python

a = 0.3 + 0.6  
print(round(a, 4))  
  
if round(a, 4) == 0.9:  
    print(True)  
else:  
    print(False)

```

```

0.9
True

```

##### c. 수 자료형의 연산

사칙연산(+, -, \*,  \/)를 이용한다.

파이썬에서 나누기 연산자(/)는 나눠진 결과를 기본적으로 실수형으로 처리한다.

나머지 연산자(%), 거듭제곱 연산자(\*\*)도 있다.

```python

a = 7  
b = 3  
  
print(a/b)  
print(a%b)  
print(a//b)  
print(a**b)

```

```

2.3333333333333335
1
2
343

```

### B. 리스트 자료형

리스트는 여러 개의 데이터를 연속적으로 담아 처리하기 위해 사용할 수 있다. C나 자바의 배열(Array) 기능을 포함한다. 내부적으로 연결 리스트 자료구조를 채택하고 있어서 append(), remove() 등의 메서드를 지원한다.

특정한 원소가 있는지 검사할 때는 **원소 in 리스트**의 형태를 사용할 수 있다. 

##### a. 리스트 만들기

대괄호(\[\])안에 원소를 넣어 초기화하며, 쉼표(,)로 원소를 구분한다. 리스트의 원소에 접근할 때는 인덱스(Index)값을 괄호 안에 넣는다. 인덱스는 0부터 시작한다. 빈 리스트를 선언할 때는 **list()** OR **대괄호(\[\])**를 이용한다.

```python

a = [1,2,3,4,5]  
print(a)  
  
print(a[2])  
  
b = list()  
print(b)  
  
c = []  
print(c)

```

```

[1, 2, 3, 4, 5]
3
[]
[]

```

코딩 테스트 문제는 주로 크기가 N인 1차원 리스트를 초기화하는 방법

```python

n = 10  
a = [0] * n  
print(a)

```

```

[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

```

##### b. 리스트의 인덱싱과 슬라이싱

인덱스값을 입력하여 리스트의 특정한 원소에 접근하는 것을 인덱싱(Indexing)이라 한다. 음의 정수를 넣으면 원소를 거꾸로 탐색한다.

```python

a = [1,2,3,4,5]  
print(a[-3])  
  
a[1] = 10  
print(a)

```

```

3
[1, 10, 3, 4, 5]

```

리스트에서 연속적인 위치를 갖는 원소들을 가져와야 할 때는 슬라이싱(Slicing)을 이용한다. 이때는 대괄호 안에 콜론(:)을 넣어서 시작인덱스와 끝인덱스를 설정할 수 있다.

```python

a = [1,2,3,4,5]  
  
print(a[1:3])

```

```

[2, 3]

```

##### c. 리스트 컴프리헨션

리스트 컴프리헨션은 리스트를 초기화하는 방법 중 하나이다. **대괄호(\[\]) 안에 조건문과 반복문을 넣는 방식**으로 리스트를 초기화할 수 있다.

```python

a = [i for i in range(20) if i%2 == 1]  
  
print(a)

```

```

[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

```

리스트 컴프리헨션은 2차원 리스트를 초기화할 때 매우 효과적으로 사용될 수 있다.

```python

n = 3  
m = 4  
array = [[0] * m for _ in range(n)]  
  
print(array)

```

```

[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]

```

특정 크기의 2차원 리스트를 초기화할 때는 반드시 리스트 컴프리헨션을 이용해야 한다.

```python

n = 3  
m = 4  
array = [[0] * m] * n  
print(array)  
  
array[1][1] = 5  
print(array)

```

```

[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
[[0, 5, 0, 0], [0, 5, 0, 0], [0, 5, 0, 0]]

```

내부적으로 포함된 3개의 리스트가 모두 동일한 객체에 대한 3개의 레퍼런스로 인식되기 때문에 위와 같은 문제가 발생한다.

##### d. 리스트 관련 기타 메서드

| 메서드명  | 사용법                                | 설명                                                                              | 시간 복잡도 |
| --------- | ------------------------------------- | --------------------------------------------------------------------------------- | ----------- |
| append()  | 변수명.append()                       | 리스트에 원소를 하나 삽입할 때 사용                                               | O(1)        |
| sort()    | 변수명.sort()                         | 기본 정렬 기능으로 오름차순으로 정렬한다.                                         | O(NlogN)    |
|           | 변수명.sort(reverse = True)           | 내림차순으로 정렬한다.                                                            |             |
| reverse() | 변수명.reverse()                      | 리스트의 원소의 순서를 모두 뒤집어 놓는다.                                        | O(N)        |
| insert()  | insert(삽입할 위치 인덱스, 삽입할 값) | 특정한 인덱스 위치에 원소를 삽입할 때 사용한다.                                   | O(N)        |
| count()   | 변수명.count(특정 값)                 | 리스트에서 특정한 값을 가지는 데이터의 개수를 셀 때 사용한다.                     | O(N)        |
| remove()  | 변수명.remove(특정 값)                | 특정한 값을 갖는 원소를 제거하는데, 값을 가지는 원소가 여러 개면 하나만 제거한다. | O(N)        |

특정한 값의 원소를 모두 제거하려면?

```python

a = [1,2,3,4,5,5,5]  
remove_set = [3,5]  
  
result = [i for i in a if i not in remove_set]  
print(result)

```

```

[1, 2, 4]

```

### C. 문자열 자료형

##### a. 문자열 초기화

문자열 변수를 초기화할 때는 큰따옴표(\")나 작은따옴표(\')를 사용한다.

```python

data = 'Hello'  
print(data)  
  
data = "Good \"day\""  
print(data)

```

```

Hello
Good "day"

```

##### b. 문자열 연산

문자열 변수에 덧셈(+)을 이용하면 단순히 문자열이 더해져서 연결된다.

```python

a = "Hello"  
b = "world"  
  
print(a + " " + b)

```

```

Hello world

```

문자열 변수를 양의 정수와 곱하는 경우, 그 값만큼 여러 번 더해진다.

```python

a = "A"  
print(a*10)

```

```

AAAAAAAAAA

```

파이썬의 문자열은 내부적으로 리스트와 같이 처리된다.

```python

a = "asdfgh"  
print(a[1:-3])

```

```

sd

```

### D. 튜플 자료형

리스트와 거의 비슷하다.

다만.

- 튜플은 한 번 선언된 값을 변경할 수 없다.
- **소괄호(())** 를 이용한다.

```python

a = (1,2,3,4)  
print(a)  
  
a[2] = 4

```

```

(1, 2, 3, 4)

TypeError: 'tuple' object does not support item assignment

```

튜플 자료형은 그래프 알고리즘을 구현할 때 자주 사용된다. 다익스트라 최단 경로 알고리즘처럼 최단 경로를 찾아주는 알고리즘의 내부에서는 우선순위 큐를 이용하는데 해당 알고리즘에서 우선순위 큐에 한 번 들어간 값은 변경되지 않는다.

자신이 알고리즘을 잘못 작성함으로써 변경하면 안 되는 값이 변경되고 있지는 않은지 체크할 수 있다. 튜플은 리스트에 비해 상대적으로 공간 효율적이고, 각 원소의 성질이 서로 다를 때 주로 사용한다. 다익스트라 최단 경로 알고리즘에서는 서로 다른 성질의 데이터를 **(비용, 노드번호)** 의 형태로 함께 튜플로 묶어서 관리하는 것이 관례이다.

특정한 원소가 있는지 검사할 때는 **원소 in 튜플**의 형태를 사용할 수 있다. 

### E. 사전 자료형

##### a. 사전 자료형 소개

사전 자료형은 키(Key)와 값(Value)의 쌍을 데이터로 가지는 자료형이다. 변경 불가능한 데이터를 키로 사용할 수 있다.

파이썬의 사전 자료형은 내부적으로 **해시 테이블(Hash Table)** 을 이용하므로 기본적으로 데이터의 검색 및 수정에 있어서 O(1)의 시간에 처리할 수 있다. 

특정한 원소가 있는지 검사할 때는 **원소 in 사전**의 형태를 사용할 수 있다. 

```python

data = dict({'사과': 'apple',  
 '바나나': 'banana'})  
data['코코넛'] = 'coconut'  
  
if '사과' in data:  
    print("사과 있음")

```

```

사과 있음

```

##### b. 사전 자료형 관련 함수

키 데이터만 뽑아서 리스트로 이용할 때는 **keys()** 함수를 이용한다.

값 데이터만 뽑아서 리스트로 이용할 때는 **value()** 함수를 이용한다.

```python

data = dict({'사과': 'apple',  
 '바나나': 'banana'})  
data['코코넛'] = 'coconut'  
  
key_list = data.keys()  
value_list = data.values()  
  
print(key_list)  
print(value_list)  
  
for i in key_list:  
    print(i)

```

```

dict_keys(['사과', '바나나', '코코넛'])
dict_values(['apple', 'banana', 'coconut'])
사과
바나나
코코넛

```

### F. 집합 자료형

##### a. 집합 자료형 소개

집합(Set)을 처리하기 위한 집합 자료형을 제공한다

- 중복을 허용하지 않는다.
- 순서가 없다.

사전 자료형과 집합 자료형은 순서가 없기 때문에 인덱싱으로 값을 얻을 수 없다는 특징이 있다. 집합 자료형에서는 키가 존재하지 않고 값 데이터만을 담게 된다. 특정 원소가 존재하는지를 검사하는 연산의 시간 복잡도는 O(1)이다.

**특정한 데이터가 이미 등장한 적이 있는지 여부**를 체크할 때 매우 효과적이다. 집합 자료형을 초기화할 때는 **set()** 함수를 이용하거나, **중괄호({})** 안에 각 원소를 **콤마(,)** 를 기준으로 구분해서 넣으면 된다.

```python

data = set([1,2,3,4,5,1])  
print(data)  
  
data = {1,2,3,4,5,5}  
print(data)

```

```

{1, 2, 3, 4, 5}
{1, 2, 3, 4, 5}

```

##### b. 집합 자료형의 연산

집합 연산으로는 합집합, 교집합, 차집합 연산이 있다. 합집합은 **|**, 교집합은 **&**, 차집합은 **-** 를 이용한다.

```python

a = set([1,2,3,4,5])  
b = set([3,4,5,6,7])  
  
print(a | b)  
print(a & b)  
print(a - b)

```

```

{1, 2, 3, 4, 5, 6, 7}
{3, 4, 5}
{1, 2}

```

##### c. 집합 자료형 관련 함수

집합 데이터에 하나의 값을 추가할 때는 **add() 함수**를 이용한다. 여러 개의 값을 한꺼번에 추가하고자 할 때는 **update() 함수**, 특정한 값을 제거할 때는 **remove() 함수**를 사용한다. add(), remove() 함수는 모두 **시간복잡도가 O(1)** 이다.

```python

data = set([1,2,3])  
print(data)  
  
data.add(4)  
print(data)  
  
data.update([5,6])  
print(data)  
  
data.remove(3)  
print(data)

```

```

{1, 2, 3}
{1, 2, 3, 4}
{1, 2, 3, 4, 5, 6}
{1, 2, 4, 5, 6}

```

# 2. 조건문

조건문은 프로그램의 흐름을 제어하는 문법이다.

```

a = 15

if a>=10:
	print(x)

```

파이썬에서 조건문을 작성할 때는 **if ~ elif ~ else** 문을 사용한다.

조건문을 작성할 때는 코드의 블록을 들여쓰기로 설정한다.

들여쓰기는 스페이스바를 4번 입력하거나 탭을 사용한다. 파이썬 커뮤니티에서는 **4개의 공백문자**를 사용하는 것이 사실상의 표준이므로, 이를 따르는 것을 추천한다.

### A. 비교 연산자

비교 연산은 특정한 두 값을 비교할 때 이용할 수 있다.

| 비교 연산자 | 설명                                   |
| ----------- | -------------------------------------- |
| X == Y      | X와 Y가 서로 같을 때 참(True)이다.     |
| X != Y      | X와 Y가 서로 다를 때 참(True)이다.     |
| X > Y       | X가 Y보다 클 때 참(True)이다.          |
| X < Y       | X가 Y보다 작을 때 참(True)이다.        |
| X >= Y      | X가 Y보다 크거나 같을 때 참(True)이다. |
| X <= Y      | X가 Y보다 작거나 같을 때 참(True)이다. |

### B. 논리 연산자

2개의 논리 값 사이의 연산을 수행할 때 사용하는데 파이썬에는 3가지 논리 연산자가 있다.

| 논리 연산자 | 설명                                           |
| ----------- | ---------------------------------------------- |
| X and Y     | X와 Y가 모두 참(True)일 때 참(True)이다.       |
| X or Y      | X와 Y 중에 하나만 참(True)이어도 참(True)이다. |
| not X       | X가 거짓(False)일 때 참(True)이다.             |

### C. 파이썬의 기타 연산자

**in 연산자**와 **not in 연산자**를 제공한다. 

여러 개의 데이터를 담는 자료형은 자료형 안에 어떠한 값이 존재하는지 확인하는 연산이 필요할 때가 있다.

| in 연산자와 not in  연산자 | 설명                                              |
| -------------------------- | ------------------------------------------------- |
| X in 리스트                | 리스트 안에 X가 들어가 있을 때 참(True)이다.      |
| X not in 문자열            | 문자열 안에 X가 들어가 있지 않을 때 참(True)이다. |

아무것도 처리하고 싶지 않을 때 pass 문을 이용할 수 있다.

```python

a = 10

if score >= 5:
	pass
else:
	print('Hello')

```

##### a. 조건부 표현식(Conditional Expression)

```python

a = 10
result = "good" if a >= 10 else "bad"

print(result)

```

리스트에 있는 원소의 값을 변경해서, 또 다른 리스트를 만들고자 할 때 매우 간결하게 사용할 수 있다.

```python

a = [1, 2, 3, 4, 5, 5, 5]
remove_set = {3, 5}

result = []

for i in a:
	if i not in remove_set:
		result.append(i)

print(result)

```

위 코드를 아래 코드처럼 표현할 수 있다.

```python

a = [1, 2, 3, 4, 5, 5, 5]
remove_set = {3, 5}

result = [i for i in a if i not in remove_set]

print(result)

```

##### b. 수학의 부등식

파이썬은 조건문 안에서 수학의 부등식을 그대로 사용할 수 있다.

x > 0 and x < 20 => 0 < x < 20

# 3. 반복문

반복문은 특정한 소스코드를 반복적으로 실행하고자 할 때 사용할 수 있다.

### A. while문

조건문이 참일 때에 한해서, 반복적으로 코드가 수행된다.

```python

i = 1
result = 0

while i <= 9:
	result += i
	i += 1
	
print(result)

```

### B. for문

in 뒤에 오는 데이터를 포함되어 있는 모든 원소를 첫 번째 인덱스부터 차례대로 하나씩 방문한다. in 뒤에 오는 데이터로는 리스트, 튜플, 문자열 등이 사용될 수 있다.

```python

for i in list:
	print(i)

```

##### a. range()

range(시작 값, 끝 값 + 1)

range()의 값으로 하나의 값만 넣으면, 자동으로 시작 값은 0이다.

##### b. continue()

반복문에서 continue를 만나면 프로그램의 흐름은 반복문의 처음으로 돌아간다.

```python

scores = [90, 85, 77, 53, 20]
black_list = {2, 4}

for i in range(5):
	if i + 1 in black_list:
		continue
	if score[i] >= 80:
		print(i + 1, "번 학생은 합격입니다.")

```

반복문은 중첩해서 사용할 수 있다. 중첩된 반복문은 **플로이드 워셜 알고리즘**, **다이나믹 프로그래밍** 등의 알고리즘 문제에서 매우 많이 사용된다.

# 4. 함수

똑같은 코드가 반복적으로 사용되어야 할 때가 많다.

동일한 알고리즘을 반복적으로 수행해야 할 때 함수는 중요하게 사용된다.

함수 내부에서 사용되는 변수의 값을 전달받기 위해 매개변수를 정의할 수 있다. 함수에서 어떠한 값을 반환하고자 할 때는 return을 이용한다. 함수에서 **매개변수나 return문은 존재하지 않을 수**도 있다.

```python

def 함수명(매개변수):
	실행할 소스코드
	return 반환 값

```

### A. 인자(argument)

인자를 넘겨줄 때, 파라미터의 변수를 직접 지정해서 값을 넣을 수 있다.

```python

def add(a, b):
	print("함수의 결과 : ", a + b)
	
add(b = 3, a = 7)

```

### B. global

함수 안에서 함수 밖의 변수 데이터를 변경해야 하는 경우가 있다. 이때는 함수에서 global 키워드를 이용하면 된다.

```python

a = 0  
  
def func():  
    global a  
    a += 1  
  
for i in range(10):  
    func()  
  
print(a)

```


### C. 람다 표현식(Lambda Express)

함수를 매우 간단하게 작성하여 적용할 수 있다. 특정한 기능을 수행하는 **함수를 한 줄에 작성**할 수 있다는 점이 특징이다.

람다식은 파이썬의 정렬 라이브러리를 사용할 때, 정렬 기준(Key)을 설정할 때에도 자주 사용된다.

```python

def add(a, b):
	return a+b
	
print(add(3, 7))

print((lambda a, b: a+b)(3,7))

```

# 5. 입출력


### A. 입력

알고리즘 문제 풀이의 첫 번째 단계는 데이터를 입력받는 것

일반적으로 입력 과정에서는 먼저 데이터의 개수가 첫 번째 줄에 주어지고, 처리할 데이터는 그 다음 줄에 주어지는 경우가 많다.

파이썬에서 데이터를 입력받을 때는 **input()** 을 이용한다. input()은 할 줄의 문자열을 입력받도록 해준다. 입력받은 데이터를 정수형 데이터로 처리하기 위해서는 문자열을 정수로 바꾸는 int() 함수를 사용해야 한다.

여러 개의 데이터를 입력받을 떄는 데이터가 공백으로 구분되는 경우가 많다. **list(map(int, input().split()))** 을 이용하면 된다.

가장 먼저 input()으로 입력받은 문자열을 split()을 이용해 공백으로 나눈 리스트로 바꾼 뒤에, map을 이용하여 해당 리스트의 모든 원소에 int() 함수를 적용한다. 최종적으로 그 결과를 list()로 다시 바꿈으로써 입력받은 문자열을 띄어쓰기로 구분하여 각각 숫자 자료형으로 저장하게 되는 것이다.

구분자가 줄 바꿈인 경우 int(input())을 여러 번 사용하면 된다.

```python

b = int(input())  
  
data = list(map(int, input().split()))  
  
data.sort(reverse=True)  
  
print(data)

```

```python

n, m, k = map(int, input().split())

print(n, m, k)

```

입력을 최대한 빠르게 받아야 하는 경우가 있다. 흔히 정렬, 이진 탐색, 최단 경로 문제의 경우 매우 많은 수의 데이터가 연속적으로 입력이 되곤 한다.

파이썬의 기본 input() 함수는 동작 속도가 느려서 시간 초과가 될 수 있다. 이 경우 파이썬의 sys 라이브러리에 정의되어 있는 **sys.stdin.readline()** 함수를 이용한다. input() 함수와 같이 한 줄씩 입력받기 위해 사용한다.

```python

import sys

sys.stdin.readline().rstrip()

```

sys 라이브러리를 사용할 때는 한 줄 입력을 받고 나서 **rstrip()** 함수를 꼭 호출해야 한다. readline()으로 입력하면 입력 후 엔터가 줄 바꿈 기호로 입력되는데, 이 공백 문자를 제거하려면 rstrip() 함수를 사용해야 한다.

### B. 출력

각 변수를 콤마(,)로 구분하여 매개변수로 넣을 수 있다. 이 경우 각 변수가 띄어쓰기로 구분되어 출력된다.

```python

print(a, b)

```

기본적으로 출력 이후에 줄 바꿈을 수행한다.

```python

print(1)
print(2)

```

문자열과 수를 함께 출력해야 되는 경우가 있다. 이 경우 단순히 더하기 연산자(+)를 이용하여 문자열과 수를 더하면 오류가 발생한다.

str() 함수를 이용하여 출력하고자 하는 변수 데이터를 문자열로 바꿔주거나, 각 자료형을 콤마(,)를 기준으로 구분하여 출력하면 된다.

```python

answer = 7

print("정답은 " + str(answer) + "입니다")

print("정답은 ", str(answer), "입니다.")

```

변수의 값 사이에 의도치 않은 공백이 삽입될 수 있다.

python 3.6 이상의 버전부터 f-string 문법을 사용할 수 있다. f-string은 문자열 앞에 접두사 **f**를 붙임으로써 사용할 수 있는데, f-string을 이용하면 단순히 중괄호({}) 안에 변수를 넣음으로써, 자료형의 변환 없이도 바꾸지 않고도 문자열과 정수를 함께 넣을 수 있다.

```python

print(f'정답은 {answer} 입니다.')

```

# 6.주요 라이브러리의 문법과 유의점

파이썬의 일부 라이브러리는 잘못 사용하면 수행 시간이 비효율적으로 증가한다.

표준 라이브러리란 특정한 프로그래밍 언어에서 자주 사용되는 표준 소스코드를 미리 구현해 놓은 라이브러리를 의미한다.

[파이썬 표준 라이브러리 - 공식문서](http://docs.python.org/ko/3/library/index.html)

코딩 테스트를 준비하며 반드시 알아야 하는 라이브러리는 6가지 정도이다.

### A. 내장 함수

별도의 import 명령어 없이 바로 사용할 수 있는 내장 함수. 앞에서 살펴본 input(), print().

##### a. sum() 함수

iterable 객체가 입력으로 주어졌을 때, 모든 원소의 합을 반환한다.

```python

result = sum([1, 2, 3, 4, 5])

print(result)

```

```

15

```


##### b. min() 함수

파라미터가 2개 이상 들어왔을 때 가장 작은 값을 반환한다.

```python

result = min(7, 3, 5, 2)
print(result)

```

```

2

```

##### c. max() 함수

파라미터가 2개 이상 들어왔을 때 가장 큰 값을 반환한다.

```python

result = max(1, 2, 3, 4, 5)

print(result)

```

```

7

```

##### d. eval() 함수

수학 수식이 문자열 형식으로 들어오면 해당 **수식을 계산한 결과를 반환**한다.

```python

result = eval("(3 + 5) * 7")

print(result)

```

```

56

```

##### e. sorted() 함수

iterable 객체가 들어왔을 때, 정렬된 결과를 반환한다. key 속성으로 정렬 기준을 명시할 수 있으며, reverse 속성으로 정렬된 결과 리스트를 뒤집을지의 여부를 설정할 수 있다.

```python

result = sorted([9, 1, 8, 5, 4])

print(result)

result = sorted([9, 1, 8, 5, 4], reverse = True)

print(result)

```

```

[1, 4, 5, 8, 9]
[9, 8, 5, 4, 1]

```

리스트의 원소로 리스트나 튜플이 존재할 때 특정한 기준에 따라서 정렬을 수행할 수 있다. 정렬 기준은 key 속성을 이용해 명시할 수 있다.

```python

result = sorted([('홍길동', 35), ('이순신', 75), ('장보고', 30)], key=lambda x:x[1], reverse=True)  
  
print(result)

```

```

[('이순신', 75), ('홍길동', 35), ('장보고', 30)]

```

iterable 객체는 기본으로 sort() 함수를 내장하고 있다. 하지만 리스트 객체의 내부 값이 정렬된 값으로 바로 변경된다.

```python

data = [9, 1, 8, 5, 4]  
data.sort()  
  
print(data)

```

```

[1, 4, 5, 8, 9]

```


### B. itertools

반복되는 형태의 데이터를 처리하는 기능을 제공한다. 순열과 조합, 중복 순열, 중복 조합 라이브러리를 제공한다.

permutations, combinations, product, combinations_with_replacement는 클래스이므로 객체 초기화 이후에는 리스트 자료형으로 변환하여 사용한다.

##### a. permutations

iterable 객체에서 r개의 데이터를 뽑아 일렬로 나열하는 모든 경우 (순열)을 계산해준다. 

**중복 X, 순서 O**

```python

from itertools import permutations  
  
data = ['a', 'b', 'c']  
result = list(permutations(data, 2))  
  
print(result)

```

```

[('a', 'b'), ('a', 'c'), ('b', 'a'), ('b', 'c'), ('c', 'a'), ('c', 'b')]

```

##### b. combinations

iterable 객체에서 r개의 데이터를 뽑아 순서를 고려하지 않고 나열하는 모든 경우(조합)를 계산한다.

**중복 X, 순서 X**

```python

from itertools import combinations  
  
data = ['a', 'b', 'c']  
result = list(combinations(data, 2))  
  
print(result)

```

```

[('a', 'b'), ('a', 'c'), ('b', 'c')]

```

##### c. product

iterable 객체에서 r개의 데이터를 뽑아 일렬로 나열하는 모든 경우(순열)를 계산한다. 원소를 중복하여 뽑는다.

뽑고자 하는 데이터의 수를 **repeat 속성**으로 넣어준다.

**중복 O, 순서 O**

```python

from itertools import product  
  
data = ['a', 'b', 'c']  
result = list(product(data, repeat=2))  
  
print(result)

```

```

[('a', 'a'), ('a', 'b'), ('a', 'c'), ('b', 'a'), ('b', 'b'), ('b', 'c'), ('c', 'a'), ('c', 'b'), ('c', 'c')]

```

##### d. combinations_with_replacement

iterable 객체에서 r개의 데이터를 뽑아 순서를 고려하지 않고 나열하는 모든 경우(조합)를 계산한다. 원소를 중복하여 뽑는다.

**중복 O, 순서 X**

```python

from itertools import combinations_with_replacement  
  
data = ['a', 'b', 'c']  
result = list(combinations_with_replacement(data, 2))  
  
print(result)

```

```

[('a', 'a'), ('a', 'b'), ('a', 'c'), ('b', 'b'), ('b', 'c'), ('c', 'c')]

```

### C. heapq

힙(Heap) 기능을 제공하는 라이브러리다. 우선순위 큐 기능을 구현하기 위해 사용한다.

다익스트라 최단 경로 알고리즘을 포함해 다양한 알고리즘에서 우선순위 큐 기능을 구현하고자 할 때 사용된다. PriorityQueue 라이브러리도 있지만, 보통 heapq가 더 빠르다.

파이썬의 힙은 **최소 힙(Min Heap)** 으로 구성되어 단순히 원소를 힙에 전부 넣었다가 빼는 것만으로도 시간 복잡도 **O(NlogN)** 에 오름차순 정렬이 완료된다. 최소 힙 자료구조의 최상단 원소는 항상 **가장 작은 원소**이기 때문이다.

힙에 원소를 삽입할 때는 **heapq.heappush()** 메서드를 사용한다. 힙에서 원소를 꺼내고자 할 때는 **heapq.heappop()** 메서드를 사용한다.

##### a. 최소 힙을 이용한 힙 정렬

```python

import heapq  
  
def heapsort(iterable):  
    h = []  
    result = []  
  
    for value in iterable:  
        heapq.heappush(h, value)  
  
    for i in range(len(h)):  
        result.append(heapq.heappop(h))  
  
    return result  
  
result = heapsort([1, 3, 5, 7, 8, 2, 4, 0])  
  
print(result)

```

```

[0, 1, 2, 3, 4, 5, 7, 8]

```

##### b. 최대 힙을 이용한 내림차순 힙 정렬

파이썬에서는 최대 힙(Max Heap)을 제공하지 않는다. 그래서 원소의 부호를 임시로 변경하는 방식을 사용한다.


```python

import heapq  
  
def heapsort(iterable):  
    h = []  
    result = []  
  
    for value in iterable:  
        heapq.heappush(h, -value)  
  
    for i in range(len(h)):  
        result.append(-heapq.heappop(h))  
  
    return result  
  
result = heapsort([1, 3, 5, 7, 8, 2, 4, 0])  
  
print(result)

```

```

[8, 7, 5, 4, 3, 2, 1, 0]

```


### D. bisect

이진 탐색(Binary Search) 기능을 제공하는 라이브러리다.

**정렬된 배열**에서 특정한 원소를 찾아야 할 때 매우 효과적으로 사용된다.

**bisect_left()** 함수와 **bisect_right()** 함수가 가장 중요하게 사용되며, 두 함수의 시간 복잡도는 **O(logN)** 에 동작한다.

- bisect_left(a, x)
	- 리스트 a에 데이터 x를 삽입할 가장 왼쪽 인덱스를 찾는 메서드
- bisect_right(a, x)
	- 리스트 a에 데이터 x를 삽입할 가장 오른쪽 인덱스를 찾는 메서드

```python

from bisect import bisect_left, bisect_right  
  
a = [1, 2, 4, 4, 8]  
x = 4  
  
print(bisect_left(a, x))  
print(bisect_right(a, x))

```

```

2
4

```

**정렬된 리스트**에서 **값이 특정 범위에 속하는 원소의 개수**를 구하고자 할 때, 효과적으로 사용할 수 있다.

```python

from bisect import bisect_left, bisect_right  
  
def count_by_range(a, left_value, right_value):  
    right_index = bisect_right(a, right_value)  
    left_index = bisect_left(a, left_value)  
  
    return right_index - left_index  
  
a = [1, 2, 3, 3, 3, 3, 4, 4, 8, 9]  
  
print(count_by_range(a, 4, 4))  
  
print(count_by_range(a, -1, 3))

```

```

2
6

```

### E. collections

덱(deque), 카운터(Counter) 등의 유용한 자료구조를 포함하고 있는 라이브러리다.

##### a. deque

파이썬에서는 deque를 사용해 큐를 구현한다.

리스트 자료형은 append() 메서드로 데이터를 추가하거나, pop() 메서드로 데이터를 삭제할 때 **가장 뒤쪽 원소**를 기준으로 수행된다. 앞쪽에 있는 원소를 처리할 때에는 리스트에 포함된 데이터의 개수에 따라서 많은 시간이 소요될 수 있다. 리스트에서 앞쪽에 있는 원소를 삭제하거나 앞쪽에서 새 원소를 삽입할 때의 시간 복잡도는 O(N)이다.

|                            | 리스트 | deque |
| -------------------------- | ------ | ----- |
| 가장 앞쪽에 원소 추가      | O(N)   | O(1)  |
| 가장 뒤쪽에 원소 추가      | O(1)   | O(1)  |
| 가장 앞쪽에 있는 원소 제거 | O(N)   | O(1)  |
| 가장 뒤쪽에 있는 원소 제거 | O(1)   | O(1)  |

deque는 리스트 자료형과 다르게 **인덱싱, 슬라이싱 등의 기능은 사용할 수 없**다. 다만, 연속적으로 나열된 데이터의 시작 부분이나 끝부분에 데이터를 삽입하거나 삭제할 때는 매우 효과적으로 사용될 수 있다. deque는 **스택**이나 **큐**의 기능을 모두 포함한다고 볼 수 있다.

첫 번째 원소를 제거할 때 **popleft()** 를 사용한다. 마지막 원소를 제거할 때 **pop()** 을 사용한다. 첫 번째 인덱스에 원소 x를 삽입할 때 **appendleft(x)** 를 사용한다. 마지막 인덱스에 원소를 삽입할 때 **append(x)** 를 사용한다.

```python

from collections import deque  
  
data = deque([2, 3 ,4])  
data.appendleft(1)  
data.append(5)  
  
print(data)  
print(list(data))

```

```

deque([1, 2, 3, 4, 5])
[1, 2, 3, 4, 5]

```

##### b. Counter

Counter는 등장 횟수를 세는 기능을 제공한다.

해당 객체 내부의 원소가 몇 번씩 등장했는지를 알려준다. 따라서 원소별 등장 횟수를 세는 기능이 필요할 때 짧은 소스코드로 구현할 수 있다.

```python

from collections import Counter  
  
counter = Counter(['red', 'blue', 'green', 'red', 'red'])  
  
print(counter)  
print(counter['red'])  
print(counter['green'])  
print(dict(counter))

```

```

Counter({'red': 3, 'blue': 1, 'green': 1})
3
1
{'red': 3, 'blue': 1, 'green': 1}

```

### F. math

필수적인 수학적 기능을 제공하는 라이브러리다. 팩토리얼, 제곱근, 최대공약수(GCD), 삼각함수 관련 함수부터 파이(pi)와 같은 상수를 포함한다.

##### a. factorial()

factorial(x) 함수는 x! 값을 반환한다.

```python

import math  
  
print(math.factorial(5))

```

```

120

```

##### b. sqrt()

sqrt(x) 함수는 x의 제곱근을 반환한다.

```python

import math  
  
print(math.sqrt(7))

```

```

2.6457513110645907

```

##### c. gcd()

gcd(a, b) 함수는 최대 공약수를 반환한다.

```python

import math  
  
print(math.gcd(26, 50))

```

```

2

```

##### d. 수학 상수

파이(pi)나 자연상수(e를) 제공한다.

```python

import math  
  
print(math.pi)  
print(math.e)

```

```

3.141592653589793
2.718281828459045

```

# 7. 자신만의 알고리즘 노트 만들기

모르는 문제나 어려운 문제를 만났을 때는 문제를 복습하면서 반드시 소스코드를 정리하는 것을 추천한다.

틈날 때마다 소스코드를 보기 좋게 정리하는 습관을 들이자.

사용한 소스코드들은 문제를 푼 뒤에 바로 문제 풀이 사이트를 닫지 말고 본인만의 라이브러리 노트에 기록해서 해당 문제를 해결하기 위해 사용한 기능을 라이브러리화하는 것을 추천한다.

라이브러리르 만들 때는 단순히 함수만 작성하는 것보다 해당 함수의 사용 예시(방법)까지 같이 기록해 놓는 것을 추천한다.

# 참고문헌

나동빈, "이것이 취업을 위한 코딩 테스트다 with 파이썬", 초판, 2쇄, 한빛미디어, 2020년

#코딩테스트 #파이썬 #나동빈 #한빛미디어 #자료형 #조건문 #반복문 #입출력 #함수 #라이브러리 #알고리즘노트
 #이것이취업을위한코딩테스트다