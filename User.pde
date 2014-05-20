public class User extends Sphere {
  
  int id;
  int reputation;
  int upVotes;
  int downVotes;
  int count;
  int countPerFrame;
  Calendar creationDate;
  float frequency; // Times used per unit of simulation time
  
  public User (int id, int reputation, int upVotes, int downVotes, Calendar creationDate, int count) {
    this.id = id;
    this.reputation = reputation;
    this.upVotes = upVotes;
    this.downVotes = downVotes;
    this.creationDate = creationDate;
    this.count = count;
    tradius = count;
    
    col = #FFFFFF;
    rho = 0;
    phi = random(TWO_PI);
    h = 0;
    vPhi = random(0.1);
  }
  
  public void increment() {
    count++;
    countPerFrame++;
  }
  
  public void update() {
    tradius = max(tradius + ((countPerFrame > 1 ? log(countPerFrame) : 0) - 0.0001), 0); // should figure out a better scale for this
    trho = count;
    
    frequency = ((float) count) / ((float) frameCount);
    if(frequency > maxUserFrequency)
      maxUserFrequency = frequency;
    tvPhi = 0.05 * sqrt(frequency);
    col = lerpColor(#389435, #368da9, map(frequency, 0, maxUserFrequency, 0, 1));
    
    countPerFrame = 0;
    super.update();
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
  
  public float getFrequency() {
    return frequency;
  }
  
  public Calendar getCreationDate() {
    return creationDate;
  }
}
