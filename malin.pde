// ==================================================================
// KODE GABUNGAN FINAL: ANIMASI CERITA MALIN KUNDANG
// VERSI 3.0
//
// MENGGABUNGKAN:
// 1. Struktur naratif, manajemen adegan, dan transisi waktu dari KODE 1.
// 2. Desain visual dan animasi detail kapal (goyangan, tiang) dari KODE 2.
//
// HASIL:
// Sebuah program animasi utuh yang menceritakan kisah Malin Kundang
// dengan alur cerita yang jelas dan visual kapal yang lebih dinamis.
// ==================================================================


// ==================================================================
// BAGIAN 1: VARIABEL GLOBAL
// Menggabungkan semua variabel yang dibutuhkan dari kedua kode.
// ==================================================================

// Variabel untuk ombak dan matahari
float waveOffset = 0;
float waveSpeed = 0.02;
int wavePoints = 100;
float smallWaveDirection = 1;
float smallWaveOffset = 0;
float waveXOffset = 50; // Ombak agak mundur agar tidak tumpang tindih
float sunAngle = 0; // Matahari berputar

// Variabel untuk scene management (manajemen adegan)
int programStartTime;
boolean showCharacter = false;
int scene2StartTime;
boolean showShip = false;
int scene3StartTime;
boolean programEnded = false;

// Variabel untuk karakter Malin Kundang
PImage malinKecil, malinRemaja, malinDewasa;
int transisiInterval = 10000; // 10 detik per karakter
int timeTransitionDuration = 8000; // 8 detik untuk transisi pagi ke malam
float karakterX = 700;
float karakterY = 500;

// Variabel untuk perubahan waktu (pagi ke malam)
float timeOfDay = 0.0; // 0 = pagi, 1 = malam
float sunMoonX = 850;
float sunMoonY = 100;

// Variabel Gerak Kapal (menggunakan timing yang detail dari Kode 1)
float kapalX = 900; // posisi awal kapal (kanan)
float kapalY = 330; // posisi tetap Y
float kapalTargetX = 600; // titik tengah (titik dermaga)
float kapalTargetKiriX = -200; // Tujuan akhir kapal ke kiri
int kapalGerakKiriDurasi = 20000; // 20 detik ke kiri
int kapalStartTime;
int kapalDurasiGerak = 5000; // 5 detik = 5000 ms
int kapalDiamDurasi = 35000; // 35 detik kapal diam di dermaga
boolean kapalDiam = false;
boolean kapalBerhenti = false;
boolean kapalBerjalan = true;

// Variabel untuk subtitle
PFont subtitleFont;
String currentSubtitle = "";
boolean showSubtitle = false;


// ==================================================================
// BAGIAN 2: FUNGSI UTAMA (SETUP & DRAW)
// Mengatur inisialisasi dan loop utama program.
// ==================================================================

void setup() {
  size(1000, 600);
  frameRate(60);
  programStartTime = millis();
  kapalStartTime = millis(); // Inisialisasi awal

  // Load font untuk subtitle
  try {
    subtitleFont = createFont("Arial", 18, true);
    textFont(subtitleFont);
  } catch (Exception e) {
    println("Font default tidak ditemukan, menggunakan font sistem.");
  }

  // Load gambar karakter (pastikan file ada di folder 'data')
  try {
    malinKecil = loadImage("malinkecil.png");
    malinRemaja = loadImage("malinremaja.png");
    malinDewasa = loadImage("malinbesar.png");
  } catch (Exception e) {
    println("Satu atau lebih gambar karakter tidak ditemukan, akan menggunakan placeholder berwarna.");
    // Jika gambar tidak ada, buat placeholder untuk menghindari error
    malinKecil = createImage(100, 150, RGB);
    malinRemaja = createImage(120, 180, RGB);
    malinDewasa = createImage(140, 200, RGB);

    // Fill dengan warna placeholder yang berbeda
    malinKecil.loadPixels();
    for (int i = 0; i < malinKecil.pixels.length; i++) malinKecil.pixels[i] = color(255, 100, 100, 200); // Merah
    malinKecil.updatePixels();

    malinRemaja.loadPixels();
    for (int i = 0; i < malinRemaja.pixels.length; i++) malinRemaja.pixels[i] = color(100, 255, 100, 200); // Hijau
    malinRemaja.updatePixels();

    malinDewasa.loadPixels();
    for (int i = 0; i < malinDewasa.pixels.length; i++) malinDewasa.pixels[i] = color(100, 100, 255, 200); // Biru
    malinDewasa.updatePixels();
  }
}

