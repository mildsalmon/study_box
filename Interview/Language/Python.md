# 1. 파이썬 generator에 대해 설명하라.

Generator는 Iterator를 생성해주는 함수이다. 이터레이터 클래스에는 \_\_iter\_\_, \_\_next\_\_, \_\_getitem\_\_ 메서드를 구현해야 하지만, generator는 함수 안에 yield 키워드를 사용하면 된다. 그래서 iterator보다 generator를 더 간단하게 작성할 수 있다.

Iterator는 next()함수를 이용해서 데이터를 순차적으로 접근할 수 있는 함수이다.

# 2. GIL에 대해 설명하시오.

Global Interpreter Lock

GIL은 한번에 하나의 스레드만 수행할 수 있도록 인터프리터에 lock을 거는 기능.

파이썬 객체는 garbage collection 기능을 위해, reference count를 가지고 있는데, 해당 객체를 참조할때마다 reference count 값을 변경해야 한다. 멀티스레드를 실행하게되면 reference count를 관리하기 위해서 모든 객체에 대한 lock이 필요할 것이다. 이런 비효율을 막기위해서 gil을 사용한다.

하나의 lock을 통해서 모든 객체들에 대한 reference count의 동기화 문제를 해결한 것이다.

# 3. GC 동작 방식

reference counting 방식과 generational garbage collection 방식이 있다.

다른 객체가 해당 객체를 참조한다면 reference counting이 증가하고 참조가 해제되면 감소한다. reference counting이 0이 된다면, 객체의 메모리 할당이 해제된다.

# 4. immutable 객체와 mutable 객체

## A. immutable 객체

**변경 불가능한 객체**

만들어진 이후에는 바뀔 수 없다는 것을 의미한다.

- int, float, bool, str, tuple, unicode

## B. mutable 객체

**변경 가능한 객체**

만들어진 이후에 바뀔 수 있다는 것을 의미한다.

- List, Set, Dict

# 5. Call by assignment (call by object-reference)

파이썬은 call by value, call by reference가 아닌 call by assignment이다.

mutable 객체를 바꾸는 것이 아닌, 객체 내의 원소(element, 요소)를 변경하는 것이다.

immutable 한 포멧의 객체 (tuple, int 등)는 변경할 수 없지만, mutable 한 포멧의 객체 (list, dict, set 등)는 변경할 수 있다는 특성을 갖는다.

# 6. 비트 연산자

오늘 이 글을 작성하는 이유는 `~` 연산 때문이다. 그러나 `~` 연산만 작성하기에는 애매해서 다른 비트 연산자도 정리하려고 한다.

파이썬에서 10진수를 2진수로 표현하려면 `format()`이나 `bin()`을 사용한다

```python

In[1]: format(5, 'b')
Out[1]: '101'

In[2]: bin(5)
Out[2]: '0b101'
	
```

### A. &

- AND 연산
- 둘 다 참일때만 만족

```python

In[3]: bin(0b1010 & 0b1100)
Out[3]: '0b1000'

```

### B. |

- OR 연산
- 둘 중 하나만 참이여도 만족

```python

In[4]: bin(0b1010 | 0b1100)
Out[4]: '0b1110'

```

### A. ^

- XOR 연산
- 둘 중 하나만 참일 때 만족

```python

In[5]: bin(0b1010 ^ 0b1100)
Out[5]: '0b110' # 0b0110 --맨 앞의 0 생략--> 0b110

```

### A. ~

- 보수 연산
- 0은 1로 1은 0으로 바꿈

```python

In[6]: bin(0b1010)
Out[6]: '0b1010'
	
In[7]: bin(~0b1010)
Out[7]: '-0b1011'
	
In[8]: bin(-0b1010)
Out[8]: '-0b1010'
	
In[9]: bin(~-0b1010)
Out[9]: '0b1001'
	
In[10]: bin(-~0b1010)
Out[10]: '0b1011'

```

`~` 연산은 무엇일까? `~` 연산은 2진수 값의 0과 1을 바꾸는 것이다.

그런데 왜 `In[7]`에서는 `0b0101`이 아닌 `-0b1011`이 반환되는 것일까?

그 이유는 다음 로직에서 알 수 있다.

1. 1010(2) -> 10에 NOT(~) 연산을 사용해보자.
2. 1010
3. 0101 (1의 보수)
4. 1010 (다시 1의 보수)
5. 1011 (1을 더하여 2의 보수로 변환)
6. -1011 (- 기호 추가, -11)
	- 여기까지가 `-0b1011` [1]
