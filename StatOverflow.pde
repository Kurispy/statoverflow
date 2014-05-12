import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

CSVReader reader;
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

void setup() {
  try {
    reader = new CSVReader(new FileReader(dataPath("posts.csv")));
    reader.readNext();
  }
  catch (Exception e) {
    System.out.println(e);
    System.exit(1);
  }
  size(800, 800, P3D);
  background(0);
  textFont(createFont("Arial", 36));
  sphereDetail(10);
}

void draw() {
  try {
    String [] nextLine;
    String [] tags;
    
    do {
      nextLine = reader.readNext();
    } while (nextLine == null || Integer.parseInt(nextLine[1]) != 1);
    tags = splitTokens(nextLine[13], "<>");
    for (String tag : tags) {
      tagCount.increment(tag);
    }
    
    if(pDate.get(Calendar.DAY_OF_MONTH) != dateFormat.parse(nextLine[3]).getDate()) {
      for(String tag : tagCount.keys()) {
        tagCount.sub(tag, 1);
        if(tagCount.get(tag) == 0)
          tagCount.remove(tag);
      }
      pDate.setTime(dateFormat.parse(nextLine[3]));
    }
    
    background(0);
    lights();
    
    beginCamera();
    camera();
    translate(width / 2, height / 2, -1);
    rotateX(rot.x);
    rotateY(rot.y);
    
    if(abs(targetZoom - zoom) > .001) {
      zoom += (targetZoom - zoom) * zoomEase;
    }
    else
      zoom = targetZoom;
    scale(zoom);
    endCamera();

    noFill();
    stroke(255);
    randomSeed(0);
    for(String tag : tagCount.keys()) {
      pushMatrix();
      translate(random(-width, width), 0, random(-width, width));
      sphere(tagCount.get(tag));
      popMatrix();
    }
  }
  catch (Exception e) {
    System.out.println(e);
    System.exit(1);
  }
}

void mousePressed() {
  mousePress = new PVector(mouseX, mouseY);
  prot.set(rot);
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
