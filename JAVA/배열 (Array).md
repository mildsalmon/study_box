# 1. 배열이란?

같은 타입의 여러 변수를 하나의 묶음으로 다루는 것을 **배열(Array)** 라고 한다.

여기서 중요한 것은 **같은 타입**이어야 한다는 것이며, 서로 다른 타입의 변수들로 구성된 배열은 만들 수 없다.

다뤄야할 데이터의 수가 아무리 많아도 단지 배열의 길이만 바꾸면 된다.

`int[] score = new int[5];`

변수 score는 배열을 다루는데 필요한 참조변수일 뿐 값을 저장하기 위한 공간은 아니다.

배열은 각 저장공간이 연속적으로 배치되어 있다는 특징이 있다.

# 2. 배열의 선언과 생성

원하는 타입의 변수를 선언하고 변수 또는 타입에 배열임을 의미하는 대괄호\[\]를 붙이면 된다. 대괄호\[\]는 타입 뒤에 붙여도 되고 변수이름 뒤에 붙여도 된다.

| 선언 방법        | 선언 예        |
| ---------------- | -------------- |
| 타입[] 변수이름; | int[] score;   |
|                  | String[] name; |
| 타입 변수이름[]; | int score[];   |
|                  | String name[]; |

## A. 배열의 생성

배열을 선언한 다음에는 배열을 생성해야한다. 배열을 선언하는 것은 단지 생성된 배열을 다루기 위한 참조변수를 위한 공간이 만들어질 뿐이고, 배열을 생성해야만 비로소 값을 저장할 수 있는 공간이 만들어지는 것이다.

연산자 **new**와 함께 배열의 타입과 길이를 지정해 주어야 한다.

```java

타입[] 변수이름;			// 배열을 선언 (배열을 다루기 위한 참조변수 선언)
변수이름 = new 타입[길이]; // 배열을 생성 (실제 저장공간을 생성)

```

# 3. 배열의 인덱스

생성된 배열의 각 저장공간을 **배열의 요소(element)** 라고 하며, **배열이름[인덱스]** 의 형식으로 배열의 요소에 접근한다. **인덱스(index)는 배열의 요소마다 붙여진 일련번호**로 각 요소를 구별하는데 사용된다.

인덱스는 0부터 시작하여 배열길이-1까지 존재한다.

배열은 index로 상수 대신 변수나 수식도 사용할 수 있다.

```java

for(int i=0; i<=3; i++){
	score[i] = i * 10;
}

```

# 4. 배열의 길이(배열이름.length)

자바에서는 자바 가상 머신(JVM)이 모든 배열의 길이를 별도로 관리하며, **배열이름.length**를 통해서 배열의 길이에 대한 정보를 얻을 수 있다.

```java

int[] arr = new int[5]; // 길이가 5인 int 배열
int tmp = arr.length;	// arr.length의 값은 5이다.

```

배열은 한번 생성하면 길이를 변경할 수 없기 때문에, 이미 생성된 배열의 길이는 변하지 않는다. 따라서 **배열이름.length**는 상수다. 즉, 값을 읽을 수만 있을 뿐 변경할 수 없다.

for문의 조건식에 배열의 길이를 직접 적어주는 것보다 **배열이름.length**를 사용하는 것이 좋다.

```java

int[] score = new int[5];

for(int i=0; i<score.length; i++)
	System.out.println(score[i]);

```

# 5. 배열의 초기화

배열은 생성과 동시에 자동적으로 기본값(0)으로 초기화된다. 원하는 값을 저장하려면 각 요소마다 값을 지정해 줘야한다.

```java

int[] score = new int[3];
score[0] = 50;
score[1] = 20;
score[2] = 60;

```

```java

int[] score = new int[3];

for(int i=0; i<score.length; i++)
	score[i] = i * 10 + 20;

```

자바에서는 다음과 같이 배열을 간단히 초기화 할 수 있는 방법을 제공한다.

