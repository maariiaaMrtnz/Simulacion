class Nodo {
  PVector pos, prevPos, acc;
  boolean fijo = false;

  Nodo(float x, float y) {
    pos = new PVector(x, y);
    prevPos = pos.copy();
    acc = new PVector(0, 0);
  }

  void applyForce(PVector f) {
    if (!fijo) acc.add(f);
  }

  void update() {
    if (!fijo) {
      PVector vel = PVector.sub(pos, prevPos);
      prevPos.set(pos);
      pos.add(vel.mult(0.98)); // Amortiguamiento
      pos.add(acc);
      acc.set(0, 0);
    }
  }
}

class Pelo {
  Nodo[] nodos;
  float restLength;
  int grabIndex = -1;

  Pelo(float x, float y, float totalLength, int numSegmentos) {
    nodos = new Nodo[numSegmentos + 1];
    restLength = totalLength / numSegmentos;
    for (int i = 0; i < nodos.length; i++) {
      nodos[i] = new Nodo(x, y + i * restLength);
    }
    nodos[0].fijo = true; // Raíz fija
  }

  void update() {
    for (int i = 0; i < 5; i++) {
      applyConstraints();
    }
    for (Nodo n : nodos) {
      n.applyForce(new PVector(0, 0.5)); // Gravedad
      n.update();
    }
  }

  void applyConstraints() {
    for (int i = 0; i < nodos.length - 1; i++) {
      Nodo a = nodos[i];
      Nodo b = nodos[i+1];
      PVector delta = PVector.sub(b.pos, a.pos);
      float dist = delta.mag();
      float diff = (dist - restLength) / dist;
      PVector offset = delta.mult(0.5 * diff);
      if (!a.fijo) a.pos.add(offset);
      if (!b.fijo) b.pos.sub(offset);
    }
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    for (int i = 0; i < nodos.length - 1; i++) {
      line(nodos[i].pos.x, nodos[i].pos.y, nodos[i+1].pos.x, nodos[i+1].pos.y);
    }
  }

  void tryGrab(float mx, float my) {
    for (int i = 1; i < nodos.length; i++) {
      if (dist(mx, my, nodos[i].pos.x, nodos[i].pos.y) < 10) {
        grabIndex = i;
        break;
      }
    }
  }

  void drag(float mx, float my) {
    if (grabIndex >= 0) {
      nodos[grabIndex].pos.set(mx, my);
    }
  }

  void release() {
    grabIndex = -1;
  }
}
