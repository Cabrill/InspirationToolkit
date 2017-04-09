import http.requests.*;

//JSON Loading info
//https://processing.org/reference/JSONObject.html

//HTML Get/Post
//https://github.com/runemadsen/HTTP-Requests-for-Processing

//Poetry API:
//http://poetrydb.org/index.html
//https://github.com/thundercomb/poetrydb

PoemList similarPoems;
PoemList randomPoems;
PoemList oppositePoems;

private static final String api = "http://poetrydb.org";

public void GetPoem()
{
   GetRequest get = new GetRequest(api + "/lines/happy");
  get.send(); 
}