7. 0101 (- 기호는 2의 보수로 변환할 수 있음)
	- - 기호를 적용한다면 `~` 연산 결과를 알 수 있음.

결국, `~` 연산은 0과 1이 모두 반전되므로, 1의 보수를 찾는 것과 동일하다.

그래서 다음과 같은 결론도 도출이 가능하다. [2]

1. 비트 연산자(NOT)는 2의 보수에서 1을 뺀 값
2. 2의 보수(수학 연산)은 비트 연산자(NOT)에서 1을 더한 값

---

`In[8]`은 단순히 `0b1010`에 `-` 부호를 붙인 것이다.

`In[9]`는 `-0b1010`의 `-` 부호를 2의 보수로 변환(`0b0110`)하고 `~` 부호를 적용하여 `-0b0111`에서 `-` 부호를 2의 보수로 변환하여 `0b1001`을 만들어낸다.

그런데 여기서 `~` 연산자를 적용할 때 왜 `-0b0111`이 아닌 `0b1001`인지는 잘 모르겠다.

`In[10]`은 `In[7]`에서 `-` 부호만 제거한 것이다.

### A. <<

- 왼쪽 시프트 연산자
- 변수의 값을 왼쪽으로 지정된 비트 수 만큼 이동

```python

In[11]: bin(0b101011 << 2)
Out[11]: '0b10101100'

```

### A. <<

- 오른쪽 시프트 연산자
- 변수의 값을 오른쪽으로 지정된 비트 수 만큼 이동

```python

In[12]: bin(0b101011 >> 2)
Out[12]: '0b1010'

```

# 7. 메타 클래스 (Meta Class)

클래스로 객체를 만들 듯 메타 클래스로 클래스를 만들 수 있다는 의미이다.

**type()** 이 메타 클래스이다.

type() 메타 클래스로 클래스를 만들면 아래와 같다.

```python

In[1]: a = type('temp', (), {})
In[2]: a

Out[2]: __main__.temp

```

(), {}는 각각 튜플과 딕셔너리로 상속 클래스 정의와 클래스에서 정의할 속성과 메서드가 들어간다.

```python

In[3]: class temp:
	    a = 3
	    def m(self, m, n):
	        return m + n
In[4]: ins = temp()

Out[4]: ins.m(3,4)

```

이 클래스를 type() 이용해 만들면 다음과 같다.

```python

In[5]: ins = type('temp', (object,), {'a':3, 'm':lambda a, b: a+b})
In[6]: ins.m(3,4)

Out[6]: 7
	
```

- 첫 번째 인자는 클래스명, 
- 두 번째 인자는 상속 시켜줄 부모 클래스, 
- 세 번째 인자는 클래스에서 명시할 속성과 메서드.	
	- 메서드는 lambda를 사용해도 되고 함수를 하나 만들어 변수에 넣고 그 변수를 여기에 명시해도 된다.

## A. 메타클래스로 할 수 있는 것

1. 위 예시처럼 동적으로 클래스를 만들 수 있다. 클래스에 명시되는 속서오가 메서드를 딕셔너리에 넣으면 되니 동적으로 만드는 것이 어렵지 않다.
2. 커스텀 메타 클래스를 만들 수 있다.

커스텀 메타 클래스를 활용하면 클래스를 컨트롤해 원하는 방향으로 클래스가 생성되게 만들 수 있다.

클래스가 만들어 질 때 특정 속성은 반드시 정수가 되도록 만들어보자. 검증 과정은 메타 클래스에서 중요한 부분이 될 수 있다.

```python

In[7]: class myMetaclass(type):
			def __new__(cls, clsname, bases, dct):
				assert type(dct['a']) is int, 'a속성이 정수가 아니에요.'
				return type.__new__(cls, clsname, bases, dct)
			
		class temp(metaclass=myMetaclass):
			a = 3.14

		ins = temp()

Out[7]:	Traceback (most recent call last):
		  File "C:\python\anaconda3_64\Lib\site-packages\IPython\core\interactiveshell.py", line 3437, in run_code
			exec(code_obj, self.user_global_ns, self.user_ns)
		  File "<ipython-input-8-37f754f405f1>", line 7, in <module>
			class temp(metaclass=myMetaclass):
		  File "<ipython-input-8-37f754f405f1>", line 4, in __new__
			assert type(dct['a']) is int, 'a속성이 정수가 아니에요.'
		AssertionError: a속성이 정수가 아니에요.

```

