import http.requests.*;

//JSON Loading info
//https://processing.org/reference/JSONObject.html

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing

//Poetry API:
//http://poetrydb.org/index.html
//https://github.com/thundercomb/poetrydb

//TODO: scrolling of long poems

Boolean pausePoems = false;
double poemScrollSpeed = 0.5;

JSONArray similarPoems = new JSONArray();
StringList currentPoem = new StringList();
HashMap<String, Boolean> poemsUsed = new HashMap();
int index = 0;
float poemScroll = 0;
float maxScroll = 0;
boolean scrollEnabled = false;

PoemList randomPoems;
PoemList oppositePoems;

JSONArray data;

private static final String api = "http://poetrydb.org";

public void updatePoemRetrieval() {
  if (overRect(poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight) ||
      (scrollEnabled && poemScroll < maxScroll) ||
      pausePoems) {
    return;
  } else {
    println("Changing poem!  Poem scroll: " + poemScroll + " / " + maxScroll);
    changePoem();
  }
}

public void handleMouseClickedForPoem() {
  if (overRect(0, poemAppearY, poemAreaWidth, poemAreaHeight)) {
     changePoem(); 
  }
}

public void changePoem() {
  if (index < similarPoems.size() - 1) {
    index++;
    scrollEnabled = false;
    poemScroll = 0;
    thread("loadPoem");
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
  keyword = keyword.replaceAll("\\s","+");
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

String title;
JSONObject poem;
JSONArray lines;
StringList poemLines;
void loadPoem()
{
  poem = similarPoems.getJSONObject(index);
  lines = poem.getJSONArray("lines");
  title = poem.getString("title");
  poemLines = new StringList();
  for (int i = 1; i < lines.size(); i++) {
      poemLines.append(lines.getString(i));
  }
  maxScroll = 40 + (15 * poemLines.size()) - poemAreaHeight/2;
}

void handlePoemScroll(float scrollAmount)
{
  if (scrollEnabled)
  {
    poemScroll += (poemScrollSpeed*2 * scrollAmount);
    poemScroll = max(poemScroll, 0);
    poemScroll = min(poemScroll, maxScroll);
  }
}

void drawCollectedPoems() {
  if (similarPoems.size() > index-1 && poemLines != null && poemLines.size() > 0)
  {
    
    int rowGap = 25;
    float poemX = poemAreaX;
    float poemY = poemAppearY;

    if (scrollEnabled && !pausePoems && !overRect(poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight)) {
      poemScroll += poemScrollSpeed;
    }
    poemY -= poemScroll;
  
    textAlign(CENTER);
    textSize(20);
    if (poemY + rowGap > poemAppearY + 15) {
      text(title, poemX, poemY, poemAreaWidth, poemAreaHeight);
    }
    rowGap += 15;
  
    textSize(12);
    for (int i = 1; i < poemLines.size(); i++) {
      rowGap += 15;

      if (poemY + rowGap > poemAppearY && poemY + rowGap < poemAreaHeight) {
        text(poemLines.get(i), poemX, poemY + rowGap, poemAreaWidth, poemAreaHeight);
      }
      else if (poemY + rowGap > poemAreaHeight) {
         scrollEnabled = true;
         break; 
      }
    }

    textAlign(LEFT);
  }
}