//// Ringkasan: Kode lengkap animasi transisi kapal dari berjalan -> tersambar petir -> pecah -> terdampar dengan transisi smooth.

//float waveOffset = 0;
//float cloudX1 = 100;
//float cloudX2 = 550;

//boolean showLightning = false;
//int lightningTimer = 0;

//float kapalX = 900;
//float kapalY = 308;
//int sceneStage = 0; // 0: kapal jalan, 1: petir, 2: pecah, 3: terdampar
//int petirStartFrame = -1;
//int terdamparStartFrame = -1;

//void setup() {
//  size(900, 550);
//}

//void draw() {
//  background(90, 110, 130);

//  drawLaut();
//  drawPantai();
//  drawOmbak();
//  drawAwanMendung();
//  drawHujan();
//  drawPetir();

//  // Transisi scene berdasarkan stage
//  if (sceneStage == 0) {
//    kapalX -= 0.8;
//    drawKapalReferensi(kapalX, kapalY + sin(frameCount * 0.05) * 8);
//    if (kapalX < width / 2 && random(1) < 0.01) {
//      sceneStage = 1;
//      petirStartFrame = frameCount;
//    }
//  } else if (sceneStage == 1) {
//    drawPetir();
//    drawKapalReferensi(kapalX, kapalY + sin(frameCount * 0.05) * 8);
//    if (frameCount - petirStartFrame > 10) {
//      sceneStage = 2;
//    }
//  } else if (sceneStage == 2) {
//    kapalX -= 1.5;
//    drawKapalPecah(kapalX, kapalY);
//    drawPecahanKayuMengapung();
//    if (kapalX < 200) {
//      sceneStage = 3;
//      terdamparStartFrame = frameCount;
//    }
//  } else if (sceneStage == 3) {
//    float t = min(1.0, (frameCount - terdamparStartFrame) / 60.0); // transisi 1 detik
//    float interpX = lerp(kapalX, 180, t);
//    float interpY = lerp(kapalY, 415, t);
//    float angle = lerp(0, -QUARTER_PI / 2.5, t);

//    pushMatrix();
//    translate(interpX, interpY);
//    rotate(angle);
//    drawKapalReferensi(0, 0);
//    drawAsapKapal(20, -30);
//    popMatrix();

//    drawPecahanKayuPantai();
//  }

//  waveOffset += 0.03;
//  cloudX1 += 0.1;
//  cloudX2 += 0.05;
//  if (cloudX1 > width + 200) cloudX1 = -150;
//  if (cloudX2 > width + 200) cloudX2 = -200;
//}

//// -------------------- FUNGSI TAMBAHAN --------------------

//void drawLaut() {
//  for (int layer = 0; layer < 4; layer++) {
//    float baseY = 300 + layer * 20;
//    fill(40 + layer * 10, 80 + layer * 10, 120 + layer * 10);
//    noStroke();
//    beginShape();
//    vertex(0, height);
//    vertex(0, baseY);
//    for (int x = 0; x <= width; x += 10) {
//      float y = baseY 
//        + sin((x + frameCount * (1.2 + layer * 0.2)) * 0.02) * (6 + layer * 2)
//        + noise(x * 0.005, frameCount * 0.005 + layer) * 10;
//      vertex(x, y);
//    }
//    vertex(width, baseY);
//    vertex(width, height);
//    endShape(CLOSE);
//  }
//}

//void drawPantai() {
//  fill(220, 200, 160);
//  beginShape();
//  vertex(0, 400);
//  vertex(0, height);
//  vertex(width, height);
//  vertex(width, 400);
//  bezierVertex(width * 0.85, 420, width * 0.25, 420, 0, 400);
//  endShape(CLOSE);
//}

//void drawOmbak() {
//  fill(255, 255, 255, 200);
//  noStroke();
//  for (int i = 0; i < 25; i++) {
//    float x = (i * 40 + frameCount * 1.5) % (width + 40);
//    float y = 345 + sin(x * 0.04 + waveOffset * 1.2) * 8;
//    float size = 8 + sin(x * 0.03 + waveOffset) * 4;
//    if (sin(x * 0.04 + waveOffset * 1.2) > 0.2) ellipse(x, y, size, size * 0.6);
//  }

//  fill(255, 255, 255, 150);
//  for (int i = 0; i < 35; i++) {
//    float x = (i * 30 + frameCount * 2) % (width + 30);
//    float y = 355 + sin(x * 0.06 + waveOffset * 1.8) * 6;
//    float size = 5 + sin(x * 0.05 + waveOffset) * 2;
//    if (sin(x * 0.06 + waveOffset * 1.8) > 0.4) ellipse(x, y, size, size * 0.7);
//  }

//  fill(255, 255, 255, 100);
//  for (int i = 0; i < 50; i++) {
//    float x = (i * 20 + frameCount * 2.5) % (width + 20);
//    float y = 365 + sin(x * 0.08 + waveOffset * 2.5) * 4;
//    float size = 3 + sin(x * 0.07 + waveOffset) * 1;
//    if (sin(x * 0.08 + waveOffset * 2.5) > 0.6) ellipse(x, y, size, size * 0.8);
//  }

//  fill(255, 255, 255, 80);
//  for (int i = 0; i < 30; i++) {
//    float x = (i * 35 + frameCount * 3) % (width + 35);
//    float y = 340 + sin(x * 0.1 + waveOffset * 3) * 3;
//    if (sin(x * 0.1 + waveOffset * 3) > 0.7) {
//      ellipse(x, y, 2, 2);
//      ellipse(x + random(-3, 3), y + random(-2, 2), 1, 1);
//    }
//  }
//}

