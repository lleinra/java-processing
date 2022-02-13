Cell[][] cells = new Cell[3][3];
String turn = "ai";
Cell movingPiece = null;
HashMap<String, Integer> seenCells = new HashMap<String, Integer>();

void setup() {
  size(500, 500);
  initializeCells();
}

void draw() {
  background(100);
  String winner = winner();
  if (winner == null) {
    if (turn == "ai") {
      aiMove("red");
      turn = "player";
    }
  } else {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[j][i].coin != winner) {
          cells[j][i].isClicked = true;
        }
      }
    }
    println("done");
    noLoop();
  }
  drawBoundaries();
  drawCells();
}

ArrayList<Cell> aimoves = new ArrayList<Cell>();
int[] scores = new int[3];
void aiMove(String col) {
  Cell[] aicoins = new Cell[3];
  int index = 0;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (cells[j][i].coin == col) {
        aicoins[index] = cells[j][i];
        index++;
      }
    }
  }
  println("moving");
  Cell bestCoin = null;
  Cell bestMove = null;
  Cell coin;
  int lowest = Integer.MAX_VALUE;
  for (int i = 0; i < 3; i++) {
    coin = aicoins[i];
    showPossibleMoves(coin);
    ArrayList<Cell> possibleMoves = (ArrayList<Cell>) coin.possibleMoves.clone();
    coin.possibleMoves.clear();
    if (!possibleMoves.isEmpty()) {
      for (int j = 0; j < possibleMoves.size(); j++) {
        Cell move = possibleMoves.get(j);
        coin.move(move);
        int score;
        if (seenCells.containsKey(getBoard())) {
          score = seenCells.get(getBoard());
        } else {
          score = minimax(0, Integer.MAX_VALUE, Integer.MIN_VALUE, true);
          seenCells.put(getBoard(), score);
        }
        move.move(coin);
        if (score <= lowest) {
          lowest = score;
          bestCoin = aicoins[i];
          println(bestCoin.x, bestCoin.y, lowest);
          bestMove = move;
        }
      }
    } else {
      println(coin.x, coin.y + " has no move");
    }
  }
  if (bestCoin != null && bestMove != null) {
    bestCoin.move(bestMove);
    bestCoin.possibleMoves.clear();
    seenCells.clear();
  }
}

int minimax(int depth, int beta, int alpha, Boolean maximizing) {
  String winner = winner();
  if (winner != null || depth == 250) {
    int score = winner == "blue" ? 100 - depth : winner == "red" ? -100 + depth : 0;
    //println(score);
    return score;
  }
  if (maximizing) {
    Cell[] aicoins = new Cell[3];
    int index = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[j][i].coin == "blue") {
          aicoins[index] = cells[j][i];
          index++;
        }
      }
    }
    Cell coin;
    int highest = Integer.MIN_VALUE;
    for (int i = 0; i < 3; i++) {
      coin = aicoins[i];
      showPossibleMoves(coin);
      ArrayList<Cell> possibleMoves = (ArrayList<Cell>) coin.possibleMoves.clone();
      coin.possibleMoves.clear();
      if (!possibleMoves.isEmpty()) {
        for (int j = 0; j < possibleMoves.size(); j++) {
          Cell move = possibleMoves.get(j);
          coin.move(move);
          int score;
          if (seenCells.containsKey(getBoard())) {
            score = seenCells.get(getBoard());
            //println(score);
          } else {
            score = minimax(depth + 1, beta, alpha, false);
            seenCells.put(getBoard(), score);
          }
          move.move(coin);
          highest = max(score, highest);
          if (highest >= beta) {
            break;
          }
          alpha = max(alpha, highest);
          //if (beta <= alpha) {
          //  break;
          //}
        }
      }
    }
    return highest;
  } else {
    Cell[] aicoins = new Cell[3];
    int index = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[j][i].coin == "red") {
          aicoins[index] = cells[j][i];
          index++;
        }
      }
    }
    Cell coin;
    int lowest = Integer.MAX_VALUE;
    for (int i = 0; i < 3; i++) {
      coin = aicoins[i];
      showPossibleMoves(coin);
      ArrayList<Cell> possibleMoves = (ArrayList<Cell>) coin.possibleMoves.clone();
      coin.possibleMoves.clear();
      if (!possibleMoves.isEmpty()) {
        for (int j = 0; j < possibleMoves.size(); j++) {
          Cell move = possibleMoves.get(j);
          coin.move(move);
          int score;
          if (seenCells.containsKey(getBoard())) {
            score = seenCells.get(getBoard());
          } else {
            score = minimax(depth + 1, beta, alpha, true);
            seenCells.put(getBoard(), score);
          }
          move.move(coin);
          lowest = min(score, lowest);
          if (lowest <= alpha) {
            break;
          }
          beta = min(beta, lowest);
          //if (beta <= alpha) {
          //  break;
          //}
        }
      }
    }
    return lowest;
  }
}

