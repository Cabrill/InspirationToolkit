// This sketch shows how to use the Amplitude class to analyze a
// stream of sound. In this case a sample is analyzed. Smooth_factor
// determines how much the signal will be smoothed on a scale
// form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;

// Declare a scaling factor
float scale=5;

// Declare a smooth factor
float smooth_factor=0.25;

// Used for smoothing
float sum;

int buttonGap = 20;

//Button dimensions
int largeButtonWidth = 150;
int largeButtonHeight = 50;
int smallButtonWidth = 100;
int smallButtonHeight = 50;

int visualizationButtonX = buttonGap;
int visualizationButtonY = buttonGap;

int lyricButtonX = (buttonGap * 2) + largeButtonWidth;
int lyricButtonY = visualizationButtonY;

int chordDisplayButtonX = (buttonGap * 3) + (largeButtonWidth * 2);
int chordDisplayButtonY = lyricButtonY;

int chordSuggestionButtonX = (buttonGap * 4) + (largeButtonWidth * 3);
int chordSuggestionButtonY = chordDisplayButtonY;

StringList lyricWords;

//Enabled buttons
boolean visualizationEnabled = true;
boolean lyricEnabled = false;
boolean chordDisplayEnabled = false;
boolean chordSuggestionEnabled = false;


public void setup() {
   size(1024,768);

   //Load and play a soundfile and loop it
   sample = new SoundFile(this, "beat.aiff");
   sample.loop();
    
   // Create and patch the rms tracker
   rms = new Amplitude(this);
   rms.input(sample);
   lyricWords = new StringList();
   lyricWords.append("Lights");
   lyricWords.append("Sunshine");
   lyricWords.append("Tree");
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
      // Set background color, noStroke and fill color
    background(0,0,0);
    noStroke();
    fill(255,0,150);
    
    // smooth the rms data by smoothing factor
    sum += (rms.analyze() - sum) * smooth_factor;  

    // rms.analyze() return a value between 0 and 1. It's
    // scaled to height/2 and then multiplied by a scale factor
    float rms_scaled=sum*(height/2)*scale;

    // We draw an ellispe coupled to the audio analysis
    ellipse(width/2, height/2, rms_scaled, rms_scaled);
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
  fill(0, 255, 100);
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
  fill(255, 0, 100);
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
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}