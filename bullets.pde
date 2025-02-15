// Bullet.pde
// This defines the Bullet class and makes player bullets
// Player bullets are fancy rotating triangles, enemy bullets  ellipses.

// relies on global variables like OWNER_PLAYER, OWNER_ENEMY, world boundaries, etc.

class Bullet {
  float x, y;
  float vx, vy;
  int owner;
  
  float angle = 0;
  color c1, c2, c3; // colors for player bullet triangles
  
  Bullet(float startX, float startY, float targetX, float targetY, int o) {
    x = startX;
    y = startY;
    owner = o;
    float angleDir = atan2(targetY - startY, targetX - startX);
    float speed = 8;
    vx = speed*cos(angleDir);
    vy = speed*sin(angleDir);
    
    if (owner == OWNER_PLAYER) {
      // Random colors for triangles
      c1 = color(random(255), random(255), random(255));
      c2 = color(random(255), random(255), random(255));
      c3 = color(random(255), random(255), random(255));
    }
  }
  
  void update() {
    x += vx;
    y += vy;
    if (owner == OWNER_PLAYER) {
      angle += 0.1; // rotate player bullet
    }
  }
  
  boolean offScreen() {
    return (x < worldLeft-50 || x > worldRight+50 || y < worldTop-50 || y > worldBottom+50);
  }
  
  void drawMe() {
    pushMatrix();
    translate(x,y,3);
    noStroke();
    if (owner == OWNER_PLAYER) {
      // Draw rotating triple-triangle
      rotate(angle);
      float size = 10;
      
      fill(c1);
      beginShape();
      vertex(0,-size);
      vertex(-size*0.8,size*0.8);
      vertex(size*0.8,size*0.8);
      endShape(CLOSE);
      
      rotate(PI/3);
      fill(c2);
      beginShape();
      vertex(0,-size);
      vertex(-size*0.8,size*0.8);
      vertex(size*0.8,size*0.8);
      endShape(CLOSE);
      
      rotate(PI/3);
      fill(c3);
      beginShape();
      vertex(0,-size);
      vertex(-size*0.8,size*0.8);
      vertex(size*0.8,size*0.8);
      endShape(CLOSE);
      
    } else {
      // enemy bullet = simple ellipse
      fill(255,255,0);
      ellipse(0,0,5,5);
    }
    popMatrix();
  }
}
