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
HashMap<Integer, User> map = new HashMap<Integer, User>();
int maxUpVotes = 0;
int minUpVotes = 0;

void setup() {
  size(800, 800, P3D);
  try {
    reader = new CSVReader(new FileReader(dataPath("posts.csv")));
    reader.readNext();
  }
  catch (Exception e) {
    System.out.println(e);
    System.exit(1);
  }
  
  users = loadTable("users.csv", "header");
  
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  userInfo = cp5.addTextarea("txt")
                    .setPosition(100,100)
                    .setSize(120,60)
                    .hideScrollbar()
                    .setFont(createFont("arial",12))
                    .setLineHeight(14)
                    .setColor(color(128))
                    .setColorBackground(color(255,100))
                    .setColorForeground(color(255,100));
  fps = cp5.addFrameRate();
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
    background(10);
    
    // Draw rings
    strokeWeight(2);
    noFill();
    
    // Ring 1
    stroke(255, 10);
    ellipse(0,0,200,200);
    
    // Ring 2
    stroke(255, 10);
    ellipse(0,0,400,400);
    
    // Ring 3
    ellipse(0,0,900,900);
    
    // Ring 4
    ellipse(0,0,1500,1500);
    
    // Y axis
    stroke(255, 100);
    pushMatrix();
    rotateY(-PI/2);
    line(0,0,500,0);
    popMatrix();
    
    noFill();
    stroke(255);
    randomSeed(0);
//    for(String tag : tagCount.keys()) {
//      pushMatrix();
//      translate(random(-width, width), random(-width, width), -400);
//      sphereDetail(constrain(tagCount.get(tag), 3, detailLevel));
//      sphere(tagCount.get(tag));
//      popMatrix();
//    }
//    
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
  rot.y = (mouseX - mousePress.x) / width * PI + prot.y;
  rot.x = constrain(-(mouseY - mousePress.y) / height * PI + prot.x, -HALF_PI, HALF_PI);
}

void mouseWheel(MouseEvent event) {
  if(event.getAmount() < 0)
    targetZoom /= .95;
  else if(event.getAmount() > 0)
    targetZoom *= .95;
}
