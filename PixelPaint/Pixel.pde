class Pixel {
  float x;
  float y;
  float w;
  float h;
  int i;
  int j;
  String index;
  int value = black;
  Boolean added = false;

  Pixel(int x, int y, int value) {
    this.x = x;
    this.y = y;
    this.w = width / 8;
    this.h = 480 / 2;
    this.value = value;
  }

  Pixel(int i, int j) {
    x = i * globalW;
    y = j * globalH;
    this.i = i;
    this.j = j;
    this.w = x + globalW;
    this.h = y + globalH;
    int tempIndex = j * 80 + i;
    tempIndex *= 2;
    tempIndex += 1;
    index = "0" + toHex(tempIndex) + "h";
  }

  void show() {
    stroke(255);
    fill(value);
    rect(x, y, w, h);
  }
}

String toHex(int decimal) {    
  int rem;
  String hex = "";
  char hexchars[]={'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
  if (decimal == 0) {
    return "0";
  }
  while (decimal>0)
  {
    rem=decimal%16;
    hex=hexchars[rem]+hex;
    decimal=decimal/16;
  }
  return hex;
}
