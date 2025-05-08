// Variables globales
PVector particula; 
PVector [] carretera;
PVector [] velocidad; 
PVector [] aceleracion; 

int radio, n_tramos, tramo;
float dt, v_ini, a; 


// tenemos dos opciones para mover la partícula. la primera es definir el punto P2 y la segunda opción es definir el vector carretera que va a ser el vector c. este vector c lo definimos con su modulo y su argumento (1, -1)  

void setup() 
{
  size(640, 640);
  
  // Inicializar las variables globales 
  radio = 20; 
  n_tramos = 5;
  
  particula = new PVector(radio, height/2); 
  
  carretera = new PVector [n_tramos];
  velocidad = new PVector[n_tramos - 1];
  aceleracion = new PVector[n_tramos - 1];
  
  // Establecemos el primer punto para la partícula
  carretera[0] = new PVector(particula.x, particula.y);
  carretera[1] = new PVector(particula.x + 100, particula.y +100);
  carretera[2] = new PVector(particula.x + 200, particula.y -100);
  carretera[3] = new PVector(particula.x + 300, particula.y +100);
  carretera[4] = new PVector(particula.x + 400, particula.y -100);
  
    
  //for (int i = 1; i < n_tramos; i++) 
    //carretera[i] = new PVector(width/2, radio);
    
  for (int i= 0; i < n_tramos; i++) 
  {
    if (i+1 < n_tramos)
    {
      PVector c = PVector.sub(carretera[i+1], carretera[i]);
      // la velocidad es enla dir del tramo y modulo 50 
      c.normalize();
      
      // Calculamos la pendiente de la curva 
      float pendiente = carretera [i+1].y - carretera [i].y; 
      float factor = 0; 
      
      if (pendiente > 0)
        factor = 1; 
      else if (pendiente < 0) 
        factor = 0.5; 
      
      // Velocidad inicial en la dirección del tramo
      velocidad [i] = c.mult (50 * factor); 
      
      // Definir aceleración en el tramo (aumenta gradualmente la velocidad)
      aceleracion [i] = c.mult (10 * factor); 
      println("velocidad tramo: " + str(i) , velocidad[i]); 
    } 
  }
  
  tramo = 0; 
  dt = 0.1; 
}

void draw() 
{
  background(255); // borra frame anterior y pone el color que se quiera. se pone con un solo numero para escala de grises. 
  
  //stroke(100); // para el color de los bordes
  
  fill(10);
  
  for (int i = 0; i < n_tramos; i++) 
  {
    ellipse(carretera[i].x, carretera[i].y, radio, radio);
    if (i+1 < n_tramos)
      line(carretera[i].x, carretera[i].y, carretera[i+1].x, carretera[i+1].y);
  }
  
  fill(255, 0, 0); // color d la elipse
  
  if (tramo < n_tramos - 1) 
    {
      // Actualizar velocidad con aceleración: v = u + a * dt
      velocidad[tramo].add(PVector.mult(aceleracion[tramo], dt)); 
      
      // Actualizar posición: x = x + v * dt
      particula.add(PVector.mult(velocidad[tramo], dt));
      
      ellipse(particula.x, particula.y, 20, 20);
      
      // Si la partícula alcanza el siguiente punto, pasa al siguiente tramo
      if (particula.dist(carretera[tramo+1]) < radio / 2) 
      {
        particula.set(carretera[tramo+1]); 
        tramo++;
      }
    }
    else 
    {
      setup();
    }
}
