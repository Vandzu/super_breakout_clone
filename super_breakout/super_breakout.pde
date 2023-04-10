//PARA QUE A APLICAÇÃO FUNCIONE CORRETAMENTE SERÁ NECESSÁRIO INSTALAR A BIBLIOTECA Minim //<>//
//se não for possível instalar, terá que comentar as seguintes linhas: 6, 7, 25-31, 98, 99, 131, 132, 258, 259, 267, 268, 286, 287, 312, 313

import ddf.minim.*;
Player rplayer;
ArrayList<Inimigo> Inimigos;
Ball b, b2;
InimigoMovel InMo;
PFont fontpadrao;
Minim minim;
AudioPlayer som, som2, bg, gameover, win;
float mx;
int pontos = 0;
int countxRects = 0;
int desceInimigos = 0;
int hue = 0;
int espacoEntreInimigos = 0;
int stateGame = 0;
int vidas = 3;
int rewindGameover = 0;
int rewindWin = 0;

void setup() {
  size(650, 550);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  fontpadrao = createFont("Pixellari.ttf", 32);
  textFont(fontpadrao);
  minim = new Minim(this);
  som = minim.loadFile("bolasom2.wav");
  som2 = minim.loadFile("bolasom1.wav");
  bg = minim.loadFile("background.mp3");
  win = minim.loadFile("win.wav");
  gameover = minim.loadFile("gameover.wav");
  bg.loop();
  b = new Ball(random(100, 545), 250, 5, 5);
  b2 = new Ball(random(100, 545), 250, 5, 5);
  Inimigos = new ArrayList<Inimigo>();
  rplayer = new Player(515, 80, 10);

  criaInimigosIniciais();
  InMo = new InimigoMovel();
}

void criaInimigosIniciais() {
  for (int j=0; j<7; j++) {
    for (int i=0; i<11; i++) {
      if (j!=3) {
        Inimigos.add(new Inimigo(50+i*50, 200-j*15, hue));
      }
    }
    hue+=30;
  }
}

void metodosInimigos() {
  for (int i=0; i<Inimigos.size(); i++) {
    Inimigos.get(i).mostraInimigos();
    Inimigos.get(i).movimentaInimigos();
    if (desceInimigos == 8 && i==Inimigos.size()-1) {
      desceInimigos = 1;
    }
  }
}

void cenario() {
  fill(120);
  rect(0, 50, 50, height);
  rect(600, 50, 50, height);
  rect(50, 50, 550, 15);
}

void placares() {
  textSize(50);
  fill(255);
  text(pontos, 50, 40);
  text(vidas, 570, 40);
  if (vidas==0) {
    stateGame = 3;
  }
}

void gerenciaEstados() {
  textAlign(CENTER);

  if (stateGame == 0) {
    textSize(18);
    text("Clique com o botão esquerdo do mouse para começar", width/2, 300);
    rplayer.movimentaPlayer(mx);
    b.mostraBola();
    b2.mostraBola();
    InMo.calcX();
    InMo.InimigoMovelMov();
  } else if (stateGame == 1) {
    b.movimentaBola();
    b2.movimentaBola();
    rplayer.movimentaPlayer(mx);
    b.mostraBola();
    b2.mostraBola();
    InMo.calcX();
    InMo.InimigoMovelMov();
    if (Inimigos.size()==0) {
      stateGame=6;
    }
  } else if (stateGame == 2) {
    textSize(18);
    text("Clique com o botão esquerdo do mouse para continuar", width/2, 300);
    rplayer.movimentaPlayer(mx);
    b.mostraBola();
    b2.mostraBola();
  } else if (stateGame==3) {
    if (rewindGameover == 0) {
      gameover.rewind();
      gameover.play();
    }
    rewindGameover=1;
    desceInimigos=0;
    textSize(20);
    text("Clique com o botão direito do mouse para reiniciar", width/2, 340);
    textSize(40);
    text("GAME OVER", width/2, 300);
  } else if (stateGame == 4) {
    if (Inimigos.size()!=0) {
      for (int i=0; i<Inimigos.size(); i++) {
        Inimigos.remove(i);
      }
    } else {
      stateGame = 5;
    }
  } else if (stateGame == 5) {
    for (int j=0; j<7; j++) {
      for (int i=0; i<11; i++) {
        if (j!=3) {
          Inimigos.add(new Inimigo(50+i*50, 200-j*15, hue));
        }
      }
      hue+=30;

      if (hue >=360) {
        hue=0;
      }
    }
    stateGame = 0;
    b.by = Inimigos.get(0).y+45;
    b2.by = Inimigos.get(0).y+45;
  } else if (stateGame == 6) {
    if (rewindWin==0) {
      win.rewind();
      win.play();
    }
    rewindWin = 1;
    rplayer.movimentaPlayer(mx);
    b.mostraBola();
    b2.mostraBola();
    textSize(18);
    text("Clique com o botão direito do mouse para reiniciar o jogo", width/2, 340);
    textSize(26);
    text("Parabéns!! Você Venceu!", width/2, 300);
  }
}

