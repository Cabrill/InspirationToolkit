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
Boolean isEnteringNewWord;

//Temporary hard-codedkeywords
String similarKeyword;
String randomKeyword;
String oppositeKeyword;

int timeSinceLastFetch;
int wait = 2500;
int timeWord;
int waitWordDraw = 50;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  initializeGUI();
  timeWord = millis();
  hasEnteredStartingWord = false;
  isEnteringNewWord = false;
}      

public void draw() {
  drawUI();
  if (!hasEnteredStartingWord || isEnteringNewWord) {
    drawPromptForStartWord();
  } else {
    if (millis() - timeWord >= (waitWordDraw/wordFallSpeed)) {
      addWordToOnScreenWords();
      timeWord = millis();
    }
    if (millis() - timeSinceLastFetch >= wait) {
      println("Fetching data");
      thread("fetchData");
      timeSinceLastFetch = millis();
    }
    
    updateImageLocations();
    updateWordLocations();
    drawCollectedImages();
    drawCollectedWords();
    drawCollectedPoems();
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
      
    if (oppositeWords != null && oppositeWords.size() > 0) {
      StringList oppositeWordList = oppositeWords.get(similarKeyword);
      if (oppositeWordList != null && oppositeWordList.size() > 0) {
        randomChoice = (int)random(0, oppositeWordList.size());
        oppositeKeyword = oppositeWordList.get(randomChoice);
      }
      else {
        String newOppositeWord = getRandomOppositeWord();
        if (newOppositeWord != null && newOppositeWord != "") {
          oppositeKeyword = newOppositeWord;
        }
      }
    } 

    if (randomWords != null && randomWords.size() > 0) {
      randomChoice = (int)random(0, randomWords.size());
      randomKeyword = randomWords.get(randomChoice);
    } else {
       randomKeyword = getRandomWord();
    }
  }
}

void mousePressed() {
  if (hasEnteredStartingWord) {
    handleMouseClickedForAddWord();
    handleMouseClickedForPoem();
    handleMouseClickedForWords();
    handleMouseClickedForImages();
    handleMouseClickedForPausePlay();
    handleMouseClickedForFFRW();
  } else if (isEnteringNewWord) {
     isEnteringNewWord = false; 
  }
}

void mouseWheel(MouseEvent event) {
  if (overRect(poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight))
  {
    handlePoemScroll( event.getCount());
  }
}

void keyPressed() {
 if (!hasEnteredStartingWord || isEnteringNewWord)
 {
   // what key was it?   ---
    if ( (key>='a'&&key<='z') || ( key >= 'A'&&key<='Z') 
    || key == ' ' || key== '\'' || key == '-' ) {
      partiallyEnteredWord+=key; // add this key to our name
    } // Letter 
    else if (key==ENTER||key==RETURN) {
      if (partiallyEnteredWord.length() > 0)
      {        
        similarKeyword = partiallyEnteredWord;
        collectedWords.append(similarKeyword);
        
        if (!hasEnteredStartingWord) {
          initializeImageLoader();
          thread("getPoems");
        }
        if (isEnteringNewWord){
          updateKeywords();
        }
        
        thread("fetchData");
        timeSinceLastFetch = millis();
        
        hasEnteredStartingWord = true;
        isEnteringNewWord = false;
      } else if (hasEnteredStartingWord) {
        isEnteringNewWord = false;
      }
    } // ENTER
    else if (key==BACKSPACE) {
      if (partiallyEnteredWord.length()>0) {
        partiallyEnteredWord=partiallyEnteredWord.substring(0, partiallyEnteredWord.length()-1);
      }
    } // BACKSPACE
    else if (key==ESC && hasEnteredStartingWord) {
      isEnteringNewWord = false;
    }
 }
}

void fetchData() {
  println("Starting word fetch");
  updateWordRetrieval();
  println("Starting image fetch");
  updateImageRetrieval();
  println("Starting poem fetch");
  updatePoemRetrieval();
  println("Fetch concluded.");
}

void drawCollectedWords() {
  int startIdx = 0;
  int rowGap = 25;
  float colGap = 50;
  float startX = collectedWordAreaX;
  float startY = collectedWordAreaY;
  float wordX = startX;
  float wordY = startY;

  textSize(24);
  for (int i = 0; i < collectedWords.size(); i++) {
    if (collectedWords.get(i) == null) {
      break;
    }
    text(collectedWords.get(i), wordX, wordY);
    wordY += rowGap;
    if (wordY >= (collectedWordAreaY + collectedWordAreaHeight)-rowGap) {
      colGap = getLongestCollectedWord(startIdx, i);
      wordY = startY;
      wordX += colGap;
      startIdx = i+1;
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