import http.requests.*;

//JSON Loading info
//https://processing.org/reference/JSONObject.html

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing

//Poetry API:
//http://poetrydb.org/index.html
//https://github.com/thundercomb/poetrydb

//TODO: scrolling of long poems

JSONArray similarPoems = new JSONArray();
StringList currentPoem = new StringList();
HashMap<String, Boolean> poemsUsed = new HashMap();
int index = 0;
double poemScroll = 0;
boolean scrollEnabled = false;

PoemList randomPoems;
PoemList oppositePoems;

JSONArray data;

private static final String api = "http://poetrydb.org";

public void updatePoemRetrieval() {
  if (overRect(poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight)) {
    return;
  } else if (index < similarPoems.size() - 1) {
    index++;
    scrollEnabled = false;
    poemScroll = 0;
  } else {
    println("retrieving new poems");
    index++;
    keyword = similarKeyword;
    searchLines = true;
    thread("getPoems");
    println("retrieved");
  }
}

String keyword;
Boolean searchLines;
public void getPoems() {
  GetRequest get;
  if (searchLines) {
    get = new GetRequest(api + "/lines/" + keyword);
  } else {
    get = new GetRequest(api + "/title/" + keyword);
  }

  get.send();
  String response = get.getContent();

  if (response.contains("\"status\":404")) {
    println("No poem found with keyword: " + keyword);
    index = 0;
  } else {
    data = JSONArray.parse(response);

    int limit = 50;
    for (int i = 0; i < data.size(); i++) {
      JSONObject poem = data.getJSONObject(i);
      similarPoems.append(poem);
      if (i > limit) {
        return;
      }
    }
  }
}

void drawCollectedPoems() {
  int rowGap = 25;
  float topLimit = poemAreaY + poemTitleBarY + poemTitleBarHeight;
  float bottomLimit = height - poemTitleBarHeight;
  float poemX = poemAreaX;
  float poemY = topLimit;

  if (similarPoems.size() > 0)
  {
    JSONObject poem = similarPoems.getJSONObject(index);
    JSONArray lines = poem.getJSONArray("lines");
  
    if (scrollEnabled && overRect(poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight)) {
      poemScroll += 2;
    }
  
    poemY -= poemScroll;
  
    String title = poem.getString("title");
    textAlign(CENTER);
    textSize(20);
    if (poemY + rowGap > topLimit + 15) {
      text(title, poemX, poemY, poemAreaWidth, poemAreaHeight);
    }
    rowGap += 15;
  
    for (int i = 1; i < lines.size(); i++) {
      rowGap += 15;
      String p = lines.getString(i);
  
      if (poemY + rowGap > topLimit && poemY + rowGap < bottomLimit) {
        textSize(12);
        text(p, poemX, poemY + rowGap, poemAreaWidth, poemAreaHeight);
      }
    }
    if (poemY + rowGap > poemAreaHeight) {
      scrollEnabled = true;
    }
    textAlign(LEFT);
  }
}