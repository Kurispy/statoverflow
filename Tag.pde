public class Tag extends Sphere {
  String name;
  int count;
  float frequency;
  
  Tag(String name, int count) {
    this.name = name;
    this.count = count;
    radius = count;
    
    col = #FFFFFF;
    rho = random(100);
    phi = random(TWO_PI);
    h = 0;
    vPhi = random(0.1);
  }
  
  public void increment() {
    rho++;
    count++;
    super.increment();
  }
}