커스텀 메타 클래스를 만들기 위해서는 type 클래스를 상속받아야 한다. 그리고 type클래스가 가지고 있는 new 메서드를 오버라이드하면 된다. 이 메서드에 하고 싶은 것을 명시하면 된다.

new메서드에 필요한 인자는 4개인데, 마지막 dct인자에 메타 클래스로 클래스를 만들 때 속성과 메서드를 이곳에 명시하면 된다.

assert로 검증을 시도한다. 속성 중 a라는 속성에 대해 정수인지 검증한다.

new메서드에서 반환해야 할 값은 type.new() 메서드로 받은 클래스이다.

테스트하기 위해 메타 클래스를 사용해야 하는데 클래스를 만들면서 `metaclass=`라는 인자에 명시하면 된다.

# 8. PyQt 시그널/슬롯

## A. 시그널

위젯에 정의된 이벤트

## B. 슬롯

이벤트가 발생할 때 호출되는 함수나 메서드

# 9. 상수

파이썬에는 상수가 없다.

# 10. 정적 메소드 (Static Method, Class Method)

- 공통점
	- 인스턴스를 만들지 않아도 class의 메서드를 바로 실행할 수 있다.

## A. @staticmethod

```python

#staticmethod
class hello:
    num = 10

    @staticmethod
    def calc(x):
        return x + 10

print(hello.calc(10))
#결과
20

```

매개변수에 `self`를 지정하지 않는다.

self를 받지 않으므로 인스턴스 속성에는 접근할 수 없다. 그래서 보통 정적 메소드를 사용할 때는 인스턴스 속성, 인스턴스 메서드가 필요 없을 때 사용한다.

정적 메서드는 메서드의 실행이 외부 상태에 영향을 끼치지 않는 순수 함수를 만들 때 사용해야 한다. 순수 함수는 입력 값이 같으면 언제나 같은 출력 값을 반환한다. 즉, 인스턴스의 상태를 변화시키지 않는 메서드를 만들 때 사용한다.

## B. @classmethod

```python

#classmethod
class hello:
    num = 10

    @classmethod
    def calc(cls, x):
        return x + 10

print(hello.calc(10))
#결과
20

-------------------------------------

#classmethod
class hello:
    num = 10

    @classmethod
    def calc(cls, x):
        return x + 10 + cls.num

print(hello.calc(10))
#결과
30

```

staticmethod와 다르게 cls 인자가 추가된다.

cls는 클래스를 가리킨다. 이것으로 클래스의 어떤 속성에도 접근할 수 있다.

```python

class hello:
    t = '내가 상속해 줬어'

    @classmethod
    def calc(cls):
        return cls.t

class hello_2(hello):
    t = '나는 상속 받았어'

print(hello_2.calc())
#결과
나는 상속 받았어

```

상속 관계에 있는 클래스들에서는 cls는 상속받은 클래스(hello_2)의 값(t)이 출력된다.

클래스 메서드는 메서드 안에서 클래스 속성, 클래스 메서드에 접근해야 할 때 사용한다.

# 11. 언더스코어와 더블 언더스코어

## A. 언더스코어 (\_, Single Underscore)

언더스코어를 사용한 변수는 프로그래머한테 private처럼 사용할테니 외부에서 접근하지 말라는 의미이다.

이 경우, 해당 모듈을 외부에서 참조할 경우 변수가 없는 것처럼 보이나 실제로는 접근 가능하다.

접근제한을 권유하지만 강제하진 않는다. 언더스코어를 붙인다는 것은 일종의 컨벤션이다.

```python

class A:  
_a = 1  
a = 2  
b = 3  
  
print(dir(A))  
print(A._a)

#결과

['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_a', 'a', 'b']
1

```

## B. 더블 언더스코어 (\_\_, Double Underscore)

더블언더스코어도 private를 구현하기 위해 사용한다. 하지만 접근 자체가 불가능하다.

더블언더스코어 사용은 애초에 클래스 안에 비슷한 이름들끼리 충돌을 방지하기 위해서 사용한다.