//void drawAwanMendung() {
//  drawAwanRealistisPadat(cloudX1, 100, 1.0);
//  drawAwanRealistisPadat(cloudX2, 140, 0.9);
//  drawAwanRealistisPadat(cloudX1 + 200, 90, 1.1);
//  drawAwanRealistisPadat(cloudX2 + 250, 130, 1.0);
//}

//void drawAwanRealistisPadat(float x, float y, float scale) {
//  noStroke();
//  fill(180);
//  ellipse(x, y, 80 * scale, 45 * scale);
//  ellipse(x + 30 * scale, y - 8 * scale, 65 * scale, 38 * scale);
//  ellipse(x - 30 * scale, y - 5 * scale, 70 * scale, 42 * scale);
//  ellipse(x + 20 * scale, y + 8 * scale, 55 * scale, 35 * scale);
//  ellipse(x - 20 * scale, y + 12 * scale, 50 * scale, 33 * scale);
//  fill(150);
//  ellipse(x, y + 15 * scale, 90 * scale, 35 * scale);
//  ellipse(x - 30 * scale, y + 18 * scale, 50 * scale, 25 * scale);
//  ellipse(x + 30 * scale, y + 18 * scale, 50 * scale, 25 * scale);
//}

//void drawHujan() {
//  stroke(200, 220);
//  strokeWeight(1);
//  for (int i = 0; i < 300; i++) {
//    float rx = random(width);
//    float ry = (frameCount * 10 + i * 20) % height;
//    line(rx, ry, rx + 1, ry + 10);
//  }
//}

//void drawPetir() {
//  if (random(1) < 0.005 && frameCount - lightningTimer > 100) {
//    showLightning = true;
//    lightningTimer = frameCount;
//  }

//  if (showLightning) {
//    fill(255, 255, 255, 100);
//    rect(0, 0, width, height);

//    stroke(255, 255, 200);
//    strokeWeight(3);
//    float x = random(width * 0.3, width * 0.7);
//    float y = 0;
//    for (int i = 0; i < 8; i++) {
//      float nextX = x + random(-20, 20);
//      float nextY = y + random(30, 60);
//      line(x, y, nextX, nextY);
//      x = nextX;
//      y = nextY;
//    }

//    if (frameCount - lightningTimer > 4) showLightning = false;
//  }
//}

//void drawKapalReferensi(float x, float y) {
//  pushMatrix();
//  translate(x, y);
//  float tilt = sin(frameCount * 0.03) * 0.08;
//  rotate(tilt);

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


//void drawKapalPecah(float x, float y) {
//  pushMatrix();
//  translate(x, y);
//  rotate(sin(frameCount * 0.03) * 0.05);
//  drawKapalReferensi(0, 0);
//  popMatrix();
//  drawPecahanKayuMengapung();
//}

//void drawAsapKapal(float x, float y) {
//  noStroke();
//  for (int i = 0; i < 8; i++) {
//    float offsetX = sin((frameCount + i * 20) * 0.02) * 5;
//    float offsetY = -i * 12 - frameCount * 0.1;
//    float sizeX = 20 + sin((frameCount + i * 10) * 0.03) * 5;
//    float sizeY = 12 + cos((frameCount + i * 15) * 0.03) * 3;
//    fill(160, 160, 160, 100);
//    ellipse(x + offsetX, y + offsetY, sizeX, sizeY);
//  }
//}

//void drawPecahanKayuMengapung() {
//  noStroke();
//  float baseY = 340;
//  for (int i = 0; i < 7; i++) {
//    float px = 150 + i * 100;
//    float angle = (px + frameCount * 1.2) * 0.04 + waveOffset;
//    float py = baseY + sin(angle) * 3;
//    float tilt = radians(sin(angle) * 2);
//    float sizeFactor = 1 + sin(i * 10 + frameCount * 0.01) * 0.5;
//    pushMatrix();
//    translate(px, py);
//    rotate(tilt);
//    switch(i % 3) {
//      case 0:
//        fill(130, 80, 40, 200);
//        rectMode(CENTER);
//        rect(0, 0, 40 * sizeFactor, 10 * sizeFactor, 3);
//        break;
//      case 1:
//        fill(120, 70, 30, 190);
//        ellipse(0, 0, 25 * sizeFactor, 8 * sizeFactor);
//        break;
//      case 2:
//        fill(110, 60, 20, 180);
//        beginShape();
//        vertex(-10 * sizeFactor, 5 * sizeFactor);
//        vertex(10 * sizeFactor, 0);
//        vertex(-10 * sizeFactor, -5 * sizeFactor);
//        endShape(CLOSE);
//        break;
//    }
//    popMatrix();
//  }
//}

//void drawPecahanKayuPantai() {
//  noStroke();
//  fill(110, 60, 25);
//  rect(240, 430, 30, 6, 2);
//  rect(260, 445, 22, 5, 2);
//  beginShape();
//  vertex(250, 460); vertex(265, 455); vertex(270, 470); vertex(255, 475);
//  endShape(CLOSE);
//  fill(100, 50, 20);
//  beginShape();
//  vertex(225, 445); vertex(240, 435); vertex(238, 455);
//  endShape(CLOSE);
//  fill(130, 80, 40);
//  ellipse(235, 470, 12, 6);
//  ellipse(268, 468, 10, 5);
//  pushMatrix();
//  translate(228, 460);
//  rotate(radians(-15));
//  rect(0, 0, 26, 5, 2);
//  popMatrix();
//}
