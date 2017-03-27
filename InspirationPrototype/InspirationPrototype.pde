import g4p_controls.*;

static final int MAX_CHOSEN_OBJECTS = 20;
PImage backgroundImage;
PImage areaImage;
PImage typeBar;
PImage wordFrame;

ImageList chosenImages;
StringList chosenStrings;
PoemList chosenPoems;

//UI coordinates
float largeAreaHeight;
float largeAreaY;
float areaGap;

float collectionAreaX;
float collectionAreaY;
float collectionAreaWidth;
float collectionAreaHeight;

float collectedWordAreaX;
float collectedWordAreaY;
float collectedWordAreaWidth;
float collectedWordAreaHeight;

float collectedWordTitleX;
float collectedWordTitleY;
float collectedWordTitleWidth;
float collectedWordTitleHeight;

float wordAreaX;
float wordAreaY;
float wordAreaWidth;
float wordAreaHeight;

float wordTitleBarX;
float wordTitleBarY;
float wordTitleBarWidth;
float wordTitleBarHeight; 

float collectionTitleBarX;
float collectionTitleBarY;
float collectionTitleBarWidth;
float collectionTitleBarHeight;

float imageTitleBarX;
float imageTitleBarY;
float imageTitleBarWidth;
float imageTitleBarHeight;

float imageAppearY;

//Temporary hard-codedkeywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

public enum KeywordType {Similar, Random, Opposite}

Image img;
float imageHeight;
int imageFallSpeed = 2;

public void setup() {
   size(1920,1080);
   setupUICoordinates();
   backgroundImage = loadImage("blue_sunburst.jpg");
   areaImage = loadImage("area.png");
   typeBar = loadImage("type_bar.png");
   wordFrame = loadImage("word_frame.png");
   initializeImageLoader();
}      

public void draw() {
  background(backgroundImage);
  updateImageRetrieval();
  drawUI();
  
  if (img == null) {
    if (similarImages != null)
    {
      img = similarImages.getRandom();
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

  textSize(12);
   text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), width/2, height/2);
   text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), width/2, 20 + height/2);
   text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), width/2, 40 + height/2);
}

public void drawUI() {
  //CollectionArea
  image(areaImage, collectionAreaX, collectionAreaY, collectionAreaWidth, collectionAreaHeight);
  
  //wordArea
  image(areaImage, wordAreaX, wordAreaY, wordAreaWidth, wordAreaHeight);
  
  //wordTitleBar
  image(typeBar, wordTitleBarX, wordTitleBarY, wordTitleBarWidth, wordTitleBarHeight);
  
  //collectionTitleBar
  image(wordFrame, collectionTitleBarX, collectionTitleBarY, collectionTitleBarWidth, collectionTitleBarHeight);
  textSize(32);
  text("Collected Images", collectionTitleBarWidth/3, collectionTitleBarY*5);

  //imageTitleBar
  image(typeBar, imageTitleBarX, imageTitleBarY, imageTitleBarWidth, imageTitleBarHeight);
}

private void setupUICoordinates()
{
  largeAreaHeight = height*0.98;
  largeAreaY = height*0.01;
  areaGap = width*0.01;
  
  collectionAreaX = areaGap;
  collectionAreaY = largeAreaY;
  collectionAreaWidth = width/3;
  collectionAreaHeight = largeAreaHeight;
  
  wordAreaX = width*0.73;
  wordAreaY = largeAreaY;
  wordAreaWidth = width - wordAreaX;
  wordAreaHeight = largeAreaHeight;
  
  wordTitleBarX = wordAreaX;
  wordTitleBarY = largeAreaY;
  wordTitleBarWidth = wordAreaWidth;
  wordTitleBarHeight = width /32; 
  
  collectionTitleBarX = collectionAreaX;
  collectionTitleBarY = collectionAreaY;
  collectionTitleBarWidth = collectionAreaWidth;
  collectionTitleBarHeight = collectionAreaHeight / 16;
  
  collectedWordTitleX = collectionAreaX;
  collectedWordTitleY = collectionAreaY / 2 + (collectionTitleBarHeight);
  collectedWordTitleWidth = collectionTitleBarWidth;
  collectedWordTitleHeight = collectionTitleBarHeight;
    
  imageTitleBarX = collectionAreaX + collectionAreaWidth;
  imageTitleBarY = largeAreaY;
  imageTitleBarWidth = wordAreaX - (collectionAreaX + collectionAreaWidth);
  imageTitleBarHeight = collectionTitleBarHeight; 
  
  imageAppearY = imageTitleBarY + imageTitleBarHeight;
  imageHeight = imageAppearY;
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