```java

int[] score = new int[]{50, 20, 60};

```

저장할 값들을 괄호\{\} 안에 쉼표로 구분해서 나열하면 되며, 괄호\{\} 안의 값의 개수에 의해 배열의 길이가 자동으로 결정되기 때문에 괄호\[\] 안에 배열의 길이는 안적어도 된다.

```java

int[] score = new int[]{50, 20, 60};
int[] score = {50, 20, 60};			// new int[]를 생략 가능
int[] score = {50, 20, 60, }; 		// 맨 뒤에 , 붙여도 됨.
										// length는 3

```

위와 같이 **new 타입[]** 을 생략하여 코드를 간단히 할 수도 있다.

다만, 다음과 같이 배열의 선언과 생성을 따로 하는 경우에는  생략할 수 없다.

```java

int[] score;
score = {50, 20, 10}; // 에러
score = new int[]{50, 60, 10};

```

# 6. 배열의 출력

배열에 저장된 값을 확인할 때도 다음과 같이 for문을 사용하면 된다.

```java

int[] iArr = {100, 95, 20};

for(int i=0; i<iArr.length; i++)
	System.out.println(iArr[i]);

```

다른 방법은 **Arrays.toString(배열이름)** 메서드를 사용하는 것이다. 이 메서드는 배열의 모든 요소를 **\[첫번째 요소, 두번째 요소, ...\]** 와 같은 형식의 문자열로 만들어서 반환한다.

```java
System.out.println(Arrays.toString(iArr)) // [100, 95, 20]
```

> import java.util.Arrays;를 추가해야한다.

만약 iArr의 값을 바로 출력하면, **타입@주소**의 형식으로 출력된다. 이것은 배열을 가리키는 참조변수다.

```java
System.out.println(iArr) // [I@14315bb
```

예외적으로 char배열은 println 메서드로 출력하면 각 요소가 구분자 없이 그대로 출력된다.

```java

char[] chArr = {'a', 'b', 'c', 'd'};
System.out.println(chArr); // abcd가 출력된다.

```

## A. 배열의 출력 예제

```java

import java.util.Arrays;  // Arrays.toString()을 사용하기 위해 추가

class Ex5_1 {
	public static void main(String[] args) {
		int[] iArr1 = new int[10];
		int[] iArr2 = new int[10];
//		int[] iArr3 = new int[]{100, 95, 80, 70, 60};
		int[] iArr3 = {100, 95, 80, 70, 60};
		char[] chArr = {'a', 'b', 'c', 'd'};

		for (int i=0; i < iArr1.length ; i++ ) {
			iArr1[i] = i + 1; // 1~10의 숫자를 순서대로 배열에 넣는다.
		}

		for (int i=0; i < iArr2.length ; i++ ) {
			iArr2[i] = (int)(Math.random()*10) + 1; // 1~10의 값을 배열에 저장
		}

		// 배열에 저장된 값들을 출력한다.
		for(int i=0; i < iArr1.length;i++) {
			System.out.print(iArr1[i]+",");	
		}
		System.out.println();

		System.out.println(Arrays.toString(iArr2));
		System.out.println(Arrays.toString(iArr3));
		System.out.println(Arrays.toString(chArr));
		System.out.println(iArr3);
		System.out.println(chArr);
	}
}

```

# 7. 배열의 활용

## A. 총합과 평균

```java

class Ex5_2 {
	public static void main(String[] args) {
		int   sum = 0;      // 총점을 저장하기 위한 변수
		float average = 0f; // 평균을 저장하기 위한 변수

		int[] score = {100, 88, 100, 100, 90};

		for (int i=0; i < score.length ; i++ ) {
			sum += score[i];
		}
		average = sum / (float)score.length ; // 계산결과를 float로 얻기 위해서 형변환

		System.out.println("총점 : " + sum);
		System.out.println("평균 : " + average);
		
		int[] arr[] = new int[3][];
		
//		System.out.println(arr[0][0]);
		
		int[] a = {10, 20,};
		System.out.println(a.length);
	}
}

```

