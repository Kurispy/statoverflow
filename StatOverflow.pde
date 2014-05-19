import java.io.FileReader;

Table userData;
CSVReader reader;
int detailLevel = 10;
int decay = 2;
int viewCountThreshold = 0;
HashMap<Integer, User> userSpheres = new HashMap<Integer, User>();
HashMap<String, Tag> tagSpheres = new HashMap<String, Tag>();
int maxUpVotes = 0;
int minUpVotes = 0;
String [] nextLine;

Timekeeper timekeeper;
Camera camera;
GUI gui;

void setup() {
  size(displayWidth, displayHeight, P3D);
  
  
  camera = new Camera();
  gui = new GUI(this);
  
  // Data loading
  try {
    reader = new CSVReader(new FileReader(dataPath("posts.csv")), CSVParser.DEFAULT_SEPARATOR, CSVParser.DEFAULT_QUOTE_CHARACTER, '\0');
    reader.readNext(); // Get rid of header
    nextLine = reader.readNext();
    timekeeper = new Timekeeper(nextLine[3]);
    timekeeper.setCurrentPostTime(nextLine[3]);
    reader.close();
    
    reader = new CSVReader(new FileReader(dataPath("posts.csv")), CSVParser.DEFAULT_SEPARATOR, CSVParser.DEFAULT_QUOTE_CHARACTER, '\0');
    reader.readNext(); // Get rid of header
  }
  catch (Exception e) {
    System.err.println(e);
  }
  userData = loadTable("users.csv", "header");
}

void draw() {
  try {

    String [] tags;
    
    timekeeper.advance();
    gui.setDate(timekeeper.getSimulationTime().toString());

    // Get the next line of the CSV
    while (!timekeeper.hasAdvanced()) {
      if (nextLine == null) {
        System.out.println("NULL");
      }
      if (Integer.parseInt(nextLine[1]) != 1 || Integer.parseInt(nextLine[5]) < viewCountThreshold) {
        nextLine = reader.readNext();
        timekeeper.setCurrentPostTime(nextLine[3]);
        continue;
      }

      // "Pump up" the spheres that got contributed to
      tags = splitTokens(nextLine[13], "<>");
      for (String tag : tags) {
        Tag tagSphere = tagSpheres.get(tag);
        if(tagSphere == null)
          tagSpheres.put(tag, new Tag(tag, 1));
        else
          tagSphere.increment();
      }
      
      // Remove any tags that haven't been used for a while
//      if (pDate.get(Calendar.DAY_OF_MONTH) != cSimDate.get(Calendar.DAY_OF_MONTH)) {
//        for (String tag : tagCount.keys()) {
//          tagCount.sub(tag, decay);
//          if (tagCount.get(tag) <= 0)
//            tagCount.remove(tag);
//        }
//        pDate.setTime(cSimDate.getTime());
//      }

      // Who asked the question?
      TableRow row = userData.findRow(str(parseInt(nextLine[7])+1000000), "Id");
      if (row != null) {
        userSpheres.put(row.getInt("Id"), new User(row.getInt("Id"), row.getInt("Reputation"), row.getInt("UpVotes"), row.getInt("DownVotes")));
      }
      
      nextLine = reader.readNext();
      timekeeper.setCurrentPostTime(nextLine[3]);
    }
    
    updateColors();
    
    // Draw pretty things
    background(0);

    // Draw rings
    pushMatrix();
    rotateX(HALF_PI);
    noFill();
    stroke(127);
    for(int i = 1; i <= 4; i++) {
      strokeWeight(1 / camera.getZoom());
      ellipse(0, 0, pow(10, i), pow(10, i));
    }
    popMatrix();


    // Draw tags
    maxFrequency = 0;
    for (Tag tag: tagSpheres.values()) {
      tag.update();
      tag.render();
      
    }

    // Draw users
    pushMatrix();
    translate(0, -300, 0);
    for (User user: userSpheres.values())
    {
      user.update();
      user.render();
    }
    popMatrix();

    
    gui.drawGUI();
    camera.drawCamera();
  }
  catch (Exception e) {
    System.err.println(e);
  }
}

void updateColors() {
  // Find the max and min of upvotes
  for (User user: userSpheres.values()) {
    maxUpVotes = max(user.getUpVotes(), maxUpVotes);
    minUpVotes = min(user.getUpVotes(), minUpVotes);
  }

  // Change color based on mapping of upvotes
  colorMode(HSB);
  for (User user: userSpheres.values()) {
    if (user.getUpVotes() > 0) {
      float c = map(sqrt(user.getUpVotes()), sqrt(minUpVotes), sqrt(maxUpVotes), 250, 0);
      user.setColor(color(c, 255, 255));
    } 
    else {
      user.setColor(color(200, 255, 255));
    }
  }
  colorMode(RGB);
}

void mousePressed() {
  camera.mousePressed();
  
  // Show user information if selected on
  color c = get(mouseX, mouseY);
  for (User user: userSpheres.values()) {
    if (user.getColor() == c) {
      gui.setUserInfo("User Id: " + user.getId() + "\n" +
        "Upvotes: " + user.getUpVotes() + "\n" +
        "Downvotes: " + user.getDownVotes() + "\n" +
        "Reputation: " + user.getReputation());
    }
  }
}

void mouseDragged() {
  camera.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  camera.mouseWheel(event);
}
