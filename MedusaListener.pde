import processing.serial.*;
import processing.sound.*;

Serial brieSerial; // create local serial object from serial library   
String brieString = null; //collect serial data
int newLine = 10; //ascii code for carriage retun in serial
float myVal; //float to storing converter ascii serial data

//create file objects: one per sound file
SoundFile Innocent;
SoundFile ForeShadow;
SoundFile PosMedusa;
SoundFile Haunted;
SoundFile Crying;
boolean debug = true;

void setup() {

  size(400, 512); //Open a window interface just to see that the progam is running
  background(0);//make it black


  //link processing to serial port (9600)
  String myPort = Serial.list() [0]; //mac 2nd port, PC???
  brieSerial = new Serial(this, myPort, 9600);

  // Load a soundfile from the /data folder of the sketch and play it back
  Innocent = new SoundFile(this, "Innocent.wav");
  ForeShadow = new SoundFile(this, "ForeshadowMedusa.wav");
  PosMedusa = new SoundFile(this, "PosMedusaLow.wav");
  Haunted = new SoundFile(this, "HuntedMedusa.wav");
  Crying = new SoundFile(this, "CryingMedusaHigh.wav");
}  

PImage medusa; //create an image object that will hold the Medusa image to be placed on the window

//Declare boolean values that will help to play each sounds only once while in the loop
boolean playInnocent = true;
boolean playForeShadow = true;
boolean playPosMedusa = true;
boolean playHaunted = true;
boolean playCrying = true;

void draw() {

  while (brieSerial.available() >0) { //if info is available (coming from Flora) excecute whats inside this while
    brieString = brieSerial.readStringUntil(newLine); //strip data of serial port (pinted values coming from Flora
    if (brieString != null) {
      textSize(34);
      text("Medusa by Brie", 10, 30);
      medusa = loadImage("Medusa.jpg");
      image(medusa, 10, 40);

      //myVal = float(brieString);//takes serial data and turns it into numbers
      brieString = brieString.replaceAll("\\s", ""); //remove all white spaces to avoid issues
      println(brieString); //this is to make sure we can see the values coming from Flora
      if (brieString.equals("NoLayer"))
      {
        Innocent.stop();
        ForeShadow.stop();
        PosMedusa.stop();
        Haunted.stop();
        if (playCrying == true) {
          Crying.play();
          playCrying = false;
        }
        println("NoLayer: stop all sounds but crying");
      }
      if (brieString.equals("BlackLayer"))
      {
        if (playHaunted == true) {
          Haunted.play();
          playHaunted = false;
          playCrying = true;
        }
        println("BlackLayer: playing haunted");
      }
      if (brieString.equals("GrayLayer"))
      {
        if (playPosMedusa == true) {
          PosMedusa.play();
          playPosMedusa = false;
          playCrying = true;
        }
        println("GrayLayer: playing poseidon");
      }
      if (brieString.equals("BlueLayer"))
      {
        if (playForeShadow == true) {
          ForeShadow.play();
          playForeShadow = false;
          playCrying = true;
        }
        println("BlueLayer: playing foreShadow");
      }
      if (brieString.equals("RedLayer"))
      {
        if (playInnocent == true) {
          Innocent.play();
          playInnocent = false;
          playCrying = true;
        }
        println("RedLayer: playing innocent");
      }

      if (brieString.equals("Nolight"))
      {
        println("It's dark in here: no light coming through");
        Innocent.stop();
        ForeShadow.stop();
        PosMedusa.stop();
        Haunted.stop();
        Crying.stop();
        playCrying = true;
        playHaunted = true;
        playInnocent = true;
        playForeShadow = true;
        playPosMedusa = true;
      }
    }
  }
}
