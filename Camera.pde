public class Camera {
  float zoom = 1.0;
  float targetZoom = 1.0;
  float zoomEase = 0.2;
  PVector mousePress = new PVector(0, 0);
  PVector rot = new PVector(0, 0, 0);
  PVector prot = new PVector(0, 0, 0);
  boolean cp5Click = false;
  
  void drawCamera() {
    // Zoom easing
    if (abs(targetZoom - zoom) > .001)
      zoom += (targetZoom - zoom) * zoomEase;
    else
      zoom = targetZoom;
      
      
    
    beginCamera();
    camera();
    translate(width / 2, height / 2, -1);
    rotateX(rot.x);
    rotateY(rot.y);
    scale(zoom);
    endCamera();
  }
  
  public float getZoom() {
    return zoom;
  }
  
  public PVector getRot() {
    return rot;
  }
  
  void mouseDragged() {
    if (gui.isMouseOver() && cp5Click == true)
      return;
  
    rot.y = (mouseX - mousePress.x) / width * PI + prot.y;
    rot.x = constrain(-(mouseY - mousePress.y) / height * PI + prot.x, -HALF_PI, HALF_PI);
  }
  
  void mousePressed() {
    if (gui.isMouseOver()) {
      cp5Click = true;
      return;
    }
    cp5Click = false;
  
    mousePress = new PVector(mouseX, mouseY);
    prot.set(rot);
  }
  
  void mouseWheel(MouseEvent event) {
    if (gui.isMouseOver())
      return;
  
    if (event.getAmount() < 0)
      targetZoom /= .95;
    else if (event.getAmount() > 0)
      targetZoom *= .95;
  }
  
  void rotateToCamera() {
    rotateY(-rot.y);
    rotateX(-rot.x);
  }
}
