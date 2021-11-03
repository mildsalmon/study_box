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