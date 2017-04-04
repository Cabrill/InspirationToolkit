//Word retrieval API
//http://www.datamuse.com/api/

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

public static StringList similarWords = new StringList();
public static StringList randomWords = new StringList();
public static StringList oppositeWords;

private static final String url = "https://api.datamuse.com/words";
private static final String randomURL = "http://randomword.setgetgo.com/get.php";

public void getWordsSimilarTo(String word)
{
  GetRequest get = new GetRequest(url + "?ml=" + word);
  get.send();

  String response = get.getContent();
  JSONArray jsonArray = JSONArray.parse(response);

  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject json = jsonArray.getJSONObject(i); 
    String currentWord = json.getString("word");
    int score = json.getInt("score");
    if (score < 30000) break;
    if (!similarWords.hasValue(currentWord)) {
      similarWords.append(currentWord);
    }
  }
}

public void getRandomWord()
{
  GetRequest get = new GetRequest(randomURL);
  get.send();
  onScreenWords.put(get.getContent(), new float[]{wordRandomAppearX, imageAppearY});
}

public StringList getOppositeWords(String word)
{
  StringList returnList = new StringList();
  //TODO
  return returnList;
}