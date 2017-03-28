static final int MAX_CHOSEN_OBJECTS = 20;

public enum KeywordType {Similar, Random, Opposite}

ImageList chosenImages;
StringList chosenStrings;
PoemList chosenPoems;

//Temporary hard-coded keywords
String similarKeyword = "Happy";
String randomKeyword = "Random";
String oppositeKeyword = "Sad";

Image img;
float imageHeight;
int imageFallSpeed = 2;

public void setup() {
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