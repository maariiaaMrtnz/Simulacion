PVector paraca; 
PVector velocidad; 
float dt=0.0001; 

void setup() 
{
  size(600, 400);
  paraca = new PVector(100, 300);
  velocidad = new PVector (1,1); 
  
  textSize(24);
}
  
void draw(){  
  background (255); 
  
  strokeWeight(2); 
  noFill();
  
  dibujar_vector(paraca, velocidad);
  
  paraca = euler (paraca, velocidad); 
  velocidad = euler (velocidad, dv_dt(velocidad));

  text("posicion: " + paraca, 20, 30);
  text("V (euler): " + velocidad, 20, 60); 
}

PVector dv_dt(PVector v) 
{
  float m = 60; 
  float c = 80; 
  PVector g = new PVector(0, -9.8); 
  return PVector.sub(g, PVector.mult(v, c/m));
}
