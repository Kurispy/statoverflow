public abstract class Sphere {
  float ease = 0.2;
  float radius = 0, tradius;
  color col = #FFFFFF, tcol;
  float rho, trho;
  float phi, tphi;
  float h, th;
  float vPhi, tvPhi;
  float aPhi, taPhi;
  float x = 0;
  float y = 0;
  float z = 0;
  
  public void render(float frequency) {
    // Graph variable determines if its flat
    // In order to change to an X-Y plot, distance from center is still based on rho.
    // Animations would occur only for transition
    // abs(rho.x) remains the same + push off axis
    // rho.y based on element the item is filtered by and flipped(*-1) + push off axis
    // rho.z is 0   
    if(radius <= 0)
      return;
      
    x = map(sin(phi) * rho * (1 - graph) + rho * graph, 0, 500, 0, 1000);
    if(isUser)
      y = -1 * map(frequency * graph, 0, maxUserFrequency, 0, 500); // TODO: change value; currently creates 3 streams and stacks data on top of eachother
    else
      y = -1 * map(frequency * graph, 0, maxTagFrequency, 0, 500); // TODO: change value; currently creates 3 streams and stacks data on top of eachother
    z = cos(phi) * rho * (1-graph);
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
      radius += (tradius - radius) * ease;
    else
      radius = tradius;
      
    if (abs(trho - rho) > .001)
      rho += (trho - rho) * ease;
    else
      rho = trho;
      
    if (abs(tvPhi - vPhi) > .001)
      vPhi += (tvPhi - vPhi) * ease;
    else
      vPhi = tvPhi;
      
    if(!isUser) {
      if (abs(tcol - col) > 1)
        col = lerpColor(col, tcol, .01);
      else
        col = tcol;
    }
    
    //vPhi = max(vPhi + (aPhi / exp(radius)) - 0.0001 * exp(radius), 0);
    phi += vPhi;
  }
    
  public color getColor() { 
    return col;
  }
  
  public void setColor(color c) {
   col = c;
  } 
}
