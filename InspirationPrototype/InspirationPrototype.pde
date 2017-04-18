import http.requests.*;
static final int MAX_CHOSEN_OBJECTS = 20;

Boolean debugEnabled = true;

public enum KeywordType {
  Similar, Opposite, Random
}

KeywordType chooseCurrentType;

ImageList collectedImages = new ImageList();
StringList collectedWords = new StringList();
PoemList collectedPoems;

HashMap<String, float[]> onSreenWords = new HashMap();

KeywordType currentUpdatingKeyword = KeywordType.Similar;

//Temporary hard-codedkeywords
String similarKeyword = "Fire";
String randomKeyword = "Random";
String oppositeKeyword = "Ice";

int time;
int wait = 5000;

int imageFallSpeed = 4;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  //size(displayWidth, displayHeight);
  initializeGUI();
  initializeImageLoader();
  getWordsSimilarTo("Happy");
  getPoems(similarKeyword, true);
  thread("fetchData");
  thread("updateWordRetrival");
  time = millis();
}      

public void draw() {
  if (millis() - time >= wait) {
    fetchData();
    addWordToOnScreenWords();
    time = millis();
  }
  drawUI();
  updateImageLocations();
  updateWordLocations();
  drawCollectedImages();
  drawCollectedWords();
  drawCollectedPoems();
}

void mousePressed() {
  if (mouseX >= wordSimilarAppearX && mouseY >= wordAppearY && mouseY <= imageDisappearY) {
    String clicked = getClickedWord(mouseX,mouseY); 
    if (clicked != null) {
       collectedWords.append(clicked);
       onSreenWords.remove(clicked);
    }
  }
  handleMouseClickedForImages();
}

void fetchData() {
  updateImageRetrieval();
  updateWordRetrival();
  updatePoemRetrieval();
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

boolean overRect(float x, float y, float width, float height) {
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