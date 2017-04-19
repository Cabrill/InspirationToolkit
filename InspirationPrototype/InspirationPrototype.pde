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

int imageFallSpeed = 2;

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
  updateKeywords();
}

private void updateKeywords()
{
  if (collectedWords.size() != 0)
  {
    int randomChoice = (int)random(0, collectedWords.size());
    similarKeyword = collectedWords.get(randomChoice);
    StringList oppositeWordList = oppositeWords.get(similarKeyword);
    if (oppositeWordList != null && oppositeWordList.size() > 0)
    {
      randomChoice = (int)random(0, oppositeWordList.size());
      oppositeKeyword = oppositeWordList.get(randomChoice);
    }
    randomChoice = (int)random(0, randomWords.size());
    randomKeyword = randomWords.get(randomChoice);
  }
}

void mousePressed() {
  handleMouseClickedForWords();
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