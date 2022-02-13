int iteration = 7;
float[] xConsts = {7, 1, -1, 4};
float[] yConsts = {21, 4, 1, 8};
float[] zConsts = {15, 2, -1, 5};
float[] initialGuess = {3, 3, 3};
float[] x = new float[iteration + 1];
float[] y = new float[iteration + 1];
float[] z = new float[iteration + 1];

void setup() {
  x = new float[iteration + 1];
  y = new float[iteration + 1];
  z = new float[iteration + 1];
  x[0] = initialGuess[0];
  y[0] = initialGuess[1];
  z[0] = initialGuess[2];
  jacobi(1);
  //for (int i = 1; i <= iteration; i++) {
  //  println("x=7+(" + nf(y[i - 1], 0, 5) + ")-(" + nf(z[i - 1], 0, 5) + ")=" + nf(x[i], 0, 5));
  //  println("y=21+4(" + nf(x[i - 1], 0, 5) + ")+(" + nf(z[i - 1], 0, 5) + ")=" + nf(y[i], 0, 5));
  //  println("z=15+2(" + nf(x[i - 1], 0, 5) + ")-(" + nf(y[i - 1], 0, 5) + ")=" + nf(z[i], 0, 5));
  //}
  x = new float[iteration + 1];
  y = new float[iteration + 1];
  z = new float[iteration + 1];
  x[0] = initialGuess[0];
  y[0] = initialGuess[1];
  z[0] = initialGuess[2];
  gauss_seidel(1);
  for (int i = 1; i <= iteration; i++) {
    println("x=7+(" + nf(y[i - 1], 0, 5) + ")-(" + nf(z[i - 1], 0, 5) + ")=" + nf(x[i], 0, 5));
    println("y=21+4(" + nf(x[i], 0, 5) + ")+(" + nf(z[i - 1], 0, 5) + ")=" + nf(y[i], 0, 5));
    println("z=15+2(" + nf(x[i], 0, 5) + ")-(" + nf(y[i], 0, 5) + ")=" + nf(z[i], 0, 5));
  }
}

void jacobi(int index) {
  if (index <= iteration) {
    x[index] = float(nf((xConsts[0] + (xConsts[1] * y[index - 1]) + (xConsts[2] * z[index - 1])) / xConsts[3], 0, 5));
    y[index] = float(nf((yConsts[0] + (yConsts[1] * x[index - 1]) + (yConsts[2] * z[index - 1])) / yConsts[3], 0, 5));
    z[index] = float(nf((zConsts[0] + (zConsts[1] * x[index - 1]) + (zConsts[2] * y[index - 1])) / zConsts[3], 0, 5));
    jacobi(index + 1);
  }
}

void gauss_seidel(int index) {
  if (index <= iteration) {
    x[index] = float(nf((xConsts[0] + (xConsts[1] * y[index - 1]) + (xConsts[2] * z[index - 1])) / xConsts[3], 0, 5));
    y[index] = float(nf((yConsts[0] + (yConsts[1] * x[index]) + (yConsts[2] * z[index - 1])) / yConsts[3], 0, 5));
    z[index] = float(nf((zConsts[0] + (zConsts[1] * x[index]) + (zConsts[2] * y[index])) / zConsts[3], 0, 5));
    gauss_seidel(index + 1);
  }
}
