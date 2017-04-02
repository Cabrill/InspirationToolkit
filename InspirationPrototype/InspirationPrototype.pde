static final int MAX_CHOSEN_OBJECTS = 20;


Boolean debugEnabled = true;

public enum KeywordType {Similar, Opposite, Random}

KeywordType chooseCurrentType;

ImageList collectedImages = new ImageList();
StringList collectedWords = new StringList();
PoemList collectedPoems;

KeywordType currentUpdatingKeyword = KeywordType.Similar;

ArrayList<OnScreenImage> onScreenSimilarImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenRandomImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenOppositeImages = new ArrayList<OnScreenImage>();

//Temporary hard-codedkeywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

int imageFallSpeed = 4;

public void setup() {
  fullScreen();
  pushMatrix();
  chooseCurrentType = KeywordType.Similar;
  //size(displayWidth, displayHeight);
  initializeGUI();
  initializeImageLoader();
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