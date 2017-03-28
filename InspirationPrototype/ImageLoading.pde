import at.mukprojects.imageloader.*;
import at.mukprojects.imageloader.file.*;
import at.mukprojects.imageloader.flickr.*;
import at.mukprojects.imageloader.image.*;

//API info tied to cabrill@hotmail.com
//https://www.flickr.com/services/apps/72157679930482211/key
String apiKey = "974dd25b0edd998bcce9bc2127ebe42c";
String apiSecret = "c5f08b40712e9b20";
///

//Documentation found at:
//https://github.com/keshrath/ImageLoader

int timeOutSeconds = 60;

KeywordType currentKeyword = KeywordType.Similar;
Boolean isRetrieving;
Boolean isRefreshing = true;

ImageList similarImages;
ImageList randomImages;
ImageList oppositeImages;

ImageLoader loader;

public void initializeImageLoader()
{
  loader = new FlickrLoader(this, apiKey, apiSecret);
  similarImages = retrieveImages(similarKeyword);
}

public void updateImageRetrieval()
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
      //Once a list begins receiving images, it will continue until it hits 50 so we just monitor until it hits 1
     if (retrievalList != null && retrievalList.size() >= 1)
     {
         stopLoading();
         currentKeyword = nextKeywordType();
         
         //If we completed all three (Similar/Random/Opposite) and are back to Similar, then stop refreshing for now.
         isRefreshing = (currentKeyword == KeywordType.Similar ? false : true); 
     }
  }
    
  if (isRefreshing && !isRetrieving)
  {
    switch (currentKeyword)
    {
      case Similar:
        similarImages = retrieveImages(similarKeyword); break;
      case Random:
        randomImages = retrieveImages(randomKeyword); break;
      case Opposite:
        oppositeImages = retrieveImages(oppositeKeyword); break;
    } 
  }
}

public void notifyImagesThatKeywordsChanged()
{
    isRefreshing = true;
    isRetrieving = false;
    currentKeyword = KeywordType.Similar;
}

private void stopLoading()
{
  isRetrieving = false;
  loader.stop();
}


private ImageList retrieveImages(String keyword)
{
  isRetrieving = true;
  return loader.start(keyword, false, timeOutSeconds * 1000);
}