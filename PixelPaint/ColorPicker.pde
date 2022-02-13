int curValue = 0;

class ColorPicker {
  Pixel[] pix = new Pixel[16];

  ColorPicker() {
    pix[0] = new Pixel(0, 600, black);
    pix[1] = new Pixel(240, 600, blue);
    pix[2] = new Pixel(480, 600, green);
    pix[3] = new Pixel(720, 600, cyan);
    pix[4] = new Pixel(960, 600, red);
    pix[5] = new Pixel(1200, 600, magenta);
    pix[6] = new Pixel(1440, 600, brown);
    pix[7] = new Pixel(1680, 600, lightgray);
    pix[8] = new Pixel(0, 840, darkgray);
    pix[9] = new Pixel(240, 840, lightblue);
    pix[10] = new Pixel(480, 840, lightgreen);
    pix[11] = new Pixel(720, 840, lightcyan);
    pix[12] = new Pixel(960, 840, lightred);
    pix[13] = new Pixel(1200, 840, lightmagenta);
    pix[14] = new Pixel(1440, 840, yellow);
    pix[15] = new Pixel(1680, 840, white);
  }

  void show() {
    for (int i = 0; i < pix.length; i++) {
      pix[i].show();
    }
  }
}

int black = #000000;
int blue = #00008b;
int green = #006400;
int cyan = #008b8b;
int red = #8B0000;
int magenta = #8b008b;
int brown = #888404;
int lightgray = #D3D3D3;
int darkgray = #63666A;
int lightblue = #0000FF;
int lightgreen = #39FF14;
int lightcyan = #00FFFF;
int lightred = #FF0000;
int lightmagenta = #FF00FF;
int yellow = #FFFF00;
int white = #FFFFFF;

String getHex(int value) {
  if (value == black) {
    return "0h";
  } else if (value == blue) {
    return "010h";
  } else if (value == green) {
    return "020h";
  } else if (value == cyan) {
    return "030h";
  } else if (value == red) {
    return "040h";
  } else if (value == magenta) {
    return "050h";
  } else if (value == brown) {
    return "060h";
  } else if (value == lightgray) {
    return "070h";
  } else if (value == darkgray) {
    return "080h";
  } else if (value == lightblue) {
    return "090h";
  } else if (value == lightgreen) {
    return "0a0h";
  } else if (value == lightcyan) {
    return "0b0h";
  } else if (value == lightred) {
    return "0c0h";
  } else if (value == lightmagenta) {
    return "0d0h";
  } else if (value == yellow) {
    return "0e0h";
  } else if (value == white) {
    return "0f0h";
  } else return "";
}
