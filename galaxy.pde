// Galaxy.pde
// This file handles galaxy related data and drawing (swirl and spin etc)

float[][] galaxyPoints;
int galaxyPointCount = 9000;
float galaxyAngle = 0.0;
float galaxyRotationSpeedZ = 0.1; 
float galaxyRotationSpeedX = 0.002;
float galaxyRotationSpeedY = 0.003;

void initGalaxy() {
  galaxyPoints = new float[galaxyPointCount][3];
  for (int i=0; i<galaxyPointCount; i++) {
    float a = i * 0.05;
    float rr = i * 0.2;  
    float xx = rr*cos(a);
    float yy = rr*sin(a);
    float zz = random(-200, -15);
    galaxyPoints[i][0] = xx;
    galaxyPoints[i][1] = yy;
    galaxyPoints[i][2] = zz;
  }
}

void drawSpiralGalaxy() {
  pushMatrix();
  galaxyAngle += 1.0/60.0; 
  rotateZ(galaxyAngle * galaxyRotationSpeedZ);
  rotateX(galaxyAngle * galaxyRotationSpeedX);
  rotateY(galaxyAngle * galaxyRotationSpeedY);
  
  noStroke();
  for (int i=0; i<galaxyPointCount; i++) {
    float x = galaxyPoints[i][0];
    float y = galaxyPoints[i][1];
    float z = galaxyPoints[i][2];
    float distFromCenter = sqrt(x*x + y*y + z*z);
    float brightness = map(distFromCenter, 0, galaxyPointCount*0.2, 255, 50);
    fill(brightness, brightness, 255);
    pushMatrix();
    translate(x, y, z);
    ellipse(0,0,3,3);
    popMatrix();
  }
  popMatrix();
}
