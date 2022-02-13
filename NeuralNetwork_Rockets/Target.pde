class Target {
  PVector pos;
  float r = 8;

  Target() {
    //float x = random(width);
    //float y = random(height);
    float x = width / 2;
    float y = r;
    pos = new PVector(x, y);
  }

  void show() {
    stroke(0);
    fill(255);
    ellipseMode(CENTER);
    ellipse(pos.x, pos.y, r * 2, r * 2);
  }
}
