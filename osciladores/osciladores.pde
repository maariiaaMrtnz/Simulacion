// Listas para almacenar las trayectorias
ArrayList<PVector> trayectoria1;
ArrayList<PVector> trayectoria2;

// Variables
float x;
float v, escala; 

void setup() {
  size(800, 400);
  x = 0;
  
  trayectoria1 = new ArrayList<PVector>();
  trayectoria2 = new ArrayList<PVector>();
  
  v = 2;
  escala = 50;
}

void draw() {
  background(255);
  stroke(0);
  
  // Dibujar línea de separación 
  line(0, height / 2, width, height / 2);
  
  // Calcular las posiciones de la partícula en cada función
  float y1 = height / 4 + escala * sin(x * 0.05) * exp(-0.002 * x);
  float y2 = 3 * height / 4 + escala * (0.5 * sin(3 * x * 0.05) + 0.5 * sin(3.5 * x * 0.05));

  // Guardar las posiciones en las listas
  trayectoria1.add(new PVector(x, y1));
  trayectoria2.add(new PVector(x, y2));

  // Dibujar las trayectorias
  noFill();
  stroke(255, 0, 0);
  beginShape();
  for (PVector p : trayectoria1) {
    vertex(p.x, p.y);
  }
  endShape();

  stroke(0, 0, 255);
  beginShape();
  for (PVector p : trayectoria2) {
    vertex(p.x, p.y);
  }
  endShape();

  // Dibujar la partícula en cada función
  fill(255, 0, 0);
  ellipse(x, y1, 10, 10); // Partícula en la primera función
  
  fill(0, 0, 255);
  ellipse(x, y2, 10, 10); // Partícula en la segunda función

  // Incrementar la posición en X con la velocidad
  x += v;

  // Reiniciar la animación cuando la partícula llega al final de la pantalla
  if (x > width) {
    x = 0;
    trayectoria1.clear();
    trayectoria2.clear();
  }
}
