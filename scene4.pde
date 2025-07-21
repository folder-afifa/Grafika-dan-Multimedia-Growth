//// ========== Variabel Global ==========
//float waveOffset = 0;
//float waveSpeed = 0.02;
//int wavePoints = 100;
//float smallWaveDirection = 1;
//float smallWaveOffset = 0;
//float sunAngle = 0;
//float shipX = 1100;   // mulai dari kanan layar (di luar)
//float shipY = 330;    // posisi vertikal tetap
//float targetX = 520;  // posisi berhenti di tengah dermaga
//float shipSpeed = 0.161;  // agar sampai dalam 60 detik
//boolean shipStopped = false;
//int stopStartTime = 0;
//int stopDuration = 60000; // 60 detik dalam milidetik
//boolean shipDeparting = false;

//void setup() {
//  size(1000, 600);
//  frameRate(60);
  
//}

//void draw() {
//  background(135, 206, 250); 
//  drawSun();                
//  drawBackground();         
//  drawExtraMountains();     
//  drawSeaAndDistantWaves(); 
//  // 1. Jika kapal belum sampai ke pelabuhan
//if (!shipStopped && !shipDeparting) {
//  if (shipX > targetX) {
//    shipX -= shipSpeed;
//  } else {
//    shipStopped = true;
//    stopStartTime = millis(); // Catat waktu berhenti
//  }
//}

//// 2. Saat berhenti di pelabuhan (selama 1 menit)
//if (shipStopped && !shipDeparting) {
//  if (millis() - stopStartTime >= stopDuration) {
//    shipDeparting = true; // Setelah 1 menit, lanjut jalan lagi
//    shipSpeed = 1.5;      // Bisa percepat agar tidak lambat keluar layar
//  }
//}

//// 3. Jika sudah waktunya berangkat, lanjut jalan ke kiri
//if (shipDeparting) {
//  shipX -= shipSpeed;
//}
//  if (shipX > targetX) {
//  shipX -= shipSpeed;
//}
//drawShip(shipX, shipY);
              
//  drawBeach();              
//  drawPier();               
//  drawForegroundFoam();
  
//}

//// ========== Matahari ==========
//void drawSun() {
//  pushMatrix();
//  translate(850, 100);
//  rotate(sunAngle);
//  sunAngle += 0.01;

//  noStroke();
//  fill(255, 204, 0);
//  ellipse(0, 0, 60, 60);

//  stroke(255, 200, 0);
//  strokeWeight(2);
//  for (int i = 0; i < 8; i++) {
//    float angle = TWO_PI / 8 * i;
//    float x1 = cos(angle) * 35;
//    float y1 = sin(angle) * 35;
//    float x2 = cos(angle) * 50;
//    float y2 = sin(angle) * 50;
//    line(x1, y1, x2, y2);
//  }
//  popMatrix();
//}

//// ========== Gunung & Awan ==========
//void drawExtraMountains() {
//  noStroke();
//  fill(90, 180, 100);
//  ellipse(200, 300, 500, 200);
//  ellipse(800, 300, 600, 200);
//}

//void drawBackground() {
//  noStroke();
//  fill(100, 200, 120);
//  ellipse(250, 350, 300, 150);
//  ellipse(600, 350, 400, 180);

//  fill(255);
//  ellipse(200, 100, 100, 50);
//  ellipse(250, 100, 80, 40);
//  ellipse(230, 80, 60, 30);
//  ellipse(800, 120, 120, 60);
//  ellipse(850, 120, 90, 45);
//  ellipse(825, 100, 70, 35);
//}

//// ========== Laut & Ombak ==========
//void drawSeaAndDistantWaves() {
//  noStroke();
//  for (int y = 280; y < height; y++) {
//    float inter = map(y, 280, height, 0, 1);
//    color c = lerpColor(color(0, 191, 255), color(0, 100, 200), inter);
//    fill(c);
//    rect(0, y, width, 1);
//  }

//  waveOffset += waveSpeed;
//  smallWaveOffset += waveSpeed * smallWaveDirection * 0.3;
//  if (smallWaveOffset > 2 || smallWaveOffset < -2) {
//    smallWaveDirection *= -1;
//  }
  
