import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tool_NonogramSolver extends PApplet {

String[] values;
int rows;
int timeStep = 100000;
int w = 500;
Cell[][] cells;
Textbox[][] nums;
//num[0] are values of each column
//num[1] are values of each rows

Cell curCell;
Boolean solving = false;
PrintWriter data;

public void setup() {
  
  values = loadStrings("data.txt");
  rows = PApplet.parseInt(values[values.length - 1]);
  setup(true);
}

public void setup(Boolean s) {
  cells = new Cell[rows][rows];
  nums = new Textbox[2][rows];
  for (int i = 0; i < rows; i++) {
    nums[0][i] = new Textbox(i + 1, 0);
    nums[1][i] = new Textbox(0, i + 1);
    for (int j = 0; j < rows; j++) {
      cells[j][i] = new Cell(j, i);
    }
  }
  preset();
  refresh();
  curCell = cells[0][0];
}

public void draw() {
  background(0);
  if (solving && curCell != null) {
    for (int i = 0; i < timeStep; i++) {
      curCell = solve(curCell);
      if (curCell == null) { 
        break;
      }
    }
  }
  display();
}

public void exit() {
  data = createWriter("data.txt");
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < rows; j++) {
      int[] values = nums[i][j].values;
      for (int k = 0; k < values.length; k++) {
        data.print(values[k]);
        if (k < values.length - 1) {
          data.print(" ");
        }
      }
      data.println();
    }
  }
  data.println(rows);

  data.flush();
  data.close();

  //launch(sketchPath("data.txt"));
  super.exit();
}

Stack<Cell> stack = new Stack<Cell>();
public Cell solve(Cell curr) {
  if (curr == null) {
    return null;
  }

  //mark current cell as safe and add to stack
  curr.isSafe = true;
  stack.push(curr);

  /*
  if not within constraints of row and columns
   uncheck current cell and remove from stack
   */
  if (!inConst(curr, false) || !inConst(curr, true)) {
    curr.isSafe = false;
    stack.remove(curr);
  }

  //get next cell
  Cell next = getNext(curr);

  /*
  if reached end of row
   if cells don't matches numbers
   uncheck current cell and remove from stack
   pop a cell from stack then solve the next of that cell
   */
  if (curr.i >= rows - 1) {
    if (!verifyRow(curr, false)) {
      curr.isSafe = false;
      stack.remove(curr);
      Cell cell = curr;
      if (!stack.isEmpty()) {
        cell = stack.pop();
        cell.isSafe = false;
      }
      if (cell.i >= rows - 1) {
        if (!stack.isEmpty()) {
          cell = stack.pop();
          cell.isSafe = false;
        }
      }
      next = getNext(cell);
    }
  }
  /*
  if reached end of column
   if cells don't matches numbers
   uncheck current cell and remove from stack
   pop a cell from stack then solve the next of that cell
   */
  if (curr.j >= rows - 1) {
    if (!verifyRow(curr, true)) {
      curr.isSafe = false;
      stack.remove(curr);
      if (stack.isEmpty()) {
        return null;
      }
      Cell cell = stack.pop();
      cell.isSafe = false;
      if (stack.isEmpty()) {
        return null;
      }
      if (cell.j >= rows - 1) {
        cell = stack.pop();
      }
      cell.isSafe = false;
      next = getNext(cell);
    }
  }

  //get next cell
  return next;
}

Stack<Cell[]> groups = new Stack<Cell[]>();
public Boolean inConst(Cell curr, Boolean checkingCol) {
  groups.clear();
  Cell[] col = new Cell[rows];

  int index = curr.j;
  int[] values = nums[1][index].values;
  for (int i = 0; i < rows; i++) {
    col[i] = cells[i][index];
  }

  if (checkingCol) {
    index = curr.i;
    values = nums[0][index].values;
    for (int j = 0; j < rows; j++) {
      col[j] = cells[index][j];
    }
  }

  int count = 0;
  for (int i = 0; i < rows; i++) {
    if (col[i].isSafe) {
      count += 1;
      if (i + 1 == rows || !col[i + 1].isSafe) {
        if (!groups.empty()) {
          if (groups.peek().length != values[groups.indexOf(groups.peek())]) {
            return false;
          }
        }
        Cell[] group = new Cell[count];
        for (int j = 0, k = i - count + 1; j < count; j++, k++) {
          group[j] = col[k];
        }
        groups.add(group);
        count = 0;
      }
    }
  }
  if (groups.size() > values.length) {
    return false;
  }
  for (int i = 0; i < groups.size(); i++) {
    if (groups.get(i).length > values[i]) {
      return false;
    }
  }
  return true;
}

