PImage map_source;
PGraphics map;
boolean[][] bounds, pac_dots, power_pellets;
Index[] encruzilhada;
PVector score_pos;
float[] startingX, startingY;
float fruitX, fruitY;
int[] fruit_values = {100, 300, 500, 700, 1000, 2000, 3000, 5000};
int F, fruit_millis, fruit_score;
TP[] TPs;
Pac pacman;
int ppx, ppy;
Ghost[] ghosts;
PImage[] scared_ghosts, eyeballs, fruits, floating_scores;
PImage life;
AI[] AIs;
boolean blink, pause, game_over, REC;
int ready_millis, power_millis, power_score, nps, killed, score_pause, release_millis, RG;
int score, lives, level;
PFont emulogic;

int pmillis;

float pacV = 0.12;
float ghoV = 0.09;
float eyeV = 0.3;

boolean[] arrow_keys;

void setup() {
  size(573, 663);
  
  emulogic = loadFont("Emulogic-18.vlw");
  textFont(emulogic);
  
  noSmooth();
  build_map( "map og" );
  load_sprites( "spritesheet.png" );
  AIs = new AI[ghosts.length];
  for( int i = 0; i < AIs.length; ++i ) AIs[i] = new Seguidor();
  arrow_keys = new boolean[4];
  rectMode( CENTER );
  
  game_over = false;
  level = 0;
  lives = 2;
  F = -1;
  fruit_millis = millis()+30000;
  RG = 1;
  power_score = 1;
  nps = 1;
  release_millis = millis();
  ready_millis = millis() + 2500;
}

