/*
BayTech SoftSerial Switching.
Switches BayTech powerbars.

Writing to the Devices works.
Reading the status and such seems quite buggy as of now
so this is commented out.
 */
#include <SoftwareSerial.h>

SoftwareSerial mySerial[] = {
	SoftwareSerial(10, 11), // RX, TX
	SoftwareSerial(12, 13), // RX, TX
};

#define NUM_BARS 2
int cmd=-1;
int bar=-1;

void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Goodnight moon!");

  // set the data rate for the SoftwareSerial ports and init the prompts
  for (int i=0; i<NUM_BARS; i++){
 	 mySerial[i].begin(9600);
 	 mySerial[i].println();
	}
  delay(1000); // Prompt for the powerbars needs some time to get ready
}

void loop() // run over and over
{
	if (Serial.available() > 0){
		char val=Serial.read();
		if(cmd<0){
			// Check if the first value is the bar number
			if(bar < 0 && (val-'0'>=0 || val-'0'<NUM_BARS)){
				bar=val-'0';
//				mySerial[bar].listen();
			// Then a space
			} else if (bar>=0 && val==' '){
				cmd=0;
			}
		} else {
			// At carriage return end message and reset the loop values
			if (val=='\r' || val=='\n'){
				mySerial[bar].println();
				cmd = -1;
				bar = -1;
			// Send the commands to selected bar
			} else {
				mySerial[bar].print(val);
			}
		}
	}
	// Read output from selected powerbar prompt (too buggy right now)
/*	if(bar>=0){
 		if(mySerial[bar].available() >0){
 			Serial.print((char) mySerial[bar].read());
 		}
 	}*/
}

