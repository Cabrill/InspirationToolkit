static final int MAX_CHOSEN_OBJECTS = 20;


Boolean debugEnabled = true;

public enum KeywordType {Similar, Opposite, Random}

KeywordType chooseCurrentType;

ImageList chosenImages = new ImageList();
StringList chosenWords = new StringList();
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
  drawChosenWords();
}      

public void draw() {
  updateImageRetrieval();
  drawUI();
  updateImageLocations();
  drawChosenWords();
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
  chooseAnyClickedImage(onScreenSimilarImages);
  chooseAnyClickedImage(onScreenRandomImages);
  chooseAnyClickedImage(onScreenOppositeImages);
}



void drawChosenWords()
{
  int rowGap = 20;
  int colGap = 40;
  float startX = collectedWordAreaX * 1.01;
  float startY = (collectedWordAreaY + collectedWordTitleHeight) * 1.01;
  float wordX = startX;
  float wordY = startY;
  
  textSize(24);
  for (int i = 0; i < chosenWords.size(); i++)
  {
    text(chosenWords.get(i), wordX, wordY);
    wordY += rowGap;
    if (wordY >= (collectedWordAreaY + collectedWordAreaHeight)-rowGap)
    {
       wordY = startY;
       wordX += colGap;
    }
  }
}

boolean overRect(float x, float y, float width, float height)  {
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