import java.io.FileReader;

Table userData;
CSVReader reader;
int detailLevel = 10;
int decay = 2;
int viewCountThreshold = 0;
int maxUpVotes = 0;
int maxReputation = 0;
HashMap<Integer, User> userSpheres = new HashMap<Integer, User>();
HashMap<String, Tag> tagSpheres = new HashMap<String, Tag>();
String [] nextLine;
PFont ringLabelFont;
boolean showRingLabels = false;
boolean graphMode = false;
String xLabel = "User Amount";
String yLabel = "User Frequency";
float [] coordinates;
// graph = 0, Orbital mode
// graph = 1, 2D Graph mode
// y axis frequency
// x axis amount
float graph = 0;
float maxTagFrequency = 0;
float maxUserFrequency = 0;
float yMin = 0;
float yMax = 0;
// False = tag
// True = user
boolean isUser = true;

Timekeeper timekeeper;
Timekeeper userTimekeeper;
Camera camera;
GUI gui;
PFont label = createFont("Helvetica", 80);

void setup() {
  size(displayWidth, displayHeight, P3D);
  
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
  
  camera = new Camera();
  gui = new GUI(this);
}

void draw() {
  try {

    String [] tags;

    timekeeper.advance();
    gui.setDate(timekeeper.getSimulationTime().toString());

    // Get the next line of the CSV
    while (!timekeeper.hasAdvanced ()) {
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
        if (tagSphere == null)
          tagSpheres.put(tag, new Tag(tag, 1));
        else
          tagSphere.increment();
      }

      // Who asked the question?
      TableRow row = userData.findRow(str(parseInt(nextLine[7])+1000000), "Id");

      // Parse through users.csv
      if (row != null) {
        User userSphere = userSpheres.get(row.getInt("Id"));
        if (userSphere == null) {
          userTimekeeper = new Timekeeper(row.getString("CreationDate"));
          userTimekeeper.setCurrentPostTime(row.getString("CreationDate"));
          Calendar cal = Calendar.getInstance();
          cal.setTime(userTimekeeper.getPostTime());
          userSpheres.put(row.getInt("Id"), new User(row.getInt("Id"), row.getInt("Reputation"), row.getInt("UpVotes"), row.getInt("DownVotes"), cal, 1));
        } else {
          userSphere.increment();
        }
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
    for (int i = 1; i <= 4; i++) {
      strokeWeight(1 / camera.getZoom());
      ellipse(0, 0, pow(10, i), pow(10, i));
    }
    popMatrix();
    
    // Draw ring labels
    if(showRingLabels) {
      noStroke();
      fill(255);
      
      pushMatrix();
      if(graphMode) {
        textAlign(LEFT, BASELINE);
        rotateZ(HALF_PI);
      }
      else {
        textAlign(CENTER, BASELINE);
        rotateX(HALF_PI);
      }
      textFont(ringLabelFont);
      for(int i = 1; i <= 6; i++) {
        int size = (int) pow(10, i);
        textSize(size / 4);
        text(size, 0, -size / 2 - size / 100);
      }
      popMatrix();
    }

    // 2D Graph Mode
    // Draw the Y Axis
    stroke(255, 100);
    pushMatrix();
    rotateZ(-PI/2);
    line(0, 0, 1000 * graph, 0);

    // Draw Y Axis max/min`
    pushMatrix();
    fill(255, 100 * graph);
    rotateZ(PI/2);
    textFont(label);
    textSize(24);
//    text(round(yMin), -textWidth(str(yMin)), -10);
    text(round(yMax), -textWidth(str(yMax)), -1000);
    popMatrix();

    // Draw Y Axis Label
    fill(255, graph * 255);
    text(yLabel, 250 * graph, -10);

    popMatrix();

    // Draw the X Axis if we are not graph
    pushMatrix();
    line(0, 0, 5000 * graph, 0);

    // Draw X Axis Label
    fill(255, graph * 255);
    text(xLabel, 200 * graph, 25);

    // Draw X Axis min/max
    fill(255, 100 * graph);
    text("Max", 5000 * graph, 25);

    popMatrix();

    if (isUser) {
      // Draw users
      pushMatrix();
      for (User user: userSpheres.values()) {
        user.update();
        user.render(user.getFrequency());
      }
      popMatrix();
    } 
    else {
      // Draw tags
      for (Tag tag: tagSpheres.values()) {
        tag.update();
        tag.render(tag.getFrequency());
      }
    }

    gui.drawGUI();
    camera.drawCamera();
  }
  catch (Exception e) {
    System.err.println(e);
  }
}

void updateColors() {
  colorMode(HSB);
  for (User user: userSpheres.values()) {
    // Find the max and min of upvotes
    maxUpVotes = max(user.getUpVotes(), maxUpVotes);
    maxReputation = max(user.getReputation(), maxReputation);
    
    // Change color based on mapping of upvotes
    if (user.getUpVotes() > 0) {
      float c = map(user.getReputation(), 0, maxReputation, 100, 250);
      float d = map(user.getReputation(), 0, maxReputation, 255, 75);
      float e = map(user.getReputation(), 0, maxReputation, 255, 125);
      user.setColor(color(c, 255, 255));
    } 
    else
      user.setColor(color(200, 255, 255));
  }
  colorMode(RGB);
}


void mousePressed() {
  camera.mousePressed();

  // Show user information if selected on
  color c = get(mouseX, mouseY);
  if(isUser) {
    for (User user: userSpheres.values()) {
      if (user.getColor() == c) {
        Calendar ca = user.getCreationDate();
        gui.setUserInfo("User Id: " + user.getId() + "\n" +
                        "Upvotes: " + user.getUpVotes() + "\n" +
                        "Downvotes: " + user.getDownVotes() + "\n" +
                        "Reputation: " + user.getReputation() + "\n" +
                        "Creation Date: " + ca.get(Calendar.MONTH) + "/" + ca.get(Calendar.DAY_OF_MONTH) + "/" + ca.get(Calendar.YEAR));
        break;
      }
    }
  } else {
    for (Tag tag: tagSpheres.values()) {
      if(tag.getColor() == c){
        gui.setUserInfo("Tag Name: #" + tag.getName() + "\n" +
                        "Count: " + tag.getCount());
        break;
      }
    }
  }
}

void sortByFrequency() {
  yLabel = "Frequency";
  toggleGraph(1);
  if(isUser) 
    yMax = maxUserFrequency;
  else
    yMax = maxTagFrequency;
}

void undoSort() {
  toggleGraph(0);
}

void toggleGraph(float x) {
  graph = x;
}

void keyPressed() {
  if (key == ' ') {
    isUser = !isUser;
    if(isUser) {
      xLabel = "User Amount";
      yLabel = "User Frequency";
    } else  {
      xLabel = "Tag Amount";
      yLabel = "Tag Frequency";
    }
  }  

  if (key == '1') {
    graphMode = !graphMode;
    sortByFrequency();
  } 
  else if (key == '2') {
    undoSort();
  }
}

void mouseDragged() {
  camera.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  camera.mouseWheel(event);
}