void draw() {
  int currentTime = millis() - programStartTime;

  // Perpanjang durasi program menjadi 160 detik (02:40)
  if (currentTime >= 160000) {
    if (!programEnded) {
      programEnded = true;
      programStartTime = millis(); // Loop animasi dari awal
    }
  }

  // --- MANAJEMEN ADEGAN & UPDATE STATUS (Dari Kode 1) ---
  // Scene 1: 0-50 detik (Pemandangan awal)
  if (currentTime < 50000) {
    showCharacter = false;
    showShip = false;
    timeOfDay = 0.0;
  }
  // Scene 2: 50-81 detik (Malin tumbuh)
  else if (currentTime < 81000) {
    if (!showCharacter) { // Inisialisasi sekali saat scene mulai
      showCharacter = true;
      scene2StartTime = millis();
    }
    showShip = false;
    updateTimeOfDay(); // Transisi waktu lambat (pagi-malam-pagi)
  }
  // Scene 3: 81-150 detik (Malin merantau)
  else if (currentTime < 150000) {
    if (!showShip) { // Inisialisasi sekali saat scene mulai
      showShip = true;
      scene3StartTime = millis();
      kapalStartTime = millis(); // Reset gerak kapal
    }
    showCharacter = false;
    timeOfDay = 0.0; // Tetap pagi
  }
  // Scene 4 (Baru): 150-159 detik (Transisi waktu cepat)
  else if (currentTime < 159000) {
    showCharacter = false;
    showShip = false;
    timeOfDay = map(currentTime, 150000, 159000, 0.0, 1.0); // Pagi -> Malam dalam 9 detik
  }
  // Adegan Penutup: 159-160 detik
  else {
    showCharacter = false;
    showShip = false;
    timeOfDay = 1.0; // Tetap di kondisi malam
  }

  // Update subtitle berdasarkan waktu
  updateSubtitle(currentTime);

  // --- PROSES MENGGAMBAR SEMUA ELEMEN VISUAL ---
  drawSky();
  drawSunMoon();
  drawBackground();
  drawExtraMountains();

  if (showShip) {
    // Tampilan khusus untuk adegan kapal
    drawSeaAndDistantWaves();
    drawShip(); // Memanggil fungsi kapal yang telah diperbarui
    drawBeach();
    drawPier();
    drawForegroundFoam();
  } else {
    // Tampilan untuk adegan tanpa kapal (Scene 1, 2, 4)
    drawSea();
    if (showCharacter) {
      drawWaves();
    } else {
      drawWavesScene1();
    }
    drawBeach();
    drawHouse();
    if (showCharacter) {
      drawMalin();
    }
  }

  // Gambar subtitle di lapisan paling atas
  drawSubtitle();
}

// ==================================================================
// BAGIAN 3: FUNGSI NARASI & MANAJEMEN WAKTU (Dari Kode 1)
// Mengatur subtitle dan transisi siang-malam.
// ==================================================================

