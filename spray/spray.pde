ArrayList<Particle> particles;

void setup() {
  size(600, 400);
  particles = new ArrayList<Particle>();
}

void draw() {
  background(0);
  // Emitir nuevas partículas en forma de spray
  for (int i = 0; i < 5; i++) {
    particles.add(new Particle(width/2, height/2));
  }
  
  // Actualizar y mostrar
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.show();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}

class Particle {
  PVector pos;
  PVector vel;
  float lifespan;
  
  Particle(float x, float y) {
    pos = new PVector(x, y);
    
    // Ángulo aleatorio tipo spray (cono)
    float angle = random(-PI/6, PI/6); 
    float speed = random(2, 5);
    vel = new PVector(cos(angle), sin(angle));
    vel.mult(speed);
    
    lifespan = 255;
  }
  
  void update() {
    pos.add(vel);
    lifespan -= 3;
  }
  
  void show() {
    noStroke();
    fill(255, lifespan);
    ellipse(pos.x, pos.y, 8, 8);
  }
  
  boolean isDead() {
    return lifespan < 0;
  }
}