//  drawWaveLine(320, 0.01, 15, 10, 6, color(0, 120, 255, 200));
//  drawWaveLine(340, 0.015, 10, 8, 5, color(30, 150, 255, 180));
//  drawWaveLine(360, 0.02, 8, 6, 4, color(60, 180, 255, 160));
//  drawWaveLine(380, 0.025, 6, 4, 3, color(100, 200, 255, 140));
//  drawWaveLine(400, 0.03, 4, 3, 2, color(130, 220, 255, 120));
//  drawWaveLine(420, 0.035, 3, 2, 2, color(0, 200, 255, 100));
//}

//void drawWaveLine(float baseY, float freq, float noiseAmp, float sinAmp, float weight, color c) {
//  stroke(c);
//  strokeWeight(weight);
//  noFill();
//  beginShape();
//  for (int x = 0; x <= width; x += width / wavePoints) {
//    float y = baseY + sin((x * freq) + waveOffset) * sinAmp + noise(x * freq * 0.5, waveOffset) * noiseAmp;
//    vertex(x, y);
//  }
//  endShape();
//}

//// ========== Pantai ==========
//void drawBeach() {
//  fill(255, 218, 185);
//  noStroke();
//  beginShape();
//  vertex(0, 450);
//  for (int x = 0; x <= width; x += 20) {
//    float y = 450 + sin(x * 0.01) * 15 + noise(x * 0.01) * 10;
//    vertex(x, y);
//  }
//  vertex(width, height);
//  vertex(0, height);
//  endShape(CLOSE);
//}

//// ========== Kapal ==========
//// ⛵ Kapal (sudah terintegrasi penuh)
//void drawShip(float x, float y) {
//  pushMatrix();
//  translate(x, y);
//  float tilt = sin(frameCount * 0.03) * 0.08;
//  rotate(tilt);
//  scale(1.5);

//  stroke(60, 30, 10);
//  strokeWeight(4);
//  fill(180, 100, 50);
//  beginShape();
//  vertex(-120, 10); vertex(-100, 40); vertex(-80, 45); vertex(0, 50);
//  vertex(80, 45); vertex(100, 40); vertex(120, 10); vertex(100, -5);
//  vertex(80, -10); vertex(0, -15); vertex(-80, -10); vertex(-100, -5);
//  endShape(CLOSE);

//  fill(200, 120, 70);
//  strokeWeight(3);
//  rect(-90, -15, 180, 25, 5);

//  stroke(120, 60, 30);
//  strokeWeight(2);
//  for (int i = -1; i <= 4; i++) line(-100, i * 8, 100, i * 8);
//  for (int i = -8; i <= 8; i++) line(i * 12, -10, i * 12, 35);

//  stroke(60, 30, 10);
//  strokeWeight(4);
//  fill(160, 90, 45);
//  triangle(-120, 10, -140, 0, -120, -5);
//  fill(160, 90, 45);
//  beginShape(); vertex(120, 10); vertex(130, 5); vertex(130, -5); vertex(120, -5); endShape(CLOSE);

//  stroke(60, 30, 10);
//  strokeWeight(8);
//  float mastSway = sin(frameCount * 0.05) * 2;
//  line(0, -15, mastSway, -180);

//  strokeWeight(5);
//  line(-80 + mastSway, -160, 80 + mastSway, -160);
//  line(-70 + mastSway, -120, 70 + mastSway, -120);
//  line(-60 + mastSway, -80, 60 + mastSway, -80);

//  stroke(100, 100, 90);
//  strokeWeight(3);
//  fill(250, 250, 240);
//  beginShape();
//  vertex(-70 + mastSway, -180);
//  bezierVertex(-60 + mastSway, -175, -60 + mastSway, -125, -70 + mastSway, -120);
//  vertex(70 + mastSway, -120);
//  bezierVertex(60 + mastSway, -125, 60 + mastSway, -175, 70 + mastSway, -180);
//  endShape(CLOSE);

//  stroke(200, 200, 190);
//  strokeWeight(1);
//  for (int i = -170; i <= -130; i += 12)
//    line(-65 + mastSway, i, 65 + mastSway, i);

//  stroke(60, 30, 10);
//  strokeWeight(6);
//  line(60, -15, 60 + mastSway * 0.5, -120);

