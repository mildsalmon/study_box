> 인상깊은 구절의 일부를 내 마음대로 정리하거나 그대로 가져옵니다. 깊은 감동을 위해서는 아래 출처를 통해 확인해주세요.

# 발췌요약

## 0. What's an anti-pattern?

As opposed to design patterns which are common approaches to common problems that have been formalized and are generally considered a good development practices, anti-patterns are the opposite and are undesirable

- Introducing anti-patterns happens for many reasons
	1. absence of code review
	2. a willingness to try out "cool" stuff when simple things might do the trick
	3. not using to right tools
		- code linters and formatters to follow PEP8 conventions
		- docstrings generators 
		- IDEs that support auto-completion
	4. simply not knowing a better alternative
		- which is fine as long as you learn and grow

- Anti-patterns can be spread into one or many of these categories
	1. Correctness
		- Anti-patterns that will literally break your code or make it do the wrong things
	2. Maintainability
		- Anti-patterns that will make your code hard to maintain or extend
	3. Readability
		- Anti-patterns that will make your code hard to read or understand
	4. Performance
		- Anti-patterns that will unnecessarily slow your code down
	5. Security
		- Anti-patterns that will pose a security risk to your program

## 1. Using non-explicit variable names

- Your variable names should always be descriptive to provide a minimum context
	- a variable name should tell you in words what the variable stands for

This makes the code easier to understand for other developers and easier to debug for you

```python

# bad practice

df = pd.read_csv("./customer_reviews.csv")

x = df.groupby("country").agg({"satisfaction_score": "mean"})

# good practice

customer_data = pd.read_csv("./customer_reviews.csv")

average_satisfaction_per_country = customer_data.groupby("country").agg({"satisfaction_score": "mean"})

```

```python

# bad practice

x = data[["f1", "f2", "f3"]]
y = data["target"]

# good practice

features = data[["f1", "f2", "f3"]]
target = data["target"]

```

## 2. Ignoring comments

Code should always be clear in what it's doing and comments should clarify why you are doing it. At the same time, be concise when you comment your code.  
When your code is self-explanatory, comments are not needed.

### Tips.

if you’re using VSCode, you can speed up generating docstrings with this [extension](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring) that automatically generate a comment template for your classes and functions.

## 3. Forgetting to update comments

Comments that contradict the code are worse than no comments at all.

An outdated comment is misleading for everyone working on the code.

There's always time to update comments.

## 4. Using CameCase in function names

PEP8 style guide recommends that function names should always be lowercase, with words separated by underscores.

```python

# bad practice

def computeNetValue(price, tax):
	# ...

# good practice

def compute_net_value(price, tax):
	# ...

```

## 5. Not iterating directly over the elements of an iterator

This is a quite common anti-pattern. You don't necessarily need to iterate over the indices of the elements in an iterator if you don't need them. You can iterate directly over the elements.

**This makes your code more pythonic**

```python

list_of_fruits = ["apple", "pear", "orange"]

# bad practice

for i in range(len(list_of_fruits)):
	fruit = list_of_fruits[i]
	process_fruit(fruit)

# good practice

for fruit in list_of_fruits:
	process_fruit(fruit)

```

## 6. Not using enumerate when you need the element and its index at the same time

When you need to access an element and its index at the same time when iterating over an iterator, use **enumerate**.

```python

list_of_fruits = ["apple", "pear", "orange"]

# bad practice 

for i in range(len(list_of_fruits)):
    fruit = list_of_fruits[i]
    print(f"fruit number {i+1}: {fruit}")

# good practice

for i, fruit in enumerate(list_of_fruits):
    print(f"fruit number {i+1}: {fruit}")
	
```

## 7. Not using zip to iterate over pairs of lists

**zip**is a useful built-in function that allows you to create a list of tuples from two iterators. the first element of each tuple comes from the first iterator, whereas the second element comes from the second iterator.