String getBoard() {
  String code = "";
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (cells[j][i].coin == "red") {
        code += "2";
      } else if (cells[j][i].coin == "blue") {
        code += "1";
      } else {
        code += "0";
      }
    }
  }
  return code;
}

String winner() {
  if (cells[0][0].coin == "blue" && cells[1][0].coin == cells[0][0].coin && cells[2][0].coin == cells[0][0].coin) {
    return cells[0][0].coin;
  }
  if (cells[0][1].coin != "" && cells[1][1].coin == cells[0][1].coin && cells[2][1].coin == cells[0][1].coin) {
    return cells[0][1].coin;
  }
  if (cells[0][2].coin == "red" && cells[1][2].coin == cells[0][2].coin && cells[2][2].coin == cells[0][2].coin) {
    return cells[0][2].coin;
  }
  if (cells[0][0].coin != "" && cells[0][1].coin == cells[0][0].coin && cells[0][2].coin == cells[0][0].coin) {
    return cells[0][0].coin;
  }
  if (cells[1][0].coin != "" && cells[1][1].coin == cells[1][0].coin && cells[1][2].coin == cells[1][0].coin) {
    return cells[1][0].coin;
  }
  if (cells[2][0].coin != "" && cells[2][1].coin == cells[2][0].coin && cells[2][2].coin == cells[2][0].coin) {
    return cells[2][0].coin;
  }
  if (cells[0][0].coin != "" && cells[1][1].coin == cells[0][0].coin && cells[2][2].coin == cells[0][0].coin) {
    return cells[0][0].coin;
  }
  if (cells[2][0].coin != "" && cells[1][1].coin == cells[2][0].coin && cells[0][2].coin == cells[2][0].coin) {
    return cells[2][0].coin;
  }
  return null;
}

void mousePressed() {
  Cell clicked = null;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (cells[j][i].isClicked()) {
        clicked = cells[j][i];
        break;
      }
    }
  }
  if (clicked != null) {
    if (!clicked.isClicked) {//if clicked coin is not yet clicked
      if (clicked.coin == "blue") {//if clicked on a coin
        if (movingPiece == null) {//if clicked on a coin
          clicked.isClicked = true;
          showPossibleMoves(clicked);
          highlight(clicked);
          movingPiece = clicked;
        } else {//if clicked on a coin while another coin is still clicked
          movingPiece.isClicked = false;
          unhighlight(movingPiece);
          movingPiece.possibleMoves.clear();
          clicked.isClicked = true;
          showPossibleMoves(clicked);
          highlight(clicked);
          movingPiece = clicked;
        }
      } else {//if clicked on an area
        if (movingPiece != null) {
          if (movingPiece.possibleMoves.contains(clicked)) {//if possible then move coin there
            movingPiece.move(clicked);
            movingPiece.isClicked = false;
            unhighlight(movingPiece);
            movingPiece.possibleMoves.clear();
            movingPiece = null;
            turn = "ai";
          }
        }
      }
    } else {//if clicked is already clicked
      clicked.isClicked = false;
      unhighlight(clicked);
      clicked.possibleMoves.clear();
      movingPiece = null;
    }
  }
}

