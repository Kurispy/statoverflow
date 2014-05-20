public abstract class Sphere {
  float ease = 0.2;
  float radius = 0, tradius;
  color col = #FFFFFF, tcol;
  float rho, trho;
  float phi, tphi;
  float h, th;
  float vPhi, tvPhi;
  float aPhi, taPhi;
  
  public void render() {
    if(radius <= 0)
      return;
    
    float x = sin(phi) * rho;
    float y = h;
    float z = cos(phi) * rho;
    pushMatrix();
    translate(x,y,z);
    camera.rotateToCamera();
    fill(col);
    noStroke();
    ellipse(0,0,radius * 2,radius * 2);
    popMatrix();   
  }
  
  public void update() {
    if (abs(tradius - radius) > .001)
      radius += (tradius - radius) * ease * timekeeper.getTimescale();
    else
      radius = tradius;
      
    if (abs(trho - rho) > .001)
      rho += (trho - rho) * ease * timekeeper.getTimescale();
    else
      rho = trho;
      
    if (abs(tvPhi - vPhi) > .001)
      vPhi += (tvPhi - vPhi) * ease * timekeeper.getTimescale();
    else
      vPhi = tvPhi;
      
//    if (abs(tcol - col) > 1)
//      col = lerpColor(col, tcol, .01 * timekeeper.getTimescale());
//    else
//      col = tcol;
    
    phi += vPhi * timekeeper.getTimescale();
  }
}
