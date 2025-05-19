int cols = 20;
int rows = 20;
float spacing = 15;

Cloth cloth1, cloth2, cloth3;
PVector gravity = new PVector(0, 0.15, 0);

void setup() {
  size(1200, 1200, P3D);

  // Malla 1: 1 punto fijo (esquina superior izquierda)
  cloth1 = new Cloth(cols, rows, spacing, new PVector(-350, -100, 0));
  cloth1.lockPoints(new int[][] { {0,0} });

  // Malla 2: 2 puntos fijos (esquinas superiores izquierda y derecha)
  cloth2 = new Cloth(cols, rows, spacing, new PVector(0, -100, 0));
  cloth2.lockPoints(new int[][] { {0,0}, {cols-1, 0} });

  // Malla 3: 4 puntos fijos (las cuatro esquinas)
  cloth3 = new Cloth(cols, rows, spacing, new PVector(350, -100, 0));
  cloth3.lockPoints(new int[][] { 
    {0, 0},           // esquina superior izquierda
    {cols-1, 0},      // esquina superior derecha
    {0, rows-1},      // esquina inferior izquierda
    {cols-1, rows-1}  // esquina inferior derecha
  });
}

void draw() {
  background(40);
  lights();
  translate(width/2, height/2, -300);

  for (int i = 0; i < 5; i++) {
    cloth1.simulate(gravity);
    cloth2.simulate(gravity);
    cloth3.simulate(gravity);
  }

  cloth1.display();
  cloth2.display();
  cloth3.display();
}

// ======= CLASES =======

class Cloth {
  Particle[][] particles;
  int cols, rows;
  float spacing;
  PVector origin;

  Cloth(int c, int r, float s, PVector o) {
    cols = c;
    rows = r;
    spacing = s;
    origin = o.copy();

    particles = new Particle[cols][rows];
    for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        PVector pos = new PVector(x * spacing, y * spacing, 0);
        pos.add(origin);
        particles[x][y] = new Particle(pos);
      }
    }
  }

  void lockPoints(int[][] points) {
    for (int i=0; i<points.length; i++) {
      int x = points[i][0];
      int y = points[i][1];
      particles[x][y].locked = true;
    }
  }

  void simulate(PVector gravity) {
    for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        particles[x][y].applyForce(gravity);
        particles[x][y].update();
      }
    }

    for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        if (x < cols-1) satisfyConstraint(particles[x][y], particles[x+1][y], spacing);
        if (y < rows-1) satisfyConstraint(particles[x][y], particles[x][y+1], spacing);
      }
    }
  }

  void satisfyConstraint(Particle a, Particle b, float restLength) {
    PVector delta = PVector.sub(b.pos, a.pos);
    float dist = delta.mag();
    float diff = (dist - restLength) / dist;

    if (!a.locked) a.pos.add(delta.copy().mult(0.5 * diff));
    if (!b.locked) b.pos.sub(delta.copy().mult(0.5 * diff));
  }

  void display() {
    stroke(255);
    noFill();
    for (int x=0; x<cols-1; x++) {
      for (int y=0; y<rows-1; y++) {
        beginShape();
        vertex(particles[x][y].pos.x, particles[x][y].pos.y, particles[x][y].pos.z);
        vertex(particles[x+1][y].pos.x, particles[x+1][y].pos.y, particles[x+1][y].pos.z);
        vertex(particles[x+1][y+1].pos.x, particles[x+1][y+1].pos.y, particles[x+1][y+1].pos.z);
        vertex(particles[x][y+1].pos.x, particles[x][y+1].pos.y, particles[x][y+1].pos.z);
        endShape(CLOSE);
      }
    }
  }
}

class Particle {
  PVector pos, prev;
  boolean locked = false;
  float damping = 0.98;

  Particle(PVector p) {
    pos = p.copy();
    prev = p.copy();
  }

  void applyForce(PVector force) {
    if (locked) return;
    pos.add(force);
  }

  void update() {
    if (locked) return;
    PVector velocity = PVector.sub(pos, prev);
    velocity.mult(damping);
    PVector temp = pos.copy();
    pos.add(velocity);
    prev.set(temp);
  }
}