**zip** can be helpful it you want to iterate over two or more iterators at the same time.

```python

list_of_letters = ["A", "B", "C"]
list_of_ids = [1, 2, 3]

# bad practice 

for i in range(len(list_of_letters)):
    letter = list_of_letters[i]
    id_ = list_of_ids[i]
    process_letters(letter, id_)
		
# good practice

# list(zip(list_of_letters, list_of_ids)) = [("A", 1), ("B", 2), ("C", 3)]

for letter, id_ in zip(list_of_letters, list_of_ids):
    process_letters(letter, id_)
	
```

## 8. Not using a context manager when reading or writing files

When you use **open** without a context manager and some exception occurs before you close the file memory issue could happen and the file might be corrupted along the way.

When you use **with**to open a file and an exception occurs, Python guarantees that the file is closed.

```python

d = {"foo": 1}

# bad practice 

f = open("./data.csv", "wb")
f.write("some data")

v = d["bar"] # KeyError
# f.close() never executes which leads to memory issues

f.close()

# good practice

with open("./data.csv", "wb") as f:
    f.write("some data")
    v = d["bar"]
# python still executes f.close() even if the KeyError exception occurs

```

## 9. Using in to check if an element is contained in a (large) list

Checking if an element is contained in a list using the in statement might be slow for large lists. Consider using set or bisect instead.

```python

# bad practice

list_of_letters = ["A", "B", "C", "A", "D", "B"]
check = "A" in list_of_letters

# good practice

set_of_letters = {"A", "B", "C", "D"}
check = "A" in set_of_letters

```

