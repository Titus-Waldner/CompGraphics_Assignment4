//Player hander for drawing them and moving them

void updatePlayer() {
  float vx = 0;
  float vy = 0;

  if (movingUp)    vy -= playerSpeed;
  if (movingDown)  vy += playerSpeed;
  if (movingLeft)  vx -= playerSpeed;
  if (movingRight) vx += playerSpeed;
  
  if (!movingLeft && !movingRight && !movingUp && !movingDown) {
    playerX = lerp(playerX, playerHomeX, 0.01); //DRIFT BACK TO HOME
    playerY = lerp(playerY, playerHomeY, 0.01);
  } else {
    playerX += vx;
    playerY += vy;
  }
  
  playerX = constrain(playerX, worldLeft, worldRight);
  playerY = constrain(playerY, worldTop, worldBottom);
  
  // If shooting and canShoot, fire once
  if (shooting && canShoot) {
    playerBullets.add(new Bullet(playerX, playerY, playerX, worldTop, OWNER_PLAYER));
    canShoot = false;
  }
}

void drawPlayer() {
  playerFrameTimer += 1.0/60.0; 
  if (playerFrameTimer > playerFrameDelay) {
    playerFrameTimer = 0.0;
    currentPlayerFrame = (currentPlayerFrame + 1) % playerFrameCount;
  }

  float playerZ = -10;

  pushMatrix();
  translate(playerX, playerY, playerZ);
  noStroke();
  if (doTextures && playerFrames != null && playerFrames.length == playerFrameCount) {
    PImage frame = playerFrames[currentPlayerFrame];
    float halfW = frame.width * 0.5;
    float halfH = frame.height * 0.5;
    beginShape(QUADS);
    texture(frame);
    vertex(-halfW, -halfH, 0, 0, 0);
    vertex( halfW, -halfH, 0, 1, 0);
    vertex( halfW,  halfH, 0, 1, 1);
    vertex(-halfW,  halfH, 0, 0, 1);
    endShape();
  } else {
    fill(0,255,0);
    rectMode(CENTER);
    rect(0,0,30,30);
  }
  popMatrix();
}
