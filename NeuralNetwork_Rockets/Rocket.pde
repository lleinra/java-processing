class Rocket {
  PVector pos;
  PVector vel;
  PVector acc;
  float fitness = 0;
  Boolean crashed = false;
  Boolean done = false;
  NeuralNetwork brain;
  float w = 30;
  float h = 15;

  Rocket() {
    pos = new PVector(width / 2, height / 2);
    vel = PVector.random2D();
    acc = new PVector(0, 0);
    brain = new NeuralNetwork();
  }

  Rocket(NeuralNetwork brain) {
    pos = new PVector(width / 2, height / 2);
    vel = PVector.random2D();
    acc = new PVector(0, 0);
    this.brain = brain;
  }

  void applyForce(PVector force) {
    force.mult(0.1);
    acc.add(force);
  }

  void calcFitness() {
    if (this.crashed) {
      fitness = 1;
    } else if (this.done) {
      fitness = 100;
    } else {
      fitness = this.pos.dist(target.pos);
      fitness = map(fitness, max, 0, 0, 100);
    }
    fitness = sq(fitness);
  }

  void update() {
    if (!crashed && !done) {
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
    }
    if (this.pos.x - h <= 0 || this.pos.x + h >= width ||
      this.pos.y - h <= 0 || this.pos.y + h >= height) {
      crashed = true;
    }
    if (this.pos.x - h < target.pos.x + target.r / 2 &&
      this.pos.x + h > target.pos.x - target.r / 2 &&
      this.pos.y - h / 2 < target.pos.y + target.r / 2&&
      this.pos.y + h / 2 > target.pos.y - target.r / 2) {
      done = true;
    }
  }

  void show() {
    push();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    rotate(vel.heading());
    stroke(255);
    if (crashed) {
      fill(255, 0, 0);
    } else if (done) {
      fill(0, 255, 0);
    } else {
      fill(0);
    }
    rect(0, 0, w, h);
    pop();
  }
}
