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

# 참고자료

[1] 빌노트. [파이썬 비트연산자 사용법 정리 (Python 비트연산) (withcoding.com)](https://withcoding.com/69). Tistory. (accessed Nov 8. 2021)

[2]  joon96. [[Python] 비트 연산 (tistory.com)](https://kbj96.tistory.com/28). Tistory. (accessed Nov 8. 2021)