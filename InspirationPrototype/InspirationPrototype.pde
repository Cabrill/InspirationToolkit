// This sketch shows how to use the Amplitude class to analyze a
// stream of sound. In this case a sample is analyzed. Smooth_factor
// determines how much the signal will be smoothed on a scale
// form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;
FFT fft;
AudioDevice device;

// Define how many FFT bands we want
int bands = 128;

// Declare a scaling factor
float scale=5;

// Declare a smooth factor
float smooth_factor=0.25;

// Create a smoothing vector
float[] sums = new float[bands];

// declare a drawing variable for calculating rect width
float r_width;

// Used for smoothing
float sum;

int buttonGap = 20;

//Button dimensions
int largeButtonWidth = 150;
int largeButtonHeight = 50;
int smallButtonWidth = 100;
int smallButtonHeight = 50;

int visualizationButtonX = buttonGap*2;
int visualizationButtonY = buttonGap;

int lyricButtonX = (buttonGap * 4) + largeButtonWidth;
int lyricButtonY = visualizationButtonY;

int chordDisplayButtonX = (buttonGap * 5) + (largeButtonWidth * 2);
int chordDisplayButtonY = lyricButtonY;

int chordSuggestionButtonX = (buttonGap * 6) + (largeButtonWidth * 3);
int chordSuggestionButtonY = chordDisplayButtonY;

int prevVisualizationX = 5;
int prevVisualizationY = buttonGap;

int nextVisualizationX = visualizationButtonX + largeButtonWidth + 5;
int nextVisualizationY = buttonGap;

int arrowWidth = (int)(buttonGap * 1.6);

StringList lyricWords;

Animation danceAnimation;

int frameSkipCount = 0;

//Enabled buttons
boolean visualizationEnabled = true;
boolean lyricEnabled = false;
boolean chordDisplayEnabled = false;
boolean chordSuggestionEnabled = false;

enum Visualizations {Ball, Bars, Dancing};
Visualizations SelectedVisualization;


public void setup() {
   size(1280,800);
   
   SelectedVisualization = Visualizations.Ball;
   
   // If the Buffersize is larger than the FFT Size, the FFT will fail
   // so we set Buffersize equal to bands
   device = new AudioDevice(this, 44000, bands);
   // Calculate the width of the rects depending on how many bands we have
   r_width = width/float(bands);

   //Load and play a soundfile and loop it. This has to be called 
   // before the FFT is created.
   sample = new SoundFile(this, "beat.aiff");
   sample.loop();

   // Create and patch the FFT analyzer
   fft = new FFT(this, bands);
   fft.input(sample);

   lyricWords = new StringList();
   lyricWords.append("Lights");
   lyricWords.append("Sunshine");
   lyricWords.append("Tree");
   
   danceAnimation = new Animation("dancing", 18);
}      

public void draw() {
  background(0,0,0);
  if (visualizationEnabled) drawVisualization();
  if (lyricEnabled) drawLyrics();
  if (chordDisplayEnabled) drawChords();
  if (chordSuggestionEnabled) drawChordSuggestions();
  drawUI();
}

public void drawUI() {
  drawButton(visualizationEnabled,visualizationButtonX,visualizationButtonY, largeButtonWidth, largeButtonHeight, "Visuals");
  drawButton(lyricEnabled, lyricButtonX, lyricButtonY, largeButtonWidth, largeButtonHeight, "Lyrics");
  drawButton(chordDisplayEnabled, chordDisplayButtonX, chordDisplayButtonY, largeButtonWidth, largeButtonHeight, "Chords");
  drawButton(chordSuggestionEnabled, chordSuggestionButtonX, chordSuggestionButtonY, largeButtonWidth, largeButtonHeight, "Suggestions");
  
  if (visualizationEnabled)
  {
      drawVisualizationArrows();
  }
}

private void drawVisualizationArrows()
{
    
    stroke(0, 200, 50);
    
   
   
    
    //Previous visualization
   if (overRect(prevVisualizationX, prevVisualizationY, arrowWidth, largeButtonHeight))
   {
     fill(0, 255, 100);
   }
   else {
     fill(0, 200, 50);
   }
    triangle(prevVisualizationX, prevVisualizationY+(largeButtonHeight/2), //X1, Y1 
             arrowWidth, prevVisualizationY,                   //X2, Y2
             arrowWidth, largeButtonHeight+prevVisualizationY);//X3, Y3
   
    
    //Next visualization
   if (overRect(nextVisualizationX, nextVisualizationY, arrowWidth, largeButtonHeight))
   {
     fill(0, 255, 100);
   }
    else {
      fill(0, 200, 50);
    }
    triangle(nextVisualizationX-5+arrowWidth, nextVisualizationY+(largeButtonHeight/2),//X1, Y1 
             nextVisualizationX, nextVisualizationY,  //X2, Y2
             nextVisualizationX, largeButtonHeight+nextVisualizationY);  //X3, Y3  
}

private void drawButton(boolean isEnabled, int x, int y, int btnWidth, int btnHeight, String btnText){
  if (isEnabled) {
    drawEnabledButton(x, y, btnWidth, btnHeight, btnText);
  }
  else {
    drawDisabledButton(x, y, btnWidth, btnHeight, btnText);
  }
}

public void drawVisualization() {
    if (SelectedVisualization == Visualizations.Ball) drawBallVisualization();
    if (SelectedVisualization == Visualizations.Bars) drawBarsVisualization();
    if (SelectedVisualization == Visualizations.Dancing) drawDanceVisualization();
}

