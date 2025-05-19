// Use PeasyCam for 3D rendering //<>//
import peasy.*;

// Camera:
PeasyCam _camera;

// Simulation and time control:
int _lastTimeDraw = 0;
float _deltaTimeDraw = 0.0;
float _simTime = 0.0;
float _elapsedTime = 0.0;
float _timeStep;

// Height map for waves
HeightMap map;

ArrayList<Sphere> spheres = new ArrayList<Sphere>();
float sphereRadius = 20;
boolean moveSpheresWithWaves = true;

// Main code:
void settings() {
  if (FULL_SCREEN) 
  {
    fullScreen(P3D);
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else 
  {
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
  }
}

void setup() 
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  
  float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);  
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  _camera = new PeasyCam(this, 0);
  _camera.setDistance(CAMERA_DIST); 

  // Cargar imagen
  img = loadImage("textura.jpg");
  
  // Crear Mapa de Alturas
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  
  initSimulation();
}

void stop() {
   endSimulation();
}

void keyPressed() {
  float dx = random(2f) - 1;
  float dz = random(2f) - 1;

  // INICIAR SIMULACIÓN
  if (key == 'I' || key == 'i') {
    initSimulation();
  }
  // TEXTURA
  if (key == 'T' || key == 't') {
    _viewmode = !_viewmode;
  }
  // RESETEAR
  if (key == 'R' || key == 'r') {
    _clear = true;
  }
  // ONDA DIRECCIONAL
  if (key == '1') {
    map.addWave(new WaveDirectional(amplitude, new PVector(dx, 0, dz), wavelength, speed));
  }
  // ONDA RADIAL
  if (key == '2') {
    map.addWave(new WaveRadial(amplitude, new PVector(dx * (_MAP_SIZE * _MAP_CELL_SIZE/2f), 0, dz * (_MAP_SIZE * _MAP_CELL_SIZE/2f)), wavelength, speed));
  }
  // ONDA GERSTNER
  if (key == '3') {
    map.addWave(new WaveGerstner(amplitude, new PVector(dx, 0, dz), wavelength, speed));
  }
  // AÑADIR ESFERA
  if (key == 'B' || key == 'b') {
  // Añadir esfera en una posición aleatoria pero dentro de los límites
  float safeZone = _MAP_SIZE * _MAP_CELL_SIZE * 0.4f; // 40% del tamaño del mapa
  float x = random(-safeZone, safeZone);
  float z = random(-safeZone, safeZone);
  spheres.add(new Sphere(x, z, sphereRadius));
}
  // TOGGLE MOVIMIENTO DE ESFERAS
  if (key == 'X' || key == 'x') {
    moveSpheresWithWaves = !moveSpheresWithWaves;
    for (Sphere s : spheres) {
      s.moveWithWaves = moveSpheresWithWaves;
    }
  }

  // --- NUEVAS TECLAS PARA MODIFICAR PARÁMETROS ---
  // AUMENTAR/DISMINUIR AMPLITUD (Teclas UP/DOWN)
  if (keyCode == UP) {
    amplitude += 5f;
  }
  if (keyCode == DOWN) {
    amplitude = max(0.1f, amplitude - 5f);
  }
  // AUMENTAR/DISMINUIR LONGITUD DE ONDA (Teclas 'P'/'O')
  if (key == 'P' || key == 'p') {
    wavelength += 10f;
  }
  if (key == 'O' || key == 'o') {
    wavelength = max(5f, wavelength - 10f);
  }
  // AUMENTAR/DISMINUIR VELOCIDAD (Teclas 'V'/'C')
  if (key == 'V' || key == 'v') {
    speed += 5f;
  }
  if (key == 'C' || key == 'c') {
    speed = max(0.1f, speed - 5f);
  }
  if (key == 'N' || key == 'n') {
    spheres.clear();
  }
}

void initSimulation() 
{
  _simTime = 0.0;
  _elapsedTime = 0.0;
  _timeStep = TS*TIME_ACCEL;
   
}

void updateSimulation() 
{
  _simTime += _timeStep;
  map.update();
}

void endSimulation() 
{
}

void printInfo() {
  pushMatrix();
  {
    camera();
    fill(0);
    textSize(20);
    
    text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.05);
    text("Elapsed time = " + _elapsedTime + " s", width*0.025, height*0.075);
    text("Simulated time = " + _simTime + " s ", width*0.025, height*0.1);
    text("Presiona 'T' para poner/quitar la textura", width*0.025, height*0.125);
    text("Presiona '1' para generar una onda DIRECCIONAL", width*0.025, height*0.145);
    text("Presiona '2' para generar una onda RADIAL", width*0.025, height*0.165);
    text("Presiona '3' para generar una onda GERSTNER", width*0.025, height*0.185);
    text("Presiona 'B' para añadir una esfera", width*0.025, height*0.205);
    text("Presiona 'X' para quitar movimiento en X e Y de las esferas", width*0.025, height*0.225);
    text("Presiona 'N' para eliminar TODAS las esferas", width*0.025, height*0.245);
    text("Tecla UP/DOWN: Aumentar/Disminuir amplitud", width*0.025, height*0.265);
    text("Tecla 'O'/'P': Aumentar/Disminuir longitud de onda", width*0.025, height*0.285);
    text("Tecla 'V'/'C': Aumentar/Disminuir velocidad", width*0.025, height*0.305);
    text("Amplitud actual: " + amplitude, width*0.025, height*0.325);
    text("Longitud de onda actual: " + wavelength, width*0.025, height*0.345);
    text("Velocidad actual: " + speed, width*0.025, height*0.365);
  }
  popMatrix();
}

void drawStaticEnvironment() 
{
  strokeWeight(1);
  
  fill(255, 0, 0);
  box(200.0, 0.25, 0.25);
  
  fill(0, 255, 0);
  box(0.25, 200.0, 0.25);
  
  fill(0, 0, 255);
  box(0.25, 0.25, 200.0);
}

void drawDynamicEnvironment() 
{
  pushMatrix();
  translate(0, 20, 0);
  map.run();
  popMatrix(); 
}

void updateAndDisplaySpheres() {
  // Actualizar física primero
  for (Sphere s : spheres) {
    s.update(map);
  }
  
  // Luego verificar colisiones entre esferas
  for (Sphere s : spheres) {
    s.checkCollision(spheres);
  }
  
  // Finalmente dibujar
  for (Sphere s : spheres) {
    s.display();
  }
}

void draw() 
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;
  
  //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");
  
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  drawStaticEnvironment();
  drawDynamicEnvironment();
  updateAndDisplaySpheres();
  if (REAL_TIME) 
  {
    float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/_timeStep;
    int iterations = 0; 

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0)) 
    {
      updateSimulation();
      iterations++;
    }
    
    //println("Expected Simulated Time: " + expectedSimulatedTime);
    //println("Expected Iterations: " + expectedIterations);
    //println("Iterations: " + iterations);
  } 
  else 
  {
    updateSimulation();
  }
  
  //ELIMINAR ONDAS
  if(_clear)
  {
    map.waves.clear();
    map.waveArray = new Wave[0];
    amplitude = random (2f) + 8f;
    wavelength = amplitude* (30 + random(2f));
    speed = wavelength/(1+random(3f));
    _clear = false;
  }

  printInfo();
}
