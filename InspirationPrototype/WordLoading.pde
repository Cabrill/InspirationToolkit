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
  String word = "BEANS";
  if (collectedWords.size() != 0) {
    word = collectedWords.get((int)random(collectedWords.size()));
  } else { 
    word = currentUpdatingKeyword.toString();
  }
  if (!randomWords.hasValue(random)) {
    randomWords.append(random);
  }

  if (!similarWords.containsKey(word)) {
    similarWords.put(word, getWordsSimilarTo(word));
  }

  if (!oppositeWords.containsKey(word)) {
    oppositeWords.put(word, getOppositeWords(word));
  }
}

public StringList getWordsSimilarTo(String word)
{
  StringList list = new StringList();
  GetRequest get = new GetRequest(url + "?ml=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word");
    int score = json.getInt("score");
    if (score < 30000) break;
    if (!list.hasValue(currentWord)) {
      list.append(currentWord);
    }
  }
  return list;
}

public String getRandomWord()
{
  GetRequest get = new GetRequest(randomURL);
  get.send();
  return get.getContent();
}

public StringList getOppositeWords(String word)
{
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

  for (String word : onSreenWords.keySet()) {
    text(word, onSreenWords.get(word)[0], onSreenWords.get(word)[1]);
    onSreenWords.put(word, new float[]{onSreenWords.get(word)[0], onSreenWords.get(word)[1] + 10});
  }
}

public void addWordToOnScreenWords() {
  int random = (int) random(3);
  switch(random) {
  case 0: 
    addRandomWord();
  case 1: 
    addSimilarWord();
  case 2: 
    addOppositeWord();
  }
}

public void addRandomWord() {
  String word = randomWords.remove((int)random(randomWords.size()));
  onSreenWords.put(word, new float[]{wordRandomAppearX, wordAppearY});
}

public void addSimilarWord() {
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
public void addOppositeWord() {
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