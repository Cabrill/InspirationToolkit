//Word retrieval API
//http://www.datamuse.com/api/

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

Boolean pauseWords = false;

float wordFallSpeed = 0.5f;
float wordFallMaxSpeed = 5f;
float wordFallMinSpeed = 0.1f;

public static HashMap<String, StringList> similarWords = new HashMap();
public static StringList randomWords = new StringList();
public static HashMap<String, StringList>  oppositeWords = new HashMap();

private static final String url = "https://api.datamuse.com/words";
private static final String randomURL = "http://setgetgo.com/randomword/get.php";

public void updateWordRetrieval() {
  thread("FetchLotsOfRandomWords");
  if (collectedWords.size() != 0) {
    StringList opposite, similar;
    for (String collected : collectedWords) {
      if (!similarWords.containsKey(collected)) {
        similar = getWordsSimilarTo(collected);
        similarWords.put(collected, similar);
      }
      
      if (!oppositeWords.containsKey(collected)) {
        opposite = getOppositeWords(collected);
        oppositeWords.put(collected, opposite);
      } else if (oppositeWords.get(collected).size() == 0) {
        similar = getWordsSimilarTo(collected);
        String randomSimilar = similar.get((int)random(similar.size()));
        opposite = getOppositeWords(randomSimilar);
        oppositeWords.put(collected, opposite);
      }
    }
  }
}

public void FetchLotsOfRandomWords(){
  for (int i = 0; i < 10; i++)
  {
    String random = getRandomWord();
    if (!randomWords.hasValue(random)) {
      randomWords.append(random);
    }
  } 
}

public String getRandomOppositeWord()
{
  if (oppositeWords.size() > 0) {
    ArrayList<String> nonEmptyKeys = new ArrayList<String>();
    ArrayList<String> keys = new ArrayList<String>(oppositeWords.keySet());
    for (String word : keys) {
      StringList opposites = oppositeWords.get(word);
      if (opposites.size() > 0) {
        nonEmptyKeys.add(word);
      }
    }
    if (nonEmptyKeys.size() > 0) {
      String randomKey = nonEmptyKeys.get((int)random(nonEmptyKeys.size()));
      StringList words = oppositeWords.get(randomKey);
      int randomChoice = (int)random(words.size());
      String resultWord = words.get(randomChoice);
      if (oppositeKeyword == null) {
        oppositeKeyword = resultWord;
      }
      return resultWord;
    }
  }
  return null;
}

