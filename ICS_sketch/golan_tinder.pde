// Wrinkly Men Neural Net Training Application
// June 10, 2019
// By Cassie

import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;

StringList imageNames;
String folderOfImages = "C:\\Users\\schei\\OneDrive\\Desktop\\Summer 2019\\studio\\golan_tinder\\data\\source_images";

String goodFolder = "C:\\Users\\schei\\OneDrive\\Desktop\\Summer 2019\\studio\\golan_tinder\\data\\good";
String badFolder = "C:\\Users\\schei\\OneDrive\\Desktop\\Summer 2019\\studio\\golan_tinder\\data\\bad";

String logFolder = "C:\\Users\\schei\\OneDrive\\Desktop\\Summer 2019\\studio\\golan_tinder\\data\\image_logs";

boolean good = false;
boolean bad = false;
boolean next = false;
boolean newImg = true;

boolean loading = true;

PImage img;
int currImage = 0;

String currSession = "start";
StringList txtFiles;

String prevImgName;
String prevImgNewLocation;
boolean undo = false;
boolean undoBlock = false;

void setup() {
  size(1200, 1800);
  imageNames = new StringList();
  txtFiles = new StringList();

  String[] allFiles = listFileNames(folderOfImages);
  String[] txtFiles = listFileNames(logFolder);
  
  // sort through given files in source_images and pick out the images
  for (int i = 0; i < allFiles.length; i++) {
    String file = allFiles[i];
    if (file.toLowerCase().endsWith(".jpg") || file.toLowerCase().endsWith(".tif")
        || file.toLowerCase().endsWith(".png") || file.toLowerCase().endsWith(".gif")) {
          imageNames.append(file);
    }
  }
  
  // on boot, determine the name of the output log
  // (month_day_year_session_session#)
  while (loading) {
    int session = 0;
    int day = day();
    int month = month();
    int year = year();
    
    // if there are logs already in the folder, make sure not to duplicate a name
    if (txtFiles.length > 0) {
      for (int i = 0; i < txtFiles.length; i++) {
        String sessionName = str(month) + "_" + str(day) + "_" + str(year) + "_session_" + str(session);
        
        if (txtFiles[i].equals(sessionName + ".txt")) {
          session += 1;
        }
      }
      currSession = str(month) + "_" + str(day) + "_" + str(year) + "_session_" + str(session);
    }
    // if there's aren't logs, it's the first one
    else {
      currSession = str(month) + "_" + str(day) + "_" + str(year) + "_session_" + str(session);
    }
    //println("Current Session: ", currSession);
    loading = false;
  }
}

void draw() {
  background(255);
  
  // stop when you've sorted all the images
  // just a white screen at the moment
  if (currImage >= imageNames.size()) {
      return;
  }
  
  // undo last choice, return the sorted image to the original source_images folder
  if (undo == true) {
     currImage -= 1;
     undo = false;
     undoBlock = true;
      
     File file = new File(prevImgNewLocation + "\\" + prevImgName);
     file.renameTo(new File(folderOfImages + "\\" + prevImgName));
  }
  
  // load image
  String imgString = imageNames.get(currImage);
  img = loadImage(folderOfImages + "\\" + imgString);
  
  // scale to fit canvas
  float resizeFactorW = round(float(width)/img.width * 100); 
  float resizeFactorH = round(float(height)/img.height * 100);
  
  if (img.width > 0 && img.height > 0) {
    if (img.width > img.height || img.width == img.height) {
      img.resize(int((resizeFactorW/100)*img.width), 0);
      image(img, 0, 0);
    }
    else {
      img.resize(0, int((resizeFactorH/100)*img.height));
      image(img, 0, 0);
    }
  }
  
  /*
  // print image data 
  if (newImg) {
    newImg = false;
    println("Current Image: " + currImage + " - " + imgString);
    println("Size: ", img.width, img.height);
  }*/
  
  // moving images between folders
  if (next == true) {
    // if a bad photo, write -1 on the data log and move the image from source_images to bad
    if (bad == true) {
      String data = imgString + "  " + "-1";
      appendTextToFile(logFolder + "\\" + currSession + ".txt", data);
      File file = new File(folderOfImages + "\\" + imgString);
      file.renameTo(new File(badFolder + "\\" + imgString));
      prevImgName = imgString;
      prevImgNewLocation = badFolder;
    }
    // if a good photo, log 1 and move to good
    else if (good == true) {
      String data = imgString + "  " + "1";
      appendTextToFile(logFolder + "\\" + currSession + ".txt", data);
      File file = new File(folderOfImages + "\\" + imgString);
      file.renameTo(new File(goodFolder + "\\" + imgString));
      prevImgName = imgString;
      prevImgNewLocation = goodFolder;
    }
    
    // increase image counter, reset variables
    currImage += 1;
    next = false;
    good = false;
    bad = false;
    undoBlock = false;
    newImg = true;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      bad = true;
      println("bad");
      next = true;
    }
    else if (keyCode == RIGHT) {
      good = true;
      println("good");
      next = true;
    }
    else if (keyCode == UP) {
      if (!undoBlock) {
        undo = true;
      }
      /*else {
        println("Already undone too much");
      }*/
    }
  }
}

// given a folder of files, return an array of all the names of the files
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    return null;
  }
}

// given txt file, append given text
void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}
