import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class Timekeeper {
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  Calendar cSimDate = new GregorianCalendar();
  Calendar postDate = new GregorianCalendar();
  Calendar pDate = new GregorianCalendar();
  Calendar startTime = new GregorianCalendar();
  int simSecondsPerFrame = 1000; // simulated seconds per frame
  float timescale = 1.0;
  
  
  Timekeeper(String startDate) {
    try {
      startTime.setTime(dateFormat.parse(startDate));
      cSimDate.setTime(dateFormat.parse(startDate));
    }
    catch (java.text.ParseException e) {
      System.err.println(e);
    }
  }
  
  public void advance() {
    cSimDate.setTimeInMillis((long) (cSimDate.getTimeInMillis() + 1000 * simSecondsPerFrame * timescale));
  }
  
  public long getMillisPerFrame() {
    return 1000 * simSecondsPerFrame;
  }
  
  public Date getPostTime() {
    return postDate.getTime();
  }
  
  public Date getSimulationTime() {
    return cSimDate.getTime();
  }
  
  public float getTimescale() {
    return timescale;
  }
  
  public long getTimeSinceStart() {
    return cSimDate.getTimeInMillis() - startTime.getTimeInMillis();
  }
  
  public boolean hasAdvanced() {
    return postDate.after(cSimDate);
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
