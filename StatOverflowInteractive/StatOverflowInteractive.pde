Table userData;
int windowWidth = 800, windowHeight = 800;
float zoom;
PVector offset;
PVector poffset;
PVector mouse;

void setup() {
  size(windowWidth, windowHeight);
  zoom = 1.0;
  offset = new PVector(0, 0);
  poffset = new PVector(0, 0);
  
  userData = loadTable("users.csv", "header");
  fill(255, 100);
  noStroke();
  
}

void draw() {
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
