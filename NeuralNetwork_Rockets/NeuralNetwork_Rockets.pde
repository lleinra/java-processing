Rocket[] rockets = new Rocket[100];
Target target;
Obstacle obstacle;
PVector move = new PVector();
int generation = 0;
int lifetime = 500;
int life = lifetime;
float max = 0;
Rocket bestRocket;
Rocket[] nextGen;
float bestFitness;
float mutRate = 10;
ArrayList<Rocket> matingPool = new ArrayList<Rocket>();

void setup() {
  size(500, 500);
  PVector origin = new PVector(0, 0);
  PVector end = new PVector(width, height);
  max = origin.dist(end);
  nextGen = new Rocket[rockets.length];
  for (int i = 0; i < rockets.length; i++) {
    rockets[i] = new Rocket();
    nextGen[i] = new Rocket();
  }
  bestRocket = new Rocket();
  target = new Target();
}

void draw() {
  background(100);
  for (int i = 0; i < rockets.length; i++) {
    Rocket rocket = rockets[i];
    float[] inputX = {rocket.pos.x, rocket.vel.x, target.pos.x};
    float[] inputY = {rocket.pos.y, rocket.vel.y, target.pos.y};
    float guessX = rocket.brain.guessX(inputX);
    float guessY = rocket.brain.guessY(inputY);
    move.set(guessX, guessY);
    rocket.applyForce(move);
    rocket.update();
    rocket.show();
  }
  life -= 1;
  if (life <= 0 || rocketsGone()) {
    matingPool.clear();
    bestFitness = 0;
    for (int i = 0; i < rockets.length; i++) {
      rockets[i].calcFitness();
      if (rockets[i].fitness >= bestFitness) {
        bestFitness = rockets[i].fitness;
        bestRocket = rockets[i];
      }
      for (int j = 0; j < rockets[i].fitness; j++) {
        matingPool.add(rockets[i]);
      }
    }
    for (int i = 0; i < rockets.length; i++) {
      NeuralNetwork brain = matingPool.get((int) random(matingPool.size())).brain;
      brain.mutate();
      nextGen[i] = new Rocket(brain);
    }
    rockets = nextGen;
    target = new Target();
    life = lifetime;
  }
  target.show();
}

Boolean rocketsGone() {
  int sum = 0;
  for (int i = 0; i < rockets.length; i++) {
    if (rockets[i].crashed || rockets[i].done) {
      sum += 1;
    }
  }
  return sum == rockets.length;
}
