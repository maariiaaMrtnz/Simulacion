class Nodo {
  PVector pos, prev, acc;
  boolean fijo;

  Nodo(PVector p) {
    pos = p.copy();
    prev = p.copy();
    acc = new PVector();
    fijo = false;
  }

  void applyForce(PVector f) {
    if (!fijo) acc.add(f);
  }

  void update() {
    if (!fijo) {
      PVector vel = PVector.sub(pos, prev).mult(0.98);
      prev.set(pos);
      pos.add(vel);
      pos.add(acc);
      acc.set(0, 0);
    }
  }
}

void aplicarMuelle(Nodo a, Nodo b) {
  float restLen = spacing;
  PVector delta = PVector.sub(b.pos, a.pos);
  float dist = delta.mag();
  float diff = (dist - restLen) / dist;
  PVector offset = delta.mult(0.5 * diff);
  if (!a.fijo) a.pos.add(offset);
  if (!b.fijo) b.pos.sub(offset);
}
