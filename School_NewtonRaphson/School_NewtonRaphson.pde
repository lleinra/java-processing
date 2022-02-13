float[] x = new float[10];

void setup() {
  x[0] = 5;
  for (int i = 1; i < x.length; i++) {
    x[i] = x[i - 1] - ((function(x[i - 1])) / (inverse(x[i - 1])));
  }
  for (int i = 1; i < x.length; i++) {
    println(x[i]);
  }
}

float function(float x) {
  return sq(x) + 8 * x + 15;
}

float inverse(float x) {
  return 2 * x + 8;
}
