public abstract class Sphere {
  float ease = 0.2;
  float radius = 0, tradius;
  color col = #FFFFFF, tcol;
  float rho, trho;
  float phi, tphi;
  float h, th;
  float vPhi, tvPhi, gPhi;
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
      
    if(isUser) {
      x = map(sin(phi) * rho * (1 - graph) + rho * graph, 0, 100, 0, 1000);
      y = -1 * map(frequency * graph, 0, maxUserFrequency, 0, 1000); // TODO: change value; currently creates 3 streams and stacks data on top of eachother
      z = map(cos(phi) * rho * (1-graph), 0, 100, 0, 1000);
      
      colorMode(HSB);
      // Change color based on mapping of upvotes
      float c = map(frequency, 0, maxUserFrequency, 100, 250);
      float d = map(frequency, 0, maxUserFrequency, 255, 75);
      float e = map(frequency, 0, maxUserFrequency, 255, 125);
      col = color(c, 255, 255);
      colorMode(RGB);
    }
    else {
      x = map(sin(phi) * rho * (1 - graph) + rho * graph, 0, 500, 0, 1000);
      y = -1 * map(frequency * graph, 0, maxTagFrequency, 0, 1000); // TODO: change value; currently creates 3 streams and stacks data on top of eachother
      z = map(cos(phi) * rho * (1-graph), 0, 500, 0, 1000);
      colorMode(HSB);
      // Change color based on mapping of upvotes
      float c = map(frequency, 0, maxTagFrequency, 100, 250);
      float d = map(frequency, 0, maxTagFrequency, 255, 75);
      float e = map(frequency, 0, maxTagFrequency, 255, 125);
      col = color(c, 255, 255);
      colorMode(RGB);
    }
    
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
    
    phi += vPhi * timekeeper.getTimescale();
  }
    
  public color getColor() { 
    return col;
  }
  
  public void setColor(color c) {
   col = c;
  } 
}
