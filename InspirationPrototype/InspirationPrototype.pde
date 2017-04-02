static final int MAX_CHOSEN_OBJECTS = 20;


Boolean debugEnabled = true;

public enum KeywordType {Similar, Opposite, Random}

KeywordType chooseCurrentType;


ImageList chosenImages;
StringList chosenStrings;
PoemList chosenPoems;

KeywordType currentUpdatingKeyword = KeywordType.Similar;

ArrayList<OnScreenImage> onScreenSimilarImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenRandomImages = new ArrayList<OnScreenImage>();
ArrayList<OnScreenImage> onScreenOppositeImages = new ArrayList<OnScreenImage>();

//Temporary hard-codedkeywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

int imageFallSpeed = 4;

public void setup() {
  fullScreen();
  chooseCurrentType = KeywordType.Similar;
  //size(displayWidth, displayHeight);
  initializeGUI();
  initializeImageLoader();
}      

public void draw() {
  updateImageRetrieval();

  drawUI();
    updateImageLocations();
}

void updateImageLocations()
{
    ImageList imgSource = null;
    float imageAppearX = 0;
    float earliestAppearY = 0;
    ArrayList<OnScreenImage>  OSI = null;
    
    float topSimilarY = getTopImageY(onScreenSimilarImages);
    float topRandomY = getTopImageY(onScreenRandomImages);
    float topOppositeY = getTopImageY(onScreenOppositeImages);
    switch (currentUpdatingKeyword)
    {
       case Similar: imgSource = similarImages; imageAppearX = imageSimilarAppearX; OSI = onScreenSimilarImages;
       earliestAppearY = Math.min(topSimilarY, topRandomY);
       break;
       case Random: imgSource = randomImages; imageAppearX = imageRandomAppearX; OSI = onScreenRandomImages; 
       earliestAppearY = Math.min(Math.min(topSimilarY, topRandomY), topOppositeY);
       break;
       case Opposite: imgSource = oppositeImages; imageAppearX = imageOppositeAppearX; OSI = onScreenOppositeImages; 
       earliestAppearY = Math.min(topOppositeY, topRandomY);
       break;
       
    }
    if (imgSource != null && imgSource.size() > 0 && earliestAppearY > (imageHeight+imageAppearY))
    {
      Image img = imgSource.getRandom();
      OnScreenImage osi = new OnScreenImage(img, imageAppearX, imageAppearY);
      OSI.add(osi);
      currentUpdatingKeyword = nextKeywordType(currentUpdatingKeyword);
    }
    incrementAllY(onScreenSimilarImages, imageFallSpeed);
    incrementAllY(onScreenRandomImages, imageFallSpeed);
    incrementAllY(onScreenOppositeImages, imageFallSpeed);
    
    removeOffScreenImages(onScreenSimilarImages, imageDisappearY);
    removeOffScreenImages(onScreenRandomImages, imageDisappearY);
    removeOffScreenImages(onScreenOppositeImages, imageDisappearY);
    
    drawImages(onScreenSimilarImages);
    drawImages(onScreenRandomImages);
    drawImages(onScreenOppositeImages);
}

void mousePressed() {
  //img = randomImages.getRandom();
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

private KeywordType nextKeywordType(KeywordType kt)
{
  return KeywordType.values()[(kt.ordinal() + 1) % 3];
}