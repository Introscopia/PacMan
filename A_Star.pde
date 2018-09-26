class Index{
  int i, j;
  Index( int i, int j ){
    this.i = i;
    this.j = j;
  }
  Index( float i, float j ){
    this.i = floor(i);
    this.j = floor(j);
  }
  boolean equals( Index b ){
    if( i == b.i && j == b.j ) return true;
    else return false;
  }
  Index get(){ return new Index( i, j ); }
}

ArrayList<Index> A_Star( Index start, Index goal, boolean[][] map ){
  ArrayList<Index> closedSet = new ArrayList();
  ArrayList<Index> openSet = new ArrayList();
  openSet.add( start );
  Index[][] cameFrom = new Index[map.length][map[0].length];
  float[][] gScore = new float[map.length][map[0].length];
  
  for(int i = 0; i < map.length; i++) for(int j = 0; j < map[0].length; j++) gScore[i][j] = -1;
  gScore[start.i][start.j] = 0;
  float[][] fScore = new float[map.length][map[0].length];
  for(int i = 0; i < map.length; i++) for(int j = 0; j < map[0].length; j++) fScore[i][j] = -1;
  fScore[start.i][start.j] = heuristic_cost_estimate(start, goal);
  
  float r = sqrt(2);
  int[] ik =     { -1,  0,  1,  1,  1,  0, -1, -1 };
  int[] jk =     { -1, -1, -1,  0,  1,  1,  1,  0 };
  float[] dist = {  r,  1,  r,  1,  r,  1,  r,  1 };
  
  while( openSet.size() > 0 ){
    Index current; 
    float[] openSet_fscores = new float[openSet.size()];
    for( int u = 0; u < openSet.size(); ++u ) openSet_fscores[u] = fScore[ openSet.get(u).i ][ openSet.get(u).j ];
    int theU = openSet.size()-1;
    int theI = openSet.get(theU).i;
    int theJ = openSet.get(theU).j;
    float small = ( fScore[ openSet.get(theU).i ][ openSet.get(theU).j ] >= 0 )? fScore[ openSet.get(theU).i ][ openSet.get(theU).j ] : 9999999;
    for( int u = openSet_fscores.length-2; u >= 0; --u ){
      if( openSet_fscores[u] >= 0 && openSet_fscores[u] < small ){
        small = openSet_fscores[u];
        theI = openSet.get(u).i;
        theJ = openSet.get(u).j;
        theU = u;
      }
    }
    current = new Index( theI, theJ );
    
    if( current.equals(goal) ) return reconstruct_path(cameFrom, start, goal );
    
    openSet.remove( theU );
    closedSet.add( current.get() );
    
    
    for( int u = 0; u < 8; ++u ){
      
      int ni = current.i + ik[u];
      int nj = current.j + jk[u];
      
      if(  ni < 0 || ni >= map.length ) continue;
      if(  nj < 0 || nj >= map[0].length ) continue;
      
      Index neighbor = new Index( ni, nj );
      
      if( !map[ni][nj] ) continue;
      
      int oi = -1, oj = -1;
      switch( u ){
        case 0:
          oi = current.i -1;
          oj = current.j -1;
          break;
        case 2:
          oi = current.i +1;
          oj = current.j -1;
          break;
        case 4:
          oi = current.i +1;
          oj = current.j +1;
          break;
        case 6:
          oi = current.i -1;
          oj = current.j +1;
          break;
      }
      if( oi >= 0 && oi < map.length && oj >=0 && oj < map[0].length ){
        if( !map[oi][current.j] || !map[current.i][oj] ) continue;
      }
      
      if( contains( closedSet, neighbor) ) continue;
          
      float tentative_gScore = gScore[current.i][current.j] + dist[u];
      
      if( !contains( openSet, neighbor ) ){
        openSet.add( neighbor );
      }
      else if( tentative_gScore >= gScore[neighbor.i][neighbor.j] && gScore[neighbor.i][neighbor.j] >= 0 ) continue;

      cameFrom[ni][nj] = current.get();
      gScore[ni][nj] = tentative_gScore;
      fScore[ni][nj] = gScore[ni][nj] + heuristic_cost_estimate(neighbor, goal);
    }
  }
  return null;
}

float heuristic_cost_estimate( Index a, Index b ){
  return dist( a.i, a.j, b.i, b.j );
}

ArrayList<Index> reconstruct_path(Index[][] cameFrom, Index start, Index goal ){
  ArrayList<Index> tp = new ArrayList(); //total_path
  tp.add( goal ); 
  while( !tp.get( tp.size() -1 ).equals( start ) ){
    tp.add( cameFrom[ tp.get( tp.size() -1 ).i ][ tp.get( tp.size() -1 ).j ].get() );
  }
  return tp;
}

boolean contains( ArrayList<Index> list, Index item ){
  for(int i = 0; i < list.size(); i++){
    if( list.get(i).equals( item ) ) return true;
  }
  return false;
}
