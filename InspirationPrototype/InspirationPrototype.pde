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

Boolean hasEnteredStartingWord;

//Temporary hard-codedkeywords
String similarKeyword;
String randomKeyword;
String oppositeKeyword;

int time;
int wait = 5000;
int timeWord;
int waitWordDraw = 1000;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  initializeGUI();
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
      thread("fetchData");
      time = millis();
    }
    
    updateImageLocations();
    updateWordLocations();
    drawCollectedImages();
    drawCollectedWords();
    drawCollectedPoems();
    if (!isRefreshing) {
      thread("updateKeywords");
    }
  }
}

public void updateKeywords() {
  if (collectedWords.size() != 0) {
    println("Updating keywords");
    int randomChoice = (int)random(0, collectedWords.size());
    String chosenWord = collectedWords.get(randomChoice);
    
    StringList similarWordList = similarWords.get(chosenWord);
    if (similarWordList != null && similarWordList.size() > 0) {
        randomChoice = (int)random(0, similarWordList.size());
        similarKeyword = similarWordList.get(randomChoice);
      } else {
       similarKeyword = chosenWord; 
      }
      
    StringList oppositeWordList = oppositeWords.get(similarKeyword);
    if ((oppositeWordList == null || oppositeWordList.size() == 0) &&  oppositeWords.keySet().size() > 0)
    {
       ArrayList<String> keys = new ArrayList<String>(oppositeWords.keySet());
       String randomKey = keys.get((int)random(keys.size()));
       oppositeWordList = oppositeWords.get(randomKey);
    }
    if (oppositeWordList != null && oppositeWordList.size() > 0) {
      randomChoice = (int)random(0, oppositeWordList.size());
      oppositeKeyword = oppositeWordList.get(randomChoice);
    } 

    if (randomWords != null && randomWords.size() > 0) {
      randomChoice = (int)random(0, randomWords.size());
      randomKeyword = randomWords.get(randomChoice);
    } else {
       randomKeyword = getRandomWord();
    }
    notifyImagesThatKeywordsChanged();
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
        updateWordRetrieval();
        updateKeywords();
        initializeImageLoader();
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
  updateWordRetrieval();
  updateImageRetrieval();
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