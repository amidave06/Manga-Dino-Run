import java.util.*;
import g4p_controls.*;


void populateRoulette() {
  for (int i=0; i<roulette.length; i++) {
    roulette[i]=skins.get((int)random(0,skins.size()));
  }
}

void mouseClicked() {
  if (screenNum==1) {
    int index=0;
    if (mouseX>=50&&mouseX<=width-50) {
      index+=(mouseX-50)/50;
      index+=(mouseY-50)/50*(width-200)/50;
      if (index<skinCollection.size()) {
        currentSkin=skinCollection.get(index).img; 
      }
     }
  }
}
