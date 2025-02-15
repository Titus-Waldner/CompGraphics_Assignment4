// UI at bottom and top for health, score, and game over screen
void drawUI() {
  fill(255);
  textSize(16);
  textAlign(LEFT, BOTTOM);
  text("Kills: " + kills, 10, height - 10);
  
  int maxHealth = 100;
  int barWidth = 100;
  int barHeight = 20;
  float healthPercent = constrain((float)playerHealth/(float)maxHealth, 0, 1);
  
  int xPos = width - barWidth - 20;
  int yPos = 20;
  
  fill(255,0,0);
  rect(xPos, yPos, barWidth, barHeight);
  
  fill(0,255,0);
  rect(xPos, yPos, barWidth*healthPercent, barHeight);
  
  noFill();
  stroke(255);
  rect(xPos, yPos, barWidth, barHeight);
  noStroke();
}

void drawGameOverScreen() {
  rectMode(CENTER);
  fill(50, 50, 50, 150);
  float boxWidth = 300;
  float boxHeight = 100;
  rect(width / 2, height / 2, boxWidth, boxHeight);
  rectMode(CORNER);
  
  fill(255,0,0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/2 - 20);
  
  fill(255);
  textSize(16);
  text("Press 'q' to restart", width/2, height/2 + 20);
}
