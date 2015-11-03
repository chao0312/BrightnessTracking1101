import gab.opencv.*;
import processing.video.*;

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
//int ledPin = 13;
int val;

PShader conway;
PGraphics pg;

Capture cam;

Capture video;
OpenCV opencv;

int x, y;

void setup() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[3]);
  
//   arduino.pinMode(ledPin, Arduino.OUTPUT);
  
  size(640, 480, P3D);
  pg = createGraphics(640, 480, P2D);
  pg.noSmooth();
  conway = loadShader("conway.glsl");
  conway.set("resolution", float(pg.width), float(pg.height)); 
  
//  frameRate(30);
  background(0);
  //printArray(Capture.list());
  video = new Capture(this, 640, 480);
  video.start();
  opencv = new OpenCV(this, video.width, video.height);
  
}

// Light tracking
void draw() {
  if(video.available()) {
    video.read();
    video.loadPixels();
    float maxBri = 0;
    int theBrightPixel = 0;
    for(int i=0; i<video.pixels.length; i++) {
      if(brightness(video.pixels[i]) > maxBri) {
        maxBri = brightness(video.pixels[i]);
        theBrightPixel = i;
      }
    }
    x = theBrightPixel % video.width;
    y = theBrightPixel / video.width;
  }
  
  println(x , y);
  image(video, 0, 0);
//  noStroke();
//  fill(255,0,0);
  //ellipse(x, y, 10, 10);
 
  
  conway.set("time", millis()/1000.0);
  float x1 = map(x, 0, width, 0, 1);
  float y1 = map(y, 0, height, 1, 0); 
  conway.set("mouse",x1 ,y1); 
  
//  conway.set("size",val);
  pg.beginDraw();
  pg.background(0);
  pg.shader(conway);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();  
  val = arduino.analogRead(0);
//  image(pg, 0, 0, width, height);
  image(pg, 0, 0, val/2, val/2);
  
}
