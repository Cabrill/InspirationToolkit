static final int MAX_CHOSEN_OBJECTS = 20;


Boolean debugEnabled = true;

public enum KeywordType {Similar, Random, Opposite}

KeywordType chooseCurrentType;


ImageList chosenImages;
StringList chosenStrings;
PoemList chosenPoems;

ArrayList<OnScreenImage> onScreenImages = new ArrayList<OnScreenImage>();

//Temporary hard-codedkeywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

Image img;
float imageHeight;
int imageFallSpeed = 2;

public void setup() {
  chooseCurrentType = KeywordType.Similar;
  size(displayWidth, displayHeight);
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
  if (img == null) {
    ImageList imgSource = null;
    float imageAppearX = 0;
    switch (currentKeyword)
    {
       case Similar: imgSource = similarImages; imageAppearX = imageSimilarAppearX; break;
       case Random: imgSource = randomImages; imageAppearX = imageRandomAppearX; break;
       case Opposite: imgSource = oppositeImages; imageAppearX = imageOppositeAppearX; break;
       
    }
    if (imgSource != null && imgSource.size() > 0)
    {
      img = imgSource.getRandom();
      OnScreenImage osi = new OnScreenImage(img, imageAppearX, imageAppearY);
      onScreenImages.add();
    }
  } else {
    image(img.getImg(), width/2, imageHeight, width*0.2, height*0.2);
    imageHeight += imageFallSpeed ;
    if (imageHeight > height)
    {
       img = similarImages.getRandom();
       imageHeight = imageAppearY; 
    }
  }
}

void mousePressed() {
  img = randomImages.getRandom();
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

private KeywordType nextKeywordType()
{
  return KeywordType.values()[(currentKeyword.ordinal() + 1) % 3];
}