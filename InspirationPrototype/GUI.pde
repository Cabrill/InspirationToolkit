//GUI static images
PImage backgroundImage;
PImage areaImage;
PImage typeBar;
PImage wordFrame;

//GUI coordinates
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

float collectedImageTitleX;
float collectedImageTitleY;
float collectedImageTitleWidth;
float collectedImageTitleHeight;

float imageTitleBarX;
float imageTitleBarY;
float imageTitleBarWidth;
float imageTitleBarHeight;

float imageAppearY;

private void setupUICoordinates()
{
  backgroundImage = loadImage("blue_sunburst.jpg");
  areaImage = loadImage("area.png");
  typeBar = loadImage("type_bar.png");
  wordFrame = loadImage("word_frame.png");
  
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
  
  collectedImageTitleX = collectionAreaX;
  collectedImageTitleY = collectionAreaY;
  collectedImageTitleWidth = collectionAreaWidth;
  collectedImageTitleHeight = collectionAreaHeight / 16;
  
  collectedWordTitleX = collectionAreaX;
  collectedWordTitleY = collectionAreaHeight / 2 + (collectedImageTitleHeight);
  collectedWordTitleWidth = collectedImageTitleWidth;
  collectedWordTitleHeight = collectedImageTitleHeight;
    
  imageTitleBarX = collectionAreaX + collectionAreaWidth;
  imageTitleBarY = largeAreaY;
  imageTitleBarWidth = wordAreaX - (collectionAreaX + collectionAreaWidth);
  imageTitleBarHeight = collectedImageTitleHeight; 
  
  imageAppearY = imageTitleBarY + imageTitleBarHeight;
  imageHeight = imageAppearY;
}

public void drawUI() {
=======
float imageSimilarAppearX;
float imageRandomAppearX;
float imageOppositeAppearX;

public void initializeGUI()
{
   setupUICoordinates();
   backgroundImage = loadImage("blue_sunburst.jpg");
   areaImage = loadImage("area.png");
   typeBar = loadImage("type_bar.png");
   wordFrame = loadImage("word_frame.png"); 
}

public void drawDebugText()
{
   textSize(12);
   text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), width/2, height/2);
   text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), width/2, 20 + height/2);
   text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), width/2, 40 + height/2);
}

public void drawUI() {
  //Background
  image(backgroundImage, 0, 0, displayWidth, displayHeight);
  
  //CollectionArea
  image(areaImage, collectionAreaX, collectionAreaY, collectionAreaWidth, collectionAreaHeight);
  
  //wordArea
  image(areaImage, wordAreaX, wordAreaY, wordAreaWidth, wordAreaHeight);
  
  //wordTitleBar
  image(typeBar, wordTitleBarX, wordTitleBarY, wordTitleBarWidth, wordTitleBarHeight);
  
  //imageTitleBar
  image(typeBar, imageTitleBarX, imageTitleBarY, imageTitleBarWidth, imageTitleBarHeight);
  
  textSize(32);
  //collectedImageTitle
  image(wordFrame, collectedImageTitleX, collectedImageTitleY, collectedImageTitleWidth, collectedImageTitleHeight);
  text("Collected Images", collectedImageTitleWidth/3, collectedImageTitleY*5);
  
  //collectednWordTitle
  image(wordFrame, collectedWordTitleX, collectedWordTitleY, collectedWordTitleWidth, collectedWordTitleHeight);
  text("Collected Words", collectedWordTitleWidth/3, collectedWordTitleY + (collectedWordTitleHeight*0.7));

   
   if (debugEnabled)
   {
     drawDebug();
   }
}

private void drawDebug()
{
   textSize(12);
   text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 60);
   text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 40);
   text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 20);  
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
   imageSimilarAppearX = imageTitleBarX;
   imageRandomAppearX = imageTitleBarX * 1.33;
   imageOppositeAppearX = imageTitleBarX * 1.66;
}