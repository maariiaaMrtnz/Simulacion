final int cols = 20;
final int rows = 20;
final float spacing = 20;
Nodo[][] malla;
PVector esferaPos;
float esferaRadio = 80;

void setup() {
  size(800, 600, P3D);
  malla = new Nodo[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * spacing - cols * spacing / 2;
      float y = j * spacing;
      float z = 0;
      malla[i][j] = new Nodo(new PVector(x + width / 2, y, z));
      if (j == 0) malla[i][j].fijo = true;  // fila superior fija
    }
  }
  esferaPos = new PVector(width/2, height/2, 0);
}

void draw() {
  background(240);
  lights();
  translate(0, 0, -200);

  // Dibujar esfera
  pushMatrix();
  translate(esferaPos.x, esferaPos.y, esferaPos.z);
  fill(100, 150, 255);
  noStroke();
  sphere(esferaRadio);
  popMatrix();

  // Actualizar nodos
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Nodo n = malla[i][j];
      n.applyForce(new PVector(0, 0.3, 0)); // gravedad
      n.update();
      // Colisión con esfera
      PVector dir = PVector.sub(n.pos, esferaPos);
      float d = dir.mag();
      if (d < esferaRadio) {
        dir.normalize();
        n.pos = PVector.add(esferaPos, dir.mult(esferaRadio));
      }
    }
  }

  // Aplicar restricciones (tipo muelle)
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (i < cols-1) aplicarMuelle(malla[i][j], malla[i+1][j]);
      if (j < rows-1) aplicarMuelle(malla[i][j], malla[i][j+1]);
    }
  }

  // Dibujar malla
  stroke(0);
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      beginShape(QUADS);
      fill(200);
      vertex(malla[i][j].pos.x, malla[i][j].pos.y, malla[i][j].pos.z);
      vertex(malla[i+1][j].pos.x, malla[i+1][j].pos.y, malla[i+1][j].pos.z);
      vertex(malla[i+1][j+1].pos.x, malla[i+1][j+1].pos.y, malla[i+1][j+1].pos.z);
      vertex(malla[i][j+1].pos.x, malla[i][j+1].pos.y, malla[i][j+1].pos.z);
      endShape();
    }
  }
}
