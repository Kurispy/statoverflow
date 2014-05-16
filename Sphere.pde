public abstract class Sphere {
  float radius;
  color col;
  float rho;
  float phi = 0;
  float h = 0;
  float phiSpeed = 0;
  
  public abstract void render();
  public abstract void update();
}
