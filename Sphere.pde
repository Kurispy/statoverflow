public abstract class Sphere {
  float radius;
  color col;
  float rho;
  float phi = 0;
  float h = 0;
  float vPhi = 0;
  
  public void increment() {
    radius++;
  }
  
  public void render() {
    if(radius <= 0)
      return;
    
    float x = sin(phi) * rho * 2;
    float y = h;
    float z = cos(phi) * rho * 2;
    pushMatrix();
    translate(x,y,z);
    camera.rotateToCamera();
    fill(col);
    noStroke();
    ellipse(0,0,radius * 2,radius * 2);
    popMatrix();   
  }
  
  public void update() {
    phi += vPhi;
  }
}
