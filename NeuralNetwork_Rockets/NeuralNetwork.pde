class NeuralNetwork {
  PVector[] weights = new PVector[3];

  NeuralNetwork() {
    for (int i = 0; i < weights.length; i++) {
      weights[i] = PVector.random2D();
    }
  }

  NeuralNetwork(PVector[] weights) {
    this.weights = weights;
  }

  void mutate() {
    for (int i = 0; i < weights.length; i++) {
      if (mutRate > random(100)) {
        weights[i] = PVector.random2D();
      }
    }
  }

  float guessX(float[] input) {
    float sum = 0;
    for (int i = 0; i < weights.length; i++) {
      sum += input[i] * weights[i].x;
    }
    sum /= width;
    return sum;
  }

  float guessY(float[] input) {
    float sum = 0;
    for (int i = 0; i < weights.length; i++) {
      sum += input[i] * weights[i].y;
    }
    sum /= height;
    return sum;
  }
}
