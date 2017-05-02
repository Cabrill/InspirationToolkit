//GUI static images
PImage backgroundImage;
PImage areaImage;
PImage typeBar;
PImage wordFrame;
PImage prerenderedGUI;
PImage playImage;
PImage pauseImage;
PImage ffImage;
PImage rwImage;

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

float wordPausePlayX;
float wordPausePlayY;
float wordPausePlayWidthHeight;
float wordFFX;
float wordFFY;
float wordRWX;
float wordRWY;
float wordFFRWWidthHeight;

float poemTitleBarX;
float poemTitleBarY;
float poemTitleBarWidth;
float poemTitleBarHeight;

float poemPausePlayX;
float poemPausePlayY;
float poemPausePlayWidthHeight;

float imageTitleBarX;
float imageTitleBarY;
float imageTitleBarWidth;
float imageTitleBarHeight;

float imagePausePlayX;
float imagePausePlayY;
float imagePausePlayWidthHeight;
float imageFFX;
float imageFFY;
float imageRWX;
float imageRWY;
float imageFFRWWidthHeight;

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

int debugTimer = 0;

public void initializeGUI(){
  setupUICoordinates();
  backgroundImage = loadImage("blue_sunburst.png");
  areaImage = loadImage("area.png");
  typeBar = loadImage("type_bar.png");
  wordFrame = loadImage("word_frame.png");
  playImage = loadImage("play.png");
  pauseImage = loadImage("pause.png");
  ffImage = loadImage("ff.png");
  rwImage = loadImage("rw.png");
  drawFullUI();
  prerenderedGUI = get(0, 0, width, height);
}

String partiallyEnteredWord = "";
public void drawPromptForStartWord()
{
  fill(100,100,100,200);
  rect(0,0,width,height);
  fill(200,200,200,255);
  rect(width/3, height/3, width/3, height/3);
  textSize(32);
  fill(0,0,0);
  text("Please enter a starting word:", (width/3)+5, (height/3)+50);
  text(partiallyEnteredWord, (width/3)+5, (height/2));
  fill(255,255,255,255);
}

