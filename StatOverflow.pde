import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

Table users;
CSVReader reader;
int detailLevel = 10;
int decay = 2;
float zoom = 1.0;
float targetZoom = 1.0;
float zoomEase = 0.2;
PVector mousePress = new PVector(0, 0);
PVector rot = new PVector(0, 0, 0);
PVector prot = new PVector(0, 0, 0);
IntDict tagCount = new IntDict();
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
Calendar calendar = new GregorianCalendar();
Calendar pDate = new GregorianCalendar();
ControlP5 cp5;
FrameRate fps;
boolean cp5Click = false;

void setup() {
  size(displayWidth, displayHeight, P3D);
  
  // Data loading
  try {
    reader = new CSVReader(new FileReader(dataPath("posts.csv")));
    reader.readNext();
  }
  catch (Exception e) {
    System.out.println(e);
    System.exit(1);
  }
  //users = loadTable("users.csv", "header");
  
  // CP5 setup
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  fps = cp5.addFrameRate();
  fps.hide();
  ControllerGroup rightMenu = cp5.addGroup("Settings")
    .setPosition(width - 200, 10)
    .setWidth(200)
    .setBarHeight(10)
    .setBackgroundHeight(height)
    .setBackgroundColor(color(255,10))
    ;
  cp5.addSlider("detailLevel")
    .setSize(20, 200)
    .setRange(3, 30)
    .setNumberOfTickMarks(28)
    .showTickMarks(false)
    .setCaptionLabel("Detail Level")
    .setGroup(rightMenu)
    ;
  cp5.addSlider("decay")
    .setSize(20, 200)
    .setRange(0, 10)
    .setNumberOfTickMarks(11)
    .setGroup(rightMenu)
    ;
  cp5.addButton("Show FPS")
    .setSize(20, 20)
    .setPosition(10, 300)
    .setGroup(rightMenu)
    .setSwitch(true)
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
    .setPaddingX(0)
    ;
  
  // This allows us to use the scroll wheel with CP5
  addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  });
}

void draw() {
  try {
    String [] nextLine;
    String [] tags;
    
    // Get the next line of the CSV
    do {
      nextLine = reader.readNext();
    } while (nextLine == null || Integer.parseInt(nextLine[1]) != 1);
    
    // Who asked the question?
    //TableRow row = users.findRow(str(parseInt(nextLine[7])+1000000), "Id");
    
    // "Pump up" the spheres that got contributed to
    tags = splitTokens(nextLine[13], "<>");
    for (String tag : tags) {
      tagCount.increment(tag);
    }
    
    // Remove any tags that haven't been used for a while
    if(pDate.get(Calendar.DAY_OF_MONTH) != dateFormat.parse(nextLine[3]).getDate()) {
      for(String tag : tagCount.keys()) {
        tagCount.sub(tag, decay);
        if(tagCount.get(tag) <= 0)
          tagCount.remove(tag);
      }
      pDate.setTime(dateFormat.parse(nextLine[3]));
    }
    
    // Zoom easing
    if(abs(targetZoom - zoom) > .001)
      zoom += (targetZoom - zoom) * zoomEase;
    else
      zoom = targetZoom;
    
    // Draw pretty things
    background(0);
    noFill();
    stroke(255);
    randomSeed(0);
    for(String tag : tagCount.keys()) {
      pushMatrix();
      translate(random(-width, width), 0, random(-height, height));
      sphereDetail(constrain(tagCount.get(tag), 3, detailLevel));
      sphere(tagCount.get(tag));
      popMatrix();
    }
    
    // Position the camera and draw the GUI
    beginCamera();
    camera();
    hint(DISABLE_DEPTH_TEST);
    drawGUI();
    hint(ENABLE_DEPTH_TEST);
    translate(width / 2, height / 2, -1);
    rotateX(rot.x);
    rotateY(rot.y);
    scale(zoom);
    endCamera();
    
  }
  catch (Exception e) {
    System.out.println(e);
    System.exit(1);
  }
}

void drawGUI() {
  cp5.draw();
}

void mousePressed() {
  if(cp5.isMouseOver()) {
    cp5Click = true;
    return;
  }
  cp5Click = false;
  
  mousePress = new PVector(mouseX, mouseY);
  prot.set(rot);
}

void mouseDragged() {
  if(cp5.isMouseOver() && cp5Click == true)
    return;
  
  rot.y = (mouseX - mousePress.x) / width * PI + prot.y;
  rot.x = constrain(-(mouseY - mousePress.y) / height * PI + prot.x, -HALF_PI, HALF_PI);
}

void mouseWheel(MouseEvent event) {
  if(cp5.isMouseOver())
    return;
  
  if(event.getAmount() < 0)
    targetZoom /= .95;
  else if(event.getAmount() > 0)
    targetZoom *= .95;
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController() == cp5.getController("Show FPS")) {
    if(!fps.isVisible())
      fps.show();
    else
      fps.hide();
  }
}