```python

class A:  
_a = 1  
a = 2  
b = 3  
  
print(dir(A))  
print(A._a)

#결과

['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_a', 'a', 'b']
1

#결과

['_A__a', '__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'a', 'b']
Traceback (most recent call last):
  File "D:/CloudStation/SourceCode/PS/del/12.py", line 7, in <module>
    print(A._a)
AttributeError: type object 'A' has no attribute '_a'

```

```python

class A:  
__a = 1  
a = 2  
b = 3  
  
z = A()  
  
print(dir(A))  
print(z._A__a)

#결과

['_A__a', '__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'a', 'b']
1

```

더블언더스코어(\_\_a)에 접근하기 위해서는 치환된 변수명을 알아야한다. 예제에서 치환된 변수명은 `_A__a`이다. 그래서 `_A__a`로 접근할 수 있다.


# 12. 파이썬 sort() 함수의 정렬 알고리즘

TimSort 알고리즘을 사용한다.

## A. TimSort 알고리즘

Merge 정렬과 Insert 정렬에서 파생된 하이브리드 정렬 알고리즘이다.

stable하다. (정렬 알고리즘에서 stability란 원래 순서를 갖고 정렬을 할 수 있냐, 없냐의 차이)

### a. 시간복잡도

- 최상
	- O(n)
- 평균
	- O(nlogn)
- 최악
	- O(nlogn)

### b. 공간복잡도

O(n)

### c. TimSort 구현

- minrun
	- 임의의 run이 구성될 수 있는 최소 길이

Timsort는 run 생성시 run 크기를 동적으로 구한다. run을 만들 때 이미 정렬된 subsequence 기준으로 생성하며 만약 minrun보다 작게되면 insertion sort를 사용한다.

minimum run size(minrun)을 구하는 것은 data size에 의해 결정되며 elements가 64보다 작으면 minrun은 64가 되며 이처럼 사이즈가 작은 subsequence의 경우에 Timsort는 insertion sort를 수행한다. (이처럼 작은 단위에서는 binary insertion sort보다 빠른 정렬방법은 없기 때문에)

사이즈가 큰 array에서는 32~64 범위의 minrun을 가지고 array를 분할시킨다. 이러한 algorithm은 모든 array에 수행하며 크기가 64보다 작아질 때까지 한다.

### d. 코드

```python

MIN_MERGE = 64

def timSort(arr):
    def calcMinRun(n):
        """Returns the minimum length of a run from 23 - 64 so that
        the len(array)/minrun is less than or equal to a power of 2.

        e.g. 1=>1, ..., 63=>63, 64=>32, 65=>33, ..., 127=>64, 128=>32, ...
        """
        r = 0
        while n >= MIN_MERGE:
            r |= n & 1
            n >>= 1
        return n + r
        
    n = len(arr)
    minRun = calcMinRun(n)
    
    # min run 만큼 건너뛰면서 삽입 정렬 실행
    for start in range(0, n, minRun):
        end = min(start + minRun - 1, n - 1)
        arr = insert_sort(arr, start, end)
    currentSize = minRun

    # minRun이 배열 길이보다 작을 때까지만 minRun * 2 를 한다.
    while currentSize < n:
        for start in range(0, n, currentSize * 2):
            mid = min(n - 1, start + currentSize - 1)
            right = min(start + 2*currentSize - 1, n - 1)
            merged = merge_sort(array1=arr[start:mid + 1],
                               array2=arr[mid + 1:right + 1])
            arr[start:start + len(merged)] = merged

        currentSize *= 2

    return arr

```

# 13. 객체

## A. 4가지 특징

- 상속성
	- 부모 클래스의 메소드와 변수를 사용할 수 있다.
- 다형성
	- 같은 이름의 메소드가 클래스 혹은 객체에 따라 다르게 동작하도록 구현되는 것을 말한다.
- 추상화
	- 부모에서 자식으로 내려올수록 구체화되고, 자식에서 부모로 올라갈수록 추상화된다.
- 캡슐화
	- 캡슐로 보호하듯이 외부에서 데이터에 대한 접근을 막는다.

# 참고자료

[1] 빌노트. [파이썬 비트연산자 사용법 정리 (Python 비트연산) (withcoding.com)](https://withcoding.com/69). Tistory. (accessed Nov 8. 2021)

[2]  joon96. [[Python] 비트 연산 (tistory.com)](https://kbj96.tistory.com/28). Tistory. (accessed Nov 8. 2021)