public void drawDebugText() {
  textSize(12);

  text("Similar Keyword: " + similarKeyword, width/2, height-100);
  text("Random Keyword: " + randomKeyword, width/2, height-80);
  text("Opposite Keyword: " + oppositeKeyword, width/2, height-60);

  text("currentRetrievingKeyword:" + currentRetrievingKeyword, collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 120);
  text("isRetrieving:" + isRetrieving, collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 100);
  text("isRefreshing:" + isRefreshing, collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 80);
  text("Similar Image Count:" + (similarImages == null ? 0 : similarImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 60);
  text("Random Image Count:" + (randomImages == null ? 0 : randomImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 40);
  text("Opposite Image Count:" + (oppositeImages == null ? 0 : oppositeImages.size()), collectedImageTitleX + collectedWordTitleWidth - 150, collectedWordTitleY - 20);
}

public void drawUI() {
  image(prerenderedGUI, 0, 0, displayWidth, displayHeight);
  if (debugEnabled)  {
    drawDebugText();
  }
  if (pauseImages) {
    image(pauseImage, imagePausePlayX, imagePausePlayY, imagePausePlayWidthHeight, imagePausePlayWidthHeight);
  } else {
    image(playImage, imagePausePlayX, imagePausePlayY, imagePausePlayWidthHeight, imagePausePlayWidthHeight);
  }
  
  if (pauseWords) {
    image(pauseImage, wordPausePlayX, wordPausePlayY, wordPausePlayWidthHeight, wordPausePlayWidthHeight);
  } else {
    image(playImage, wordPausePlayX, wordPausePlayY, wordPausePlayWidthHeight, wordPausePlayWidthHeight);
  }
  
  if (pausePoems) {
    image(pauseImage, poemPausePlayX, poemPausePlayY, poemPausePlayWidthHeight, poemPausePlayWidthHeight);
  } else {
    image(playImage, poemPausePlayX, poemPausePlayY, poemPausePlayWidthHeight, poemPausePlayWidthHeight);
  }
  
  if (wordFallSpeed == wordFallMaxSpeed) {
    tint(100);
  } 
  image(ffImage, wordFFX, wordFFY, wordFFRWWidthHeight, wordFFRWWidthHeight);
  tint(255);
  
  if (wordFallSpeed == wordFallMinSpeed) {
    tint(100);
  }
  image(rwImage, wordRWX, wordRWY, wordFFRWWidthHeight, wordFFRWWidthHeight);
  tint(255);
  
  if (imageFallSpeed == imageFallMaxSpeed) {
    tint(100);
  } 
  image(ffImage, imageFFX, imageFFY, imageFFRWWidthHeight, imageFFRWWidthHeight);
  tint(255);
  
  if (imageFallSpeed == imageFallMinSpeed) {
    tint(100);
  }
  image(rwImage, imageRWX, imageRWY, imageFFRWWidthHeight, imageFFRWWidthHeight);
  tint(255);
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
  text("Poem", poemTitleBarX + poemTitleBarWidth*0.42, poemTitleBarY + poemTitleBarHeight * 0.75);

  //collectedImageTitle
  image(wordFrame, collectedImageTitleX, collectedImageTitleY, collectedImageTitleWidth, collectedImageTitleHeight);
  text("Collected Images", collectedImageTitleX + collectedImageTitleWidth/2.8, collectedImageTitleY + collectedImageTitleHeight * 0.7);

  //collectednWordTitle
  image(wordFrame, collectedWordTitleX, collectedWordTitleY, collectedWordTitleWidth, collectedWordTitleHeight);
  text("Collected Words", collectedWordTitleX + (collectedWordTitleWidth/3.5), collectedWordTitleY + (collectedWordTitleHeight*0.7));
}

private void setupUICoordinates() {
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
  wordPausePlayWidthHeight = wordTitleBarHeight * 0.7f;
  wordPausePlayX = wordTitleBarX + (wordPausePlayWidthHeight*0.2f);
  wordPausePlayY = wordTitleBarY + (wordPausePlayWidthHeight*0.2f);
  wordFFX = wordTitleBarX + (0.65 * wordTitleBarWidth);
  wordFFY = wordPausePlayY;
  wordRWX = wordTitleBarX + (0.31 * wordTitleBarWidth);;
  wordRWY = wordPausePlayY;
  wordFFRWWidthHeight = wordPausePlayWidthHeight;

  imageTitleBarX = poemAreaX + poemAreaWidth;
  imageTitleBarY = largeAreaY;
  imageTitleBarWidth = wordAreaX - (poemAreaX + poemAreaWidth);
  imageTitleBarHeight = wordTitleBarHeight; 
  imagePausePlayWidthHeight = imageTitleBarHeight * 0.7f;
  imagePausePlayX = imageTitleBarX + (imagePausePlayWidthHeight*0.2f);
  imagePausePlayY = imageTitleBarY + (imagePausePlayWidthHeight*0.2f);
  imageFFX = imageTitleBarX + (0.65 * imageTitleBarWidth);
  imageFFY = imagePausePlayY;
  imageRWX = imageTitleBarX + (0.31 * imageTitleBarWidth);;
  imageRWY = imagePausePlayY;
  imageFFRWWidthHeight = imagePausePlayWidthHeight;
 
  poemTitleBarX = poemAreaX;
  poemTitleBarY = largeAreaY;
  poemTitleBarWidth = poemAreaWidth;
  poemTitleBarHeight = width /32; 
  poemPausePlayWidthHeight = poemTitleBarHeight * 0.7f;
  poemPausePlayX = poemTitleBarX + (poemPausePlayWidthHeight*0.2f);
  poemPausePlayY = poemTitleBarY + (poemPausePlayWidthHeight*0.2f);

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

public void handleMouseClickForPausePlay()
{
  if (overRect(imagePausePlayX, imagePausePlayY, imagePausePlayWidthHeight, imagePausePlayWidthHeight)) {
    pauseImages = !pauseImages;
  } else if (overRect(wordPausePlayX, wordPausePlayY, wordPausePlayWidthHeight, wordPausePlayWidthHeight)) {
    pauseWords = !pauseWords;
  } else if (overRect(poemPausePlayX, poemPausePlayY, poemPausePlayWidthHeight, poemPausePlayWidthHeight)) {
    pausePoems = !pausePoems;
  }
}

public void handleMouseClickForFFRW()
{
  if (overRect(wordFFX, wordFFY, wordFFRWWidthHeight, wordFFRWWidthHeight)) {
    wordFallSpeed += 0.1f + (0.1f * wordFallSpeed);
    wordFallSpeed = min(wordFallSpeed,wordFallMaxSpeed);
  } else if (overRect(wordRWX, wordRWY, wordFFRWWidthHeight, wordFFRWWidthHeight)) {
    wordFallSpeed -= 0.1f + (0.1f * wordFallSpeed);
    wordFallSpeed = max(wordFallSpeed, wordFallMinSpeed);
  }
  
  else if (overRect(imageFFX, imageFFY, imageFFRWWidthHeight, imageFFRWWidthHeight)) {
    imageFallSpeed += 0.1 + (0.1f * imageFallSpeed);
    imageFallSpeed = min(imageFallSpeed,wordFallMaxSpeed);
    initialImageFallSpeed = imageFallSpeed;
  } else if (overRect(imageRWX, imageRWY, imageFFRWWidthHeight, imageFFRWWidthHeight)) {
    imageFallSpeed -= 0.1f + (01.f * imageFallSpeed);
    imageFallSpeed = max(imageFallSpeed, imageFallMinSpeed);
    initialImageFallSpeed = imageFallSpeed;
  }
}