# 1. 데이터베이스에서 인덱스를 사용하는 이유와 장단점

## A. 인덱스를 사용하는 이유

데이터를 논리적으로 정렬하여 검색과 정렬 속도를 높이기 위해서 사용한다.

## B. 장단점

### a. 장점

검색 속도가 향상된다.

### b. 단점

- 데이터를 삽입, 삭제할때마다 인덱스를 변경해줘야하기 때문에 성능저하가 발생할 수 있다.
- 데이터베이스의 데이터 양이 적을 경우 인덱스 스캔보다 풀 스캔이 더 빠를 수도 있다.

# 2. Redis와 Mongodb

둘 다 No SQL 방식을 사용한다.

## A. Redis

document 형식으로 데이터를 저장한다.

## B. Mongodb

key-value 형식으로 데이터를 저장한다.