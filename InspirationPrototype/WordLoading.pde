//Word retrieval API
//http://www.datamuse.com/api/

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

public static HashMap<String, StringList> similarWords = new HashMap();
public static StringList randomWords = new StringList();
public static HashMap<String, StringList>  oppositeWords = new HashMap();

private static final String url = "https://api.datamuse.com/words";
private static final String randomURL = "http://randomword.setgetgo.com/get.php";

public void updateWordRetrieval() {
  String random = getRandomWord();
  if (collectedWords.size() != 0) {
    for (String collected : collectedWords) {
      if (!similarWords.containsKey(collected)) {
        StringList similar = getWordsSimilarTo(collected);
        if (similar.size() != 0) {
          similarWords.put(collected, similar);
        }
      } 
      if (!oppositeWords.containsKey(collected)) {
        StringList opposite = getOppositeWords(collected);
        if (opposite.size() != 0) {
          oppositeWords.put(collected, opposite);
        }
      }
    }
  }
  if (!randomWords.hasValue(random)) {
    randomWords.append(random);
  }
}


public StringList getWordsSimilarTo(String word)
{
  word = word.replaceAll("[^a-zA-Z]","").toLowerCase();
  StringList list = new StringList();
  GetRequest get = new GetRequest(url + "?ml=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word").replaceAll("[^a-zA-Z]","").toLowerCase();
    if (!list.hasValue(currentWord)) {
      list.append(currentWord);
    }
  }
  return list;
}

public String getRandomWord() {
  GetRequest get = new GetRequest(randomURL);
  get.send();
  return get.getContent();
}

public StringList getOppositeWords(String word)
{
  word = word.replaceAll("[^a-zA-Z]","").toLowerCase();
  StringList returnList = new StringList();

  GetRequest get = new GetRequest(url + "?rel_ant=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word").replaceAll("[^a-zA-Z]","").toLowerCase();
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
    } else { 
      onSreenWords.put(word, new float[]{onSreenWords.get(word)[0], onSreenWords.get(word)[1] + 1});
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
      ArrayList<String> keys = new ArrayList<String>(oppositeWords.keySet());
      String randomKey = keys.get((int)random(keys.size()));
      StringList words = oppositeWords.get(randomKey);

      if (words.size() != 0) {
        String word = words.remove((int)random(words.size()));
        oppositeWords.put(randomKey, words);
        onSreenWords.put(word, new float[]{wordOppositeAppearX, wordAppearY});
        if (words.size() == 0) {
          oppositeWords.remove(word);
        }
      }
    }
  }
}

public String getClickedWord(int x, int y) {
  int textSize = 25;
  textSize(textSize);
  for (String word : onSreenWords.keySet()) {
    int wordX = (int)onSreenWords.get(word)[0];
    int wordY = (int)onSreenWords.get(word)[1];
    if (wordX <= x && (wordX + textWidth(word)) >= x && (wordY-textSize) <= y && wordY >= y) {
      return word;
    }
  }
  return null;
}

public void handleMouseClickedForWords() {
  if (mouseX >= wordSimilarAppearX && mouseY >= wordAppearY && mouseY <= imageDisappearY)  {
    String clicked = getClickedWord(mouseX, mouseY); 
    if (clicked != null)  {
      collectedWords.append(clicked);
      onSreenWords.remove(clicked);
    }
  }
}