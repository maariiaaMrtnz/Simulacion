// Variables 
float centroX, centroY; 
float r, t, T, dt, w; 

void setup() {
  size(400, 400); 
  
  centroX = width / 2; 
  centroY = height / 2; 
  r = 100; 
  t = 0; 
  T = 1.0; 
  dt = 0.007; 
  
  // w = 2π / T
  w = TWO_PI / T; 
}

void draw () {
  background(255);
  
  // Calcular la posición de la bola en movimiento circular
  float x = centroX + r * cos(w * t);
  float y = centroY + r * sin(w * t);
  
  // Dibujar la bola en movimiento
  fill(255, 0, 0);
  ellipse(x, y, 20, 20);
  
  // Dibujar la trayectoria circular
  noFill();
  stroke(0);
  ellipse(centroX, centroY, r * 2, r * 2);
  
  // Incrementar el tiempo
  t += dt;
}
