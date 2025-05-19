// Sphere.pde
class Sphere {
  PVector position;
  PVector velocity;
  float radius;
  color sphereColor;
  boolean moveWithWaves = true;
  float mass;  // Masa de la esfera para cálculos de física
  
  Sphere(float x, float z, float r) {
    position = new PVector(x, 100, z); // Iniciar arriba (y=100)
    velocity = new PVector(0, 0, 0);
    radius = r;
    mass = r * 0.1f; // Masa proporcional al radio
    sphereColor = color(random(255), random(255), random(255));
  }
  
  void update(HeightMap map) {
    // Obtener variación de las olas (ahora con suavizado)
    PVector waveEffect = getWaveEffect(map, position.x, position.z);
    PVector nextWaveEffect = getWaveEffect(map, position.x + velocity.x * 0.1f, position.z + velocity.z * 0.1f);
    
    // Calcular la "normal" de la ola para efectos de pendiente
    PVector waveGradient = PVector.sub(nextWaveEffect, waveEffect).normalize();
    
    // Altura del agua considerando el radio
    float waterHeight = waveEffect.y;
    float sphereBottom = position.y - radius;
    
    // --- FÍSICA MEJORADA ---
    float gravity = 0.5f;
    float buoyancyForce = 0.8f; // Fuerza de flotación base
    float dragInWater = 0.05f;  // Fricción en el agua
    float dragInAir = 0.01f;    // Fricción en el aire
    
    // Si la esfera está en contacto con el agua
    if (sphereBottom < waterHeight) {
      // Calcular cuánto está sumergida (0-1)
      float submergedRatio = constrain((waterHeight - sphereBottom) / (2 * radius), 0, 1);
      
      // FLOTABILIDAD MEJORADA (impulso hacia arriba + efecto de las olas)
      float buoyancy = buoyancyForce * submergedRatio * (1 + waveEffect.y * 0.05f);
      velocity.y += buoyancy;
      
      // MOVIMIENTO LATERAL CON LAS OLAS (solo si moveWithWaves está activado)
      if (moveWithWaves) {
        float wavePush = 0.2f * submergedRatio;
        velocity.x += waveGradient.x * wavePush;
        velocity.z += waveGradient.z * wavePush;
      }
      
      // FRICCIÓN DEL AGUA (depende de cuánto está sumergida)
      velocity.mult(1 - (dragInWater * submergedRatio));
      
      // COLISIÓN CON LA SUPERFICIE (ajuste suave)
      if (sphereBottom < waterHeight) {
        float penetration = waterHeight - sphereBottom;
        position.y += penetration * 0.5f; // Empujar hacia arriba suavemente
        velocity.y *= 0.6f; // Amortiguación vertical
      }
    } else {
      // Gravedad normal cuando está en el aire
      velocity.y -= gravity;
      velocity.mult(1 - dragInAir); // Fricción del aire
    }
    
    // Aplicar velocidad
    position.add(velocity);
    
    // Confinar dentro del mapa (considerando el radio)
    float halfSize = (map.mapSize * map.cellSize / 2) - radius;
    position.x = constrain(position.x, -halfSize, halfSize);
    position.z = constrain(position.z, -halfSize, halfSize);
    
    // Pequeña fricción adicional para estabilidad
    velocity.mult(0.98f);
  }
  
  PVector getWaveEffect(HeightMap map, float x, float z) {
    PVector result = new PVector(0, 0, 0);
    float time = millis()/1000f;
    
    for (Wave wave : map.waves) {
      PVector variation = wave.getVariation(x, 0, z, time);
      result.add(variation);
    }
    return result;
  }
  
  void checkCollision(ArrayList<Sphere> spheres) {
    for (Sphere other : spheres) {
      if (other != this) {
        float distance = PVector.dist(position, other.position);
        float minDist = radius + other.radius;
        
        if (distance < minDist) {
          // Resolver colisión
          PVector dir = PVector.sub(position, other.position);
          dir.normalize();
          float overlap = minDist - distance;
          
          // Mover ambas esferas para resolver la colisión
          position.add(PVector.mult(dir, overlap * 0.5));
          other.position.sub(PVector.mult(dir, overlap * 0.5));
          
          // Transferencia de momentum (conservación simplificada)
          PVector temp = velocity.copy();
          velocity = other.velocity.copy().mult(0.9);
          other.velocity = temp.mult(0.9);
        }
      }
    }
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(sphereColor);
    noStroke();
    sphere(radius);
    popMatrix();
  }
}
