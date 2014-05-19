import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class Timekeeper {
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  Calendar cSimDate = new GregorianCalendar();
  Calendar postDate = new GregorianCalendar();
  Calendar pDate = new GregorianCalendar();
  String cDate;
  long simSecondsPerFrame = 60; // simulated seconds per frame
  
  Timekeeper() {
    cSimDate.set(2008, 6, 31);
  }
  
  public void advance() {
    cSimDate.setTimeInMillis(cSimDate.getTimeInMillis() + 1000 * simSecondsPerFrame);
  }
  
  public Date getPostTime() {
    return postDate.getTime();
  }
  
  public Date getSimulationTime() {
    return cSimDate.getTime();
  }
  
  public boolean hasAdvanced() {
    return postDate.getTimeInMillis () > cSimDate.getTimeInMillis();
  }
  
  public void setCurrentPostTime(String date) {
    try {
      postDate.setTime(dateFormat.parse(date));
    }
    catch (java.text.ParseException e) {
      System.err.println(e);
    }
  }
  
}