## B. 최대값과 최소값

```java

class Ex5_3 { 
	public static void main(String[] args) { 
		int[] score = { 79, 88, 91, 33, 100, 55, 95 }; 

		int max = score[0]; // 배열의 첫 번째 값으로 최대값을 초기화 한다. 
		int min = score[0]; // 배열의 첫 번째 값으로 최소값을 초기화 한다. 

		for(int i=1; i < score.length;i++) {
			if(score[i] > max) { 
				max = score[i]; 
			} else if(score[i] < min) { 
				min = score[i]; 
			} 
		} // end of for 

		System.out.println("최대값 :" + max);       
		System.out.println("최소값 :" + min);       
	} // end of main 
} // end of class

```

## C. 섞기(shuffle)

```java

import java.util.Arrays;

class Ex5_4 {
	public static void main(String[] args) {
		int[] numArr = {0,1,2,3,4,4,5,6,7,8,9};
		System.out.println(Arrays.toString(numArr));

		for (int i=0; i < 100; i++ ) {
			int n = (int)(Math.random() * 10);  // 0~9 중의 한 값을 임의로 얻는다.
			int tmp = numArr[0];
			numArr[0] = numArr[n];
			numArr[n] = tmp;
		}
		System.out.println(Arrays.toString(numArr));
	} // main의 끝
}

```

## D. 로또 번호 만들기

```java

class Ex5_5 { 
	public static void main(String[] args) { 
		int[] ball = new int[45];  // 45개의 정수값을 저장하기 위한 배열 생성.      

		// 배열의 각 요소에 1~45의 값을 저장한다. 
		for(int i=0; i < ball.length; i++)       
			ball[i] = i+1;    // ball[0]에 1이 저장된다.

		int tmp = 0;   // 두 값을 바꾸는데 사용할 임시변수 
		int j = 0;     // 임의의 값을 얻어서 저장할 변수 

		// 배열의 i번째 요소와 임의의 요소에 저장된 값을 서로 바꿔서 값을 섞는다. 
		// 0번째 부터 5번째 요소까지 모두 6개만 바꾼다.
		for(int i=0; i < 6; i++) {       
			j = (int)(Math.random() * 45); // 0~44범위의 임의의 값을 얻는다. 
			tmp     = ball[i]; 
			ball[i] = ball[j]; 
			ball[j] = tmp; 
		} 

		// 배열 ball의 앞에서 부터 6개의 요소를 출력한다.
		for(int i=0; i < 6; i++) 
			System.out.printf("ball[%d]=%d%n", i, ball[i]); 
	} 
}

```

# 8. String배열의 선언과 생성

배열의 타입이 String인 경우에도 int배열의 선언과 생성 방법은 다르지 않다.

`String[] name = new String[3];`

3개의 String타입의 참조변수를 저장하기 위한 공간이 마련되고 참조형 변수의 기본값은 null이므로 각 요소의 값은 null로 초기화된다.

## A. 변수의 타입에 따른 기본값

| 자료형           | 기본값        |
| ---------------- | ------------- |
| boolean          | false         |
| char             | '\u0000'      |
| byte, short, int | 0             |
| long             | 0L            |
| float            | 0.0f          |
| double           | 0.0d 또는 0.0 |
| 참조형           | null          |

# 9. String배열의 초기화

배열의 각 요소에 문자열을 지정하면 된다.

```java

String[] name = new String[3];
name[0] = "Kim";
name[1] = "Park";
name[2] = "Yi";

```

또는 괄호\{\}를 사용해서 간단히 초기화할 수도 있다.

```java

String[] name = new String[]{"Kim", "Park", "Yi"};
String[] name = {"Kim", "Park", "Yi"};

```

# 10. String 클래스