void updateSubtitle(int currentTime) {
  float timeInSeconds = currentTime / 1000.0;
  showSubtitle = false;
  currentSubtitle = "";

  if (timeInSeconds >= 0 && timeInSeconds <= 7) {
    showSubtitle = true;
    currentSubtitle = "Suatu hari di pesisir laut Sumatera Barat, hiduplah seorang ibu\ndan anak bernama Malin yang hidup dalam kesederhanaan.";
  } else if (timeInSeconds >= 21 && timeInSeconds <= 48) {
    showSubtitle = true;
    if (timeInSeconds <= 34) {
      currentSubtitle = "Malin:\n\"Ibu, pasti ibu lelah berjualan ikan seharian di pasar.\nAku janji, suatu hari nanti aku akan sukses dan membuat ibu bahagia.\"";
    } else {
      currentSubtitle = "Ibu:\n\"Aamiin nak. Ibu selalu doakan kamu agar kelak menjadi\nanak yang sukses.\"";
    }
  } else if (timeInSeconds >= 75 && timeInSeconds <= 81) {
    showSubtitle = true;
    currentSubtitle = "\"Saatnya aku merantau agar bisa menjadi orang sukses\ndan membanggakan ibuku.\"";
  } else if (timeInSeconds >= 81 && timeInSeconds <= 88) {
    showSubtitle = true;
    currentSubtitle = "Keesokan harinya, sebuah kapal dagang besar\ntiba di pelabuhan kampung Malin.";
  } else if (timeInSeconds >= 88 && timeInSeconds <= 95) {
    showSubtitle = true;
    currentSubtitle = "Nahkoda:\n\"Kami membutuhkan anak muda yang kuat untuk\nbekerja di kapal dagang ini.\"";
  } else if (timeInSeconds >= 95 && timeInSeconds <= 105) {
    showSubtitle = true;
    currentSubtitle = "Malin:\n\"Pak Nahkoda, izinkan saya ikut berlayar.\nSaya akan bekerja keras!\"";
  } else if (timeInSeconds >= 105 && timeInSeconds <= 115) {
    showSubtitle = true;
    currentSubtitle = "Nahkoda:\n\"Baiklah, tapi ini perjalanan yang sangat jauh dan berbahaya.\nApakah kamu yakin?\"";
  } else if (timeInSeconds >= 115 && timeInSeconds <= 125) {
    showSubtitle = true;
    currentSubtitle = "Malin:\n\"Saya sudah bertekad, Pak. Demi masa depan yang lebih baik\nuntuk saya dan ibu saya.\"";
  } else if (timeInSeconds >= 125 && timeInSeconds <= 135) {
    showSubtitle = true;
    currentSubtitle = "Malin bergegas pulang untuk pamit kepada ibunya\ndan mengambil barang-barangnya.";
  } else if (timeInSeconds >= 135 && timeInSeconds < 150) {
    showSubtitle = true;
    currentSubtitle = "Dengan harapan besar di hati, Malin Kundang\nmeninggalkan kampung halamannya untuk merantau.";
  } else if (timeInSeconds >= 150 && timeInSeconds < 159) {
    showSubtitle = true;
    currentSubtitle = "Beberapa tahun berlalu dengan cepat...";
  }
}

void drawSubtitle() {
  if (showSubtitle && currentSubtitle.length() > 0) {
    fill(0, 0, 0, 150);
    noStroke();
    rect(0, height - 80, width, 80);
    stroke(255, 255, 255, 100);
    strokeWeight(1);
    line(0, height - 80, width, height - 80);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(currentSubtitle, width / 2, height - 40);
  }
}

void updateTimeOfDay() {
  int elapsed = millis() - scene2StartTime;
  int timeInCycle = elapsed % transisiInterval;
  int currentCharacter = elapsed / transisiInterval;

  if (currentCharacter < 2) {
    if (timeInCycle <= timeTransitionDuration) {
      timeOfDay = map(timeInCycle, 0, timeTransitionDuration, 0.0, 1.0);
    } else {
      timeOfDay = 1.0;
    }
  } else {
    if (timeInCycle <= timeTransitionDuration) {
      timeOfDay = map(timeInCycle, 0, timeTransitionDuration, 0.0, 1.0);
    } else {
      timeOfDay = 0.0;
    }
  }
}

