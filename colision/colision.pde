class Particle {
  PVector position, velocity;
  float radius;
  float elasticity = 0.8; // Factor de rebote
  color particleColor;
  
  Particle(float x, float y, float vx, float vy, float r, color c) {
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    radius = r;
    particleColor = c;
  }
  
  void update(PVector gravity) {
    velocity.add(gravity); // Aplica la gravedad
    position.add(velocity);
    checkDiagonalColorChange();
  }
  
  void checkCollisionLinea(PVector a, PVector b) {
    PVector ap = PVector.sub(position, a);
    PVector ab = PVector.sub(b, a);
    float t = PVector.dot(ap, ab) / PVector.dot(ab, ab);
    t = constrain(t, 0, 1);
    PVector closest = PVector.add(a, PVector.mult(ab, t));
    float distance = PVector.dist(position, closest);
    
    if (distance < radius) {
      PVector normal = PVector.sub(position, closest).normalize();
      float nv = PVector.dot(normal, velocity);
      PVector Vn = PVector.mult(normal, nv);
      PVector Vt = PVector.sub(velocity, Vn);
      velocity = PVector.sub(Vt, PVector.mult(Vn, elasticity));
      position.add(PVector.mult(normal, radius - distance));
    }
  }
  
  void checkCollisionParticles(ArrayList<Particle> particles) {
    for (Particle other : particles) {
      if (other == this) continue;
      float d = PVector.dist(position, other.position);
      if (d < radius * 2) {
        PVector normal = PVector.sub(position, other.position).normalize();
        PVector relativeVelocity = PVector.sub(velocity, other.velocity);
        float nv = PVector.dot(normal, relativeVelocity);
        if (nv < 0) {
          PVector impulse = PVector.mult(normal, -nv * (1 + elasticity));
          velocity.add(impulse);
          other.velocity.sub(impulse);
        }
      }
    }
  }
  
  void checkDiagonalColorChange() {
    float m = (caja.b.y - caja.a.y) / (caja.b.x - caja.a.x);
    float yCajaDiagonal = caja.a.y + m * (position.x - caja.a.x);
    float screenDiagonalY = (height / width) * position.x;
    if (position.y < yCajaDiagonal || position.y < screenDiagonalY) {
      particleColor = color(0, 0, 255); 
    } else {
      particleColor = color(255, 0, 0);
    }
  }
  
  void display() {
    fill(particleColor);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}

class Caja {
  PVector a, b;
  
  Caja(PVector _a, PVector _b) {
    a = _a.copy();
    b = _b.copy();
  }
  
  Boolean inside(PVector x) {
    return (x.x >= a.x && x.x <= b.x) && (x.y >= a.y && x.y <= b.y);
  }
  
  void display() {
    stroke(0);
    noFill();
    rect(a.x, a.y, b.x - a.x, b.y - a.y);
    stroke(255, 0, 0);
    line(a.x, a.y, b.x, b.y);
  }
}

ArrayList<Particle> particles;
Caja caja;
boolean gravityActive = true; // Variable para activar o desactivar la gravedad
PVector gravity;

void setup() {
  size(600, 400);
  caja = new Caja(new PVector(200, 100), new PVector(400, 300));
  particles = new ArrayList<Particle>();
  gravity = new PVector(0, 0.1); // Gravedad hacia abajo (puedes modificar la fuerza)
}

void draw() {
  background(200);
  caja.display();
  
  // Mostrar número de partículas, el frame rate y si la gravedad está activada
  fill(0);
  textSize(16);
  text("Partículas: " + particles.size(), 10, height - 60);
  text("Frame Rate: " + int(frameRate), 10, height - 40);
  text("Gravedad activa: " + (gravityActive ? "Sí" : "No"), 10, height - 20);
  
  for (Particle p : particles) {
    p.update(gravityActive ? gravity : new PVector(0, 0)); // Aplica gravedad si está activada
    p.checkCollisionLinea(caja.a, caja.b);
    p.checkCollisionParticles(particles);
    p.display();
  }
}

void mousePressed() {
  PVector click = new PVector(mouseX, mouseY);
  float m = (caja.b.y - caja.a.y) / (caja.b.x - caja.a.x);
  float yLinea = caja.a.y + m * (click.x - caja.a.x);
  color c = (click.y < yLinea) ? color(0, 0, 255) : color(255, 0, 0);
  
  if (caja.inside(click)) {
    particles.add(new Particle(mouseX, mouseY, random(-2, 2), random(-2, 2), 10, c));
  } else {
    particles.add(new Particle(mouseX, mouseY, random(-2, 2), random(-2, 2), 10, c));
  }
}

void keyPressed() {
  // Cambiar el estado de la gravedad al presionar la tecla 'G'
  if (key == 'G' || key == 'g') {
    gravityActive = !gravityActive;
  }
}