private void drawDanceVisualization()
{
    fft.analyze();
    sum = 0;
    int rValue = 0;
    int gValue = 0;
    int bValue = 0;
      for (int i = 0; i < bands; i++) {
        // smooth the FFT data by smoothing factor
        sum += fft.spectrum[i];
        if (i <= (bands/3)) rValue += fft.spectrum[i]*40;
        if (i > (bands/3) && i < (bands*2/3)) gValue += fft.spectrum[i]*150;
        if (i >= (bands*2/3)) bValue += fft.spectrum[i]*500;
      }
    background(rValue, gValue, bValue);
   danceAnimation.display((sum > 1), width/2 - (danceAnimation.getWidth()/2), height/2 - (danceAnimation.getHeight()/2)); 
}

private void drawBallVisualization()
{
      // Set background color, noStroke and fill color
      background(0,0,0);
      noStroke();
      
      int rValue = 50;
      int gValue = 50;
      int bValue = 50;
      sum = 0;
      fft.analyze();
      for (int i = 0; i < bands; i++) {
        // smooth the FFT data by smoothing factor
        sum += fft.spectrum[i];
        if (i <= (bands/3)) rValue += fft.spectrum[i]*50;
        if (i > (bands/3) && i < (bands*2/3)) gValue += fft.spectrum[i]*80;
        if (i >= (bands*2/3)) bValue += fft.spectrum[i]*100;
      }
      
      //sum = (float)Math.log(sum);
      sum = sum/8;
      //println(sum);
      // rms.analyze() return a value between 0 and 1. It's
      // scaled to height/2 and then multiplied by a scale factor
      float rms_scaled=sum*(height/2)*scale;
      
      fill(rValue,gValue,bValue);
  
      // We draw an ellispe coupled to the audio analysis
      ellipse(width/2, height/2, rms_scaled, rms_scaled);
}

private void drawBarsVisualization()
{
    fill(255,0,150);
    noStroke();
  
    fft.analyze();
  
    for (int i = 0; i < bands; i++) {
      
      // smooth the FFT data by smoothing factor
      sums[i] += (fft.spectrum[i] - sums[i]) * smooth_factor;
      
      // draw the rects with a scale factor
      rect( i*r_width, height, r_width, -sums[i]*height*scale );
    }
}

private void drawLyrics() {
  fill(255, 255, 255);
  
  int startY = largeButtonHeight + buttonGap;
  for (int i = 0; i < lyricWords.size(); i++)
  {  
    text(lyricWords.get(i), buttonGap, startY + buttonGap * (i+1));
  }
}

private void drawChords() {
  fill(255,255,255);
  text("You just played: C#", width-200, largeButtonHeight+(buttonGap*2));
}

private void drawEnabledButton(int x, int y, int btnWidth, int btnHeight, String btnText){
  if (overRect(x, y, btnWidth, btnHeight))
  {
    fill(0, 255, 100);
  } else {
    fill(0, 200, 50);
  }
  stroke(0, 200, 50);
  rect(x, y, btnWidth, btnHeight);
  
  fill(0, 0, 0);
  text(btnText, x+(btnWidth/3), y+(btnHeight/2));
}

private void drawChordSuggestions() {
  fill(255,255,255);
  text("You should totally play:", width-200, largeButtonHeight+(buttonGap*3));
  text("D F G A", width-200, largeButtonHeight+(buttonGap*4));
}

private void drawDisabledButton(int x, int y, int btnWidth, int btnHeight, String btnText){
  if (overRect(x, y, btnWidth, btnHeight))
  {
    fill(255, 0, 100);
  } else {
    fill(200, 0, 50);
  }
  
  stroke(200, 0, 25);
  rect(x, y, btnWidth, btnHeight);
  
  fill(255, 255, 255);
  text(btnText, x+(btnWidth/3), y+(btnHeight/2));
}

void mousePressed() {
  if (overRect(visualizationButtonX,visualizationButtonY, largeButtonWidth, largeButtonHeight)) visualizationEnabled = !visualizationEnabled;
  if (overRect(lyricButtonX, lyricButtonY, largeButtonWidth, largeButtonHeight)) lyricEnabled = !lyricEnabled;
  if (overRect(chordDisplayButtonX, chordDisplayButtonY, largeButtonWidth, largeButtonHeight)) chordDisplayEnabled = !chordDisplayEnabled;
  if (overRect(chordSuggestionButtonX, chordSuggestionButtonY, largeButtonWidth, largeButtonHeight)) chordSuggestionEnabled = !chordSuggestionEnabled;
  
  if (overRect(prevVisualizationX, prevVisualizationY, arrowWidth, largeButtonHeight)) selectNextVisualization();
  if (overRect(nextVisualizationX, nextVisualizationY, arrowWidth, largeButtonHeight)) selectPrevVisualization();
}

private void selectNextVisualization()
{
  int newIndex = (SelectedVisualization.ordinal() + 1) % Visualizations.values().length;
  SelectedVisualization = Visualizations.values()[newIndex];
}

private void selectPrevVisualization()
{
  int newIndex = (SelectedVisualization.ordinal() - 1) % Visualizations.values().length;
  if (newIndex < 0) newIndex = Visualizations.values().length - 1;
  SelectedVisualization = Visualizations.values()[newIndex];
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(boolean shouldIncrement, float xpos, float ypos) {
    if (shouldIncrement || frameSkipCount > 10)
    {
       frame = (frame+1) % imageCount;
       frameSkipCount = 0;
    } else { 
       frameSkipCount++;
    }
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
  
  int getHeight() {
    return images[0].height;
  }
}