// ==================================================================
// BAGIAN 4: FUNGSI MENGGAMBAR ELEMEN LINGKUNGAN
// Menggunakan fungsi dari Kode 1 yang sudah mendukung transisi waktu.
// ==================================================================

void drawSky() {
  color morningColor = color(135, 206, 250);
  color eveningColor = color(255, 140, 70);
  color nightColor = color(25, 25, 112);
  color currentSkyColor;

  if (timeOfDay < 0.5) {
    currentSkyColor = lerpColor(morningColor, eveningColor, timeOfDay * 2);
  } else {
    currentSkyColor = lerpColor(eveningColor, nightColor, (timeOfDay - 0.5) * 2);
  }
  background(currentSkyColor);

  if (timeOfDay > 0.7) {
    drawStars();
  }
}

void drawStars() {
  fill(255, 255, 200);
  noStroke();
  randomSeed(12345);
  for (int i = 0; i < 50; i++) {
    float x = random(width);
    float y = random(200);
    float size = random(2, 4);
    float alpha = map(timeOfDay, 0.7, 1.0, 0, 255);
    fill(255, 255, 200, alpha);
    ellipse(x, y, size, size);
  }
  randomSeed((int)millis());
}

void drawSunMoon() {
  pushMatrix();
  translate(sunMoonX, sunMoonY);
  rotate(sunAngle);
  sunAngle += 0.01;
  noStroke();

  if (timeOfDay < 0.5) {
    float sunAlpha = map(timeOfDay, 0, 0.5, 255, 0);
    fill(255, 204, 0, sunAlpha);
    ellipse(0, 0, 60, 60);
    stroke(255, 200, 0, sunAlpha);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float angle = TWO_PI / 8 * i;
      line(cos(angle) * 35, sin(angle) * 35, cos(angle) * 50, sin(angle) * 50);
    }
  }

  if (timeOfDay > 0.3) {
    float moonAlpha = map(timeOfDay, 0.3, 1.0, 0, 255);
    noStroke();
    fill(220, 220, 255, moonAlpha);
    ellipse(0, 0, 50, 50);
    fill(200, 200, 220, moonAlpha * 0.5);
    ellipse(-8, -8, 8, 8);
    ellipse(10, 5, 6, 6);
    ellipse(-2, 12, 4, 4);
  }
  popMatrix();
}

void drawExtraMountains() {
  noStroke();
  color morningMountain = color(90, 180, 100);
  color eveningMountain = color(70, 100, 60);
  color nightMountain = color(30, 50, 35);
  color currentMountainColor;

  if (timeOfDay < 0.5) {
    currentMountainColor = lerpColor(morningMountain, eveningMountain, timeOfDay * 2);
  } else {
    currentMountainColor = lerpColor(eveningMountain, nightMountain, (timeOfDay - 0.5) * 2);
  }
  fill(currentMountainColor);
  ellipse(200, 300, 500, 200);
  ellipse(800, 300, 600, 200);
}

void drawBackground() {
  noStroke();
  color morningMountain = color(100, 200, 120);
  color eveningMountain = color(80, 120, 60);
  color nightMountain = color(40, 60, 40);
  color currentMountainColor;

  if (timeOfDay < 0.5) {
    currentMountainColor = lerpColor(morningMountain, eveningMountain, timeOfDay * 2);
  } else {
    currentMountainColor = lerpColor(eveningMountain, nightMountain, (timeOfDay - 0.5) * 2);
  }
  fill(currentMountainColor);
  ellipse(250, 350, 300, 150);
  ellipse(600, 350, 400, 180);

  float cloudAlpha = map(timeOfDay, 0, 1, 255, 100);
  fill(255, cloudAlpha);
  ellipse(200, 100, 100, 50);
  ellipse(250, 100, 80, 40);
  ellipse(230, 80, 60, 30);
  ellipse(800, 120, 120, 60);
  ellipse(850, 120, 90, 45);
  ellipse(825, 100, 70, 35);
}

