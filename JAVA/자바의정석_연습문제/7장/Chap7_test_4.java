
class MyTv{
	private boolean isPowerOn;
	private int channel;
	private int volume;
	private int prevChannel;
	
	final int MAX_VOLUME = 100;
	final int MIN_VOLUME = 0;
	final int MAX_CHANNEL = 100;
	final int MIN_CHANNEL = 1;
	
	public int getChannel() {
		return channel;
	}

	public int getVolume() {
		return volume;
	}
	
	public void setChannel(int channel) {
		if ((MIN_CHANNEL <= channel) && (channel <= MAX_CHANNEL))
			this.prevChannel = this.channel;
			this.channel = channel;
	}

	public void setVolume(int volume) {
		if ((MIN_VOLUME <= volume) && (volume <= MAX_VOLUME))
			this.volume = volume;
	}
	
	public void gotoPrevChannel() {
		setChannel(this.prevChannel);
	}
}

public class Chap7_test_4 {

}
