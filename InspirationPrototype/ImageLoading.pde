import at.mukprojects.imageloader.*;
import at.mukprojects.imageloader.file.*;
import at.mukprojects.imageloader.flickr.*;
import at.mukprojects.imageloader.image.*;

//API info tied to cabrill@hotmail.com
//https://www.flickr.com/services/apps/72157679930482211/key
String apiKey = "974dd25b0edd998bcce9bc2127ebe42c";
String apiSecret = "c5f08b40712e9b20";
///

int timeOutSeconds = 60;

KeywordType currentKeyword = KeywordType.Similar;
Boolean isRetrieving;
Boolean isRefreshing;

ImageList similarImages;
ImageList randomImages;
ImageList oppositeImages;

ImageLoader loader;

public void InitializeImageLoader()
{
  loader = new FlickrLoader(this, apiKey, apiSecret);
  similarImages = loader.start(similarKeyword, false, timeOutSeconds * 1000);
  isRetrieving = true;
  isRefreshing = true;
}

public void UpdateImageRetrieval()
{
  if (isRefreshing && isRetrieving)
  {

      ImageList retrievalList = null;
      switch (currentKeyword)
      {
        case Similar: retrievalList = similarImages;break;
        case Random: retrievalList = randomImages; break;
        case Opposite: retrievalList = oppositeImages; break;
      } 
     if (retrievalList != null && retrievalList.size() >= maxObjectPerType)
     {
         StopLoading();
         currentKeyword = NextKeywordType();
         
         //If we completed all three (Similar/Random/Opposite) and are back to Similar, then stop refreshing for now.
         isRefreshing = (currentKeyword == KeywordType.Similar ? false : true); 
     }
  }
    
  if (isRefreshing && !isRetrieving)
  {
    switch (currentKeyword)
    {
      case Similar:
        similarImages = RetrieveImages(similarKeyword); break;
      case Random:
        randomImages = RetrieveImages(randomKeyword); break;
      case Opposite:
        oppositeImages = RetrieveImages(oppositeKeyword); break;
    } 
  }
}

public void NotifyImagesThatKeywordsChanged()
{
    isRefreshing = true;
    isRetrieving = false;
    currentKeyword = KeywordType.Similar;
}

private void StopLoading()
{
  isRetrieving = false;
  loader.stop();
}

private KeywordType NextKeywordType()
{
  return KeywordType.values()[(currentKeyword.ordinal() + 1) % 3];
}

private ImageList RetrieveImages(String keyword)
{
  isRetrieving = true;
  return loader.start(keyword, false, timeOutSeconds * 1000);
}