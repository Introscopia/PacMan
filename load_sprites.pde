void load_sprites( String fn ){
  PImage ss = loadImage( fn );
  PImage[] S = new PImage[13];
  S[0] = ss.get( 3, 90, 14, 14 );
  S[1] = ss.get( 20, 90, 14, 14 );
  S[2] = ss.get( 35, 90, 14, 14 );
  S[3] = ss.get( 3, 105, 16, 14 );
  S[4] = ss.get( 22, 105, 16, 14 );
  S[5] = ss.get( 41, 105, 16, 14 );
  S[6] = ss.get( 60, 105, 16, 14 );
  S[7] = ss.get( 79, 105, 16, 14 );
  S[8] = ss.get( 98, 105, 14, 14 );
  S[9] = ss.get( 115, 105, 10, 14 );
  S[10] = ss.get( 128, 105, 6, 14 );
  S[11] = ss.get( 137, 105, 2, 14 );
  S[12] = ss.get( 142, 105, 12, 14 );
  pacman = new Pac( startingX[0], startingY[0], S );
  
  PGraphics l = createGraphics(28, 28);
  l.beginDraw();
  l.translate(28, 0);
  l.scale( 1.647 );
  l.scale(-1, 1);
  l.image(S[1], 0, 0);
  l.endDraw();
  life = l;
  
  ghosts = new Ghost[4];
  scared_ghosts = new PImage[4];
  eyeballs = new PImage[4];
  for(int i = 0; i < 4; ++i ){
    S = new PImage[8];
    for(int j = 0; j < 8; ++j ) S[j] = ss.get( 3+(17*j), 124+(18*i), 14, 14 );
    ghosts[i] = new Ghost( startingX[i+1], startingY[i+1], S );
    scared_ghosts[i] = ss.get(3+(17*i), 196, 14, 14);
    eyeballs[i] = ss.get(3+(17*(i+4)), 196, 14, 14);
  }
  
  floating_scores = new PImage[12];
  for(int i = 0; i < 12; ++i ){
    floating_scores[i] = ss.get( 172, 97+(9*i), 16, 7 );
  }
  fruits = new PImage[8];
  for(int i = 0; i < 8; ++i ){
    fruits[i] = ss.get( 157, 97+(14*i), 12, 14 );
  }
  
}
