void keyPressed() {
  if( key == CODED ){
    if (keyCode==UP) arrow_keys[0]=true;
    if (keyCode==DOWN) arrow_keys[1]=true;
    if (keyCode==LEFT) arrow_keys[2]=true;
    if (keyCode==RIGHT) arrow_keys[3]=true;
  }
}
void keyReleased() {
  if( key == CODED ){
    if (keyCode==UP) arrow_keys[0]=false;
    if (keyCode==DOWN) arrow_keys[1]=false;
    if (keyCode==LEFT) arrow_keys[2]=false;
    if (keyCode==RIGHT) arrow_keys[3]=false;
  }
  else if ( key == 'p' || key == 'P' ) pause = !pause;
  else if ( key == 'r' || key == 'R' ) REC = !REC;
}
