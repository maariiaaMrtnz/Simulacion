int posx, posy; // Posición del lanzador 
float angulo; // Angulo lanzamiento 
float bolax, bolay; // Posicion de la bola disparada 
boolean activo; // Bola disparada o no 
float vel; // Velocidad de la bola
float dirBX, dirBY; // Direccion de la bola 

void setup() 
{
  size(800, 600); 
  posx = width / 2; 
  posy = height - 50; 
  angulo = 0; 
  bolax = 0; 
  bolay = 0; 
  activo = false; 
  vel = 5; 
  dirBX = 0;
  dirBY = 0; 
}

void draw ()
{
  background(255); 
  
  fill (0); 
  rect (posx - 10, posy, 20, 20); 
  
  if (activo) 
  {
    ellipse (bolax, bolay, 20, 20); 
    bolax += dirBX * vel; 
    bolay += dirBY * vel; 
    
    if (bolax < 0 || bolax > width || bolay < 0 || bolay > height) 
      activo = false; 
  }
  
  line (posx, posy, posx + cos(angulo) * 50, posy +sin(angulo) * 50); 
}

void keyPressed ()
{
  if (key == ' ' && !activo) 
  {
    activo = true; 
    bolax = posx; 
    bolay = posy; 
    
    dirBX = cos(angulo); 
    dirBY = sin(angulo); 
  }
}

void mouseMoved ()
{
  float dx = mouseX - posx; 
  float dy = mouseY - posy; 
  angulo = atan2(dy, dx); 
}
