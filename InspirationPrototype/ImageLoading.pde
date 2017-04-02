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

KeywordType currentRetrievingKeyword = KeywordType.Similar;
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
      switch (currentRetrievingKeyword)
      {
        case Similar: retrievalList = similarImages;break;
        case Random: retrievalList = randomImages; break;
        case Opposite: retrievalList = oppositeImages; break;
      } 
      //Once a list begins receiving images, it will continue until it hits 50 so we just monitor until it hits 1
     if (retrievalList != null && retrievalList.size() >= 1)
     {
         stopLoading();
         currentRetrievingKeyword = nextKeywordType(currentRetrievingKeyword);
         
         //If we completed all three (Similar/Random/Opposite) and are back to Similar, then stop refreshing for now.
         isRefreshing = (currentRetrievingKeyword == KeywordType.Similar ? false : true); 
     }
  }
    
  if (isRefreshing && !isRetrieving)
  {
    switch (currentRetrievingKeyword)
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
    currentRetrievingKeyword = KeywordType.Similar;
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

public float getTopImageY(ArrayList<OnScreenImage> imageList)
{
  float topY = 9999;
  float imageY;
  for (int i = 0; i < imageList.size(); i++)
  {
    imageY = imageList.get(i).getY();
    if (imageY < topY) topY = imageY;
  }
  return topY;
}

public void incrementAllY(ArrayList<OnScreenImage> imageList, float yIncrement)
{
  float currentY;
  for (int i = 0; i < imageList.size(); i++)
  {
    currentY = imageList.get(i).getY();
    imageList.get(i).setY(currentY + yIncrement);
  }
}

public void removeOffScreenImages(ArrayList<OnScreenImage> imageList, float yRemoval)
{
  float currentY;
  for (int i = imageList.size(); i > 0; i--)
  {
    currentY = imageList.get(i-1).getY();
    if (currentY > yRemoval)
    {
      imageList.remove(imageList.get(i-1));
    }
  }
}

public void drawImages(ArrayList<OnScreenImage> imageList)
{
  OnScreenImage osi;
  PImage img;
  float imgX;
  float imgY;
  float imgWidth;
  float imgHeight = imageHeight;
  float actualHeight;
  float actualX;
  
  for (int i = 0; i < imageList.size(); i++)
  {
    osi = imageList.get(i);
    img = osi.getImage().getImg();
    imgX = osi.getX();
    imgY = osi.getY();

    actualHeight = Math.min(imgHeight, (imageDisappearY - imgY));
    imgWidth = actualHeight;
    actualX = imgX + (imgHeight - imgWidth)/2;
    
    image(img, actualX, imgY, imgWidth, actualHeight);
  }
}