![](https://miro.medium.com/max/1050/1*qO4sI_V_NXSzqSMjcBaLxA.png)

## 10. Passing mutable default arguments to functions (i.e. an empty list)

- Here's funny things in python that may result in silent errors and obscure bugs
	- default arguments are evaluated once when the function is defined, not each time the function is called.

This means that if you use a mutable default argument (such as a list) and mutate it, you will and have mutated that object for all future calls to the function as well.

```python

# bad practice

def append_to(element, muta=[]):
    muta.append(element)
    return muta

>>> my_list = append_to("a") 
>>> print(my_list)
>>> ["a"]

>>> my_second_list = append_to("b") 
>>> print(my_second_list)
>>> ["a", "b"]

# good practice 

def append_to(element, muta=None):
    if muta is None:
        muta = []
    muta.append(element)
    return muta

```

- To avoid this issue, you can set the default argument **muta** to None
	- if the function with called multiple times with **muta** set to None, create a new empty list and append the element to it each time
	- when you pass a list to **muta**, you append an element to it. Since it's not the default function argument, this works well.

## 11. Returning different types in a single function

When trying to handle special user inputs that may generate errors, you can sometimes introduce None as output. This makes your code inconsistent since your function now returns at least two types: the initial type you intended and the NoneType type.

This makes it hard to test and debug later.

Instead of returning None, you can raise an error and later catch it.

```python

# bad practice

def get_code(username):
    if username != "ahmed":
        return "Medium2021"
    else:
        return None

code = get_code("besbes")

# good practice: raise an exception and catch it

def get_code(username):
    if username != "ahmed":
        return "Medium2021"
    else:
        raise ValueError

try:
    secret_code = get_code("besbes")
    print("The secret code is {}".format(secret_code))
except ValueError:
    print("Wrong username.")
	
```

## 12. Using while loops when simple for loops would do the trick

You don’t need to use a while loop if you already know the number of iterations beforehand.

```python

# bad practice

i = 0
while i < 5:
    i += 1 
    some_processing(i) 
    ...

# good practice

for i in range(5):
    some_processing(i) 
    ...
	
```

## 13. Using stacked and nested if statements

Stacked and nested if statements make it hard to follow the code logic.

Instead of nesting conditions, you can combine them with Boolean operators.

```python

user = "Ahmed"
age = 30
job = "data scientist"

# bad practice

if age > 30:
    if user == "Ahmed":
        if job == "data scientist":
            access = True
        else:
            access = False

# good practice

access = age > 30 and user == "ahmed" and job == "data scientist"

```

## 14. Using global variables

Avoid global variables like the plague. They’re a source of many errors. They can be simultaneously accessed from multiple sections of a program and this may result in bugs.

The typical error that arises when using global variables is when a function accesses its values before another one needs to update properly.

```python

x = 0

def complex_processing(i):
    global x
    x += 1
    return x

>>> complex_processing(1)
>>> x 
1
>>> complex_processing(1)
>>> x
2

```

## 15. Not using get() to return default values from a dictionary

When you use **get**, python checks if the specified key exists in the dictionary. If it does, then **get()** returns the value of that key. If the key doesn't exist, **get()** returns the value specified in the second argument.

```python

user_ids = {
    "John": 12,
    "Anna": 2,
    "Jack": 10
}

# bad practice

name = "Paul"

if name in user_ids:
    user_id = user_ids[name]
else:
    user_id = None

# good practice

user_id = user_ids.get(name, None)

```

## 16. Using try/except blocks that don't handle exceptions meaningfully

Using a try/except block and ignoring the exception by passing it (for instance) should be avoided.

```python

user_ids = {"John": 12, "Anna": 2, "Jack": 10}

user = "Paul"
# bad practice

try:
    user_id = user_ids[user]
except:
    pass

# good practice

try:
    user_id = user_ids[user]
except KeyError:
    print("user id not found")
	
```

## 17. proudly typing: from module import *

Imports should always be specific. Importing * from a module is a very bad practice that pollutes the namespace.

```python

# bad practice

from math import *
x = ceil(x)

# good practice

from math import ceil
x = ceil(x) # we know where ceil comes from

```

## 18. Over-engineering everything

You don’t always need a class. Simple functions can be very useful.

Essentially, a class is a way of grouping functions (as methods) and data (as properties) into a logical unit revolving around a certain kind of thing. If you don’t need that grouping, there’s no need to make a class.

```python

# bad practice

class Rectangle:
    def __init__(self, height, width):
        self.height = height
        self.width = width
    
    def area(self):
        return self.height * self.width

# good practice: a simple function is enough

def area(height, width):
    return height * width

```

# 내 생각

## 0. What's an anti-pattern?

공식화되고 일반적으로 고려되는 좋은 개발 관행인 일반적인 문제에 일반적인 접근방식인 디자인 패턴과 다르게, 안티 패턴은 반대이며 바람직하지 않다.

- 많은 이유로 발생하는 안티 패턴을 소개한다.
	1. 코드 리뷰의 부재
	2. 간단하게 해결할 수 있는 일을 멋지게 처리하려고 시도할 때
	3. 올바른 도구들을 사용하지 않음
		- PEP8 작성규칙을 따르는 code linters와 formatters
		- docstrings 생성기
		- 자동완성을 지원하는 IDE
	4. 단순히 더 나은 방법을 모를 때
		- 꾸준히 배우고 성장한다면 괜찮다.

- Anti-patterns은 하나 이상의 아래 예시로 확산될 수 있다.
	1. 정확성
		- 안티 패턴은 코드를 고장내거나 잘못된 일을 하게 만들 수 있다.
	2. 유지보수성
		- 안티 패턴은 코드를 유지보수하기 어렵게 만들거나 확장하기 어렵게 만들 수 있다.
	3. 가독성
		- 안티 패턴은 코드를 읽기 어렵게 만들거나 이해하기 어렵게 만든다. 
	4. 성능
		- 안티 패턴으로 불필요하게 속도가 느려진다.
	5. 보안
		- 안티 패턴은 너의 프로그램에 보안 위험을 초래한다.

## 1. 불분명한 변수 이름 사용

- 변수 이름은 항상 설명 최소한의 문맥을 제공하기 위해 설명적이어야 한다.
	- 변수 이름은 어떤 의미인지 단어로 알려야 한다.

이 방법은 코드를 다른 개발자들이 이해하기 쉽게 만들고 스스로 디버깅하기 쉽게 만든다.

```python

# bad practice

df = pd.read_csv("./customer_reviews.csv")

x = df.groupby("country").agg({"satisfaction_score": "mean"})

# good practice

customer_data = pd.read_csv("./customer_reviews.csv")

average_satisfaction_per_country = customer_data.groupby("country").agg({"satisfaction_score": "mean"})

```

```python

# bad practice

x = data[["f1", "f2", "f3"]]
y = data["target"]

# good practice

features = data[["f1", "f2", "f3"]]
target = data["target"]

```

## 2. 주석 작성하지 않기

코드는 항상 동작이 분명해야하고 주석는 왜 너가 이렇게 작성했는지 분명해야 한다. 동시에 코드에 주석을 달때 간결하다. 코드가 스스로 설명된다면 주석은 필요없다.

### Tips.

만약 VSCode를 사용한다면, class 또는 함수에 자동으로 주석 템플릿을 생성해주는 [extension](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)을 사용하여 docstring 생성 속도를 높일 수 있다.

## 3. 주석 업데이트를 까먹기

코드와 모순되는 주석은 주석이 전혀 없는 것보다 나쁘다.

오래된 주석은 코드를 보는 모든 작업자들을 오해하게 할 수 있다.

항상 주석을 업데이트할 시간은 있다.

## 4. 함수 이름에 낙타 표기법을 사용하기

PEP8 스타일 가이드는 함수 이름에는 항상 소문자를 사용하고, 언더스코어로 단어를 구분하는 것을 추천한다.

```python

# bad practice

def computeNetValue(price, tax):
	# ...

# good practice

def compute_net_value(price, tax):
	# ...

```

## 5. 반복자 원소를 직접 반복하지 않음

이것은 꽤 일반적으로 사용되는 안티 패턴이다. 만약 필요하지 않는 경우 iterator의 원소의 인덱스를 반복할 필요가 없다. 원소를 직접 반복할 수 있다.

**이 방법은 코드를 더 pythonic하게 만들어 줄 수 있다.**

```python

list_of_fruits = ["apple", "pear", "orange"]

# bad practice

for i in range(len(list_of_fruits)):
	fruit = list_of_fruits[i]
	process_fruit(fruit)

# good practice

for fruit in list_of_fruits:
	process_fruit(fruit)

```

## 6. 원소와 index가 동시에 필요할 때 enumerate를 사용하지 않음

iterator를 통해 반복할 때 원소와 index에 동시에 접근이 필요한 경우 **enumerate**를 사용할 수 있다.

```python

list_of_fruits = ["apple", "pear", "orange"]

# bad practice 

for i in range(len(list_of_fruits)):
    fruit = list_of_fruits[i]
    print(f"fruit number {i+1}: {fruit}")

# good practice

for i, fruit in enumerate(list_of_fruits):
    print(f"fruit number {i+1}: {fruit}")
	
```

---

어떤 글들을 보면, 'enumerate가 range를 사용하는 것보다 무조건 좋다.'는 글들이 있는데, 이런 접근은 좋지 않다. enumerate를 사용하면 원소와 index를 동시에 사용할 수 있다는 점에 초점을 맞추는 것이 좋다.

[코딩테스트 연습 - 주식가격 | 프로그래머스 (programmers.co.kr)](https://programmers.co.kr/learn/courses/30/lessons/42584)

```python

def solution(prices):  
    answer = []  
  
    for i, price in enumerate(prices):  
        sec = 0  
        for j, next_price in enumerate(prices[i + 1:]):  
            sec += 1  
            if price > next_price:  
                break  
        answer.append(sec)  
  
    return answer

```

```python

def solution(prices):  
    answer = []  
  
    for i, price in enumerate(prices):  
        sec = 0  
        for j in range(i + 1, len(prices)):  
            sec += 1  
            if price > prices[j]:  
                break  
        answer.append(sec)  
  
    return answer

```

위 문제를 enumerate만 이용해서 푸는 방법과 range를 조합하여 푸는 방법으로 풀어봤다. 만약 enumerate가 range보다 절대적으로 좋다면, 첫 번째 코드는 무조건 성공해야 한다. 하지만 첫 번째 코드는 효율성 케이스에서 실패하고 두 번째 코드는 모든 경우에 대해 성공한다.

물론 이 경우는 매 반복마다 리스트 슬라이싱을 다시 해주기 때문에 (`enumerate(prices[i + 1:])`) 시간 초과가 발생하는 것이긴 하다.

결론은 어떤 방법이 절대적으로 좋다, 빠르다는 생각을 하기보다는 상황에 맞게 적절히 코드를 작성하는 것이 좋다.

## 7. lists의 쌍을 반복하기 위해 zip을 사용하지 않음

**zip**은 두 반복자들로부터 튜플 목록을 생성할 수 있는 유용한 내장 함수이다. 각 튜플의 첫 번째 원소는 첫 번째 iterator에서 가져오고 두 번째 원소는 두 번째 iterator에서 가져온다.

**zip**은 둘 이상의 반복자를 반복하려는 경우에 유용할 수 있다.

```python

list_of_letters = ["A", "B", "C"]
list_of_ids = [1, 2, 3]

# bad practice 

for i in range(len(list_of_letters)):
    letter = list_of_letters[i]
    id_ = list_of_ids[i]
    process_letters(letter, id_)
		
# good practice

# list(zip(list_of_letters, list_of_ids)) = [("A", 1), ("B", 2), ("C", 3)]

for letter, id_ in zip(list_of_letters, list_of_ids):
    process_letters(letter, id_)
	
```

---

zip은 2차원 리스트를 전치시킬 수도 있다.

```python

a = [[1, 2, 3],
     [4, 5, 6],
     [7, 8, 9]]

for b in zip(*a):
    print(b)
    
(1, 4, 7)
(2, 5, 8)
(3, 6, 9)

```

## 8. 파일을 read하거나 write할 때 context manager를 사용하지 않음

context manager 없이 **open**을 사용하고 파일을 닫기 전에 일부 예외가 발생하면 메모리 문제가 발생할 수 있고 그 과정에서 파일이 손상될 수 있다.

**with**를 사용하여 파일을 열 때 예외가 발생하면 python은 파일이 닫히는 것을 보장한다.

```python

d = {"foo": 1}

# bad practice 

f = open("./data.csv", "wb")
f.write("some data")

v = d["bar"] # KeyError
# f.close() never executes which leads to memory issues

f.close()

# good practice

with open("./data.csv", "wb") as f:
    f.write("some data")
    v = d["bar"]
# python still executes f.close() even if the KeyError exception occurs

```

## 9. 원소가 (큰) list에 포함되어 있는지 확인하기 위해 in을 사용한다.

in을 사용하여 list에 원소가 있는지 확인하는 것은 큰 list의 경우 느릴 수 있다. 대신 set이나 bisect을 사용해라.

```python

# bad practice

list_of_letters = ["A", "B", "C", "A", "D", "B"]
check = "A" in list_of_letters

# good practice

set_of_letters = {"A", "B", "C", "D"}
check = "A" in set_of_letters

```

---

list에 in을 하는 경우 시간 복잡도는 O(n)이다. 여기에서 n은 list의 길이와 동일하다. 하지만 set에 in을 하는 경우 시간 복잡도는 O(1)이다. set의 경우 dict과 동일하게 hashtable이기 때문이다.

## 10. mutable default argument를 함수에 전달 (i.e. 빈 list)

- 이것은 조용한 오류와 모호한 버그를 유발할 수 있는 파이썬의 재미있는 것들이다.
	- default arguments는 함수가 호출될 때마다가 아니라 함수가 정의될 때 한 번 평가된다.

mutable default argument (list같은)를 사용하고 변경하면, 이후에 함수에 대한 모든 호출에 대해서도 해당 객체를 변경하게 된다.

```python

# bad practice

def append_to(element, muta=[]):
    muta.append(element)
    return muta

>>> my_list = append_to("a") 
>>> print(my_list)
>>> ["a"]

>>> my_second_list = append_to("b") 
>>> print(my_second_list)
>>> ["a", "b"]

# good practice 

def append_to(element, muta=None):
    if muta is None:
        muta = []
    muta.append(element)
    return muta

```

- 이 문제를 피하기 위해 default argument인 **muta**를 None으로 설정할 수 있다.
	- **muta**가 None인 상태로 함수가 여러번 불려진다면, 새로운 빈 list를 만들고 매번 원소를 추가하게 된다.
	- **muta**에 list를 전달할 때, 원소를 추가한다. default argument가 아니기 때문에 잘 작동한다.

---

### A. 예제

#### a. 디폴트 매개변수에 mutable 객체를 선언하여 문제 발생

```python

>>> import datetime
>>> import time

>>> # stopwatch 함수 선언
>>> def stopwatch(date_info = []):
>>>     date_info.append(datetime.datetime.now())
>>>     return date_info

>>> print("##### Phase 1 #########")
>>> print(f'stopwatch 함수 선언 후 바로 실행\n\t{stopwatch()}')
>>> print(f'stopwatch 함수의 defaults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> print("##### Phase 2 #########")
>>> print(f'stopwatch 실행\n\t{stopwatch()}')
>>> print(f'stopwatch 함수의 defaults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> print("##### Phase 3 #########")
>>> print(f'stopwatch 새로 실행\n\t{stopwatch([])}')
>>> print(f'stopwatch 함수의 defaults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> print("##### Phase 4 #########")
>>> print(f'stopwatch 실행\n\t{stopwatch()}')
>>> print(f'stopwatch 함수의 defaults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()

------

##### Phase 1 #########
stopwatch 함수 선언 후 바로 실행
    [datetime.datetime(2022, 4, 3, 9, 48, 9, 400298)]
stopwatch 함수의 defaults 매개변수
    ([datetime.datetime(2022, 4, 3, 9, 48, 9, 400298)],)
현재 시간
    2022-04-03 09:48:09.400298
    
##### Phase 2 #########
stopwatch 실행
    [datetime.datetime(2022, 4, 3, 9, 48, 9, 400298), datetime.datetime(2022, 4, 3, 9, 48, 19, 411539)]
stopwatch 함수의 defaults 매개변수
    ([datetime.datetime(2022, 4, 3, 9, 48, 9, 400298), datetime.datetime(2022, 4, 3, 9, 48, 19, 411539)],)
현재 시간
    2022-04-03 09:48:19.411539
    
##### Phase 3 #########
stopwatch 새로 실행
    [datetime.datetime(2022, 4, 3, 9, 48, 29, 411675)]
stopwatch 함수의 defaults 매개변수
    ([datetime.datetime(2022, 4, 3, 9, 48, 9, 400298), datetime.datetime(2022, 4, 3, 9, 48, 19, 411539)],)
현재 시간
    2022-04-03 09:48:29.411675
    
##### Phase 4 #########
stopwatch 실행
    [datetime.datetime(2022, 4, 3, 9, 48, 9, 400298), datetime.datetime(2022, 4, 3, 9, 48, 19, 411539), datetime.datetime(2022, 4, 3, 9, 48, 39, 423540)]
stopwatch 함수의 defaults 매개변수
    ([datetime.datetime(2022, 4, 3, 9, 48, 9, 400298), datetime.datetime(2022, 4, 3, 9, 48, 19, 411539), datetime.datetime(2022, 4, 3, 9, 48, 39, 423540)],)
현재 시간
    2022-04-03 09:48:39.423540
    
```

1.  default 매개변수가 계속 누적되는 것을 볼 수 있다.
2.  stopwatch를 재실행해도 Phase 4에서는 이전에 실행했던 stopwatch 기록으로 기록이 진행된다.

#### b. 해결 방법

```python

>>> import datetime
>>> import time

>>> # stopwatch 함수 선언
>>> def stopwatch(date_info = None):
>>>     if date_info is None:
>>>         date_info = []
>>>     date_info.append(datetime.datetime.now())
>>>     return date_info

>>> record = None

>>> print("##### Phase 1 #########")
>>> print(f'stopwatch 함수 선언 후 바로 실행\n\t{stopwatch(record)}')
>>> print(f'stopwatch 함수의 defqults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> print("##### Phase 2 #########")
>>> print(f'stopwatch 실행\n\t{stopwatch(record)}')
>>> print(f'stopwatch 함수의 defqults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> record = []

>>> print("##### Phase 3 #########")
>>> print(f'stopwatch 새로 실행\n\t{stopwatch(record)}')
>>> print(f'stopwatch 함수의 defqults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()
>>> time.sleep(10)

>>> print("##### Phase 4 #########")
>>> print(f'stopwatch 실행\n\t{stopwatch(record)}')
>>> print(f'stopwatch 함수의 defqults 매개변수\n\t{stopwatch.__defaults__}')
>>> print(f'현재 시간\n\t{datetime.datetime.now()}')
>>> print()

-------

##### Phase 1 #########
stopwatch 함수 선언 후 바로 실행
    [datetime.datetime(2022, 4, 3, 10, 6, 25, 272702)]
stopwatch 함수의 defqults 매개변수
    (None,)
현재 시간
    2022-04-03 10:06:25.272702
    
##### Phase 2 #########
stopwatch 실행
    [datetime.datetime(2022, 4, 3, 10, 6, 35, 274798)]
stopwatch 함수의 defqults 매개변수
    (None,)
현재 시간
    2022-04-03 10:06:35.274798
    
##### Phase 3 #########
stopwatch 새로 실행
    [datetime.datetime(2022, 4, 3, 10, 6, 45, 280475)]
stopwatch 함수의 defqults 매개변수
    (None,)
현재 시간
    2022-04-03 10:06:45.280475
    
##### Phase 4 #########
stopwatch 실행
    [datetime.datetime(2022, 4, 3, 10, 6, 45, 280475), datetime.datetime(2022, 4, 3, 10, 6, 55, 280664)]
stopwatch 함수의 defqults 매개변수
    (None,)
현재 시간
    2022-04-03 10:06:55.280664

```

## 11. 하나의 함수에서 여러 종류의 type 반환

에러를 발생시킬 수 있는 특수 사용자 입력을 처리하려고 할 때, 출력으로 None을 도입할 수 있다. 이제 함수가 최소 두가지 이상의 타입을 반환하므로 코드가 일관되지 않게 된다. (의도한 초기 타입과 None 타입)

이 방식은 나중에 테스트와 디버깅을 어렵게 만든다.

None을 반환하는 대신 에러를 raise하고 나중에 해결할 수 있다.

```python

# bad practice

def get_code(username):
    if username != "ahmed":
        return "Medium2021"
    else:
        return None

code = get_code("besbes")

# good practice: raise an exception and catch it

def get_code(username):
    if username != "ahmed":
        return "Medium2021"
    else:
        raise ValueError

try:
    secret_code = get_code("besbes")
    print("The secret code is {}".format(secret_code))
except ValueError:
    print("Wrong username.")
	
```

## 12. 간단한 for 반복문으로 해결할 수 있는 것을 while 반복문으로 해결하기

만약 미리 반복 횟수를 알 수 있다면 while 반복문을 사용할 필요 없다.

```python

# bad practice

i = 0
while i < 5:
    i += 1 
    some_processing(i) 
    ...

# good practice

for i in range(5):
    some_processing(i) 
    ...
	
```

## 13. 쌓이거나 중첩된 if 문의 사용

쌓이거나 중첩된 if 문은 코드 logic을 따르기 어렵게 만든다.

조건을 중첩하는 대신, Boolean 연산자와 결합할 수 있다.

```python

user = "Ahmed"
age = 30
job = "data scientist"

# bad practice

if age > 30:
    if user == "Ahmed":
        if job == "data scientist":
            access = True
        else:
            access = False

# good practice

access = age > 30 and user == "ahmed" and job == "data scientist"

```

## 14. 전역변수 사용하기

전염병 같은 전역 변수를 자제해라. 그것들은 많은 오류의 원인이다. 프로그램의 여러 섹션에서 동시에 접근할 수 있고 버그가 발생할 수 있다.

전역변수를 사용할때 나타나는 일반적인 에러는 다른 함수가 제대로 업데이트하기 전에 함수가 값에 접근할 때 발생한다.

```python

x = 0

def complex_processing(i):
    global x
    x += 1
    return x

>>> complex_processing(1)
>>> x 
1
>>> complex_processing(1)
>>> x
2

```

## 15. get()을 사용하여 dict에서 기본값을 반환하지 않음

**get**을 사용하면 python은 지정된 key가 dict에 있는지 확인한다. 만약 key가 존재한다면 **get()** 이 key의 value를 반환한다. key가 존재하지 않는다면, **get()** 은 지정된 두 번째 인수를 반환한다.

```python

user_ids = {
    "John": 12,
    "Anna": 2,
    "Jack": 10
}

# bad practice

name = "Paul"

if name in user_ids:
    user_id = user_ids[name]
else:
    user_id = None

# good practice

user_id = user_ids.get(name, None)

```

## 16. 의미 있게 예외를 처리하지 않는 try/except blocks 사용

try/except block 사용하고 예외를 전달하여 무시하는 것은 자제해야 한다.

```python

user_ids = {"John": 12, "Anna": 2, "Jack": 10}

user = "Paul"
# bad practice

try:
    user_id = user_ids[user]
except:
    pass

# good practice

try:
    user_id = user_ids[user]
except KeyError:
    print("user id not found")
	
```

## 17. 당당하게 from module import * 을 사용하기

Import는 항상 구체적이어야 한다. module에서 * 를 가져오는 것은 namespace를 오염시키는 매우 나쁜 습관이다.

```python

# bad practice

from math import *
x = ceil(x)

# good practice

from math import ceil
x = ceil(x) # we know where ceil comes from

```

## 18. 모든 것을 과하게 engineering하기

항상 class가 필요하지는 않다. 단순한 함수가 유용할 때도 있다.

기본적으로 class는 특정한 것에 대한 논리적 단위로 메소드와 속성을 그룹화하는 방법이다. 만약 그룹화가 필요 없다면 class를 만들 필요가 없다.

```python

# bad practice

class Rectangle:
    def __init__(self, height, width):
        self.height = height
        self.width = width
    
    def area(self):
        return self.height * self.width

# good practice: a simple function is enough

def area(height, width):
    return height * width

```

# 참고문헌

[Ahmed Besbes](https://ahmedbesbes.medium.com/?source=post_page-----44d983805f0f--------------------------------). [18 Common Python Anti-Patterns I Wish I Had Known Before | by Ahmed Besbes | Towards Data Science](https://towardsdatascience.com/18-common-python-anti-patterns-i-wish-i-had-known-before-44d983805f0f). Medium. (accessed Apr 30, 2022)
