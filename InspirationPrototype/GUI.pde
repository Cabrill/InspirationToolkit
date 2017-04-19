//GUI static images
PImage backgroundImage;
PImage areaImage;
PImage typeBar;
PImage wordFrame;
PImage prerenderedGUI;

//GUI coordinates
float largeAreaHeight;
float largeAreaY;
float areaGap;

float poemAreaX;
float poemAreaY;
float poemAreaWidth;
float poemAreaHeight;

float collectedImageAreaX;
float collectedImageAreaY;
float collectedImageAreaWidth;
float collectedImageAreaHeight;

float collectedImageTitleX;
float collectedImageTitleY;
float collectedImageTitleWidth;
float collectedImageTitleHeight;

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

float poemTitleBarX;
float poemTitleBarY;
float poemTitleBarWidth;
float poemTitleBarHeight;

float imageTitleBarX;
float imageTitleBarY;
float imageTitleBarWidth;
float imageTitleBarHeight;

float imageAppearY;
float imageDisappearY;
float imageHeight;
float imageWidth;
float imageSimilarAppearX;
float imageRandomAppearX;
float imageOppositeAppearX;

float wordSimilarAppearX;
float wordRandomAppearX;
float wordOppositeAppearX;
float wordAppearY;

float zoomedImageX;
float zoomedImageY;
float zoomedImageWidth;
float zoomedImageHeight;

float collectedImageHeight;
float collectedImageWidth;

public void initializeGUI()
{
  setupUICoordinates();
  backgroundImage = loadImage("blue_sunburst.png");
  areaImage = loadImage("area.png");
  typeBar = loadImage("type_bar.png");
  wordFrame = loadImage("word_frame.png");
  drawFullUI();
  prerenderedGUI = get(0,0,width,height);
}

public void drawDebugText()
{
  textSize(12);

  text("Similar Keyword: " + similarKeyword, width/2, height-100);
  text("Random Keyword: " + randomKeyword, width/2, height-150);
  text("Opposite Keyword: " + oppositeKeyword, width/2, height-200);
    
  text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 60);
  text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 40);
  text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 20);
}

public void drawUI()
{
  image(prerenderedGUI, 0, 0, displayWidth, displayHeight);
  if (debugEnabled)
  {
    drawDebugText();
  }
}

public void drawFullUI() {
  textAlign(LEFT);
  //Background
  image(backgroundImage, 0, 0, displayWidth, displayHeight);

  //poemArea
  image(areaImage, poemAreaX, poemAreaY, poemAreaWidth, poemAreaHeight);

  //wordArea
  image(areaImage, wordAreaX, wordAreaY, wordAreaWidth, wordAreaHeight);

  //imageArea
  image(areaImage, collectedImageAreaX, collectedImageAreaY, collectedImageAreaWidth, collectedImageAreaHeight);

  //wordTitleBar
  image(typeBar, wordTitleBarX, wordTitleBarY, wordTitleBarWidth, wordTitleBarHeight);

  //imageTitleBar
  image(typeBar, imageTitleBarX, imageTitleBarY, imageTitleBarWidth, imageTitleBarHeight);

  textSize(32);
  //poemTitleBar
  image(wordFrame, poemTitleBarX, poemTitleBarY, poemTitleBarWidth, poemTitleBarHeight);
  text("Poem", poemTitleBarX + poemTitleBarWidth*0.4, poemTitleBarY + poemTitleBarHeight * 0.75);

  //collectedImageTitle
  image(wordFrame, collectedImageTitleX, collectedImageTitleY, collectedImageTitleWidth, collectedImageTitleHeight);
  text("Collected Images", collectedImageTitleX + collectedImageTitleWidth/4, collectedImageTitleY + collectedImageTitleHeight * 0.75);

  //collectednWordTitle
  image(wordFrame, collectedWordTitleX, collectedWordTitleY, collectedWordTitleWidth, collectedWordTitleHeight);
  text("Collected Words", collectedWordTitleX + (collectedWordTitleWidth/6), collectedWordTitleY + (collectedWordTitleHeight*0.75));
}

private void setupUICoordinates()
{
  largeAreaHeight = height*0.98;
  largeAreaY = height*0.01;
  areaGap = width*0.01;

  poemAreaX = areaGap;
  poemAreaY = largeAreaY;
  poemAreaWidth = width/3;
  poemAreaHeight = largeAreaHeight;

  wordAreaX = width*0.73;
  wordAreaY = largeAreaY;
  wordAreaWidth = width - wordAreaX;
  wordAreaHeight = largeAreaHeight;

  wordTitleBarX = wordAreaX;
  wordTitleBarY = largeAreaY;
  wordTitleBarWidth = wordAreaWidth;
  wordTitleBarHeight = width /32; 

  imageTitleBarX = poemAreaX + poemAreaWidth;
  imageTitleBarY = largeAreaY;
  imageTitleBarWidth = wordAreaX - (poemAreaX + poemAreaWidth);
  imageTitleBarHeight = wordTitleBarHeight; 

  poemTitleBarX = poemAreaX;
  poemTitleBarY = largeAreaY;
  poemTitleBarWidth = poemAreaWidth;
  poemTitleBarHeight = width /32; 

  collectedWordTitleX = wordAreaX;
  collectedWordTitleY = (wordAreaHeight / 2) + wordTitleBarHeight + largeAreaY;
  collectedWordTitleWidth = wordAreaWidth;
  collectedWordTitleHeight = wordAreaHeight / 16;

  collectedWordAreaX = collectedWordTitleX * 1.01;
  collectedWordAreaY = (collectedWordTitleY + collectedWordTitleHeight) * 1.05;
  collectedWordAreaWidth = collectedWordTitleWidth;
  collectedWordAreaHeight = height - collectedWordAreaY;

  collectedImageAreaX = poemAreaX + poemAreaWidth + areaGap;
  collectedImageAreaY = collectedWordTitleY;
  collectedImageAreaWidth = width - poemAreaWidth - wordAreaWidth - (3 * areaGap);
  collectedImageAreaHeight = height -  collectedImageAreaY;

  collectedImageTitleX = imageTitleBarX;
  collectedImageTitleY = collectedWordTitleY;
  collectedImageTitleWidth = collectedImageAreaWidth;
  collectedImageTitleHeight = collectedWordTitleHeight;

  imageAppearY = imageTitleBarY + imageTitleBarHeight;
  imageDisappearY = collectedImageAreaY;
  imageHeight = collectedImageAreaWidth *0.4;
  imageWidth = imageHeight;
  imageSimilarAppearX = imageTitleBarX + areaGap;
  imageRandomAppearX = imageTitleBarX * 1.4;
  imageOppositeAppearX = imageTitleBarX * 1.65;

  wordSimilarAppearX = wordAreaX +5;
  wordRandomAppearX = wordAreaX + wordAreaWidth * 0.4 +5;
  wordOppositeAppearX = wordAreaX + wordAreaWidth * 0.7 +5;
  wordAppearY = wordTitleBarY + wordTitleBarHeight + 20;

  zoomedImageX = imageSimilarAppearX;
  zoomedImageY = imageAppearY;
  zoomedImageWidth = collectedImageTitleWidth;
  zoomedImageHeight = collectedImageTitleY - zoomedImageY;

  collectedImageHeight = collectedImageAreaWidth / 3;
  collectedImageWidth = collectedImageHeight;
}