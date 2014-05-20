public class GUI implements ControlListener {
  ControlP5 cp5;
  Textarea userInfo;
  Textlabel currentDate;
  FrameRate fps;
  
  GUI(PApplet parent) {
    cp5 = new ControlP5(parent);
    cp5.addListener(this);
    cp5.setAutoDraw(false);
    fps = cp5.addFrameRate();
    fps.hide();
    ControllerGroup rightMenu = cp5.addGroup("Settings")
      .setPosition(width - 200, 10)
      .setWidth(200)
      .setBarHeight(10)
      .setBackgroundHeight(height)
      .setBackgroundColor(color(255, 10))
      .close()
      ;
      
    cp5.addSlider("detailLevel")
      .setSize(20, 200)
      .setRange(3, 30)
      .setNumberOfTickMarks(28)
      .showTickMarks(false)
      .setCaptionLabel("Detail Level")
      .setGroup(rightMenu)
      ;
      
    cp5.addSlider("decay")
      .setSize(20, 200)
      .setRange(0, 10)
      .setNumberOfTickMarks(11)
      .setGroup(rightMenu)
      ;
      
    cp5.addButton("Show FPS")
      .setSize(20, 20)
      .setPosition(10, 300)
      .setGroup(rightMenu)
      .setSwitch(true)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addNumberbox("viewCountThreshold") // This should be converted to a range slider
      .setPosition(100, 300)
      .setSize(90, 20)
      .setRange(0, Integer.MAX_VALUE)
      .setGroup(rightMenu)
      .setMultiplier(25)
      .setCaptionLabel("View Count Threshold")
      ;
      
    userInfo = cp5.addTextarea("txt")
      .setPosition(100, 100)
      .setSize(155, 75)
      .hideScrollbar()
      .setFont(createFont("Arial", 12))
      .setLineHeight(14)
      .setColor(color(128))
      .setColorBackground(color(255, 100))
      .setColorForeground(color(255, 100))
      ;
      
    currentDate = cp5.addTextlabel("cDate");
    currentDate.setPosition(0, height - currentDate.getHeight());
  
    // This allows us to use the scroll wheel with CP5
    addMouseWheelListener(new java.awt.event.MouseWheelListener() {
      public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
        cp5.setMouseWheelRotation(e.getWheelRotation());
      }
    });
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.getController() == cp5.getController("Show FPS")) {
      if (!fps.isVisible())
        fps.show();
      else
        fps.hide();
    }
  }
  
  void drawGUI() {
    beginCamera();
    camera();
    hint(DISABLE_DEPTH_TEST);
    cp5.draw();
    hint(ENABLE_DEPTH_TEST);
    endCamera();
  }
  
  boolean isMouseOver() {
    return cp5.isMouseOver();
  }
  
  void setDate(String date) {
    currentDate.setText(date);
  }
  
  void setUserInfo(String info) {
    userInfo.setText(info);
  }
}
