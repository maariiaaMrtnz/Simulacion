// Clase para representar una partícula de humo
class ParticulaHumo {
  PVector posicion;
  PVector velocidad;
  float vida;
  float vidaInicial;
  float tamano;
  
  ParticulaHumo(PVector pos, PVector vel, float vida, float tam) {
    this.posicion = pos.copy();
    this.velocidad = vel.copy();
    this.vidaInicial = vida;
    this.vida = vida;
    this.tamano = tam;
  }
  
  boolean actualizar() {
    vida -= 1.0;
    if (vida <= 0) return false;
    
    // Movimiento tipo humo
    velocidad.x += random(-0.02, 0.02); // turbulencia
    velocidad.y -= 0.01; // sube con el tiempo
    velocidad.mult(0.99); // resistencia
    
    posicion.add(velocidad);
    return true;
  }
  
  void dibujar() {
    float alpha = map(vida, 0, vidaInicial, 0, 100);
    float expansion = map(vidaInicial - vida, 0, vidaInicial, 1, 1.8);
    fill(180, alpha);
    noStroke();
    ellipse(posicion.x, posicion.y, tamano * expansion, tamano * expansion);
  }
}

// Clase para representar un sistema de humo
class GeneradorHumo {
  ArrayList<ParticulaHumo> particulas;
  
  GeneradorHumo() {
    particulas = new ArrayList<ParticulaHumo>();
  }
  
  void crearHumo(PVector centro, int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      float angulo = random(-PI / 6, PI / 6); // humo hacia arriba
      float velocidadMag = random(0.5, 2);
      PVector vel = PVector.fromAngle(angulo - HALF_PI).mult(velocidadMag); // apuntar arriba
      
      float vida = random(80, 150);
      float tam = random(8, 16);
      
      particulas.add(new ParticulaHumo(centro, vel, vida, tam));
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
    for (ParticulaHumo p : particulas) {
      p.dibujar();
    }
  }
}

// --------------------- PROGRAMA PRINCIPAL ---------------------

GeneradorHumo humo;

void setup() {
  size(800, 600);
  humo = new GeneradorHumo();
  background(20); // fondo oscuro
}

void draw() {
  fill(20, 20, 20, 25); // fondo con leve opacidad
  noStroke();
  rect(0, 0, width, height);
  
  humo.actualizar();
  humo.dibujar();
}

void mousePressed() {
  humo.crearHumo(new PVector(mouseX, mouseY), 30); // más o menos humo por clic
}
