int r = 6;
Line[][] lines = new Line[2][r * (r - 1)];
Line[][] temp = new Line[2][r * (r - 1)];
Line closestLine = null;
String turn = "ai";
int w = 700;
int aiScore = 0;
int playerScore = 0;
String winner = "";
int state = 0;
ArrayList<Line> moves = new ArrayList<Line>();
HashMap<String, int[]> table = new HashMap<String, int[]>();
String boardCode = "";
Line aiLastMove = null;
float curDepth = 2;

void setup() {
  size(1000, 500);
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length; j++) {
      lines[i][j] = new Line(i, j);
      boardCode += "0";
    }
  }
  background(100);  
  display();
}

void draw() {
  background(100);
  if (!isGameEnd()) {
    if (turn == "ai") {
      delay(500);
      aiMove();
      delay(100);
    } else {
      for (int i = 0; i < lines.length; i++) {
        for (int j = 0; j < lines[i].length; j++) {
          if (lines[i][j].equals(closestLine) && isMouseActive()) {
            lines[i][j].hovered = true;
          } else {
            lines[i][j].hovered = false;
          }
        }
      }
    }
    display();
  } else {
    checkWinner();
    displayWinner();
  }
}

Boolean isMouseActive() {
  return mouseX >= 10 && mouseX <= w - 10 && mouseY >= 10 && mouseY <= height - 10;
}

void aiMove() {
  Line move = null;
  moves.clear();
  table.clear();
  int lowest = Integer.MAX_VALUE;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length; j++) {
      if (!lines[i][j].moved) {
        lines[i][j].moved = true;
        state++;
        int score = lines[i][j].checkNeighbors();
        String code = getCode(i, j, boardCode);
        int bestScore = minimax(code, -score, 0, score == 0, Integer.MIN_VALUE, Integer.MAX_VALUE);
        lines[i][j].moved = false;
        state--;
        if (bestScore == 0) {
          moves.add(lines[i][j]);
        }
        if (bestScore <= lowest) {
          lowest = bestScore;
          move = lines[i][j];
        }
      }
    }
  }
  if (move != null) {
    int score = move.checkNeighbors();
    if (score == 0) {
      if (!moves.isEmpty()) {
        do {
          move = moves.get((int) random(moves.size()));
        } while (move == null);
      }
      turn = "player";
      aiLastMove = move;
    } else {
      aiScore += score;
      turn = "ai";
    }
    move.moved = true;
    state++;
    curDepth += 0.1;
    setBoardCode();
  }
}

int minimax(String curCode, int score, int depth, Boolean maximizing, int alpha, int beta) {
  if (curDepth >= 6) {
    if (isGameEnd()) {
      return score;
    }
  } else {
    if (depth > curDepth || isGameEnd()) {
      return score;
    }
  }
  if (maximizing) {
    int highest = Integer.MIN_VALUE;
    for (int i = 0; i < lines.length; i++) {
      for (int j = 0; j < lines[i].length; j++) {
        if (!lines[i][j].moved) {
          lines[i][j].moved = true;
          state++;
          int num = lines[i][j].checkNeighbors();
          int bestScore;
          String code = getCode(i, j, curCode);
          if (table.containsKey(code)) {
            int[] val = table.get(code);
            if (val[1] == 1) {
              bestScore = score + val[0];
            } else {
              bestScore = score - val[0];
            }
          } else {
            bestScore = minimax(code, score + num, depth + 1, num != 0, alpha, beta);
            table.put(code, arr(bestScore, 1));
          }
          lines[i][j].moved = false;
          state--;
          if (bestScore >= highest) {
            highest = bestScore;
          }
          alpha = max(alpha, highest);
          if (alpha >= beta) {
            break;
          }
        }
      }
    }
    return highest;
  } else {
    int lowest = Integer.MAX_VALUE;
    for (int i = 0; i < lines.length; i++) {
      for (int j = 0; j < lines[i].length; j++) {
        if (!lines[i][j].moved) {
          lines[i][j].moved = true;
          state++;
          int num = lines[i][j].checkNeighbors();
          int bestScore;
          String code = getCode(i, j, curCode);
          if (table.containsKey(code)) {
            int[] val = table.get(code);
            if (val[1] == -1) {
              bestScore = score + val[0];
            } else {
              bestScore = score - val[0];
            }
          } else {
            bestScore = minimax(code, score - num, depth + 1, num == 0, alpha, beta);
            table.put(code, arr(bestScore, -1));
          }
          lines[i][j].moved = false;
          state--;
          if (bestScore <= lowest) {
            lowest = bestScore;
          }
          beta = min(beta, lowest);
          if (alpha >= beta) {
            break;
          }
        }
      }
    }
    return lowest;
  }
}

String getCode(int i, int j, String code) {
  int index = (i * lines[i].length) + j;
  if (index == 0) {
    return "1" + code.substring(index + 1, code.length());
  } else if (index == code.length() - 1) {
    return code.substring(0, index) + "1";
  } else {
    return code.substring(0, index) + "1" + code.substring(index + 1, code.length());
  }
}

void mousePressed() {
  if (turn == "player" && !isGameEnd()) {
    Line line = closestLine;
    line.moved = true;
    int score = line.checkNeighbors();
    if (score != 0) {
      playerScore += score;
      turn = "player";
    } else {
      turn = "ai";
    }
    state++;
    aiLastMove = null;
    curDepth += 0.1;
    setBoardCode();
  }
}

void setBoardCode() {
  String boardCode = "";
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length; j++) {
      if (lines[i][j].moved) {
        boardCode += "1";
      } else {
        boardCode += "0";
      }
    }
  }
}

int[] arr(int val, int mult) {
  int[] temp = {val, mult};
  return temp;
}

void checkWinner() {
  if (playerScore > aiScore) {
    winner = "PLAYER";
  } else if (aiScore > playerScore) {
    winner = "AI";
  } else {
    winner = "TIE";
  }
}

Boolean isGameEnd() {
  return state >= lines[0].length * 2;
}

void display() {
  float lowest = Float.MAX_VALUE;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length; j++) {
      lines[i][j].update();
      if (!lines[i][j].moved) {
        if (lines[i][j].distance < lowest) {
          lowest = lines[i][j].distance;
          closestLine = lines[i][j];
        }
      }
      lines[i][j].show();
    }
  }
  stroke(0);
  strokeWeight(r * 2);
  for (int i = 0; i < r; i++) {
    for (int j = 0; j < r; j++) {
      point((w / 20) + (i * w / r), (height / 20) + (j * height / r));
    }
  }
  textSize(100);
  text("Score", w + 10, 100);
  textSize(50);
  text("Player = " + playerScore, w + 10, 200);
  text("AI = " + aiScore, w + 10, 300);
  text("Depth = " + floor(curDepth), w + 10, 400);
}

void displayWinner() {
  textSize(100);
  textAlign(CENTER);
  text("Winner:", width / 2, 100);
  textSize(200);
  text(winner, width / 2, 300);
  textAlign(BASELINE);
  textSize(50);
  text("Player = " + playerScore, 10, 400);
  text("AI = " + aiScore, 10, 450);
}