public Boolean verifyRow(Cell curr, Boolean checkingCol) {
  groups.clear();
  Cell[] col = new Cell[rows];

  int index = curr.j;
  int[] values = nums[1][index].values;
  for (int i = 0; i < rows; i++) {
    col[i] = cells[i][index];
  }

  if (checkingCol) {
    index = curr.i;
    values = nums[0][index].values;
    for (int j = 0; j < rows; j++) {
      col[j] = cells[index][j];
    }
  }

  int count = 0;
  for (int i = 0; i < rows; i++) {
    if (col[i].isSafe) {
      count += 1;
      if (i + 1 == rows || !col[i + 1].isSafe) {
        Cell[] group = new Cell[count];
        for (int j = 0, k = i - count + 1; j < count; j++, k++) {
          group[j] = col[k];
        }
        groups.add(group);
        count = 0;
      }
    }
  }
  if (groups.size() != values.length) {
    return false;
  }
  for (int i = 0; i < groups.size(); i++) {
    if (groups.get(i).length != values[i]) {
      return false;
    }
  }
  return true;
}

public Cell getNext(Cell curr) {
  int i = curr.i;
  int j = curr.j;

  if (i == rows - 1 && j == rows - 1) {
    return null;
  }
  return cells[(i + 1) % rows][(i + 1) / rows + j];
}

public void preset() {
  println(values.length / 2, PApplet.parseInt(values[values.length - 1]));
  if (rows != PApplet.parseInt(values[values.length - 1])) {
    return;
  }

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < rows; j++) {
      nums[i][j].str = values[i * rows + j];
    }
  }
}

public void refresh() {
  for (int i = 0; i < rows; i++) {
    nums[0][i].update();
    nums[1][i].update();
    for (int j = 0; j < rows; j++) {
      cells[j][i].reset();
    }
  }
}

public void mousePressed() {
  if (mouseX >= 700 && mouseX <= 750 && mouseY >= 60 && mouseY <= 90) {
    rows = 5;
    setup(true);
  } else if (mouseX >= 800 && mouseX <= 850 && mouseY >= 60 && mouseY <= 90) {
    rows = 10;
    setup(true);
  } else if (mouseX >= 900 && mouseX <= 950 && mouseY >= 60 && mouseY <= 90) {
    rows = 15;
    setup(true);
  }
  for (int i = 0; i < rows; i++) { // if a cell is clicked
    for (int j = 0; j < rows; j++) {
      Cell cell = cells[j][i];
      int x = cell.x + 100;
      int y = cell.y + 100;
      int r = cell.r;
      if (x < mouseX && x + r > mouseX && y < mouseY && y + r > mouseY) {
        if (mouseButton == LEFT) {
          cell.isCrossed = false;
          if (cell.isSafe) {
            cell.isSafe = false;
            stack.remove(cell);
          } else {
            cell.isSafe = true;
            stack.push(cell);
            curCell = cell;
          }
          //clicking a cell
          //solve();
        } else {
          cell.isSafe = false;
          if (cell.isCrossed) {
            cell.isCrossed = false;
          } else {
            cell.isCrossed = true;
          }
        }
      }
    }
  }
  for (int a = 0; a < 2; a++) { // if a textbox is clicked
    Boolean clicked = false; 
    for (Textbox txtbox : nums[a]) {
      if (txtbox.clicked()) {
        for (int i = 0; i < rows; i++) {
          nums[a % 1][i].isClicked = false; 
          if (txtbox != nums[a][i]) {
            nums[a][i].isClicked = false;
          }
        }
        if (txtbox.isClicked) {
          txtbox.isClicked = false;
        } else {
          txtbox.str = ""; 
          txtbox.isClicked = true;
        }
        clicked = true;
        break;
      }
    }
    if (!clicked) {
      for (int i = 0; i < rows; i++) {
        nums[a][i].isClicked = false;
      }
    }
  }
}