void mousePressed() {
  if ((mouseButton == LEFT) && (stateGame == 0 || stateGame == 2)) {
    stateGame = 1;
  } else if (mouseButton == RIGHT && (stateGame == 3 || stateGame == 6)) {
    rewindWin = 0;
    rewindGameover=0;
    vidas = 3;
    pontos = 0;
    stateGame = 4;
    b.bx = random(100, 545);
    b2.bx = random(100, 545);
  }
}



void geraNovosInimigos() {
  if (desceInimigos==8) {
    espacoEntreInimigos ++;

    if (espacoEntreInimigos<4) {
      for (int i=0; i<11; i++) {
        Inimigos.add((new Inimigo(50+i*50, 75, hue)));

        if (i == 10) {
          hue += 30;
        }

        if (hue >=360) {
          hue=0;
        }
      }
    }
  }

  if (espacoEntreInimigos == 5) {
    espacoEntreInimigos = 0;
  }
}

class Player {
  float py, pw, ph;
  Player(float posy, float pw__, float ph__) {
    py = posy;
    pw = pw__;
    ph = ph__;
  }

  void movimentaPlayer(float x__) {
    fill(0, 0, 100);
    rect(x__, py, 80, 15);
  }
}

class Inimigo {
  float x, y, w, h, points;
  int hue;
  Inimigo(float posx, float posy, int hue__) {
    x = posx;
    y = posy;
    w = 50;
    h = 15;
    hue = hue__;
  }

  void mostraInimigos() {
    fill(hue, 80, 80);
    rect(x, y, w, h);
  }

  void movimentaInimigos() {
    if (desceInimigos == 8) {
      y += 15;
    }
  }
}

class Ball {
  float bx, by, xspeed, yspeed, r;
  int hueb;
  boolean colideplayer = false;
  boolean colideparede = false;
  boolean colideteto = false;
  boolean colideInimigoMovel = false;
  Ball (float _x, float _y, float _xspeed, float _yspeed) {
    bx=_x;
    by=_y;
    r = 5;
    xspeed=_xspeed;
    yspeed=_yspeed;
    hueb = 0;
  }

  void mostraBola () {
    fill(hueb, 80, 80);
    circle(bx, by, r*2);
  }

  void movimentaBola () {
    bx=bx+xspeed;
    by=by+yspeed;
  }

