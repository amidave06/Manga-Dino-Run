class coin {
  float coinX;
  float coinY;
  boolean active;

  coin(float xpos, float ypos) {
    coinX = xpos;
    coinY = ypos;
    active = true;
  }
  void update() { //Method
    coinX -= speed;
    if (active) {
      fill(255, 255, 0);
      strokeWeight(0);
      circle(coinX, coinY, 30);
      if (dist(50 + (squareSize/2), yPos + (squareSize/2), coinX, coinY) < 60) {
        collect();
      }
    }
    if (coinX < -50) {
      reset();
    }
  }
  void collect() {
    coinCounter++;
    active = false;
  }
  void reset() {
    coinX = 700;
    coinY = random(60, floor - 30);
    active = true;
  }
}
