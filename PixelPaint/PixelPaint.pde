Pixel[][] pixel = new Pixel[80][25];
PrintWriter code;
PrintWriter saved;
int globalW = 80;
int globalH = 25;
ColorPicker colorPicker;
int[] colors = new int[16];
Pixel firstPoint = null;
Pixel secondPoint = null;
String point = "firstPoint";
String[] lines;

void setup() {
  fullScreen();
  globalW = width / globalW;
  globalH = 600 / globalH;
  background(0);
  colorPicker = new ColorPicker();
  for (int i = 0; i < pixel.length; i++) {
    for (int j = 0; j < pixel[i].length; j++) {
      pixel[i][j] = new Pixel(i, j);
    }
  }
  colorPicker.show();
  lines = loadStrings("saved.txt");
  if (lines != null) {
    initializePixels();
  }
}

void draw() {
  for (int i = 0; i < pixel.length; i++) {
    for (int j = 0; j < pixel[i].length; j++) {
      Pixel pix = pixel[i][j];
      stroke(0);
      fill(pix.value);
      rect(pix.x, pix.y, globalW, globalH);
    }
  }
}

void initializePixels() {
  for (int i = 0; i < lines.length; i++) {
    int[] index = int(split(lines[i], ' '));
    pixel[index[0]][index[1]].value = index[2];
  }
}

void keyPressed() {
  int index = 1;
  if (key == ' ') {
    code = createWriter("code.txt");
    for (int j = 0; j < pixel[0].length; j++) {
      for (int i = 0; i < pixel.length; i++) {
        Pixel pix = pixel[i][j];
        if (!pix.added && pix.value != black) {
          //println(pix.index);
          int count = neighborCount(pixel[i][j], i, j, 0);
          if (count == 0) {
            code.println("mov [" + pix.index + "], " + getHex(pix.value));
          } else {
            String name = "loop" + index;
            code.println("mov di, " + pix.index + "\nmov cx, " + (count + 1)+ "\n" + name + ": mov [di], " + getHex(pix.value) + "\n\tadd di, 2\nloop " + name + "\n");
            index += 1;
          }
          //print(count);
        }
      }
    }
    saved = createWriter("data/saved.txt");
    for (int j = 0; j < pixel[0].length; j++) {
      for (int i = 0; i < pixel.length; i++) {
        Pixel pix = pixel[i][j];
        if (pix.value != black) {
          saved.println(i + " " + j + " " + pix.value);
        }
      }
    }

    code.flush();
    saved.flush();
    code.close();
    saved.close();
    exit();
  } else if (key == 'f') {
    if (firstPoint != null && secondPoint != null) {
      int x1 = 0;
      int x2 = 0;
      int y1 = 0;
      int y2 = 0;
      if (firstPoint.j < secondPoint.j) {
        x1 = firstPoint.j;
        x2 = secondPoint.j;
      } else {
        x1 = secondPoint.j;
        x2 = firstPoint.j;
      }
      if (firstPoint.i < secondPoint.i) {
        y1 = firstPoint.i;
        y2 = secondPoint.i;
      } else {
        y1 = secondPoint.i;
        y2 = firstPoint.i;
      }
      for (int j = x1; j <= x2; j++) {
        for (int i = y1; i <= y2; i++) {
          pixel[i][j].value = curValue;
        }
      }
    }
  }
}

int neighborCount(Pixel pix, int i, int j, int count) {
  if (i < 79) {
    if (pix.value == pixel[i + 1][j].value) {
      pixel[i + 1][j].added = true;
      count = neighborCount(pixel[i + 1][j], i + 1, j, count + 1);
    }
  }
  return count;
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < pixel.length; i++) {
      for (int j = 0; j < pixel[i].length; j++) {
        Pixel pix = pixel[i][j];
        if (pix.x < mouseX && pix.w > mouseX && pix.y < mouseY && pix.h > mouseY) {
          pixel[i][j].value = curValue;
        }
      }
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < pixel.length; i++) {
      for (int j = 0; j < pixel[i].length; j++) {
        Pixel pix = pixel[i][j];
        if (pix.x < mouseX && pix.w > mouseX && pix.y < mouseY && pix.h > mouseY) {
          pixel[i][j].value = curValue;
          if (point == "firstPoint") {
            firstPoint = pixel[i][j];
            point = "secondPoint";
          } else if (point == "secondPoint") {
            secondPoint = pixel[i][j];
            point = "firstPoint";
          }
          //println(pixel[i][j].index);
        }
      }
    }
    for (int i = 0; i < colorPicker.pix.length; i++) {
      Pixel pixx = colorPicker.pix[i];
      if (pixx.x < mouseX && pixx.x + pixx.w > mouseX && pixx.y < mouseY && pixx.y + pixx.h > mouseY) {
        curValue = pixx.value;
      }
    }
  }
}