  void colisoes () {
    //colisao com as bordas
    if ((bx+r>=width-50 || bx-r<=50) && colideparede == false) {
      if (bx-r<=50) {
        bx = 56;
      } else {
        bx = width-56;
      }

      xspeed = xspeed*-1;
      colideparede = true;
      som.rewind();
      som.play();
    } else {
      colideparede = false;
    }

    if (by-r<=65 && colideteto == false) {
      colideteto = true;
      yspeed=yspeed*-1;
      som.rewind();
      som.play();
    } else {
      colideteto = false;
    }

    if (b.by-r>=550 && b2.by-r>=550) {
      stateGame=2;
      b.bx = random(100, 545);
      b2.bx = random(100, 545);
      b.by = 250;
      b2.by = 250;
      vidas -= 1;
      xspeed = 5;
      yspeed = 5;
    }
    //colisao com Player
    if (bx+r>=mx && bx-r <= mx+rplayer.pw && by>=rplayer.py && by <= rplayer.py+rplayer.ph && colideplayer == false) {
      yspeed = yspeed*-1;
      colideplayer = true;
      desceInimigos += 1;
      som.rewind();
      som.play();
      //aumentavelocidade da bola
      if (xspeed >=8 || xspeed <= -8) {
        xspeed = xspeed*-1.;
        yspeed = yspeed*1;
      } else {
        xspeed = xspeed*-1.05;
        yspeed = yspeed*1.05;
      }

      if (bx+r<=mx+rplayer.pw/2 && xspeed>0) {
        xspeed = xspeed*-1;
      }
      if (bx+r> mx+rplayer.pw/2 && xspeed<0) {
        xspeed = xspeed*-1;
      }
    } else {
      colideplayer = false;
    }
    //colisao com Inimigo Movel
    if (bx+r>=InMo.I_Mx && bx-r <= InMo.I_Mx + InMo.I_Mwd && by>=InMo.I_My && by <= InMo.I_My+InMo.I_Mhg && colideInimigoMovel == false) {
      yspeed = yspeed*-1;
      colideInimigoMovel = true;
      desceInimigos += 1;
      som.rewind();
      som.play();
      //aumentavelocidade da bola

      if (bx+r<=InMo.I_Mx+InMo.I_Mwd/2 && xspeed>0) {
        xspeed = xspeed*-1;
      }
      if (bx+r> InMo.I_Mx+InMo.I_Mwd/2 && xspeed<0) {
        xspeed = xspeed*-1;
      }
    } else {
      colideInimigoMovel = false;
    }

    for (int i=0; i<Inimigos.size(); i++) {
      if (bx+5>=Inimigos.get(i).x && bx-5<=Inimigos.get(i).x+50 && by+5>=Inimigos.get(i).y && by-5<=Inimigos.get(i).y+15) {
        yspeed=yspeed*-1;
        pontos += 1;
        som2.rewind();
        som2.play();
        hueb = Inimigos.get(i).hue;
        Inimigos.remove(i);
      }
    }
  }
}

class InimigoMovel {
  float I_Mx, I_My, I_Mwd, I_Mhg, xInc;
  int p = 5;
  int[] posX = new int[p];
  int cont;
  InimigoMovel() {
    I_Mx = 325;
    I_My = Inimigos.get(0).y+20;
    I_Mwd = 80;
    I_Mhg = 15;
    xInc = 10;
  }

  void mostraInimigoMovel() {
    fill(255);
    rect(I_Mx, I_My, I_Mwd, I_Mhg);
  }

  int calcX() {
    int somaX = 0;
    for (int x = 0; x<posX.length; x++)
      somaX = somaX + posX[x];
    return int(somaX/p);
  }

  void InimigoMovelMov() {
    if (I_Mx>=50 && I_Mx<=600) {
      I_Mx += xInc;

      if (b.by+b.r<I_My || b2.by+b2.r<I_My) {
        if (dist(I_Mx, I_My, b.bx, b.by) > dist(I_Mx, I_My, b2.bx, b2.by)) {
          posX[cont % posX.length] = int(b2.bx-40);
        } else {
          posX[cont % posX.length] = int(b.bx-40);
        }

        if (calcX() > I_Mx+80 && I_Mx>60) {
          xInc=-15;
        } else if (calcX() < I_Mx && I_Mx+80<590) {
          xInc=15;
        } else {
          xInc=0;
        }
      } else {
        if (dist(I_Mx, I_My, b.bx, b.by) > dist(I_Mx, I_My, b2.bx, b2.by)) {
          posX[cont % posX.length] = int(b2.bx-40);
        } else {
          posX[cont % posX.length] = int(b.bx-40);
        }

        if (calcX() > I_Mx+80) {
          xInc=15;
        } else if (calcX() < I_Mx) {
          xInc=-15;
        } else {
          xInc=0;
        }
      }
      cont++;
      if (Inimigos.size()>0) {
        I_My = Inimigos.get(0).y+20;
      }
    } else if (I_Mx < 50) {
      I_Mx = 51;
    } else if (I_Mx > 600) {
      I_Mx = 519;
    }
  }
}

void draw() {
  background(0);  
  mx = constrain(mouseX, 50, 520);

  geraNovosInimigos();
  metodosInimigos();
  b.colisoes();
  b2.colisoes();
  cenario();
  placares();
  gerenciaEstados();
  InMo.mostraInimigoMovel();
}
