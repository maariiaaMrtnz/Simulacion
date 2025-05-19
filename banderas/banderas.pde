// Parámetros de la malla
int cols = 25, rows = 18;
float spacing = 10;

// Estados de fuerza
boolean useGravity = false;
boolean useWind = true;
PVector wind = new PVector(0.12, 0);

// Las 3 banderas
Cloth clothStructured, clothBend, clothShear;

void setup() {
  size(1100, 400);
  textFont(createFont("Arial", 12));
  
  // Crear banderas 
  clothStructured = new Cloth(80, 100, "structured", 400, 3);
  clothBend = new Cloth(420, 100, "bend", 150, 2);
  clothShear = new Cloth(740, 100, "shear", 300, 2);
}

void draw() {
  background(230, 240, 250);

  // Etiquetas arriba
  fill(0, 60, 130);
  textSize(12);
  text("INSTRUCCIONES:", 160, 30);
  text("Pulse la tecla 'v' para activar/desactivar el viento", 160, 45);
  text("Pulse la tecla 'g' para activar/desactivar la gravedad", 160, 60);

  text("FUERZAS EXTERNAS:", 750, 30);
  text("Viento " + (useWind ? "activado" : "desactivado"), 750, 45);
  text("Gravedad " + (useGravity ? "activada" : "desactivada"), 750, 60);
  
  // Actualizar y mostrar las banderas
  clothStructured.update();
  clothStructured.display();

  clothBend.update();
  clothBend.display();

  clothShear.update();
  clothShear.display();

  // Etiquetas debajo
  fill(0);
  textAlign(CENTER);
  text("Malla de tipo STRUCTURED\nConstante elástica 400.0\nDamping: 3.0", 200, height - 30);
  text("Malla de tipo BEND\nConstante elástica 150.0\nDamping: 2.0", 530, height - 30);
  text("Malla de tipo SHEAR\nConstante elástica 300.0\nDamping: 2.0", 850, height - 30);
}

void keyPressed() {
  if (key == 'g') useGravity = !useGravity;
  if (key == 'v') useWind = !useWind;
}

// ================= PARTICULA =================
class Particle {
  PVector pos, prev, acc; // posicion actual, previa y aceleracion acumulada
  boolean locked = false; // si la partícula está fija

  Particle(float x, float y) {
    pos = new PVector(x, y);
    prev = pos.copy();
    acc = new PVector();
  }

  // Sumar solo una fuerza
  void applyForce(PVector f) {
    acc.add(f);
  }

  // Simular movimiento
  void update(float damping) {
    if (locked) return;
    PVector vel = PVector.sub(pos, prev).mult(1.0 - damping * 0.01);
    prev = pos.copy();
    pos.add(vel);
    pos.add(acc);
    acc.set(0, 0);
  }

  void lock() {
    locked = true;
  }

  void display() {
    stroke(0);
    point(pos.x, pos.y);
  }
}

// ================= MUELLE =================
class Spring {
  Particle a, b;
  float restLength;
  float k;

  // Conecta dos partículas 
  Spring(Particle a, Particle b, float k) {
    this.a = a;
    this.b = b;
    this.k = k;
    restLength = PVector.dist(a.pos, b.pos);
  }

  // Aplicar la ley de Hooke
  void apply() {
    PVector delta = PVector.sub(a.pos, b.pos);
    float d = delta.mag();
    float diff = d - restLength;
    if (d != 0) {
      PVector force = delta.normalize().mult(-k * diff * 0.001);
      if (!a.locked) a.applyForce(force);
      if (!b.locked) b.applyForce(force.mult(-1));
    }
  }

  void display() {
    stroke(50);
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
  }
}

// ================= BANDERA =================
class Cloth {
  Particle[][] particles;
  ArrayList<Spring> springs = new ArrayList<Spring>();
  float offsetX, offsetY;
  String type;
  float k, damping;

  Cloth(float x, float y, String type, float k, float damping) {
    this.offsetX = x;
    this.offsetY = y;
    this.type = type;
    this.k = k;
    this.damping = damping;

    particles = new Particle[cols][rows];

    // Crear partículas
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        particles[i][j] = new Particle(offsetX + i * spacing, offsetY + j * spacing);
        if (i == 0) {
          particles[i][j].lock();  // Toda la primera columna está fija
        }
      }
    }

    // Conectar muelles
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Structured
        if (i < cols - 1)
          springs.add(new Spring(particles[i][j], particles[i+1][j], k));
        if (j < rows - 1)
          springs.add(new Spring(particles[i][j], particles[i][j+1], k));
        
        // Shear
        if (type.equals("shear")) {
          if (i < cols - 1 && j < rows - 1) {
            springs.add(new Spring(particles[i][j], particles[i+1][j+1], k));
            springs.add(new Spring(particles[i+1][j], particles[i][j+1], k));
          }
        }

        // Bend
        if (type.equals("bend")) {
          if (i < cols - 2)
            springs.add(new Spring(particles[i][j], particles[i+2][j], k));
          if (j < rows - 2)
            springs.add(new Spring(particles[i][j], particles[i][j+2], k));
        }
      }
    }
  }

  // Aplicar las fuerzas externas de gravedad y/o de viento
  void update() {
    for (Spring s : springs)
      s.apply();

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Particle p = particles[i][j];
        if (useGravity) p.applyForce(new PVector(0, 0.4));
        if (useWind) {
          PVector normal = new PVector(0, 0, 1);  // Aproximación
          float dot = wind.dot(normal);
          PVector windForce = wind.copy().mult(dot + 0.5);
          p.applyForce(windForce);
        }
        p.update(damping);
      }
    }
  }

  void display() {
    for (Spring s : springs)
      s.display();
  }
}
