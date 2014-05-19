final long DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
float maxFrequency;

public class Tag extends Sphere {
  String name;
  int count;
  int countPerFrame;
  float frequency; // Times used per unit of simulation time
  
  Tag(String name, int count) {
    this.name = name;
    this.count = count;
    tradius = count;
    
    col = #FFFFFF;
    rho = 0;
    phi = random(TWO_PI);
    h = 0;
    vPhi = random(0.1);
  }
  
  public void increment() {
    count++;
    countPerFrame++;
  }
  
  public void update() {
    tradius = max(tradius + ((countPerFrame > 1 ? log(countPerFrame) : 0) - 0.001), 0); // should figure out a better scale for this
    trho = count;
    
    frequency = ((float) count) / ((float) frameCount);
    if(frequency > maxFrequency)
      maxFrequency = frequency;
    tvPhi = 0.05 * sqrt(frequency);
    col = lerpColor(#818185, #FE7A15, map(frequency, 0, maxFrequency, 0, 1));
    
    countPerFrame = 0;
    super.update();
  }
  
  public void resetFrequency() {
    maxFrequency = 0;
  }
}

// attributes
// How many usages: rho, radius
// Frequency of usage: vPhi, color, (h)
