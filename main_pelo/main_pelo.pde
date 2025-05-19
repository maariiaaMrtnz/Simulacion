final int NUM_PELOS = 50;

ArrayList<Pelo> pelos;

void setup() {
  size(800, 600);
  pelos = new ArrayList<Pelo>();
  for (int i = 0; i < NUM_PELOS; i++) {
    float x = width/2 + random(-50, 50);
    float y = random(30, 90);
    float len = random(50, 150);
    int numSegmentos = int(random(5, 15));
    pelos.add(new Pelo(x, y, len, numSegmentos));
  }
}

void draw() {
  background(255);
  for (Pelo p : pelos) {
    p.update();
    p.display();
  }
}

void mousePressed() {
  for (Pelo p : pelos) {
    p.tryGrab(mouseX, mouseY);
  }
}

void mouseReleased() {
  for (Pelo p : pelos) {
    p.release();
  }
}

void mouseDragged() {
  for (Pelo p : pelos) {
    p.drag(mouseX, mouseY);
  }
}