public StringList getWordsSimilarTo(String word)
{
  word = word.replaceAll("\\s","+");
  StringList list = new StringList();
  GetRequest get = new GetRequest(url + "?ml=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);
  JSONObject json;
  String currentWord;
  for (int i = 0; i < jsonArray.size(); i++) {
    json = jsonArray.getJSONObject(i); 
    currentWord = json.getString("word");
    if (!list.hasValue(currentWord)) {
      list.append(currentWord);
    }
  }
  return list;
}

public String getRandomWord() {
  GetRequest get = new GetRequest(randomURL);
  get.send();
  
  String newRandomWord = get.getContent();
  if (randomKeyword == null && newRandomWord != null) {
    randomKeyword = newRandomWord;
  }
  return newRandomWord;
}

public StringList getOppositeWords(String word)
{
  word = word.replaceAll("\\s","+");
  StringList returnList = new StringList();

  GetRequest get = new GetRequest(url + "?rel_ant=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);
  JSONObject json;
  String currentWord;
  for (int i = 0; i < jsonArray.size(); i++) {
    json = jsonArray.getJSONObject(i); 
    currentWord = json.getString("word").replaceAll("[^a-zA-Z]","").toLowerCase();
    returnList.append(currentWord);
  }

  return returnList;
}

public void updateWordLocations() {
  textSize(25);
  StringList deletable = new StringList();
  for (String word : onSreenWords.keySet()) {
    text(word, onSreenWords.get(word)[0], onSreenWords.get(word)[1]);
    if ((onSreenWords.get(word)[1] + 1) > imageDisappearY) {
      deletable.append(word);
    } else if (!pauseWords && !overRect(wordAreaX, wordAppearY, wordAreaWidth, imageDisappearY)) { 
      onSreenWords.put(word, new float[]{onSreenWords.get(word)[0], onSreenWords.get(word)[1] + wordFallSpeed});
    }
  }
  for (String del : deletable) {
    onSreenWords.remove(del);
  }
}

public void addWordToOnScreenWords() {
  int random = (int) random(8);
  if (random <= 2) {
    addSimilarWord();
  } else if (random >= 5) {
    addOppositeWord();
  } else {
    addRandomWord();
  }
}

public void addRandomWord() {
  if (randomWords.size() != 0) {
    String word = randomWords.remove((int)random(randomWords.size()));
    if (canDrawWord()) {
      onSreenWords.put(word, new float[]{wordRandomAppearX, wordAppearY});
    }
  } 
}

public boolean canDrawWord() {
  for (String word : onSreenWords.keySet()) {
    if (onSreenWords.get(word)[1] <= (wordAppearY + 25)) {
      return false;
    }
  }
  return true;
}

public void addSimilarWord() {
  if (canDrawWord()) {
    if (similarWords.size() > 0) {
      ArrayList<String> keys = new ArrayList<String>(similarWords.keySet());
      String randomKey = keys.get((int)random(keys.size()));
      StringList words = similarWords.get(randomKey);
      if (words.size() != 0) {
        String word = words.remove((int)random(words.size()));
        similarWords.put(randomKey, words);
        onSreenWords.put(word, new float[]{wordSimilarAppearX, wordAppearY});
        if (words.size() == 0) {
          similarWords.remove(word);
        }
      }
    }
  }
}
public void addOppositeWord() {
  if (canDrawWord()) {
    if (oppositeWords.size() > 0) {
      ArrayList<String> nonEmptyKeys = new ArrayList<String>();
      ArrayList<String> keys = new ArrayList<String>(oppositeWords.keySet());
      for (String word : keys)
      {
        StringList opposites = oppositeWords.get(word);
        if (opposites.size() > 0)
        {
          nonEmptyKeys.add(word);
        }
      }
      if (nonEmptyKeys.size() > 0)
      {
        String randomKey = nonEmptyKeys.get((int)random(nonEmptyKeys.size()));
        StringList words = oppositeWords.get(randomKey);
  
        if (words.size() != 0) {
          String word = words.remove((int)random(words.size()));
          if (oppositeKeyword == null) oppositeKeyword = word;
          oppositeWords.put(randomKey, words);
          onSreenWords.put(word, new float[]{wordOppositeAppearX, wordAppearY});
          if (words.size() == 0) {
            oppositeWords.remove(word);
          }
        }
      }
    }
  }
}

public String getClickedWord(int x, int y) {
  int textSize = 25;
  int wordX, wordY;
  textSize(textSize);
  for (String word : onSreenWords.keySet()) {
    wordX = (int)onSreenWords.get(word)[0];
    wordY = (int)onSreenWords.get(word)[1];
    if (wordX <= x && (wordX + textWidth(word)) >= x && (wordY-textSize) <= y && wordY >= y) {
      return word;
    }
  }
  return null;
}

public void handleMouseClickedForWords() {
  int textSize = 24;
  if (mouseX >= wordSimilarAppearX && mouseY >= wordAppearY && mouseY <= imageDisappearY)  {
      String clicked = getClickedWord(mouseX, mouseY); 
      if (clicked != null)  {
        collectedWords.append(clicked);
        onSreenWords.remove(clicked);
        thread("updateKeywords");
      }
  } else if (overRect(collectedWordAreaX, collectedWordAreaY-textSize, collectedWordAreaWidth, collectedWordAreaHeight+textSize)) {
      int startIdx = 0;
      int rowGap = 25;
      float colGap = 50;
      float startX = collectedWordAreaX;
      float startY = collectedWordAreaY;
      float wordX = startX;
      float wordY = startY;
      String word;
    
      textSize(textSize);
      for (int i = 0; i < collectedWords.size(); i++) {
        word = collectedWords.get(i);
        
        if (wordX <= mouseX && (wordX + textWidth(word)) >= mouseX && (wordY-textSize) <= mouseY && wordY >= mouseY) {
          collectedWords.remove(i);
          thread("updateKeywords");
          break;
        }
        
        wordY += rowGap;
        if (wordY >= (collectedWordAreaY + collectedWordAreaHeight)-rowGap) {
          colGap = getLongestCollectedWord(startIdx, i);
          wordY = startY;
          wordX += colGap;
          startIdx = i+1;
        }
      }
    }  
}

public float getLongestCollectedWord(int startIdx, int endIdx)
{
  float thisLength = 0;
  float maxLength = 0;
  String word;
  
  for (int i = startIdx; i < endIdx; i++)
  {
    word = collectedWords.get(i);
    thisLength = textWidth(word);
    if (thisLength > maxLength) maxLength = thisLength;
  }
  return maxLength+5;
}