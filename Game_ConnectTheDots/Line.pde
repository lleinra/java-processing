class Line {
  int i;
  int j;
  float x1;
  float y1;
  float x2;
  float y2;
  float distance;
  Boolean hovered = false;
  Boolean moved = false;

  Line(int i, int j) {
    this.i = i;
    this.j = j;
    float xOffset = w / 20;
    float yOffset = height / 20;
    int quotient = j / r;
    int rem = j % r;
    if (i == 0) {
      x1 = xOffset + (quotient * w / r);
      y1 = yOffset + (rem * height / r);
      x2 = xOffset + ((quotient + 1) * w / r);
      y2 = yOffset + (rem * height / r);
    } else {
      x1 = xOffset + (rem * w / r);
      y1 = yOffset + (quotient * height / r);
      x2 = xOffset + (rem * w / r);
      y2 = yOffset + ((quotient + 1) * height / r);
    }
  }

  int checkNeighbors() {
    int score = 0;
    int i2 = ~i + 2;

    if ((j % r) > 0) {
      int j2= j - 1;
      if (j2 / r == 0) {
        j2 *= r;
      } else {
        int quotient = j2 / r;
        j2 = (j2 % r) * r;
        j2 += quotient;
      }
      int sum = 0;
      if (lines[i][j - 1].moved) {
        sum++;
      }
      if (lines[i2][j2].moved) {
        sum++;
      }
      if (lines[i2][j2 + 1].moved) {
        sum++;
      }
      if (sum == 3) {
        score++;
      }
    }
    if ((j % r) < r - 1) {
      int j2 = j;
      if (j2 / r == 0) {
        j2 *= r;
      } else {
        int quotient = j2 / r;
        j2 = (j2 % r) * r;
        j2 += quotient;
      }
      int sum = 0;
      if (lines[i][j + 1].moved) {
        sum++;
      }
      if (lines[i2][j2].moved) {
        sum++;
      }
      if (lines[i2][j2 + 1].moved) {
        sum++;
      }
      if (sum == 3) {
        score++;
      }
    }
    return score;
  }

  void update() {
    distance = (abs(((x1 + x2) / 2) - mouseX) + abs(((y1 + y2) / 2) - mouseY)) / 2;
  }

  void show() {
    if (this == aiLastMove) {
      stroke(255, 255, 0);
    } else if (moved) {
      stroke(0);
    } else if (hovered) {
      stroke(0, 255, 0);
    } else {
      stroke(0, 10);
    }
    line(x1, y1, x2, y2);
  }
}