void drawSea() {
  noStroke();
  for (int y = 280; y < height; y++) {
    float inter = map(y, 280, height, 0, 1);
    color morningTop = color(0, 191, 255);
    color morningBottom = color(0, 100, 200);
    color eveningTop = color(0, 100, 180);
    color eveningBottom = color(0, 60, 120);
    color nightTop = color(0, 50, 100);
    color nightBottom = color(0, 30, 80);
    color currentTopColor, currentBottomColor;

    if (timeOfDay < 0.5) {
      currentTopColor = lerpColor(morningTop, eveningTop, timeOfDay * 2);
      currentBottomColor = lerpColor(morningBottom, eveningBottom, timeOfDay * 2);
    } else {
      currentTopColor = lerpColor(eveningTop, nightTop, (timeOfDay - 0.5) * 2);
      currentBottomColor = lerpColor(eveningBottom, nightBottom, (timeOfDay - 0.5) * 2);
    }
    color c = lerpColor(currentTopColor, currentBottomColor, inter);
    fill(c);
    rect(0, y, width, 1);
  }
}

void drawSeaAndDistantWaves() {
  noStroke();
  for (int y = 280; y < height; y++) {
    float inter = map(y, 280, height, 0, 1);
    color c = lerpColor(color(0, 191, 255), color(0, 100, 200), inter);
    fill(c);
    rect(0, y, width, 1);
  }
  waveOffset += waveSpeed;
  drawWaveLine(320, 0.01, 15, 10, 6, color(0, 120, 255, 200));
  drawWaveLine(340, 0.015, 10, 8, 5, color(30, 150, 255, 180));
  drawWaveLine(360, 0.02, 8, 6, 4, color(60, 180, 255, 160));
  drawWaveLine(380, 0.025, 6, 4, 3, color(100, 200, 255, 140));
}

