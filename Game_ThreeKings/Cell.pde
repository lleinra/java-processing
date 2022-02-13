class Cell {
  PVector pos;
  String coin = "";
  float r = height / 3 * 0.75;
  Boolean isClicked = false;
  int x;
  int y;
  Boolean isHighlighted = false;
  ArrayList<Cell> possibleMoves = new ArrayList<Cell>();

  Cell(float x, float y, int j, int i) {
    pos = new PVector(x, y);
    this.x = j;
    this.y = i;
  }

  Boolean isClicked() {
    return mouseX > pos.x - r / 2 && mouseX < pos.x + r / 2 &&
      mouseY > pos.y - r / 2 && mouseY < pos.y + r / 2;
  }

  void move(Cell cell) {
    String temp = cell.coin;
    cell.coin = coin;
    coin = temp;
  }

  void show() {
    if (coin == "red") {
      fill(255, 0, 0);
    } else if (coin == "blue") {
      fill(0, 0, 255);
    } else {
      fill(100);
    }
    if (isHighlighted) {
      fill(0, 255, 0);
    }
    if (isClicked) {
      if (coin == "red") {
        fill(255, 0, 0, 100);
      } else if (coin == "blue") {
        fill(0, 0, 255, 100);
      }
    }
    circle(pos.x, pos.y, r);
  }
}
