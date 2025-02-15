//modes and keyboard manager

final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';
final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';
final char KEY_RESTART = 'q';

void keyPressed() {
  if (key == 'a') movingLeft = true;
  if (key == 'd') movingRight = true;
  if (key == 'w') movingUp = true;
  if (key == 's') movingDown = true;
  
  if (key == ' ') {
    // Fire only on press if canShoot is true.
    if(playerAlive)
    {
      pew(); // Play shooting sound
      shooting = true; 
    }
    
  }

  if (key == 't') doTextures = !doTextures;
  if (key == 'c') doCollision = !doCollision;
  if (key == 'q' && !playerAlive) resetGame();
}

void keyReleased() {
  if (key == 'a') movingLeft = false;
  if (key == 'd') movingRight = false;
  if (key == 'w') movingUp = false;
  if (key == 's') movingDown = false;
  
  if (key == ' ') {
    // On release, allow next shot
    shooting = false;
    canShoot = true; 
  }
}
