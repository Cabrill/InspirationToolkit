int maxChosenObjects = 20;
int maxObjectPerType = 5;

ImageList chosenImages;

StringList chosenStrings;
StringList similarStrings;
StringList randomStrings;
StringList oppositeStrings;

/*
TODO:  Create a Poem class to hold poem objects
Poem[] chosenPoems = new Poem[maxChosenObjects];
Poem[] similarPoems = new Poem[maxObjectPerType];
Poem[] randomPoems = new Poem[maxObjectPerType];
Poem[] oppositePoems = new Poem[maxObjectPerType];
*/

int buttonGap = 20;

//Button dimensions
int largeButtonWidth = 150;
int largeButtonHeight = 50;
int smallButtonWidth = 100;
int smallButtonHeight = 50;

int visualizationButtonX = buttonGap*2;
int visualizationButtonY = buttonGap;

int lyricButtonX = (buttonGap * 4) + largeButtonWidth;
int lyricButtonY = visualizationButtonY;

int chordDisplayButtonX = (buttonGap * 5) + (largeButtonWidth * 2);
int chordDisplayButtonY = lyricButtonY;

int chordSuggestionButtonX = (buttonGap * 6) + (largeButtonWidth * 3);
int chordSuggestionButtonY = chordDisplayButtonY;

int prevVisualizationX = 5;
int prevVisualizationY = buttonGap;

int nextVisualizationX = visualizationButtonX + largeButtonWidth + 5;
int nextVisualizationY = buttonGap;

//Temporary hard-codedkeywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

public enum KeywordType {Similar, Random, Opposite}

Image img;

public void setup() {
   size(1280,800);
   InitializeImageLoader();
}      

public void draw() {
  background(0,0,0);
  UpdateImageRetrieval();
  drawUI();
  
  if (img == null) {
    if (similarImages != null)
    {
      img = similarImages.getRandom();
    }
  } else {
    image(img.getImg(), 0, 0, width, height);
  }
  
  
   text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), width/2, height/2);
   text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), width/2, 20 + height/2);
   text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), width/2, 40 + height/2);
}

public void drawUI() {


}

private void drawButton(boolean isEnabled, int x, int y, int btnWidth, int btnHeight, String btnText){
  if (isEnabled) {
    drawEnabledButton(x, y, btnWidth, btnHeight, btnText);
  }
  else {
    drawDisabledButton(x, y, btnWidth, btnHeight, btnText);
  }
}


private void drawEnabledButton(int x, int y, int btnWidth, int btnHeight, String btnText){
  if (overRect(x, y, btnWidth, btnHeight))
  {
    fill(0, 255, 100);
  } else {
    fill(0, 200, 50);
  }
  stroke(0, 200, 50);
  rect(x, y, btnWidth, btnHeight);
  
  fill(0, 0, 0);
  text(btnText, x+(btnWidth/3), y+(btnHeight/2));
}

private void drawDisabledButton(int x, int y, int btnWidth, int btnHeight, String btnText){
  if (overRect(x, y, btnWidth, btnHeight))
  {
    fill(255, 0, 100);
  } else {
    fill(200, 0, 50);
  }
  
  stroke(200, 0, 25);
  rect(x, y, btnWidth, btnHeight);
  
  fill(255, 255, 255);
  text(btnText, x+(btnWidth/3), y+(btnHeight/2));
}

void mousePressed() {
  img = randomImages.getRandom();
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}