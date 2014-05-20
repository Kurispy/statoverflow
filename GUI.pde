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
      
    cp5.addSlider("timescale")
      .setSize(20, 200)
      .setPosition(40, 20)
      .setRange(0, 4)
      .setGroup(rightMenu)
      .plugTo(timekeeper)
      .setValue(1.0)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addSlider("realSecondsPerFrame")
      .setSize(20, 200)
      .setPosition(140, 20)
      .setRange(0, 3600)
      .setGroup(rightMenu)
      .plugTo(timekeeper)
      .setValue(1000)
      .setCaptionLabel("RSPF")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addSlider("tagDecay")
      .setSize(20, 200)
      .setPosition(40, 240)
      .setRange(0, 4)
      .setCaptionLabel("Tag Decay")
      .setGroup(rightMenu)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addSlider("userDecay")
      .setSize(20, 200)
      .setPosition(140, 240)
      .setRange(0, 4)
      .setCaptionLabel("User Decay")
      .setGroup(rightMenu)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addButton("Show FPS")
      .setSize(20, 20)
      .setPosition(140, 550)
      .setGroup(rightMenu)
      .setSwitch(true)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addButton("Show Ring Labels")
      .setSize(20, 20)
      .setPosition(40, 550)
      .setGroup(rightMenu)
      .setSwitch(true)
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
      ;
      
    cp5.addNumberbox("viewCountThreshold") // This should be converted to a range slider
      .setPosition(55, 500)
      .setSize(90, 20)
      .setRange(0, Integer.MAX_VALUE)
      .setGroup(rightMenu)
      .setMultiplier(25)
      .setCaptionLabel("View Count Threshold")
      ;
      
    userInfo = cp5.addTextarea("txt")
      .setSize(120, 60)
      .setPosition((width - 120) / 2, height - 60)
      .hideScrollbar()
      .setFont(createFont("Arial", 12))
      .setLineHeight(14)
      .setColor(color(255))
      .setColorBackground(color(0, 0))
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
    
    if (theEvent.getController() == cp5.getController("Show Ring Labels")) {
      showRingLabels = !showRingLabels;
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
