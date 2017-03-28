static final int MAX_CHOSEN_OBJECTS = 20;

Boolean debugEnabled = true;

ImageList chosenImages;
StringList chosenStrings;
PoemList chosenPoems;

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