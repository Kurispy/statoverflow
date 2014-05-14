public class User{
  // Class properties
  int id;
  int reputation;
  int upVotes;
  int downVotes;
  
  // Sphere properties
  color col;
  float radius;
  float theta = 0;
  float thetaSpeed = 0;
  
  public User (int userId, int userReputation, int userUpVotes, int userDownVotes) {
    id = userId;
    reputation = userReputation;
    upVotes = userUpVotes;
    downVotes = userDownVotes;
    radius = upVotes;
    theta = random(2*PI);
    thetaSpeed = (2*PI)/userReputation;
  }
  
  public int getId() {
    return id;
  }

  public int getUpVotes() {
    return upVotes;
  }
  
  public int getDownVotes() {
    return downVotes;
  }
  
  public int getReputation() {
    return reputation;
  }
  
  public color getColor() { 
    return col;
  }
  
  public void setColor(color c) {
   col = c;
  } 
  
  void update() {
    theta += thetaSpeed;
  }
  
  void render() {
    float x = sin(theta) * radius * 2;
    float y = cos(theta) * radius * 2;
    pushMatrix();
    translate(x,y,0);
    rotateZ(-rot.z);
    rotateX(-rot.x);
    fill(col);
    noStroke();
    ellipse(0,0,sqrt(reputation),sqrt(reputation));
    popMatrix();   
  }
  
}
