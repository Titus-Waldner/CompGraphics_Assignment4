// Explosion.pde
// Explosion and ExplosionParticle classes, and spawnExplosion function
// BIG explosions for player, smaller for enemies

class Explosion {
  ArrayList<ExplosionParticle> parts;
  
  Explosion(float ex, float ey, boolean bigExplosion) {
    parts = new ArrayList<ExplosionParticle>();
    int count = bigExplosion ? 200 : 50; 
    for (int i=0; i<count; i++) {
      parts.add(new ExplosionParticle(ex, ey, bigExplosion));
    }
  }
  
  void update() {
    for (int i=parts.size()-1; i>=0; i--) {
      ExplosionParticle p = parts.get(i);
      p.update();
      if (p.lifespan <= 0) {
        parts.remove(i);
      }
    }
  }
  
  void drawMe() {
    for (ExplosionParticle p : parts) {
      p.drawMe();
    }
  }
  
  boolean isDone() {
    return parts.size() == 0;
  }
}

class ExplosionParticle {
  float x, y, z;
  float vx, vy, vz;
  float lifespan;
  color c;
  
  ExplosionParticle(float sx, float sy, boolean bigExplosion) {
    x = sx;
    y = sy;
    z = 0;
    float speedFactor = bigExplosion ? 4 : 2;
    vx = random(-speedFactor,speedFactor);
    vy = random(-speedFactor,speedFactor);
    vz = random(-speedFactor,speedFactor);
    
    lifespan = bigExplosion ? random(2.0,3.0) : random(1.0, 2.0); 
    c = color(random(255), random(255), random(255));
  }
  
  void update() {
    x += vx;
    y += vy;
    z += vz;
    lifespan -= 1.0/60.0;
    vx *= 0.95;
    vy *= 0.95;
    vz *= 0.95;
  }
  
  void drawMe() {
    pushMatrix();
    translate(x,y,z);
    noStroke();
    float alphaVal = map(lifespan,0,3,0,255);
    fill(red(c), green(c), blue(c), alphaVal);
    sphereDetail(2);
    sphere(3);
    popMatrix();
  }
}

// THIS function is called from main
void spawnExplosion(float ex, float ey, boolean bigExplosion) {
  explosions.add(new Explosion(ex, ey, bigExplosion));
}
