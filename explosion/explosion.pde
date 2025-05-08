// Clase para representar una partícula de la explosión
class Particula {
  PVector posicion;
  PVector velocidad;
  float vida;
  float vidaInicial;
  float tamano;
  color col;
  
  Particula(PVector pos, PVector vel, float vida, float tam, color c) {
    this.posicion = pos.copy();
    this.velocidad = vel.copy();
    this.vidaInicial = vida;
    this.vida = vida;
    this.tamano = tam;
    this.col = c;
  }
  
  boolean actualizar() {
    vida -= 1.0;
    if (vida <= 0) return false;
    
    // Física
    velocidad.y += 0.015; // gravedad
    velocidad.mult(0.985); // aire
    velocidad.x += random(-0.03, 0.03); // turbulencia
    velocidad.y += random(-0.03, 0.03);
    
    posicion.add(velocidad);
    return true;
  }
  
  void dibujar() {
    float alpha = map(vida, 0, vidaInicial, 0, 255);
    float expansion = map(vidaInicial - vida, 0, vidaInicial, 1, 2);
    fill(red(col), green(col), blue(col), alpha);
    noStroke();
    ellipse(posicion.x, posicion.y, tamano * expansion, tamano * expansion);
  }
}

// Clase para representar una explosión puntual
class Explosion {
  ArrayList<Particula> particulas;
  
  Explosion() {
    particulas = new ArrayList<Particula>();
  }
  
  void crearExplosion(PVector centro, int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      float angulo = random(TWO_PI);
      float velocidadMag = random(2, 6);
      PVector vel = PVector.fromAngle(angulo).mult(velocidadMag);
      
      float vida = random(40, 100);
      float tam = random(2, 5);
      color c = color(220 + random(-10, 10), 220 + random(-10, 10), 255, 180 + random(-30, 30));
      
      particulas.add(new Particula(centro, vel, vida, tam, c));
    }
  }
  
  void actualizar() {
    for (int i = particulas.size() - 1; i >= 0; i--) {
      if (!particulas.get(i).actualizar()) {
        particulas.remove(i);
      }
    }
  }
  
  void dibujar() {
    for (Particula p : particulas) {
      p.dibujar();
    }
  }
}

// --------------------- PROGRAMA PRINCIPAL ---------------------

Explosion explosion;

void setup() {
  size(800, 600);
  explosion = new Explosion();
  background(20); // fondo oscuro
}

void draw() {
  fill(20, 20, 20, 30); // fondo semi transparente
  noStroke();
  rect(0, 0, width, height);
  
  explosion.actualizar();
  explosion.dibujar();
}

void mousePressed() {
  explosion.crearExplosion(new PVector(mouseX, mouseY), 200);
}
