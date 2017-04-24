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

ArrayList<OnScreenImage> onScreenSimilarImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenRandomImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenOppositeImages = new ArrayList<OnScreenImage>();

ImageLoader loader;

//Declaration of local variables for reuse
private Image img;
private PImage pimg;
private OnScreenImage osi;
private ArrayList<OnScreenImage> OSI;

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

public boolean drawImages(ArrayList<OnScreenImage> imageList)
{
  int startTime, endTime;
  osi = getAnyHoveredImage(imageList);
  
  if (osi != null)
  {
    image(osi.getImage().getImg(), zoomedImageX, zoomedImageY, zoomedImageWidth, zoomedImageHeight);
    return true;
  }
  else 
  {
    float imgX;
    float imgY;
    float imgWidth;
    float imgHeight = imageHeight;
    float actualHeight;
    float actualX;
    
    for (int i = 0; i < imageList.size(); i++)
    {
      osi = imageList.get(i);
      pimg = osi.getImage().getImg();

      imgX = osi.getX();
      imgY = osi.getY();
  
      actualHeight = Math.min(imgHeight, (imageDisappearY - imgY));
      imgWidth = actualHeight;
      actualX = imgX + (imgHeight - imgWidth)/2;
      
      osi.setHeight(actualHeight);
      osi.setWidth(imgWidth);
      osi.setEffectiveX(actualX);
      
      image(pimg, actualX, imgY, imgWidth, actualHeight);

    }
    return false;
  }
}

public void chooseAnyClickedImage(ArrayList<OnScreenImage> imageList)
{
  osi = getAnyHoveredImage(imageList);
  if (osi != null)
  {
    addImageToCollection(osi);
    imageList.remove(osi);
  }
  else 
  {
    for (int i = imageList.size(); i > 0; i--)
    {
      osi = imageList.get(i-1);
      if (overRect(osi.getEffectiveX(), osi.getY(), osi.getWidth(), osi.getHeight()))
      {
        addImageToCollection(osi);
        imageList.remove(osi);
      }
    }
  }
}

private void addImageToCollection(OnScreenImage onScreenImage)
{
  collectedImages.addImage(onScreenImage.getImage());
  String keyword = onScreenImage.getSourceKeyword();
  if (!collectedWords.hasValue(keyword)){
    collectedWords.append(onScreenImage.getSourceKeyword());
  }
}

public OnScreenImage getAnyHoveredImage(ArrayList<OnScreenImage> imageList)
{
  for (int i = imageList.size(); i > 0; i--)
  {
      osi = imageList.get(i-1);
      if (osi.getIsZoomed())
      {
        boolean isStillZoomed = overRect(zoomedImageX, zoomedImageY, zoomedImageWidth, zoomedImageHeight);
        osi.setIsZoomed(isStillZoomed);
        if (isStillZoomed) return osi;
      }
      if (overRect(osi.getEffectiveX(), osi.getY(), osi.getWidth(), osi.getHeight()))
      {
        osi.setIsZoomed(true);
        return osi;
      }
  }
  return null;
}

public boolean anyImageIsZoomed(ArrayList<OnScreenImage> imageList)
{
  for (int i = imageList.size(); i > 0; i--)
  {
      osi = imageList.get(i-1);
      if (osi.getIsZoomed())
      {
        return true;
      }
  }
  return false;
}

