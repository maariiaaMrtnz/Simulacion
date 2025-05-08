// === CLASE PARTICULA ===
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
    
    velocidad.y += 0.03; // gravedad
    velocidad.mult(0.985); // aire
    posicion.add(velocidad);
    return true;
  }
  
  void dibujar() {
    float alpha = map(vida, 0, vidaInicial, 0, 255);
    float expansion = map(vidaInicial - vida, 0, vidaInicial, 1, 1.8);
    fill(red(col), green(col), blue(col), alpha);
    noStroke();
    ellipse(posicion.x, posicion.y, tamano * expansion, tamano * expansion);
  }
}

// === CLASE PALMERA ===
class Palmera {
  ArrayList<Particula> particulas;
  boolean haExplotado;
  PVector posicion;
  PVector velocidad;

  Palmera(PVector origen) {
    particulas = new ArrayList<Particula>();
    posicion = origen.copy();
    velocidad = new PVector(0, -7); // subida rápida
    haExplotado = false;
  }

  void actualizar() {
    if (!haExplotado) {
      velocidad.y += 0.05; // gravedad
      posicion.add(velocidad);
      
      if (velocidad.y >= 0) {
        crearExplosionPalmera(posicion.copy());
        haExplotado = true;
      }
    } else {
      for (int i = particulas.size() - 1; i >= 0; i--) {
        if (!particulas.get(i).actualizar()) {
          particulas.remove(i);
        }
      }
    }
  }

  void dibujar() {
    if (!haExplotado) {
      fill(255, 200, 0);
      noStroke();
      ellipse(posicion.x, posicion.y, 6, 6);
    } else {
      for (Particula p : particulas) {
        p.dibujar();
      }
    }
  }

  void crearExplosionPalmera(PVector centro) {
    int ramas = 10;
    int particulasPorRama = 8;
    
    for (int r = 0; r < ramas; r++) {
      float angulo = map(r, 0, ramas, 0, TWO_PI);
      for (int i = 0; i < particulasPorRama; i++) {
        float offset = random(-0.1, 0.1); // turbulencia
        float velocidadMag = random(2, 5);
        PVector dir = PVector.fromAngle(angulo + offset);
        dir.mult(velocidadMag * map(i, 0, particulasPorRama, 1, 0.5)); // más lento en los extremos

        float vida = random(50, 100);
        float tam = random(2, 4);
        color c = color(255, 200 + random(-30, 30), random(100, 255));
        particulas.add(new Particula(centro, dir, vida, tam, c));
      }
    }
  }

  boolean estaMuerta() {
    return haExplotado && particulas.size() == 0;
  }
}

// === VARIABLES GLOBALES ===
ArrayList<Palmera> palmeras;

void setup() {
  size(800, 600);
  background(0);
  palmeras = new ArrayList<Palmera>();
}

void draw() {
  fill(0, 0, 0, 30); // fondo semi-transparente para dejar rastro
  rect(0, 0, width, height);

  for (int i = palmeras.size() - 1; i >= 0; i--) {
    Palmera p = palmeras.get(i);
    p.actualizar();
    p.dibujar();
    if (p.estaMuerta()) {
      palmeras.remove(i);
    }
  }
}

// === EXPLOSIÓN AL HACER CLIC ===
void mousePressed() {
  palmeras.add(new Palmera(new PVector(mouseX, height)));
}
