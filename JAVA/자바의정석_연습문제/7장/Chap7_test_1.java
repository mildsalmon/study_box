//class SutdaDeck{
//	final int CARD_NUM = 20;
//	SutdaCard[] cards = new SutdaCard[CARD_NUM];
//	
//	SutdaDeck() {
//		for(int i=1; i<=CARD_NUM/2; i++) {
//			boolean isKwang = false;
//			if(i==1 || i==3 || i==8) {
//				isKwang = true;
//			}
//			cards[i-1] = new SutdaCard(i, isKwang);
//		}
//		for(int i=CARD_NUM/2+1; i<=CARD_NUM; i++) {
//			cards[i-1] = new SutdaCard(i-10, false);
//		}
//	}
//}
//
//class SutdaCard{
//	int num;
//	boolean isKwang;
//	
//	SutdaCard(){
//		this(1, true);
//	}
//	
//	SutdaCard(int num, boolean isKwang){
//		this.num = num;
//		this.isKwang = isKwang;
//	}
//	
//	public String toString() {
//		return num + (isKwang ? "K" : "");
//	}
//}
//
//class Chap7_test_1{
//	public static void main(String[] args) {
//		SutdaDeck deck = new SutdaDeck();
//		
//		for (int i = 0; i < deck.cards.length; i++) {
//			System.out.print(deck.cards[i] + ",");
//		}
//	}
//}