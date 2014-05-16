public class User{
  // Class properties
  int id;
  int reputation;
  int upVotes;
  int downVotes;
  
  // Sphere properties
  color col;
  float rho;
  float phi = 0;
  float h = 0;
  float phiSpeed = 0;
  
  public User (int userId, int userReputation, int userUpVotes, int userDownVotes) {
    id = userId;
    reputation = userReputation;
    upVotes = userUpVotes;
    downVotes = userDownVotes;
    rho = upVotes;
    phi = random(TWO_PI);
    phiSpeed = (TWO_PI)/userReputation;
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
    phi += phiSpeed;
  }
  
  void render() {
    float x = sin(phi) * rho * 2;
    float y = h;
    float z = cos(phi) * rho * 2;
    pushMatrix();
    translate(x,y,z);
    camera.rotateToCamera();
    fill(col);
    noStroke();
    ellipse(0,0,sqrt(reputation),sqrt(reputation));
    popMatrix();   
  }
  
}
