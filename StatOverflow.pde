Table userData;
int windowWidth = 800, windowHeight = 800;
float zoom;
PVector offset;
PVector poffset;
PVector mouse;
int x = 0;
String location = "";
boolean isAnim = true;

void setup() {
  size(windowWidth, windowHeight);
  zoom = 1.0;
  offset = new PVector(0, 0);
  poffset = new PVector(0, 0);
  
  userData = loadTable("users.csv", "header");
  
  textFont(createFont("Georgia", 36));
  fill(255, 100);
  noStroke();
  
}

void draw() {
  if(isAnim) {
    background(0);
    pushMatrix();
    
    scale(zoom);
    translate(offset.x / zoom, offset.y / zoom);
    
    int i = 0;
    for (TableRow row : userData.rows()) {
      if (i++ > 10000)
        break;
      ellipse(row.getInt("Reputation"), row.getInt("Views"), 1,1);
    }
    
    popMatrix();
  }
  else {
    fill(0, 20);
    rect(0, 0, width, height);
    if(!mousePressed)
      animate();
  }
}

void animate(){
  fill(#d2d2d2);
  do{
    x = int(random(0, 600000));
    location = userData.getString(x,7);
  } while(location == null);
  text(location, random(800), random(800));
}

void mouseWheel(MouseEvent event) {
  zoom -= 0.1 * event.getAmount();
}

void mousePressed() {
  mouse = new PVector(mouseX, mouseY);
  poffset.set(offset);
}

void mouseDragged() {
  offset.x = mouseX - mouse.x + poffset.x;
  offset.y = mouseY - mouse.y + poffset.y;
}

void keyPressed() {
  isAnim = !isAnim;
}
