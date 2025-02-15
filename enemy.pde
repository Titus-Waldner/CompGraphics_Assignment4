// Enemy.pde
// Enemy class and enemy image loading, spawnEnemy functions etc

PImage[] enemyImages; 
PImage bossImage;
float enemyRadius = 15;
float enemyBaseSpeed = 0.02; 
float enemyDifficulty = 0;
float numberOfEnemies = 3;

void loadEnemyImages() {
  enemyImages = new PImage[10];
  for (int i=0; i<10; i++) {
    enemyImages[i] = loadImage("enemy_"+i+".png");
  }
}


// enemy spawns off screen then moves so no pop in
Enemy spawnEnemy(PImage img, boolean isBoss) {
  float ex = random(worldLeft+50, worldRight-50);
  float ey = worldTop - 100; 
  float diffFactor = 1.0 + enemyDifficulty*0.05;
  return new Enemy(ex, ey, img, enemyBaseSpeed*diffFactor, isBoss);
}

void spawnBoss() {
  // Bosses spawn at a random location at the top (similar logic as normal enemy)
  float ex = random(worldLeft+50, worldRight-50);
  float ey = worldTop - 150; // Slightly higher start if you want

  // Boss might also scale with difficulty if desired
  float diffFactor = 1.0 + enemyDifficulty*0.05;

  // Spawn an enemy with isBoss = true
  enemies.add(new Enemy(ex, ey, bossImage, enemyBaseSpeed*diffFactor, true));
}


class Enemy {
  float x, y;
  float targetX, targetY; 
  float moveSpeed; 
  float bulletCooldown = 0;
  PImage myImage;
  boolean isBoss;
  float myRadius;
  float baseBulletCooldown;
   int health;

  Enemy(float startX, float startY, PImage img, float speed, boolean isBoss) {
    x = startX;
    y = startY;
    myImage = img;
    moveSpeed = speed;
    this.isBoss = isBoss;
    chooseNewTarget();

    if (isBoss) {
      // Boss specifics:
      bossSpawns(); // Play boss spawn sound
      // Larger radius for collision
      myRadius = 64;
      // Faster shooting: maybe every 0.75 seconds instead of 1.5?
      baseBulletCooldown = 0.3;
      health = 10; // Boss requires 10 hits
    } else {
      // Normal enemy:
      myRadius = enemyRadius; // use your predefined enemyRadius = 15
      baseBulletCooldown = 1.5;
      health = 1; // Normal enemies die in one hit
    }
  }

  void chooseNewTarget() {
    boolean validTarget = false;
    while (!validTarget) {
      targetX = random(worldLeft+50, worldRight-50);
      targetY = random(worldTop+50, worldBottom-100);

      // Keep enemy away from player
      float safeDistance = playerRadius + myRadius + 20; 
      float dx = targetX - playerX;
      float dy = targetY - playerY;
      float distanceToPlayer = sqrt(dx * dx + dy * dy);

      if (distanceToPlayer > safeDistance) {
        validTarget = true;
      }
    }
  }

  void update() {
    x = lerp(x, targetX, moveSpeed);
    y = lerp(y, targetY, moveSpeed);
    if (dist(x,y,targetX,targetY)<5) {
      chooseNewTarget();
    }

    bulletCooldown -= 1.0/60.0;
    if (bulletCooldown <= 0 && playerAlive) {
      enemyBullets.add(new Bullet(x, y, playerX, playerY, OWNER_ENEMY));
      bulletCooldown = baseBulletCooldown; // Reset cooldown based on isBoss or not
    }
  }

  void drawMe() {
    pushMatrix();
    translate(x, y, 1);
    noStroke();
    if (doTextures && myImage != null) {
      float halfW = myImage.width * 0.5;
      float halfH = myImage.height * 0.5;
      beginShape(QUADS);
      texture(myImage);
      vertex(-halfW, -halfH, 0, 0, 0);
      vertex( halfW, -halfH, 0, 1, 0);
      vertex( halfW,  halfH, 0, 1, 1);
      vertex(-halfW,  halfH, 0, 0, 1);
      endShape();
    } else {
      fill(isBoss ? color(255,0,255) : color(255,0,0));
      rectMode(CENTER);
      float size = isBoss ? 126 : 30; // Boss 126x126, normal 30x30
      rect(0,0,size,size);
    }
    popMatrix();
  }
  void postDeathEffects()
  {
    if (isBoss)
    { 
      //Spawn health pack when boss dies
      healthPackX = random(worldLeft+100, worldRight-100);
      healthPackY = random(worldTop+100, worldBottom-100);
      healthPackActive = true;
      bossDeath();// Play boss death sound
       }  
    }
}
