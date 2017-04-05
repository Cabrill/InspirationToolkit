//Word retrieval API
//http://www.datamuse.com/api/

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

public static StringList similarWords = new StringList();
public static StringList randomWords = new StringList();
public static StringList oppositeWords = new StringList();

private static final String url = "https://api.datamuse.com/words";
private static final String randomURL = "http://randomword.setgetgo.com/get.php";

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