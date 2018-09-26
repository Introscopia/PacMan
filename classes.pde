class Entity{
  int vx, vy, nvx, nvy;
  float x, y, v;
  PImage[] sprites;
  int f, pmillis;
  boolean alive;
  Entity( float x, float y, PImage[] s ){
    this.x = x;
    this.y = y;
    sprites = s;
    alive = true;
  }
  void move( boolean[] controls ){
    if( controls[0]|| controls[1] ){
      nvy = controls[0]? -1 : 1;
      if( !bounds[floor(x)][floor(y +(0.51*nvy))] ) nvy = 0;
      nvx = 0;
    }
    else if( controls[3]|| controls[2] ){
      nvx = controls[2]? -1 : 1;
      if( !bounds[floor( x +(0.51*nvx))][floor(y)] ) nvx = 0;
      nvy = 0;
    }
    if( nvx != 0 ){
      if( abs((y - floor(y))-0.5) < v ){
        y = floor(y)+0.5;
        vx = nvx;
        vy = 0;
        nvx = 0;
      }
    }
    else if( nvy != 0 ){
      if( abs((x - floor(x))-0.5) < v ){
        x = floor(x)+0.5;
        vy = nvy;
        vx = 0;
        nvy = 0;
      }
    }
    if( bounds[floor( x +(0.51*vx))][floor(y +(0.51*vy))] ){
      x += v*vx;
      y += v*vy;
    }
    //println( x, y, vx, vy );
  }
  void toggle_life(){
    f = 0;
    pmillis = millis();
    alive = !alive;
  }
  void display(){}
}

class Pac extends Entity{
  Pac( float x, float y, PImage[] s ){
    super( x, y, s );
    v = pacV;
  }
  
  void display(){
    if( alive ){
      pushMatrix();
      translate( 8*x, 8*y );
      rotate( atan2( vy, vx ) );
      int d = ( f > 2 )? 2*(f-2) : 0;
      image( sprites[f-d], 0, 0 );
      popMatrix();
      
      f = floor( ( millis() - pmillis ) / 100.0 );
      if( f > 4 ){
        pmillis += 500;
        f = 0;
      }
    }
    else{
      pushMatrix();
      translate( 8*x, 8*y );
      image( sprites[constrain( f+3, 0, sprites.length-1)], 0, 0 );
      popMatrix();
      f = floor( ( millis() - pmillis ) / 150.0 );
    }
  }
}

class Ghost extends Entity{
  boolean scared;
  Ghost( float x, float y, PImage[] s ){
    super( x, y, s );
    v = ghoV;
  }
  void display(){
    int d = 0;
    //if   ( vx ==  1 ) d = 0;
    if     ( vx == -1 ) d = 2;
    else if( vy == -1 ) d = 4;
    else if( vy ==  1 ) d = 6;
    if( alive ){
      if( scared ){
        int k = 0;
        if( blink ) k = 2;
        image( scared_ghosts[f+k], 8*x, 8*y );
      }
      else{
        image( sprites[f+d], 8*x, 8*y );
      }
    }
    else{
      image( eyeballs[d/2], 8*x, 8*y );
    }
    f = floor( ( millis() - pmillis ) / 400.0 );
    if( f > 1 ){
      pmillis += 800;
      f = 0;
    }
  }
}

class TP{
  Index origin, destination;
  TP( int a, int b, int c, int d ){
    origin = new Index( a, b );
    destination = new Index( c, d );
  }
  boolean equals( int a, int b ){
    return (a == origin.i && b == origin.j);
  }
}