//  stroke(100, 100, 90);
//  strokeWeight(2);
//  fill(245, 245, 235);
//  beginShape();
//  vertex(60 + mastSway * 0.5, -120);
//  bezierVertex(80 + mastSway * 0.5, -115, 80 + mastSway * 0.5, -70, 60 + mastSway * 0.5, -65);
//  vertex(35 + mastSway * 0.5, -65);
//  bezierVertex(40 + mastSway * 0.5, -70, 40 + mastSway * 0.5, -115, 60 + mastSway * 0.5, -120);
//  endShape(CLOSE);

//  stroke(60, 30, 10);
//  strokeWeight(3);
//  fill(140, 80, 40);
//  rect(-40, -35, 80, 25, 3);
//  fill(120, 70, 35);
//  rect(-45, -40, 90, 8, 2);

//  stroke(40, 60, 80);
//  strokeWeight(2);
//  fill(120, 160, 200);
//  rect(-30, -25, 15, 10);
//  rect(-7, -25, 15, 10);
//  rect(15, -25, 15, 10);

//  stroke(60, 30, 10);
//  strokeWeight(3);
//  line(-80, -15, -80 + mastSway * 0.3, -50);

//  fill(200, 50, 50);
//  stroke(150, 40, 40);
//  strokeWeight(1);
//  float flagSway = sin(frameCount * 0.1) * 3;
//  beginShape();
//  vertex(-80 + mastSway * 0.3, -50);
//  vertex(-80 + mastSway * 0.3, -40);
//  vertex(-65 + flagSway, -45);
//  endShape(CLOSE);

//  noStroke();
//  fill(0, 0, 0, 50);
//  ellipse(0, 65, 280, 30);
//  fill(0, 0, 0, 30);
//  ellipse(0, 70, 200, 15);
//  popMatrix();
//}


//// ========== Dermaga ==========
//void drawPier() {
//  fill(110, 70, 40);
//  noStroke();
//  for (int i = 0; i < 8; i++) {
//    float x_pos = 100 + i * 50;
//    float y_start = 440 - i * 15;
//    float y_end = y_start + 80 + i*5;
//    rect(x_pos - 5, y_start, 10, y_end - y_start);
//    rect(x_pos + 45, y_start, 10, y_end - y_start);
//  }

//  fill(160, 120, 80);
//  stroke(130, 90, 60);
//  strokeWeight(2);
//  quad(50, 470, 150, 470, 520, 340, 480, 340);

//  for (int i = 0; i < 10; i++) {
//    float startY = 470 - i * 14;
//    float endY = 340;
//    float startX1 = map(startY, 470, endY, 50, 480);
//    float startX2 = map(startY, 470, endY, 150, 520);
//    line(startX1, startY, startX2, startY);
//  }
//}

//// ========== Buih Ombak ==========
//void drawForegroundFoam() {
//  noStroke();

//  fill(255, 255, 255, 180);
//  for (int i = 0; i < width; i += 25) {
//    float x = i + random(-6, 6);
//    float y = 380 + sin((i * 0.01) + waveOffset) * 10 + random(-4, 4);
//    boolean onPier = false;
//    if (y > 340 && y < 470) {
//      float pierStartX = map(y, 470, 340, 50, 480);
//      float pierEndX = map(y, 470, 340, 150, 520);
//      if (x > pierStartX && x < pierEndX) onPier = true;
//    }
//    boolean onShip = (x > 420 && x < 780 && y > 320 && y < 420);
//    if (!onPier && !onShip && sin((i * 0.05) + waveOffset * 3) > 0.2)
//      ellipse(x, y, random(10, 18), random(4, 10));
//  }

//  fill(255, 255, 255, 120);
//  for (int i = 0; i < width; i += 40) {
//    float x = i + random(-4, 4);
//    float y = 400 + sin((i * 0.015) + waveOffset * 2) * 6 + random(-2, 2);
//    boolean onPier = false;
//    if (y > 340 && y < 470) {
//      float pierStartX = map(y, 470, 340, 50, 480);
//      float pierEndX = map(y, 470, 340, 150, 520);
//      if (x > pierStartX && x < pierEndX) onPier = true;
//    }
//    boolean onShip = (x > 420 && x < 780 && y > 320 && y < 420);
//    if (!onPier && !onShip && sin((i * 0.08) + waveOffset * 4) > 0.4)
//      ellipse(x, y, random(6, 12), random(2, 6));
//  }
//}
