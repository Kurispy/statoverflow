Table userData;
int i = 0;
String location = "";
void setup() {
  size(500, 500);
  userData = loadTable("users.csv", "header");
  textFont(createFont("Georgia", 36));
}

void draw() {
    fill(0, 20);
    rect(0, 0, width, height);
    if(!mousePressed)
      animate();
}

void animate(){
  fill(#d2d2d2);
  do{
    i = int(random(0, 600000));
    location = userData.getString(i,7);
  } while(location == null);
  text(location, random(300), random(100, 400));
}
