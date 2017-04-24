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

Boolean hasEnteredStartingWord;

//Temporary hard-codedkeywords
String similarKeyword = "Fire";
String randomKeyword = "Random";
String oppositeKeyword = "Ice";

int time;
int wait = 5000;
int timeWord;
int waitWordDraw = 1000;

int imageFallSpeed = 2;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  //size(displayWidth, displayHeight);
  initializeGUI();
  initializeImageLoader();
  getWordsSimilarTo("Happy");
  thread("fetchData");
  thread("updateWordRetrival");
  time = millis();
  timeWord = millis();
  hasEnteredStartingWord = false;
}      

public void draw() {
  drawUI();
  if (!hasEnteredStartingWord) {
    drawPromptForStartWord();
  } else {
    if (millis() - timeWord >= waitWordDraw) {
      addWordToOnScreenWords();
      timeWord = millis();
    }
    if (millis() - time >= wait) {
      fetchData();
      time = millis();
    }
    
    updateImageLocations();
    updateWordLocations();
    drawCollectedImages();
    drawCollectedWords();
    drawCollectedPoems();
    updateKeywords();
  }
}

private void updateKeywords() {
  if (collectedWords.size() != 0) {
    int randomChoice = (int)random(0, collectedWords.size());
    similarKeyword = collectedWords.get(randomChoice);
    StringList oppositeWordList = oppositeWords.get(similarKeyword);
    if (oppositeWordList != null && oppositeWordList.size() > 0) {
      randomChoice = (int)random(0, oppositeWordList.size());
      oppositeKeyword = oppositeWordList.get(randomChoice);
    }
    if (randomWords != null && randomWords.size() > 0) {
      randomChoice = (int)random(0, randomWords.size());
      randomKeyword = randomWords.get(randomChoice);
    }
  }
}

void mousePressed() {
  handleMouseClickedForWords();
  handleMouseClickedForImages();
}

void keyPressed() {
 if (!hasEnteredStartingWord)
 {
   // what key was it?   ---
    if ( (key>='a'&&key<='z') || ( key >= 'A'&&key<='Z')) {
      partiallyEnteredWord+=key; // add this key to our name
    } // Letter 
    else if (key==ENTER||key==RETURN) {
      if (partiallyEnteredWord.length() > 0)
      {
        similarKeyword = partiallyEnteredWord;
        collectedWords.append(similarKeyword);
        hasEnteredStartingWord = true;
      }
    } // ENTER
    else if (key==BACKSPACE) {
      if (partiallyEnteredWord.length()>0) {
        partiallyEnteredWord=partiallyEnteredWord.substring(0, partiallyEnteredWord.length()-1);
      }
    } // BACKSPACE
 }
}

void fetchData() {
  updateImageRetrieval();
  updateWordRetrival();
  updatePoemRetrieval();
}

void drawCollectedWords() {
  int rowGap = 25;
  int colGap = 50;
  float startX = collectedWordAreaX;
  float startY = collectedWordAreaY;
  float wordX = startX;
  float wordY = startY;

  textSize(24);
  for (int i = 0; i < collectedWords.size(); i++) {
    text(collectedWords.get(i), wordX, wordY);
    wordY += rowGap;
    if (wordY >= (collectedWordAreaY + collectedWordAreaHeight)-rowGap) {
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

private KeywordType nextKeywordType(KeywordType kt) {
  return KeywordType.values()[(kt.ordinal() + 1) % 3];
}