public void keyPressed() {
  if (key == 'q') {
    if (solving) {
      solving = false;
    } else {
      solving = true;
    }
    return;
  }

  Textbox txtbox = null;

  int x = 0, y = 0;
pick:
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < rows; j++) {
      if (nums[i][j].isClicked) {
        x = i;
        y = j;
        txtbox = nums[i][j];
        break pick;
      }
    }
  }
  if (txtbox != null) {
    if (keyCode == 9) {
      if (y < rows - 1) {
        txtbox.isClicked = false;
        txtbox = nums[x][y + 1];
      } else {
        txtbox.isClicked = false;
        txtbox = nums[(x + 1) % 2][0];
      }
      txtbox.isClicked = true;
      txtbox.str = "";
    } else if (keyCode == 8) {
      if (txtbox.str.length() > 0) {
        txtbox.str = txtbox.str.substring(0, txtbox.str.length()-1);
      }
    } else if (keyCode == 32) {
      txtbox.str += " ";
    } else {
      if (Character.isDigit(key)) {
        txtbox.str += key;
        refresh();
        curCell = cells[0][0];
      }
    }
  } else {
    if (keyCode == 9) {
      nums[0][0].isClicked = true;
      nums[0][0].str = "";
    }
  }
}

class Textbox {
  int x, y;
  int r = w / rows;
  String str = "";
  int[] values = PApplet.parseInt(split(str, ' '));
  Boolean isClicked = false;
  int total = 0;

  Textbox(int x, int y) {
    this.x = (x * r) + 100 - r; 
    this.y = (y * r) + 100 - r;
  }

  public Boolean clicked() {
    return x < mouseX && x + r > mouseX && y < mouseY && y + r > mouseY;
  }

  public void update() {
    values = PApplet.parseInt(split(str, ' ')); 
    int sum = 0; 
    for (int i = 0; i < values.length; i++) {
      sum += values[i];
    }
    total = sum;
    if (sum > rows) {
      str = str(rows); 
      values = PApplet.parseInt(split(str, ' '));
    }
  }

  public void show() {
    fill(200); 
    if (isClicked) {
      fill(255);
    }
    noStroke(); 
    square(x, y, r); 
    fill(0); 
    textAlign(CENTER); 
    textSize(30 - rows); 
    text(str, x + r / 2, y + r / 2);
  }
}

class Cell {
  int x;
  int y;
  int i;
  int j;
  int r = w / (rows);
  Boolean isSafe = false;
  Boolean isCrossed = false;

  Cell(int x, int y) {
    i = x;
    j = y;
    this.x = x * r;
    this.y = y * r;
  }

  public void reset() {
    isSafe = false; 
    isCrossed = false;
  }

  public void show() {
    if (isCrossed && isSafe) {
      fill(0, 255, 0);
    } else if (isCrossed) {
      fill(255, 0, 0);
    } else if (isSafe) {
      fill(100);
    } else {
      fill(255);
    }
    stroke(0);
    square(x + 100, y + 100, r);
  }
}

public void display() {
  textRow();
  for (int i = 0; i < rows; i++) {
    nums[0][i].show();
    nums[1][i].show();
    for (int j = 0; j < rows; j++) {
      cells[j][i].show();
    }
  }
}

public void textRow() {
  fill(255);
  rect(650, 0, 350, height);
  fill(0);
  textSize(25);
  text("Rows:", 700, 30);
  rect(700, 60, 50, 30);
  fill(255);
  text("5", 725, 85);
  fill(0);
  rect(800, 60, 50, 30);
  fill(255);
  text("10", 825, 85);
  fill(0);
  rect(900, 60, 50, 30);
  fill(255);
  text("15", 925, 85);
}

  public void settings() {  size(1000, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tool_NonogramSolver" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
