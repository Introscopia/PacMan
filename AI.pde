class AI{
  AI(){}
  boolean[] command( Entity me, boolean andou ){ return null; }
}

class Schizo extends AI{
  Schizo(){}
  boolean[] command( Entity me, boolean andou ){
    boolean[] out = new boolean[4];
    int I = round( random( -0.499, 28.499 ) );
    if( I <= 3 ) out[I] = true;
    return out;
  }
}

class Returner extends AI{
  ArrayList<Index> path;
  int c;
  Returner( float i, float j ){
    path = A_Star( new Index(i,j), new Index(startingX[1], startingY[1]), bounds );
    if( path != null ) c = path.size()-1;
    else println( "null path" );
  }
  boolean[] command( Entity me, boolean andou ){
    boolean[] out = new boolean[4];
    Index pos = new Index( me.x, me.y );
    for( int q = c; q > 0; --q ){
      if( pos.equals( path.get(q) ) ){
        out[0] = path.get(q-1).j < pos.j;
        out[1] = path.get(q-1).j > pos.j;
        out[2] = path.get(q-1).i < pos.i;
        out[3] = path.get(q-1).i > pos.i;
        c = q;
        break;
      }
    }
    return out; 
  }
}

class Seguidor extends AI{
  ArrayList<Index> path;
  int crazy;
  boolean is_crazy;
  Seguidor(){
    path = new ArrayList();
  }
  boolean[] command( Entity me, boolean andou ){
    boolean[] out = new boolean[4];
    Index pos = new Index( me.x, me.y );
    if( andou ){
      if( millis() > crazy ){
        if( random( 50 ) < 1 ){
          int R = round(random( -0.499, encruzilhada.length-0.501 ) );
          path = A_Star( pos, encruzilhada[R], bounds );
          crazy = millis() + 3000;
          is_crazy = true;
        }
        else path = A_Star( pos, new Index(floor(pacman.x), floor(pacman.y)), bounds );
      }
      else if( is_crazy ){
        path = A_Star( pos, new Index(floor(pacman.x), floor(pacman.y)), bounds );
        is_crazy = false;
      }
    }
    if( path != null ){
      if( path.size() > 0 ){
        for( int q = path.size()-1; q > 0; --q ){
          if( pos.equals( path.get(q) ) ){
            out[0] = path.get(q-1).j < pos.j;
            out[1] = path.get(q-1).j > pos.j;
            out[2] = path.get(q-1).i < pos.i;
            out[3] = path.get(q-1).i > pos.i;
            break;
          }
          path.remove(q);
        }
      }
      else{
        path = A_Star( pos, new Index(floor(pacman.x), floor(pacman.y)), bounds );
        is_crazy = false;
      }
    }
    return out; 
  }
}

/*
class Seguidor_rudimentar extends AI{
  float px, py;
  Seguidor(){
  }
  boolean[] command( Entity me ){
    boolean[] out = new boolean[4];
    if( 
    if( abs(pacman.y - me.y) > 0.5 ){
      if( pacman.y < me.y ) out[0] = true;
      if( pacman.y > me.y ) out[1] = true;
    }
    if( abs(pacman.x - me.x) > 0.5 ){
      if( pacman.x < me.x ) out[2] = true;
      if( pacman.x > me.x ) out[3] = true;
    }
    px = me.x;
    py = me.y;
    return out; 
  }
}
*/