void unhighlight(Cell cell) {
  if (!cell.possibleMoves.isEmpty()) {
    for (int i = 0; i < cell.possibleMoves.size(); i++) {
      Cell move = cell.possibleMoves.get(i);
      move.isHighlighted = false;
    }
  }
}

void highlight(Cell cell) {
  if (!cell.possibleMoves.isEmpty()) {
    for (int i = 0; i < cell.possibleMoves.size(); i++) {
      Cell move = cell.possibleMoves.get(i);
      move.isHighlighted = true;
    }
  }
}

void showPossibleMoves(Cell cell) {
  int x = cell.x;
  int y = cell.y;
  diamondRule(cell, x, y);
  //crossRule(cell, x, y);
}

void diamondRule(Cell cell, int x, int y) {
  if (x > 0 && y > 0 && cells[x - 1][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y - 1]);
  }
  if (y > 0 && cells[x][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x][y - 1]);
  }
  if (x < 2 && y > 0 && cells[x + 1][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y - 1]);
  }
  if (x > 0 && cells[x - 1][y].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y]);
  }
  if (x < 2 && cells[x + 1][y].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y]);
  }
  if (x > 0 && y < 2 && cells[x - 1][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y + 1]);
  }
  if (y < 2 && cells[x][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x][y + 1]);
  }
  if (x < 2 && y < 2 && cells[x + 1][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y + 1]);
  }
}

void crossRule(Cell cell, int x, int y) {
  if (x == y && x > 0 && y > 0 && cells[x - 1][y - 1] != null && cells[x - 1][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y - 1]);
  }
  if (y > 0 && cells[x][y - 1] != null && cells[x][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x][y - 1]);
  }
  if (x + y == 2 && x < 2 && y > 0 && cells[x + 1][y - 1] != null && cells[x + 1][y - 1].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y - 1]);
  }
  if (x > 0 && cells[x - 1][y].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y]);
  }
  if (x < 2 && cells[x + 1][y].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y]);
  }
  if (x + y == 2 && x > 0 && y < 2 && cells[x - 1][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x - 1][y + 1]);
  }
  if (y < 2 && cells[x][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x][y + 1]);
  }
  if (x == y && x < 2 && y < 2 && cells[x + 1][y + 1].coin == "") {
    cell.possibleMoves.add(cells[x + 1][y + 1]);
  }
}

void drawBoundaries() {
  strokeWeight(5);
  fill(100);
  float tlX = cells[0][0].pos.x;
  float tlY = cells[0][0].pos.y;
  float trX = cells[2][0].pos.x;
  float trY = cells[2][0].pos.y;
  float blX = cells[0][2].pos.x;
  float blY = cells[0][2].pos.y;
  float brX = cells[2][2].pos.x;
  float brY = cells[2][2].pos.y;
  float tX = cells[1][0].pos.x;
  float tY = cells[1][0].pos.y;
  float bX = cells[1][2].pos.x;
  float bY = cells[1][2].pos.y;
  float lX = cells[0][1].pos.x;
  float lY = cells[0][1].pos.y;
  float rX = cells[2][1].pos.x;
  float rY = cells[2][1].pos.y;
  line(tlX, tlY, trX, trY);
  line(tlX, tlY, blX, blY);
  line(blX, blY, brX, brY);
  line(trX, trY, brX, brY);
  line(tX, tY, bX, bY);
  line(lX, lY, rX, rY);
  line(tlX, tlY, brX, brY);
  line(blX, blY, trX, trY);
  //diamondRule
  line(tX, tY, rX, rY);
  line(tX, tY, lX, lY);
  line(bX, bY, rX, rY);
  line(bX, bY, lX, lY);
}

void drawCells() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      Cell cell = cells[j][i];
      cell.show();
    }
  }
}

void initializeCells() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      cells[j][i] = new Cell(width * (2 * j + 1) / 6, height * (2 * i + 1) / 6, j, i);
      Cell cell = cells[j][i];
      if (i == 0) {
        cell.coin = "red";
      } else if (i == 2) {
        cell.coin = "blue";
      }
    }
  }
}