Boolean isPreLoading = false;
void addNewImage()
{
  if (!isPreLoading)
  {
    ImageList imgSource = null;
    float imageAppearX = 0;
    float earliestAppearY = 0;
    ArrayList<OnScreenImage>  OSI = null;
    String keyword = null;
    
    float topSimilarY = getTopImageY(onScreenSimilarImages);
    float topRandomY = getTopImageY(onScreenRandomImages);
    float topOppositeY = getTopImageY(onScreenOppositeImages);
    switch (currentUpdatingKeyword)
    {
       case Similar: imgSource = similarImages; imageAppearX = imageSimilarAppearX; OSI = onScreenSimilarImages;
       keyword = similarKeyword;
       earliestAppearY = Math.min(topSimilarY, topRandomY);
       break;
       case Random: imgSource = randomImages; imageAppearX = imageRandomAppearX; OSI = onScreenRandomImages; 
       keyword = randomKeyword;
       earliestAppearY = Math.min(Math.min(topSimilarY, topRandomY), topOppositeY);
       break;
       case Opposite: imgSource = oppositeImages; imageAppearX = imageOppositeAppearX; OSI = onScreenOppositeImages; 
       keyword = oppositeKeyword;
       earliestAppearY = Math.min(topOppositeY, topRandomY);
       break;
    }
    
      
    if (imgSource != null && imgSource.size() > 0 && earliestAppearY > (imageHeight+imageAppearY))
    {
      Image newImg = imgSource.getRandom();
      //preload image source
      isPreLoading = true;
      PImage newPImg= newImg.getImg();
      OSI.add(new OnScreenImage(newImg, imageAppearX, imageAppearY, keyword));
      currentUpdatingKeyword = nextKeywordType(currentUpdatingKeyword);
      isPreLoading = false;
    } 
  }
}

void updateImageLocations()
{
    thread("addNewImage");

    incrementAllY(onScreenSimilarImages, imageFallSpeed);
    incrementAllY(onScreenRandomImages, imageFallSpeed);
    incrementAllY(onScreenOppositeImages, imageFallSpeed);
    
    removeOffScreenImages(onScreenSimilarImages, imageDisappearY);
    removeOffScreenImages(onScreenRandomImages, imageDisappearY);
    removeOffScreenImages(onScreenOppositeImages, imageDisappearY);

    boolean anyZoomed = drawImages(onScreenSimilarImages);
    if (!anyZoomed)
    {
      anyZoomed = drawImages(onScreenRandomImages);
    }
    if (!anyZoomed)
    {
      anyZoomed = drawImages(onScreenOppositeImages);
    }

    if (anyZoomed)
    {
      imageFallSpeed = 0;
    }
    else
    {
      imageFallSpeed = 2; 
    }
}

public void handleMouseClickedForImages()
{
  boolean similarZoomed = anyImageIsZoomed(onScreenSimilarImages);
  boolean randomZoomed = anyImageIsZoomed(onScreenRandomImages);
  boolean oppositeZoomed = anyImageIsZoomed(onScreenOppositeImages);
  if (!similarZoomed && !randomZoomed && !oppositeZoomed)
  {
    chooseAnyClickedImage(onScreenSimilarImages);
    chooseAnyClickedImage(onScreenRandomImages);
    chooseAnyClickedImage(onScreenOppositeImages);
  }
  else
  {
    if (similarZoomed) chooseAnyClickedImage(onScreenSimilarImages);
    if (randomZoomed) chooseAnyClickedImage(onScreenRandomImages);
    if (oppositeZoomed) chooseAnyClickedImage(onScreenOppositeImages);
  }
}


private float startX;
private float startY;
private float imageX;
private float imageY;
private float rowGap;
private float colGap;
private float areaCheck;
public void drawCollectedImages() {
  if (collectedImages.size() > 0) {
    startX = collectedImageAreaX + 5;
    startY = collectedImageAreaY + collectedImageTitleHeight + 5;
    imageX = startX;
    imageY = startY;
    rowGap = collectedImageHeight+10;
    colGap = 20;
    
    for (int i = 0; i < collectedImages.size(); i++) {
      img = collectedImages.getImage(i);
      areaCheck = (i == collectedImages.size()-1 ? collectedImageWidth : colGap);
      if (overRect(imageX, imageY, areaCheck, collectedImageAreaHeight)) {
        image(img.getImg(), startX, startY, collectedImageAreaHeight*.9, collectedImageAreaHeight*.9);
        break;
      }
      image(img.getImg(), imageX, imageY, collectedImageWidth, collectedImageHeight);
      
      imageX += colGap;
      
      if (imageX > collectedImageAreaX + (collectedImageAreaWidth - collectedImageWidth)) {
        imageX = startX;
        imageY += rowGap;
      }
    }
  }
}