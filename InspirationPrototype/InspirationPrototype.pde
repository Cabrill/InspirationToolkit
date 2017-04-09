import http.requests.*;
static final int MAX_CHOSEN_OBJECTS = 20;

Boolean debugEnabled = true;

public enum KeywordType {Similar, Opposite, Random}

KeywordType chooseCurrentType;

ImageList collectedImages = new ImageList();
StringList collectedWords = new StringList();
PoemList collectedPoems;

KeywordType currentUpdatingKeyword = KeywordType.Similar;

//Temporary hard-codedkeywords
String similarKeyword = "Fire";
String randomKeyword = "Random";
String oppositeKeyword = "Ice";

int imageFallSpeed = 4;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  //size(displayWidth, displayHeight);
  initializeGUI();
  initializeImageLoader();
  getWordsSimilarTo("Happy");
  GetPoem();
}      

public void draw() {
  updateImageRetrieval();
  drawUI();
  updateImageLocations();
  
  drawCollectedImages();
  drawCollectedWords();
}

void mousePressed() {
  handleMouseClickedForImages();
}

void drawCollectedWords()
{
  int rowGap = 25;
  int colGap = 50;
  float startX = collectedWordAreaX;
  float startY = collectedWordAreaY;
  float wordX = startX;
  float wordY = startY;
  
  textSize(24);
  for (int i = 0; i < collectedWords.size(); i++)
  {
    text(collectedWords.get(i), wordX, wordY);
    wordY += rowGap;
    if (wordY >= (collectedWordAreaY + collectedWordAreaHeight)-rowGap)
    {
       wordY = startY;
       wordX += colGap;
    }
  }
}

boolean overRect(float x, float y, float width, float height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

private KeywordType nextKeywordType(KeywordType kt)
{
  return KeywordType.values()[(kt.ordinal() + 1) % 3];
}