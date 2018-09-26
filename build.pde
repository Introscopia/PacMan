void load_dots_and_pellets( PImage f ){
  for(int j=0; j < f.height; j++){
    for(int i=0; i < f.width; i++){
      pac_dots[i][j] =      f.pixels[(j*f.width)+i] == #323232;
      power_pellets[i][j] = f.pixels[(j*f.width)+i] == #646464;
    }
  }
}

void build_map( String fn ){
  
  startingX = new float[5];
  startingY = new float[5];
  String[] s = loadStrings( fn+".txt" );
  String[] sp = split( s[0], ' ' );
  for(int i = 0; i < 5; i++) startingX[i] = float(sp[i]);
  sp = split( s[1], ' ' );
  for(int i = 0; i < 5; i++) startingY[i] = float(sp[i]);
  
  sp = split( s[3], ' ' );
  fruitX = float( sp[0] );
  fruitY = float( sp[1] );
  
  TPs = new TP[ s.length-5 ];
  for(int i = 5; i < s.length; i++){
    sp = split( s[i], ' ' );
    TPs[i-5] = new TP ( int(sp[0]), int(sp[1]), int(sp[2]), int(sp[3]) );
  }
  
  map_source = loadImage( fn+".png" );
  PGraphics small_map = createGraphics( map_source.width * 8, map_source.height * 8 );
  bounds = new boolean[map_source.width][map_source.height];
  pac_dots = new boolean[map_source.width][map_source.height];
  power_pellets = new boolean[map_source.width][map_source.height];
  //println( 2.24*map.width, 2.24*map.height );
  small_map.beginDraw();
  //map.background(0);
  
  //map.pushMatrix();
  //map.scale( 7.85 );
  //map.tint(255, 110);
  //map.image( f, 0, 0 );
  //map.popMatrix();
  
  map_source.loadPixels();
  
  load_dots_and_pellets( map_source );
  
  int W = map_source.width;
  int H = map_source.height;
  int d = 3;
  for(int j=0; j < H; j++){
    for(int i=0; i < W; i++){
      bounds[i][j] = map_source.pixels[(j*W)+i] == #000000 ||
                     map_source.pixels[(j*W)+i] == #323232 ||
                     map_source.pixels[(j*W)+i] == #646464 ||
                     map_source.pixels[(j*W)+i] == #ee753e ||
                     map_source.pixels[(j*W)+i] == #0cde0c;
    }
  }
  
  ArrayList<Index> enc = new ArrayList();
  
  for(int j=0; j < H; j++){
    for(int i=0; i < W; i++){
      
      int con = 0;
      if( j-1 > 0 && !bounds[i][j-1] ) ++con;
      if( j+1 < H && !bounds[i][j+1] ) ++con;
      if( i-1 > 0 && !bounds[i-1][j] ) ++con;
      if( i+1 < W && !bounds[i+1][j] ) ++con;
      if( con >= 3 ){
        enc.add( new Index( i, j ) );
      }
      
      switch( map_source.pixels[(j*W)+i] ){
        case #000000:
          
          break;
        case #666666: //outline
          
          break;
        case #3e3eee: //wall
          {
            small_map.stroke( #1f22df );
            small_map.noFill();
            color[] neighborhood = new color[9];
            int c = 0;
            for(int J = j-1; J <= j+1; J++){
              for(int I = i-1; I <= i+1; I++){
                neighborhood[c] = (I>=0 && I<W && J>=0 && J<H)? (bounds[I][J] ? #000000 : map_source.pixels[(J*W)+I]) : #010101;
                ++c;
              }
            }
            int Q = identify_wall( neighborhood );
            if( Q >= 0 ){
              int S = floor( Q/100.0 );
              int F = floor( (Q -(100*S))/10.0 );
              int R = Q -(100*S) -(10*F);
              small_map.pushMatrix();
              small_map.translate( (i+0.5)*8, (j+0.5)*8 );
              small_map.rotate( R * HALF_PI );
              switch( S ){
                case 0: // flat
                  small_map.line( -4, -1, 4, -1 );
                  break;
                case 1: // flat with border
                  small_map.line( -4, -4, 4, -4 );
                  small_map.line( -4, -1, 4, -1 );
                  break;
                case 2: //corner 
                  small_map.arc( 4, 4, 6, 6, -PI, -HALF_PI );
                  break;
                case 3: // corner with border
                  small_map.arc( 4, 4, 6, 6, -PI, -HALF_PI );
                  break;
                case 4: // inside corner
                  small_map.arc( 2, 2, 6, 6, -PI, -HALF_PI );
                  small_map.line( -1, 2, -1, 4 );
                  small_map.line( 2, -1, 4, -1 );
                  break;
                case 5: // inside corner with corner border
                  small_map.arc( 2, 2, 6, 6, -PI, -HALF_PI );
                  small_map.line( -1, 2, -1, 4 );
                  small_map.line( 2, -1, 4, -1 );
                  small_map.arc( 0, 0, 8, 8, -PI, -HALF_PI );
                  small_map.line( 0, -4, 4, -4 );
                  small_map.line( -4, 0, -4, 4 );
                  break;
                case 6: //inside corner with flat border
                  small_map.line( -4, -4, 4, -4 );
                  if( F > 0 ){
                    small_map.arc( -2, 2, 6, 6, -HALF_PI, 0 );
                    small_map.line( -2, -1, -4, -1 );
                    small_map.line( 1, 2, 1, 4 );
                  }
                  else{
                    small_map.arc( 2, 2, 6, 6, -PI, -HALF_PI );
                    small_map.line( -1, 2, -1, 4 );
                    small_map.line( 2, -1, 4, -1 );
                  }
                  break;
                case 7: // stump with border
                  small_map.line( -4, -1, 4, -1 );
                  small_map.line( -4, -4, 4, -4 );
                  break;
              }
              small_map.popMatrix();
            }
          }
          break;
        case #e93eee: //cage
          {
            small_map.stroke( #1f22df );
            small_map.noFill();
            color[] neighborhood = new color[9];
            int c = 0;
            for(int J = j-1; J <= j+1; J++){
              for(int I = i-1; I <= i+1; I++){
                neighborhood[c] = (I>=0 && I<W && J>=0 && J<H)? (bounds[I][J] ? #000000 : map_source.pixels[(J*W)+I]) : #010101;
                ++c;
              }
            }
            int Q = identify_cage( neighborhood );
            if( Q >= 0 ){
              int S = floor( Q/10.0 );
              int R = Q -(10*S);
              small_map.pushMatrix();
              small_map.translate( (i+0.5)*8, (j+0.5)*8 );
              switch( S ){
                case 0: // flat
                  if( R == 0 ){
                    for( int dt = 1; dt < 32; ++dt ){
                      if( j - dt > 0 && (map_source.pixels[((j-dt)*W)+i] == #e93eee || map_source.pixels[((j-dt)*W)+i] == #ee1515 ) ){ // we're under
                        small_map.line( -4, -4, 4, -4 );
                        small_map.line( -4, -1, 4, -1 );
                        break;
                      }
                      if( j + dt < H && (map_source.pixels[((j+dt)*W)+i] == #e93eee || map_source.pixels[((j+dt)*W)+i] == #ee1515 ) ){ // we're over
                        small_map.line( -4, 4, 4, 4 );
                        small_map.line( -4, 1, 4, 1 );
                        break;
                      }
                    }
                  }
                  else if( R == 1 ){
                    for( int dt = 1; dt < 32; ++dt ){
                      if( i - dt > 0 && (map_source.pixels[(j*W)+(i-dt)] == #e93eee || map_source.pixels[(j*W)+(i-dt)] == #ee1515 ) ){ // we're to the right
                        small_map.line( -4, -4, -4, 4 );
                        small_map.line( -1, -4, -1, 4 );
                        break;
                      }
                      if( i + d < W && (map_source.pixels[(j*W)+(i+dt)] == #e93eee || map_source.pixels[(j*W)+(i+d)] == #ee1515 ) ){ // we're to the left
                        small_map.line( 4, -4, 4, 4 );
                        small_map.line( 1, -4, 1, 4 );
                        break;
                      }
                    }
                  }
                  break;
                case 1: // corner
                  small_map.rotate( R * HALF_PI );
                  small_map.line( -4, 1, -1, 1 );
                  small_map.line( -1, 1, -1, 4 );
                  small_map.point( -4, 4 );
                  break;
                case 2: // stump
                  if( R % 2 == 0 ){
                    for( int dt = 1; dt < 32; ++dt ){
                      if( j - dt > 0 && (map_source.pixels[((j-dt)*W)+i] == #e93eee || map_source.pixels[((j-dt)*W)+i] == #ee1515 ) ){ // we're under
                        small_map.line( -4, -4, 4, -4 );
                        small_map.line( -4, -1, 4, -1 );
                        if( R == 0 ) small_map.line( 4, -4, 4, -1 );
                        else if( R == 2 ) small_map.line( -4, -4, -4, -1 );
                        break;
                      }
                      if( j + dt < H && (map_source.pixels[((j+dt)*W)+i] == #e93eee || map_source.pixels[((j+dt)*W)+i] == #ee1515 ) ){ // we're over
                        small_map.line( -4, 4, 4, 4 );
                        small_map.line( -4, 1, 4, 1 );
                        if( R == 0 ) small_map.line( 4, 4, 4, 1 );
                        else if( R == 2 ) small_map.line( -4, 4, -4, 1 );
                        break;
                      }
                    }
                  }
                  else if( R % 2 == 1 ){
                    for( int dt = 1; dt < 32; ++dt ){
                      if( i - dt > 0 && (map_source.pixels[(j*W)+(i-dt)] == #e93eee || map_source.pixels[(j*W)+(i-dt)] == #ee1515 ) ){ // we're to the right
                        small_map.line( -4, -4, -4, 4 );
                        small_map.line( -1, -4, -1, 4 );
                        if( R == 1 ) small_map.line( -4, 4, -1, 4 );
                        else if( R == 3 ) small_map.line( -4, -4, -1, -4 );
                        break;
                      }
                      if( i + d < W && (map_source.pixels[(j*W)+(i+dt)] == #e93eee || map_source.pixels[(j*W)+(i+d)] == #ee1515 ) ){ // we're to the left
                        small_map.line( 4, -4, 4, 4 );
                        small_map.line( 1, -4, 1, 4 );
                        if( R == 1 ) small_map.line( 4, 4, 1, 4 );
                        else if( R == 3 ) small_map.line( 4, -4, 1, -4 );
                        break;
                      }
                    }
                  }                  
                  break;
              }
              small_map.popMatrix();
            }
            
            boolean horizontal;
            if(( i > 0 && map_source.pixels[(j*W)+(i-1)]==#e93eee )&&( i < W-1 && map_source.pixels[(j*W)+(i+1)]==#e93eee )){
              
            }
          }
          break;
        case #ee1515: //gate
          
          break;
        case #ee753e: //tp
          
          break;
      }
    }
  }
  encruzilhada = new Index[enc.size()];
  encruzilhada = enc.toArray( encruzilhada );
  
  small_map.endDraw();
  //map_source.updatePixels();
  
  map = createGraphics( width, height );
  map.noSmooth();
  map.beginDraw();
  map.background(0);
  map.scale(2.24);
  map.image( small_map, 0, 0 );
  map.endDraw();
}

int identify_wall( color[] in ){
  color w = #3e3eee;
  color o = #666666;
  color b = #000000;
  color a = #010101;
  color[] flat     = { a, w, a, w, w, w, a, b, a };
  color[] flatbord = { a, o, a, w, w, w, a, b, a };
  color[] corner   = { a, b, a, b, w, w, a, w, w };
  color[] cornerbo = { a, b, a, b, w, w, a, w, o };
  color[] incorner = { a, w, a, w, w, w, a, w, b };
  color[] incornbo = { a, o, a, o, w, w, a, w, b };
  color[] incornb2 = { a, o, a, a, w, w, a, w, b };
  color[] stump    = { a, o, a, w, w, b, a, b, a };
  
  int R = compare_all_rotations( in, flat );
  if( R >= 0 ) return R;
  R = compare_all_rotations( in, flatbord );
  if( R >= 0 ) return 100+R;
  R = compare_all_rotations( in, corner );
  if( R >= 0 ) return 200+R;
  R = compare_all_rotations( in, cornerbo );
  if( R >= 0 ) return 300+R;
  R = compare_all_rotations( in, incorner );
  if( R >= 0 ) return 400+R;
  R = compare_all_rotations( in, incornbo );
  if( R >= 0 ) return 500+R;
  R = compare_all_rotations_and_reflections( in, incornb2 );
  if( R >= 0 ) return 600+R;
  R = compare_all_rotations_and_reflections( in, stump );
  if( R >= 0 ) return 700+R;
  return -1;
}

int identify_cage( color[] in ){
  color c = #e93eee;
  color g = #ee1515;
  color b = #000000;
  color a = #010101;
  color[] flat     = { a, a, a, c, c, c, a, a, a };
  color[] corner   = { a, a, a, c, c, a, a, c, a };
  color[] stump    = { a, a, a, a, c, g, a, a, a };
  
  int R = compare_all_rotations( in, flat );
  if( R >= 0 ) return R;
  R = compare_all_rotations( in, corner );
  if( R >= 0 ) return 10+R;
  R = compare_all_rotations( in, stump );
  if( R >= 0 ) return 20+R;
  return -1;
}
//camilabartolomei02
int compare_all_rotations( color[] in, color[] pat ){
  for(int i=0; i < 4; i++){
    if( equal( in, pat ) ) return i;
    else pat = rotate_clockwise( pat );
  }
  return -1;
}
int compare_all_rotations_and_reflections( color[] in, color[] pat ){
  for(int i=0; i < 2; i++){
    for(int j=0; j < 4; j++){
      if( equal( in, pat ) ) return (i*10)+j;
      else pat = rotate_clockwise( pat );
    }
    pat = flip_horizontal( pat );
  }
  return -1;
}

boolean equal( color[] a, color[] b ){
  for(int i=0; i < a.length; i++){
    if( a[i] != b[i] && !(a[i]==#010101 || b[i]==#010101)) return false;
  }
  return true;
}
color[] rotate_clockwise( color[] in ){
  color[] out = new color[9];
  out[0] = in[6];
  out[1] = in[3];
  out[2] = in[0];
  out[3] = in[7];
  out[4] = in[4];
  out[5] = in[1];
  out[6] = in[8];
  out[7] = in[5];
  out[8] = in[2];
  return out;
}
color[] flip_horizontal( color[] in ){
  color[] out = new color[9];
  out[0] = in[2];
  out[1] = in[1];
  out[2] = in[0];
  out[3] = in[5];
  out[4] = in[4];
  out[5] = in[3];
  out[6] = in[8];
  out[7] = in[7];
  out[8] = in[6];
  return out;
}