문자열이라는 용어는 **문자를 연이어 늘어놓은 것**을 의미하므로 문자배열인 char배열과 같은 뜻이다.

자바에서 char배열이 아닌 String클래스를 이용해서 문자열을 처리하는 이유는 String클래스가 char배열에 여러 가지 기능을 추가하여 확장한 것이기 때문이다.

객체지향언어인 자바에서는 char배열과 그에 관련된 기능들을 함께 묶어서 클래스에 정의한다.

객체지향언어에서는 데이터와 그에 관련된 기능을 하나의 클래스에 묶어서 다룰 수 있게 한다. 즉, 서로 관련된 것들끼리 데이터와 기능을 구분하지 않고 함께 묶는 것이다.

여기서 말하는 **기능**은 함수를 의미하며, 메서드는 객체지향 언어에서 **함수**대신 사용하는 용어일 뿐이다.

char배열과 String클래스는 한 가지 중요한 차이가 있는데, String객체(문자열)는 읽을 수만 있을 뿐 내용을 변경할 수 없다는 것이다.

```java

String str = "JAVA";
str = str + "8";		// "JAVA8"이라는 새로운 문자열이 str에 저장된다.
System.out.println(str);

```

문자열은 변경할 수 없으므로 새로운 내용의 문자열이 생성된다.

## A. String클래스의 주요 메서드

| 메서드                             | 설명                                                               |
| ---------------------------------- | ------------------------------------------------------------------ |
| char charAt(int index)             | 문자열에서 해당 위치(index)에 있는 문자를 반환한다.                |
| int length()                       | 문자열의 길이를 반환한다.                                          |
| String substring(int from, int to) | 문자열에서 해당 범위(from~to)의 문자열을 반환한다. (to는 포함안됨) |
| boolean equals(Object obj)         | 문자열의 내용이 같은지 확인한다. 같으면 true, 다르면 false         |
| char[] toCharArray()               | 문자열을 문자배열(char[])로 변환해서 반환한다.                     |

### a. charAt()

charAt메서드는 문자열에서 지정된 index에 있는 한 문자를 가져온다. 배열에서 **배열이름[index]** 로 index에 위치한 값을 가져오는 것과 같다고 생각하면 된다.

```java

String str = "ABCDE";
char ch = str.charAt(3); // D를 ch에 저장

```

### b. substring()

substring()은 문자열의 일부를 뽑아낼 수 있다. 주의할 것은 범위의 끝은 포함되지 않는다는 것이다.

```java

String str = "012345";
String tmp = str.substring(1, 4); // 123

```

### c. equals()

equals()는 문자열의 내용이 같은지 다른지를 확인하는데 사용한다.

기본형 변수의 값을 비교하는 경우에는 `==`연산자를 사용하지만, 문자열의 내용을 비교할 때는 `equals()`를 사용한다.

그리고 이 메서드는 대소문자를 구분한다.

대소문자를 구분하지 않고 비교하려면 `equalsIgnoreCase()`를 사용해야 한다.

```java

String str = "abc";

if(str.equals("abc")){
	...
}

```

# 11. 커맨드 라인을 통해 입력받기

커맨드 라인을 이요하여 사용자로부터 값을 입력받을 수 있다. 프로그램을 실행할 때 클래스이름 뒤에 공백문자로 구분하여 여러 개의 문자열을 프로그램에 전달 할 수 있다.

`c:\jdk1.8\work\ch5>java MainTest abc 123`

커맨드 라인을 통해 입력된 두 문자열은 String배열에 담겨서 MainTest클래스의 main메서드의 매개변수(args)에 전달된다. 그리고 main메서드 내에서 args[0], args[1]과 같은 방식으로 커맨드 라인으로 부터 전달받은 문자열에 접근할 수 있다.

커맨드 라인에 입력된 매개변수는 공백문자로 구분하기 때문에 입력될 값에 공백이 있는 경우 큰따옴표("")로 감싸주어야한다. 그리고 커맨드 라인에서 숫자를 입력해서 문자열로 처리된다.

