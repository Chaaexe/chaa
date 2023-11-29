//Muhammad Nursan
//2105176010

PImage jalan, mobil, musuh, home;
float x, y, mobilx, mobily;
float[] musuhx, musuhy;
float speed = 5;  // Kecepatan pergerakan jalan dan musuh
boolean gameStarted = false;  // Status permainan dimulai
boolean gameOver = false;  // Status game over
int jumlahMusuh = 3;  // Jumlah musuh 
int score = 0;
int highscore = 0;

void setup(){
  size(700,900);
  jalan = loadImage("https://github.com/Chaaexe/chaa/blob/main/ucha/data/jalan.png");
  mobil = loadImage("https://github.com/Chaaexe/chaa/blob/main/ucha/data/mobil.png");
  musuh = loadImage("https://github.com/Chaaexe/chaa/blob/main/ucha/data/musuh.png");
  home = loadImage("https://github.com/Chaaexe/chaa/blob/main/ucha/data/home.png");

  x = width / 2 - mobil.width / 2;  // Mengatur posisi awal mobil di tengah layar
  mobily = height / 1.3 - mobil.height / 2;  // Mengatur posisi awal mobil di bagian bawah layar
  
  // Inisialisasi array untuk dua musuh
  musuhx = new float[jumlahMusuh];
  musuhy = new float[jumlahMusuh];
  
  for (int i = 0; i < jumlahMusuh; i++) {
  resetMusuh(i);
  }
}
  
void draw() {
  if (gameOver) {
    // Tampilkan layar homescreen jika game over
    showHomeScreen();
  } else if (!gameStarted) {
    // Tampilkan layar homescreen jika permainan belum dimulai
    showHomeScreen();
  } else {
    // Mode permainan
    gameMode();
  }
}

void keyPressed() {
  if (!gameStarted) {
    // Jika tombol apa pun ditekan saat berada di layar homescreen, mulai permainan
    gameStarted = true;
    
  } else if (!gameOver) {
    // Pergerakan mobil saat tombol panah kiri atau kanan ditekan
    if (keyCode == LEFT) {
      x -= 10;  // Ubah sesuai kebutuhan
    } else if (keyCode == RIGHT) {
      x += 10;  // Ubah sesuai kebutuhan
    }

    // Batasi posisi mobil agar tetap dalam batas layar
    x = constrain(x, 180, 450);
  }
}

void mousePressed() {
  if (gameOver || !gameStarted) {
    // Reset game jika mouse ditekan setelah game over atau saat berada di layar homescreen
    resetGame();
  }
}

// Fungsi untuk menampilkan layar homescreen
void showHomeScreen() {
  background(255);  // Ganti warna latar belakang sesuai kebutuhan
  imageMode(CENTER);
  image(home, width / 2, height / 2);
  textSize(30);
  fill(255);
  textFont(createFont("https://github.com/Chaaexe/chaa/blob/main/ucha/data/pixel.otf", 20));
  textAlign(CENTER, CENTER);
  text("Press ENTER to start the game", width / 2, 600);

  // Perbarui highscore jika skor saat ini lebih tinggi
  textFont(createFont("https://github.com/Chaaexe/chaa/blob/main/ucha/data/pixel.otf", 35));
  highscore = max(score, highscore);
  text("Highscore: " + highscore, width / 2, 550);
}

void gameMode(){
    imageMode(CORNER);
    image(jalan, 0, y);
    image(jalan, 0, y - jalan.height);
    image(mobil, x, mobily);
        
    for (int i = 0; i < jumlahMusuh; i++) {
      image(musuh, musuhx[i], musuhy[i]);
    }
    
    y += speed;  // Pergerakan jalan
  
    for (int i = 0; i < jumlahMusuh; i++) {
      musuhy[i] += speed;
    }
    
    // Deteksi tabrakan dengan setiap musuh
    for (int i = 0; i < jumlahMusuh; i++) {
      if (dist(x, mobily, musuhx[i], musuhy[i]) < mobil.width / 2 + musuh.width / 2) {
        // Mobil menabrak musuh, game over
        gameOver = true;
      }
    }
  
    // Jika musuh mencapai batas bawah layar, reset posisi ke luar layar atas dengan posisi horizontal yang acak
    for (int i = 0; i < jumlahMusuh; i++) {
      if (musuhy[i] > height) {
        resetMusuh(i);
        
        // Tambah skor setiap kali musuh melewati mobil
        score++;
      }
    }
    
    // Tampilkan skor
    fill(255);
    textFont(createFont("https://github.com/Chaaexe/chaa/blob/main/ucha/data/pixel.otf", 18));
    text("Score:" + score, 65, 20);

    // Perbarui highscore jika skor saat ini lebih tinggi
    fill(255, 135, 0);
    highscore = max(score, highscore);
    text("Highscore:" + highscore, 90, 40);
    
    y += 5;  // Ubah nilai ini sesuai kecepatan pergerakan
    if (y >= jalan.height) {
      y = 0;
    }
  }
  
// Fungsi untuk mereset permainan
void resetGame() {
  y = 0;
  gameOver = false;
  gameStarted = false;
  for (int i = 0; i < jumlahMusuh; i++) {
    resetMusuh(i);
  }
  score = 0;
  
}

// Fungsi untuk mengatur posisi awal musuh
void resetMusuh(int index) {
  float minJarak = 150;  // Jarak minimum antara dua musuh

  float newX = random(180, 450);
  float newY = -random(100, 400);

  // Pemeriksaan jarak dengan musuh yang sudah ada
  for (int i = 0; i < jumlahMusuh; i++) {
    float jarak = dist(newX, newY, musuhx[i], musuhy[i]);
    if (i != index && jarak < minJarak) {
      // Jika jarak terlalu dekat, atur ulang posisi musuh
      resetMusuh(index);
      return;
    }
  }

  // Jika jarak cukup jauh, set posisi musuh baru
  musuhx[index] = newX;
  musuhy[index] = newY;
}
