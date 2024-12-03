class obstacle {
  float xPos = 650;
  float hSize = 120;
  int type = 1;

  obstacle() {
    type = int(random(2));
    if (type == 0) {
      hSize = random(30, 180);
    } else {
      hSize = random(200, 300);
    }
  }

  void update() {
    xPos -= speed;
    strokeWeight(10);
    fill(255);
    if (type == 0) {
      rect(xPos, floor - hSize, 30, hSize);

      if (xPos > 50 && xPos < 50 + squareSize && yPos + squareSize > floor - hSize) {
        setGameOver();
      }
    } else {
      rect(xPos, 0, 50, hSize);

      if (xPos > 50 && xPos < 50 + squareSize && yPos < hSize) {
        setGameOver();
      }
    }
    if (xPos < -50) {
      reset();
    }
  }

  void reset() {
    xPos = width + 50;
    speed += acceleration;
    type = int(random(2));
    if (type == 0) {
      hSize = random(30, 180);
    } else {
      hSize = random(200, 300);
    }
  }
}