커맨드 라인에 매개변수를 입력하지 않으면 크기가 0인 배열이 생성되어 args.length의 값은 0이 된다.

# 12. 2차원 배열의 선언

다차원(multi-dimensional) 배열도 선언해서 사용할 수 있다. 메모리의 용량이 허용하는 한, 차원의 제한은 없다.

| 선언 방법              | 선언 예            |
| ---------------------- | ------------------ |
| 타입\[\]\[\] 변수이름; | int\[\]\[\] score; |
| 타입 변수이름\[\]\[\]; | int score\[\]\[\]; |
| 타입\[\] 변수이름\[\]; | int\[\] score\[\]; |

4행 3열의 데이터를 담기 위한 배열은

`int[][] score = new int[4][3];`

배열요소의 타입인 int의 기본값인 0이 저장된다. 배열을 생성하면, 배열의 각 요소에는 배열요소 타입의 기본값이 자동적으로 저장된다.

## A. 2차원 배열의 인덱스

2차원 배열은 행(row)과 열(column)로 구성되어 있기 때문에 index도 행과 열에 각각 하나씩 존재한다. '행index'의 범위는 **0~행의 길이-1**이고, '열index'의 범위는 '0~열의 길이-1'이다.

2차원 배열의 각 요소에 접근하는 방법은 **배열이름\[행index\]\[열index\]** 이다.

## B. 2차원 배열의 초기화

2차원 배열도 괄호\{\}를 사용해서 생성과 초기화를 동시에 할 수 있다. 다만, 1차원 배열보다 괄호\{\}를 한번 더 써서 행별로 구분해준다.

```java

int[][] arr = new int[][]{ {1,2,3}, {4,5,6} };
int[][] arr = { {1,2,3}, {4,5,6} };

int[][] arr = {
					{1, 2, 3},
					{4, 5, 6},
				};

```

### a. 2차원 배열의 초기화 예제1

```java

class Ex5_8 {
	public static void main(String[] args) {
		int[][] score = {
				  { 100, 100, 100 }
				, { 20, 20, 20 }
				, { 30, 30, 30 }
				, { 40, 40, 40 }
		};
		int sum = 0;

		for (int i = 0; i < score.length; i++) {
			for (int j = 0; j < score[i].length; j++) {
				System.out.printf("score[%d][%d]=%d%n", i, j, score[i][j]);

				sum += score[i][j];
			}
		}

		System.out.println("sum=" + sum);
	}
}

```

2차원 배열은 **배열의 배열**로 구성되어 있다.

여기서 score.length의 값은 얼마일까?

배열 참조변수 score가 참조하고 있는 배열의 길이가 얼마인가를 세어보면 된다.

score.length => 4
score\[0\].length => 3

### b. 2차원 배열의 초기화 예제 2

```java

class Ex5_9 {
	public static void main(String[] args) {
		 int[][] score = {
							  { 100, 100, 100}
							, { 20, 20, 20}
							, { 30, 30, 30}
							, { 40, 40, 40}
							, { 50, 50, 50}
						};
		// 과목별 총점
		int korTotal = 0, engTotal = 0, mathTotal = 0;

	    System.out.println("번호  국어  영어  수학  총점  평균 ");
	    System.out.println("=============================");

		for(int i=0;i < score.length;i++) {
			int  sum = 0;      // 개인별 총점
			float avg = 0.0f;  // 개인별 평균

			korTotal  += score[i][0];
			engTotal  += score[i][1];
			mathTotal += score[i][2];
			System.out.printf("%3d", i+1);

			for(int j=0;j < score[i].length;j++) {
				sum += score[i][j]; 
				System.out.printf("%5d", score[i][j]);
			}

			avg = sum/(float)score[i].length;  // 평균계산
			System.out.printf("%5d %5.1f%n", sum, avg);
		}

		System.out.println("=============================");
     	System.out.printf("총점:%3d %4d %4d%n", korTotal, engTotal, mathTotal);
	}
}

```

