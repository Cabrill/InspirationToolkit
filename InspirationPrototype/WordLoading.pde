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

public void updateWordRetrival() {
  String random = getRandomWord();
  if (collectedWords.size() != 0) {
    for (String collected : collectedWords) {
      if (!similarWords.containsKey(collected)) {
        similarWords.put(collected, getWordsSimilarTo(collected));
      } 
      if (!oppositeWords.containsKey(collected)) {
        oppositeWords.put(collected, getOppositeWords(collected));
      }
    }
  }
  if (!randomWords.hasValue(random)) {
    randomWords.append(random);
  }
}

public StringList getWordsSimilarTo(String word) {
  StringList list = new StringList();
  GetRequest get = new GetRequest(url + "?ml=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word");
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

public StringList getOppositeWords(String word) {
  StringList returnList = new StringList();

  GetRequest get = new GetRequest(url + "?rel_ant=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word");
    returnList.append(currentWord);
  }
  return returnList;
}

public void updateWordLocations() {
  StringList deletable = new StringList();
  for (String word : onSreenWords.keySet()) {
    textSize(25);
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
  int random = (int) random(3);
  switch(random) {
  case 0: 
    addRandomWord();
    break;
  case 1: 
    addSimilarWord();
    break;
  case 2: 
    addOppositeWord();
    break;
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
  for (String word : onSreenWords.keySet()) {
    int wordX = (int)onSreenWords.get(word)[0];
    int wordY = (int)onSreenWords.get(word)[1];
    textSize(25);
    if (wordX <= x && (wordX + textWidth(word)) >= x && (wordY-25) <= y && wordY >= y) {
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