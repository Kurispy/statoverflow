public class User extends Sphere {
  // Class properties
  int id;
  int reputation;
  int upVotes;
  int downVotes;
  
  public User (int userId, int userReputation, int userUpVotes, int userDownVotes) {
    id = userId;
    reputation = userReputation;
    upVotes = userUpVotes;
    downVotes = userDownVotes;
    rho = upVotes;
    phi = random(TWO_PI);
    vPhi = (TWO_PI)/userReputation;
    tradius = sqrt(reputation) / 2;
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
}