### c. 2차원 배열의 초기화 예제3

```java

import java.util.Scanner;

class Ex5_10{
	public static void main(String[] args) {
		String[][] words = {
			{"chair","의자"},      	// words[0][0], words[0][1]
			{"computer","컴퓨터"}, 	// words[1][0], words[1][1]
			{"integer","정수"}     	// words[2][0], words[2][1]
		};

		Scanner scanner = new Scanner(System.in);

		for(int i=0;i<words.length;i++) {
			System.out.printf("Q%d. %s의 뜻은?", i+1, words[i][0]);

			String tmp = scanner.nextLine();

			if(tmp.equals(words[i][1])) {
				System.out.printf("정답입니다.%n%n");
			} else {
			   System.out.printf("틀렸습니다. 정답은 %s입니다.%n%n",words[i][1]);
			}
		} // for
	} // main의 끝
}

```

# 13. Arrays로 배열 다루기

Arrays클래스는 배열을 다루는데 유용한 메서드를 제공한다.

## A. 배열의 출력 - toString()

toString()배열의 모든 요소를 문자열로 편하게 출력할 수 있다.

toString()은 일차원 배열에만 사용할 수 있으므로, 다차원 배열에는 deepToString()을 사용해야 한다.

deepToString()은 배열의 모든 요소를 재귀적으로 접근해서 문자열을 구성하므로 2차원뿐만 아니라 3차원 이상의 배열에도 동작한다.

```java

int[] arr = {0, 1, 2, 3, 4};
int[][] arr2D = {{11, 12}, {21, 22}};

System.out.println(Arrays.toString(arr));	// [0, 1, 2, 3, 4]
System.out.println(Arrays.deepToString(arr2D));	// [[11, 12], [21, 22]]

```

## B. 배열의 비교 - equals()

equals()는 두 배열에 저장된 모든 요소를 비교해서 같으면 true, 다르면 false를 반환한다.

equals()도 일차원 배열에만 사용 가능하므로, 다차원 배열의 비교에는 deepEquals()를 사용해야 한다.

```java

String[][] str2D = new String[][]{{"aaa", "bbb"}, {"AAA", "BBB"}};
String[][] str2D2 = new String[][]{{"aaa", "bbb"}, {"AAA", "BBB"}};

System.out.println(Arrays.equals(str2D, str2D2));
System.out.println(Arrays.deepEquals(str2D, str2D2));

```

## C. 배열의 복사 - copyOf(), copyOfRange()

copyOf()는 배열 전체를, copyOfRange()는 배열의 일부를 복사해서 새로운 배열을 만들어 반환한다. copyOfRange()에 지정된 범위의 끝은 포함되지 않는다.

```java

int[] arr = {0, 1, 2, 3, 4};
int[] arr2 = Arrays.copyOf(arr, arr.length);	// arr2=[0,1,2,3,4]
int[] arr3 = Arrays.copyOf(arr, 3);				// arr3=[0,1,2]
int[] arr4 = Arrays.copyOf(arr, 7);				// arr4=[0,1,2,3,4,0,0]
int[] arr5 = Arrays.copyOfRange(arr, 2, 4);		// arr5=[2,3]
int[] arr6 = Arrays.copyOfRange(arr, 0, 7);		// arr6=[0,1,2,3,4,0,0]

```

## D. 배열의 정렬 - sort()

배열을 정렬할 때는 sort()를 사용한다.

```java

int[] arr = {3, 2, 0, 1, 4};
Arrays.sort(arr);
System.out.println(Arrays.toString(arr)); // [0, 1, 2, 3, 4]

```

# 참고문헌

남궁성, "자바의 정석 - 기초편", 도우출판, 2019년

#자바