void draw() {
  imageMode( CORNER );
  image( map, 0, 0 );
  
  fill(255);
  textAlign( RIGHT, TOP );
  text( str(score), 156, 28 );
  textAlign( CENTER, TOP );
  text("1UP", 112, 8 );
  text("HIGH SCORE", 286, 8 );
  text("512090", 286, 28 );
  for( int i = 0; i < lives; ++i ){
    image( life, 68 + (i*32), 634 );
  }
  
  scale( 2.24 );
  
  for( int i = 0; i <= level; ++i ){
    image( fruits[i], 212 -(14*i), 282 );
  }
  
  fill(#ffb898);
  boolean win = true;
  for(int j=0; j < bounds[0].length; j++){
    for(int i=0; i < bounds.length; i++){
      if( pac_dots[i][j] ){
        rect( (i+0.5)*8, (j+0.5)*8, 3, 3 );
        win = false;
      }
      if( power_pellets[i][j] ) ellipse( (i+0.5)*8, (j+0.5)*8, 7, 7 );
    }
  }
  if( win ){
    ++level;
    //.loadPixels();
    load_dots_and_pellets( map_source );
    
    pacman.x = startingX[0];
    pacman.y = startingY[0];
    for(int i = 0; i < ghosts.length; ++i ){
      ghosts[i].x = startingX[i+1];
      ghosts[i].y = startingY[i+1];
      ghosts[i].alive = true;
    }
    RG = 1;
    release_millis = millis();
    ready_millis = millis() + 3000;
  }
  
  int PX = floor(pacman.x);
  int PY = floor(pacman.y);
  
  if( millis() < ready_millis || game_over ){
    resetMatrix();
    fill(255, 255, 1);
    String msg = "READY!";
    if( game_over ){
      fill(255, 1, 1);
      msg = "GAME  OVER";
    }
    textAlign( CENTER, CENTER );
    text( msg, 17.92* fruitX, 17.92* fruitY );
    scale( 2.24 );
  }
  else if( millis() < score_pause ){
    imageMode( CENTER );
    for(int i = 0; i < ghosts.length; ++i ) if( i != killed ) ghosts[i].display();
    image( floating_scores[power_score], score_pos.x, score_pos.y );
    power_millis += millis()-pmillis;
  }
  else if( pause ){
    
  }
  else{
    boolean goahead = true;
    if( pacman.alive ){
      pacman.move( arrow_keys );
    }
    else{
      if( pacman.f > pacman.sprites.length ){
        goahead = false;
        pacman.x = startingX[0];
        pacman.y = startingY[0];
        pacman.toggle_life();
        for(int i = 0; i < ghosts.length; ++i ){
          ghosts[i].x = startingX[i+1];
          ghosts[i].y = startingY[i+1];
        }
        --lives;
        if( lives < 0 ) game_over = true;
        RG = 1;
        release_millis = millis();
        fruit_millis = millis() + 25000;
        ready_millis = millis() + 2500;
      }
    }
    PX = floor(pacman.x);
    PY = floor(pacman.y);
    
    if( RG < ghosts.length ){
      if( millis() > release_millis + 4000 ){
        ghosts[RG].x = startingX[1];
        ghosts[RG].y = startingY[1];
        ++RG;
        release_millis = millis();
      }
    }
    
    boolean andou = ( PX != ppx || PY != ppy );
    ppx = PX;
    ppy = PY;
    for( int i = 0; i < AIs.length; ++i ){
      ghosts[i].move( AIs[i].command( ghosts[i], andou ) );
      
      if( ghosts[i].alive ){
        if( dist( ghosts[i].x, ghosts[i].y, pacman.x, pacman.y ) < 0.4 ){
          if( ghosts[i].scared ){
            ghosts[i].toggle_life();
            ghosts[i].x = floor(ghosts[i].x)+0.5;
            ghosts[i].y = floor(ghosts[i].y)+0.5;
            ghosts[i].v = eyeV;
            AIs[i] = new Returner( ghosts[i].x, ghosts[i].y );
            power_score = nps;
            switch(power_score){
              case 1: 
                nps = 3;
                add_score( 200 );
                break;
              case 3: 
                nps = 6; 
                add_score( 400 );
                break;
              case 6: 
                nps = 8; 
                add_score( 800 );
                break;
              case 8:
                add_score( 1600 );
                break;
            }
            killed = i;
            score_pos = new PVector( 8 * ghosts[i].x, 8 * ghosts[i].y );
            score_pause = millis() + 1000;
          }
          else{
            if( pacman.alive ){
              pacman.toggle_life();
              pacman.vx = 0;
              pacman.vy = 0;
            }
          }
        }
      }
      else{
        if( dist( ghosts[i].x, ghosts[i].y, startingX[1], startingY[1] ) < 0.2 ){
          //they should respawn inside the cage...
          AIs[i] = new Seguidor();
          ghosts[i].toggle_life();
          ghosts[i].v = ghoV;
          ghosts[i].scared = false;
        }
      }
    }
    
    if( pac_dots[PX][PY] ){
      pac_dots[PX][PY] = false;
      add_score( 10 );
    }
    if( power_pellets[PX][PY] ){
      power_pellets[PX][PY] = false;
      add_score( 50 );
      for( int j = 0; j < ghosts.length; ++j ) ghosts[j].scared = true;
      power_millis = millis() + 6000;
      blink = false;
    }
    
    int l = power_millis - millis();
    if( l > 0 ){
      if( l < 3000 ){
        if( floor( l / 200.0 ) % 2 == 0 ) blink = true;
        else blink = false;
      }
    }
    else{
      for( int j = 0; j < ghosts.length; ++j ) ghosts[j].scared = false;
      power_score = 1;
      nps = 1;
    }
    
    if( goahead ){
      imageMode( CENTER );
      
      if( F < 0 ){
        if( millis() > fruit_millis ){
          F = level;
          fruit_millis = millis() + 10000;
        }
      }
      else{
        image( fruits[F], 8*fruitX, 8*fruitY );
        if( dist( pacman.x, pacman.y, fruitX, fruitY ) < 0.25 ){
          add_score( fruit_values[F] );
          F = -1;
          fruit_millis = millis() + 30000;
          fruit_score = millis() + 2000;
        }
        if( millis() > fruit_millis ){
          F = -1;
          fruit_millis = millis() + 25000;
        }
      }
      if( fruit_score > millis() ) image( floating_scores[0], 8*fruitX, 8*fruitY );
      
      pacman.display();
      if( pacman.alive ) for(int i = 0; i < ghosts.length; ++i ) ghosts[i].display();
    }
  }
  
  fill(0);  //stroke(255);
  for(int i = 0; i < TPs.length; i++) {
    rect( (TPs[i].origin.i + 0.5)*8, (TPs[i].origin.j + 0.5)*8, 13, 13 );
    if( TPs[i].equals( PX, PY ) ){
      if( abs((pacman.y - PY)-0.5) < pacV && abs((pacman.x - PX)-0.5) < pacV ){
        pacman.x = TPs[i].destination.i + 0.5;
        pacman.y = TPs[i].destination.j + 0.5;
      }
    }
    for( int j = 0; j < ghosts.length; ++j ){
      if( TPs[i].equals( floor(ghosts[j].x), floor(ghosts[j].y) ) ){
        if( abs((ghosts[j].y - floor(ghosts[j].y))-0.5) < ghoV && abs((ghosts[j].x - floor(ghosts[j].x))-0.5) < ghoV ){
          ghosts[j].x = TPs[i].destination.i + 0.5;
          ghosts[j].y = TPs[i].destination.j + 0.5;
        }
      }
    }
  }
  
  //if( REC ){
  //  PImage pi = get(0, 206, width, 253 );
  //  pi.save( frameCount +".jpg" );
  //  //saveFrame( "####.png" );
  //}
  
  pmillis = millis();
}

void add_score( int n ){
  int ps = score;
  score += n;
  if( floor( ps / 10000.0 ) < floor( score / 10000.0 ) ) lives += 1;
}