void drawBeach() {
  fill(255, 218, 185);
  noStroke();
  beginShape();
  vertex(0, 450);
  for (int x = 0; x <= width; x += 20) {
    float y = 450 + sin(x * 0.01) * 15 + noise(x * 0.01) * 10;
    vertex(x, y);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

void drawPier() {
  fill(110, 70, 40);
  noStroke();
  for (int i = 0; i < 8; i++) {
    float x_pos = 100 + i * 50;
    float y_start = 440 - i * 15;
    float y_end = y_start + 80 + i * 5;
    rect(x_pos - 5, y_start, 10, y_end - y_start);
    rect(x_pos + 45, y_start, 10, y_end - y_start);
  }
  fill(160, 120, 80);
  stroke(130, 90, 60);
  strokeWeight(2);
  quad(50, 470, 150, 470, 520, 340, 480, 340);
  for (int i = 0; i < 10; i++) {
    float startY = 470 - i * 14;
    float endY = 340;
    float startX1 = map(startY, 470, endY, 50, 480);
    float startX2 = map(startY, 470, endY, 150, 520);
    line(startX1, startY, startX2, startY);
  }
}

void drawForegroundFoam() {
  noStroke();
  fill(255, 255, 255, 180);
  for (int i = 0; i < width; i += 25) {
    float x = i + random(-6, 6);
    float y = 380 + sin((i * 0.01) + waveOffset) * 10 + random(-4, 4);
    boolean onPier = (x > 50 && x < 520 && y > 340 && y < 470);
    boolean onShip = (kapalBerjalan && x > kapalX - 180 && x < kapalX + 180 && y > kapalY - 20 && y < kapalY + 80);
    if (!onPier && !onShip && sin((i * 0.05) + waveOffset * 3) > 0.2) {
      ellipse(x, y, random(10, 18), random(4, 10));
    }
  }
  fill(255, 255, 255, 120);
  for (int i = 0; i < width; i += 40) {
    float x = i + random(-4, 4);
    float y = 400 + sin((i * 0.015) + waveOffset * 2) * 6 + random(-2, 2);
    boolean onPier = (x > 50 && x < 520 && y > 340 && y < 470);
    boolean onShip = (kapalBerjalan && x > kapalX - 180 && x < kapalX + 180 && y > kapalY - 20 && y < kapalY + 80);
    if (!onPier && !onShip && sin((i * 0.08) + waveOffset * 4) > 0.4) {
      ellipse(x, y, random(6, 12), random(2, 6));
    }
  }
}

void drawWaveLine(float baseY, float freq, float noiseAmp, float sinAmp, float weight, color c) {
  stroke(c);
  strokeWeight(weight);
  noFill();
  beginShape();
  for (int x = 0; x <= width; x += width / wavePoints) {
    float y = baseY + sin((x * freq) + waveOffset) * sinAmp + noise(x * freq * 0.5, waveOffset) * noiseAmp;
    vertex(x, y);
  }
  endShape();
}

void drawWaves() {
  waveOffset += waveSpeed;
  drawWaveLine(380, 0.02, 8, 6, 4, color(60, 180, 255, 100));
  drawWaveLine(420, 0.025, 6, 4, 3, color(100, 200, 255, 80));
}

void drawWavesScene1() {
  waveOffset += waveSpeed;
  drawWaveLine(360, 0.02, 8, 6, 4, color(60, 180, 255, 160));
  drawWaveLine(400, 0.03, 4, 3, 2, color(130, 220, 255, 120));
}

// ==================================================================
// BAGIAN 5: FUNGSI MENGGAMBAR ELEMEN KARAKTER & OBJEK UTAMA
// ==================================================================

void drawMalin() {
  int elapsed = millis() - scene2StartTime;
  int currentCharacterIndex = elapsed / transisiInterval;
  if (currentCharacterIndex > 2) currentCharacterIndex = 2;

  int timeInCurrentCharacter = elapsed % transisiInterval;
  int fadeDuration = 1000;

  PImage currentMalin;
  PImage nextMalin = null;
  float currentScale, nextScale = 0;

  if (currentCharacterIndex == 0) {
    currentMalin = malinKecil;
    nextMalin = malinRemaja;
    currentScale = 0.6;
    nextScale = 0.75;
  } else if (currentCharacterIndex == 1) {
    currentMalin = malinRemaja;
    nextMalin = malinDewasa;
    currentScale = 0.75;
    nextScale = 0.9;
  } else {
    currentMalin = malinDewasa;
    currentScale = 0.9;
  }

  imageMode(CENTER);
  float adjustedX = karakterX + 180;
  float adjustedY = karakterY - 70;

  if (nextMalin != null && timeInCurrentCharacter >= transisiInterval - fadeDuration && currentCharacterIndex < 2) {
    float t = map(timeInCurrentCharacter, transisiInterval - fadeDuration, transisiInterval, 0, 1);
    tint(255, 255 * (1 - t));
    image(currentMalin, adjustedX, adjustedY, currentMalin.width * currentScale, currentMalin.height * currentScale);
    tint(255, 255 * t);
    image(nextMalin, adjustedX, adjustedY, nextMalin.width * nextScale, nextMalin.height * nextScale);
  } else {
    tint(255, 255);
    image(currentMalin, adjustedX, adjustedY, currentMalin.width * currentScale, currentMalin.height * currentScale);
  }
  noTint();
}

// ========== FUNGSI KAPAL YANG DIPERBARUI (VISUAL DARI KODE 2) ==========
void drawShip() {
  int elapsedTime = millis() - kapalStartTime;

  // Logika pergerakan kapal (dari Kode 1)
  if (kapalBerjalan) {
    if (elapsedTime <= kapalDurasiGerak) {
      float t = map(elapsedTime, 0, kapalDurasiGerak, 0, 1);
      kapalX = lerp(900, kapalTargetX, t);
    } else if (elapsedTime <= kapalDurasiGerak + kapalDiamDurasi) {
      kapalX = kapalTargetX;
      kapalDiam = true;
    } else if (elapsedTime <= kapalDurasiGerak + kapalDiamDurasi + kapalGerakKiriDurasi) {
      float t = map(elapsedTime, kapalDurasiGerak + kapalDiamDurasi, kapalDurasiGerak + kapalDiamDurasi + kapalGerakKiriDurasi, 0, 1);
      kapalX = lerp(kapalTargetX, kapalTargetKiriX, t);
    } else {
      kapalBerjalan = false;
      kapalBerhenti = true;
    }
  }

  pushMatrix();
  translate(kapalX, kapalY); // Gunakan variabel global kapalX dan kapalY untuk posisi
  
  // Efek goyangan dan skala (dari Kode 2)
  float tilt = sin(frameCount * 0.03) * 0.08;
  rotate(tilt);
  scale(1.5); // Menggunakan skala dari Kode 2 yang lebih detail

  // --- Mulai Kode Menggambar Kapal dari Kode 2 ---
  stroke(60, 30, 10);
  strokeWeight(4);
  fill(180, 100, 50);
  beginShape();
  vertex(-120, 10); vertex(-100, 40); vertex(-80, 45); vertex(0, 50);
  vertex(80, 45); vertex(100, 40); vertex(120, 10); vertex(100, -5);
  vertex(80, -10); vertex(0, -15); vertex(-80, -10); vertex(-100, -5);
  endShape(CLOSE);

  fill(200, 120, 70);
  strokeWeight(3);
  rect(-90, -15, 180, 25, 5);

  stroke(120, 60, 30);
  strokeWeight(2);
  for (int i = -1; i <= 4; i++) line(-100, i * 8, 100, i * 8);
  for (int i = -8; i <= 8; i++) line(i * 12, -10, i * 12, 35);

  stroke(60, 30, 10);
  strokeWeight(4);
  fill(160, 90, 45);
  triangle(-120, 10, -140, 0, -120, -5);
  fill(160, 90, 45);
  beginShape(); vertex(120, 10); vertex(130, 5); vertex(130, -5); vertex(120, -5); endShape(CLOSE);

  stroke(60, 30, 10);
  strokeWeight(8);
  float mastSway = sin(frameCount * 0.05) * 2;
  line(0, -15, mastSway, -180);

  strokeWeight(5);
  line(-80 + mastSway, -160, 80 + mastSway, -160);
  line(-70 + mastSway, -120, 70 + mastSway, -120);
  line(-60 + mastSway, -80, 60 + mastSway, -80);

  stroke(100, 100, 90);
  strokeWeight(3);
  fill(250, 250, 240);
  beginShape();
  vertex(-70 + mastSway, -180);
  bezierVertex(-60 + mastSway, -175, -60 + mastSway, -125, -70 + mastSway, -120);
  vertex(70 + mastSway, -120);
  bezierVertex(60 + mastSway, -125, 60 + mastSway, -175, 70 + mastSway, -180);
  endShape(CLOSE);

  stroke(200, 200, 190);
  strokeWeight(1);
  for (int i = -170; i <= -130; i += 12) line(-65 + mastSway, i, 65 + mastSway, i);

  stroke(60, 30, 10);
  strokeWeight(6);
  line(60, -15, 60 + mastSway * 0.5, -120);

  stroke(100, 100, 90);
  strokeWeight(2);
  fill(245, 245, 235);
  beginShape();
  vertex(60 + mastSway * 0.5, -120);
  bezierVertex(80 + mastSway * 0.5, -115, 80 + mastSway * 0.5, -70, 60 + mastSway * 0.5, -65);
  vertex(35 + mastSway * 0.5, -65);
  bezierVertex(40 + mastSway * 0.5, -70, 40 + mastSway * 0.5, -115, 60 + mastSway * 0.5, -120);
  endShape(CLOSE);

  stroke(60, 30, 10);
  strokeWeight(3);
  fill(140, 80, 40);
  rect(-40, -35, 80, 25, 3);
  fill(120, 70, 35);
  rect(-45, -40, 90, 8, 2);

  stroke(40, 60, 80);
  strokeWeight(2);
  fill(120, 160, 200);
  rect(-30, -25, 15, 10);
  rect(-7, -25, 15, 10);
  rect(15, -25, 15, 10);

  stroke(60, 30, 10);
  strokeWeight(3);
  line(-80, -15, -80 + mastSway * 0.3, -50);

  fill(200, 50, 50);
  stroke(150, 40, 40);
  strokeWeight(1);
  float flagSway = sin(frameCount * 0.1) * 3;
  beginShape();
  vertex(-80 + mastSway * 0.3, -50);
  vertex(-80 + mastSway * 0.3, -40);
  vertex(-65 + flagSway, -45);
  endShape(CLOSE);

  noStroke();
  fill(0, 0, 0, 50);
  ellipse(0, 65, 280, 30);
  fill(0, 0, 0, 30);
  ellipse(0, 70, 200, 15);
  // --- Akhir Kode Menggambar Kapal dari Kode 2 ---
  
  popMatrix();
}

void drawHouse() {
  pushMatrix();
  translate(250, 320);
  scale(3);
  fill(0, 0, 0, 80);
  noStroke();
  ellipse(20, 80, 100, 25);
  stroke(80, 50, 30);
  strokeWeight(4);
  fill(139, 90, 60);
  rect(-55, 20, 12, 60);
  rect(50, 20, 12, 60);
  noStroke();
  fill(160, 120, 80);
  rect(-60, 10, 130, 15);
  stroke(120, 90, 60);
  strokeWeight(1);
  noFill();
  rect(-60, 10, 130, 15);
  noStroke();
  fill(205, 140, 90);
  rect(-55, -60, 110, 70);
  stroke(150, 100, 70);
  strokeWeight(1.5);
  noFill();
  rect(-55, -60, 110, 70);
  stroke(170, 110, 70);
  strokeWeight(1);
  for (int i = -55; i < 5; i += 12) line(-55, i, 55, i);
  noStroke();
  fill(30, 120, 200);
  rect(-40, -45, 25, 25);
  stroke(60, 40, 20);
  strokeWeight(1);
  noFill();
  rect(-40, -45, 25, 25);
  line(-40, -32, -15, -32);
  line(-27, -45, -27, -20);
  noStroke();
  fill(120, 80, 50);
  rect(10, -30, 35, 40);
  stroke(80, 50, 30);
  strokeWeight(1);
  noFill();
  rect(10, -30, 35, 40);
  fill(255, 215, 0);
  noStroke();
  ellipse(40, -10, 8, 8);
  stroke(80, 50, 30);
  noFill();
  rect(15, -25, 25, 30);
  line(15, -10, 40, -10);
  noStroke();
  fill(139, 60, 40);
  beginShape();
  vertex(-65, -60);
  vertex(0, -100);
  vertex(65, -60);
  endShape(CLOSE);
  stroke(100, 40, 30);
  strokeWeight(1);
  noFill();
  beginShape();
  vertex(-65, -60);
  vertex(0, -100);
  vertex(65, -60);
  endShape(CLOSE);
  noStroke();
  fill(180, 120, 80);
  int anakTangga = 7;
  for (int i = 0; i < anakTangga; i++) rect(-25, 20 + i * 8, 50, 8);
  stroke(130, 90, 60);
  strokeWeight(1);
  noFill();
  for (int i = 0; i < anakTangga; i++) rect(-25, 20 + i * 8, 50, 8);
  popMatrix();
}
