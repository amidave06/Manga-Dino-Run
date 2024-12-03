class skin {
  boolean unlocked;
  String imgName;
  PImage img;
  
  public skin(String imgName) {
    this.imgName=imgName;
    img=loadImage(imgName);
    unlocked=false;
  }
}
