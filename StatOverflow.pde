import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Map;

Table users;
CSVReader reader;
int detailLevel = 10;
int decay = 2;
int viewCountThreshold = 0;
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
Textarea userInfo;
FrameRate fps;
boolean cp5Click = false;
HashMap<Integer, User> map = new HashMap<Integer, User>();
int maxUpVotes = 0;
int minUpVotes = 0;

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
  users = loadTable("users.csv", "header");
  
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
    .close()
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
    ;
  cp5.addNumberbox("viewCountThreshold") // This should be converted to a range slider
    .setPosition(100, 300)
    .setSize(90, 20)
    .setRange(0, Integer.MAX_VALUE)
    .setGroup(rightMenu)
    .setMultiplier(25)
    .setCaptionLabel("View Count Threshold")
    ;
  userInfo = cp5.addTextarea("txt")
    .setPosition(100,100)
    .setSize(120,60)
    .hideScrollbar()
    .setFont(createFont("arial",12))
    .setLineHeight(14)
    .setColor(color(128))
    .setColorBackground(color(255,100))
    .setColorForeground(color(255,100))
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
    } while (nextLine == null || Integer.parseInt(nextLine[1]) != 1 || Integer.parseInt(nextLine[5]) < viewCountThreshold);
    
    // Who asked the question?
    TableRow row = users.findRow(str(parseInt(nextLine[7])+1000000), "Id");
    if(row != null) {
      map.put(row.getInt("Id"), new User(row.getInt("Id"), row.getInt("Reputation"), row.getInt("UpVotes"),  row.getInt("DownVotes")));
    }
    
    updateColors();
    
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
    
    // Draw rings
    pushMatrix();
    rotateX(HALF_PI);
    strokeWeight(2);
    noFill();
    
    // Ring 1
    stroke(255, 10);
    ellipse(0,0,200,200);
    
    // Ring 2
    ellipse(0,0,400,400);
    
    // Ring 3
    ellipse(0,0,900,900);
    
    // Ring 4
    ellipse(0,0,1500,1500);
    popMatrix();
    
    
    // Draw tags
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
    
    // Draw users
    for(User user: map.values())
    {
      user.update();
      user.render();
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

void updateColors() {
  // Find the max and min of upvotes
  for(User user: map.values()) {
    maxUpVotes = max(user.getUpVotes(), maxUpVotes);
    minUpVotes = min(user.getUpVotes(), minUpVotes);
  }
  
  // Change color based on mapping of upvotes
  colorMode(HSB);
  for(User user: map.values()) {
    if(user.getUpVotes() > 0) {
      float c = map(sqrt(user.getUpVotes()), sqrt(minUpVotes), sqrt(maxUpVotes), 250, 0);
      user.setColor(color(c, 255, 255));
    } else {
      user.setColor(color(200, 255, 255));
    }
  }
  colorMode(RGB);
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
  
  // Show user information if selected on
  color c = get(mouseX, mouseY);
  for(User user: map.values()) {
    if(user.getColor() == c) {
      userInfo.setText("User Id: " + user.getId() + "\n" +
                       "Upvotes: " + user.getUpVotes() + "\n" +
                       "Downvotes: " + user.getDownVotes() + "\n" +
                       "Reputation: " + user.getReputation());
    }
  }
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
