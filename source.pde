//Joheen Chakraborty
//Desktop Application Programming 2015-2016
//John P. Stevens High School, Edison, NJ



import java.io.FileReader;              //to read files
import java.io.FileNotFoundException;   //for error handling
import java.io.BufferedWriter;          //to write to files
import java.io.FileWriter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import javax.print.*;
import javax.print.attribute.*;
import com.sun.image.codec.jpeg.*;
import java.awt.image.BufferedImage;
import java.io.*;

ArrayList<String[]> memberdata;               //ArrayList of String arrays to store all of the data collected from the master file
PFont font;
String[] newmember, changeinput = new String[10];
int screen, pagenum, checkbox, changebox, numselect;        //helper variable for adding/changing members-- stores which field is currently being added/changed
boolean isadding, report1, report2, exportreport, anychange;
Boolean[] selected = new Boolean[24], ischanging = new Boolean[24];
int[] xarray = {18, 148, 248, 348, 448, 548, 698, 798, 898, 998},
lenarray = {40, 80, 80, 50, 25, 135, 35, 25, 25, 25};
String input, error = "", filename, changenum = "";
PImage frontlogo, fblalogo;

void setup() {                          //"setup" method-- unique to the processing library, first thing that runs when the program is launched
  size(1200, 600);                      //creates window
  pagenum = checkbox = screen = changebox = 0;        //initializes some helper vars
  filename = input = "";                           //clears input
  isadding = report1 = report2 = exportreport = anychange = false;   //clears isadding,changing,deleting
  for (int i = 0; i < 24; i++) selected[i] = ischanging[i] = false;
  memberdata = new ArrayList();         //creates the memberdata arraylist
  frontlogo = loadImage("frontlogo.png");
  fblalogo = loadImage("fbla_logo.png");
  font = createFont("font.ttf", 12);    //imports font from data folder
}

void draw() {                           //"draw" method-- unique to the processing library, loops 30 times per second
  background(60, 150, 180);
  textFont(font);                       //sets the current font to the custom one
  if (screen == 0) {                    //details of the welcome screen
    textSize(32);
    textAlign(CENTER);
    imageMode(CENTER);
    image(frontlogo, 600, 450);
    fill(0);
    stroke(255);
    text("FBLA Desktop Application Programming 2015-2016", 600, 50);
    textSize(28);
    fill(255);
    text("Joheen Chakraborty-- JP Stevens HS, Edison, NJ", 600, 120);
    text("Enter the destination and name of the data file:", 600, 200);
    textSize(20);
    text("(default location is " + (System.getProperty("user.dir")).substring(0,2) + "/data/data.txt)", 600, 240);
    textSize(28);
    fill(130, 160, 180);
    rect(200, 266, 800, 50, 15);
    fill(255);
    if(frameCount % 80 < 40 && filename.length() == 0)      //creates a blinking white line to tell the user 
      line(600, 275, 600,305);                                //that they should type
    text(filename, 600, 300);
    
  }
  
  if (screen == 1) {        //details of the main screen
    imageMode(CENTER);
    tint(255, 160);
    image(fblalogo, 600, 300);
    fill(130, 160, 240, 120);
    rect(5, 5, 1190, 513, 10);
    fill(90, 120, 180, 120);
    for (int i = 0; i < 12; i++)
      rect(5, 36.5+i*40, 1190, 20);
    printmemberdata();
    
    if (isadding) {
      pagenum = memberdata.size()/24;
      fill(255, 0, 0);
      rect(340, 570, 100, 20, 4);
      fill(255);
      text("Cancel", 365, 585);
      
      for (int j = 0; j < 10; j++) {      //if a member is being added
        fill(130, 160, 180);
        rect(xarray[j], 18+20*(memberdata.size()%24+1), lenarray[j], 14, 2);
        fill(255);
        text(newmember[j], xarray[j]+2, 30+20*(memberdata.size()%24+1));
      }
      fill(20, 20, 200);
      rect(xarray[changebox], 18+20*(memberdata.size()%24+1), lenarray[changebox], 14, 2);
      fill(255);
      text(newmember[changebox], xarray[changebox]+2, 30+20*(memberdata.size()%24+1));
      fill(0, 130, 0);
      rect(450, 570, 90, 20, 4);
      fill(0);
      text("Save Changes", 453, 585);
    }
    
    fill(255);
    rect(850, 570, 100, 20, 4);
    fill(0);
    text("Back to Main", 860, 585);
    text(error, 20, 542);
        
    if (pagenum == memberdata.size()/24) {            //draws checkboxes
      for (int i = 0; i < memberdata.size()%24; i++) {
        fill(200);
        rect(1110, 20+20*(i%24+1), 14, 14, 2);
        if (selected[i]) {
          fill(100);
          rect(1110, 20+20*(i%24+1), 14, 14, 2);
          fill(255);
        }
      }
    }
    else {                                      //draws checkboxes
      for (int i = 0; i < 24; i++) {
        fill(200);
        rect(1110, 20+20*(i%24+1), 14, 14, 2);
        if (selected[i]) {
          fill(100);
          rect(1110, 20+20*(i%24+1), 14, 14, 2);
          fill(255);
        }
      }
    }
    
    if (anychange == false) for (int i = 0; i < 24; i++) ischanging[i] = false;
    for (int i = 0; i < 24; i++) {          //if a member is being changed
      if (ischanging[i]) {
        for (int j = 0; j < 10; j++) {
          fill(130, 160, 180);
          rect(xarray[j], 18+20*(i%24+1), lenarray[j], 14, 2);
          fill(255);
          text(changeinput[j], xarray[j]+2, 30+20*(i%24+1)); 
        }
        fill(20, 20, 200);
        rect(xarray[changebox], 18+20*(i%24+1), lenarray[changebox], 14, 2);        
        fill(255);
        text(changeinput[changebox], xarray[changebox]+2, 30+20*(i%24+1));
        fill(0, 130, 0);
        rect(560, 570, 90, 20);
        fill(0);
        text("Save Changes", 563, 585);
        fill(255);
      }
    }
  }
  
  if (screen == 2) {              //senior report
    fill(130, 160, 240, 120);
    rect(5, 5, 640, 515, 10);
    fill(90, 120, 180, 120);
    for (int i = 0; i < 12; i++)
      rect(5, 37+i*40, 640, 20);
    fill(255);
    printseniorreport();
    fill(255);
    rect(20, 570, 100, 20, 4);
    fill(0);
    text("Export", 52, 585);   //export buddon
    fill(255);
    rect(885, 570, 100, 20, 4);   //print buddon
    fill(0);
    text("Print", 922, 585);
    fill(255);
    if (exportreport) {
      text("Enter the destination and name of the report file: ", 250, 550);
      text("Must be a .xls file", 250, 570);
      text("e.g. C:/Users/John/reports/rep.xls", 250, 590);
      
      fill(130, 160, 180);
      rect(545, 578, 300, 14, 2);
      fill(255);
      if(frameCount % 80 < 40 && input.length() == 0)
        line(550, 580, 550, 590);
      text(input, 550, 590);
    }
  }
  
  if (screen == 3) {          //balance report
    fill(130, 160, 240, 120);
    rect(5, 5, 990, 515, 10);
    fill(90, 120, 180, 120);
    for (int i = 0; i < 12; i++)
      rect(5, 37+i*40, 990, 20);
    fill(255);
    printbalancereport();
    fill(255);
    rect(20, 570, 100, 20, 4);
    fill(0);
    text("Export", 52, 585);   //export buddon
    fill(255);
    rect(885, 570, 100, 20, 4);
    fill(0);
    text("Print", 922, 585);
    fill(255);
    if (exportreport) {
      text("Enter the destination and name of the report file: ", 250, 550);
      text("Must be a .doc file", 250, 570);
      text("e.g. C:/Users/John/reports/rep.doc", 250, 590);
      fill(130, 160, 180);
      rect(545, 578, 300, 14, 2);
      fill(255);
      if(frameCount % 80 < 40 && input.length() == 0)
        line(550, 580, 550, 590);
      text(input, 550, 590);
    }
  }
}

void keyPressed() {              //unique to the processing library-- called once whenever there is a user keystroke
  if (screen == 0) {                                          //if the program is currently on the welcome screen
    if (keyCode == BACKSPACE && filename.length() > 0)        //if backspace is pressed
      filename = filename.substring(0, filename.length()-1);  //get rid of the last letter
    else if (keyCode == ENTER) {                              //if enter is pressed
      if (filename.trim() == "") {
        filename = (System.getProperty("user.dir")).substring(0,2) + "/data/data.txt)";
      }
      readData(filename);                                     //run the readdata function with the inputted file name
      screen = 1;                                             //and go to the main screen
    }
    else if (key != CODED && keyCode != BACKSPACE)
      filename += key;
  }
  
  if (report1 || exportreport) {
    if (keyCode == BACKSPACE && input.length() > 0)            //read the user's keystrokes-- if it's backspace, delete the last character
      input = input.substring(0, input.length()-1);
    else if (keyCode == ENTER) {
      if (report1) balancereport(input);
      else if (exportreport) exportseniorreport(input);
      report1 = report2 = exportreport = false;
    }
    else if (key != CODED && keyCode != BACKSPACE)                                 //if the key isn't a special key
      input += key;
  }
  
  if (isadding) {        //if a user is being added or changed
    if (keyCode == BACKSPACE && newmember[changebox].length() > 0)            //read the user's keystrokes-- if it's backspace, delete the last character
      newmember[changebox] = newmember[changebox].substring(0, newmember[changebox].length()-1);
    else if (key != CODED && keyCode != BACKSPACE)             //if the key isn't a special key
      if (newmember[changebox].equals("NA")) {
        String str = "";
        str+= key;
        newmember[changebox] = str;
      }
      else newmember[changebox] += key;
  }
  if (anychange) {        //if a user is being added or changed
    if (keyCode == BACKSPACE && changeinput[changebox].length() > 0)            //read the user's keystrokes-- if it's backspace, delete the last character
      changeinput[changebox] = changeinput[changebox].substring(0, changeinput[changebox].length()-1);
    else if (key != CODED && keyCode != BACKSPACE)             //if the key isn't a special key
      changeinput[changebox] += key;
  }
}

void mousePressed() {          //unique to the processing library-- called once whenever the user clicks
  
  if (screen == 1) {        //if the user is on the main page
    if (mouseX > 850 && mouseX < 950 && mouseY > 570 && mouseY < 590) {      //if the mouse is over the "back to main" buddon
      pagenum = 0;
      anychange = isadding = false;
    }
    if (mouseX > 10 && mouseX < 100 && mouseY > 570 && mouseY < 590) {      //if the mouse is over the "add" button
      report1 = report2 = anychange = false;
      isadding = true;               //we are now adding info
      input = error = "";            //make sure the input is cleared
      newmember = new String[10];    //and make a new, clean temp array to hold info for now
      for (int i = 0; i < 10; i++) newmember[i] = "NA";
    }

    if (mouseX > 120 && mouseX < 210 && mouseY > 570 && mouseY < 590) {      //if the mouse is over the "change" button
      if (numselect == 1) {
        isadding = report1 = report2 = false;
        error = "Select the field(s) you want to change and type the \nnew information";
        for (int i = 0; i < 24; i++) {
          if (selected[i] == true) {
            ischanging[i] = true;
            anychange = true;
            changeinput = memberdata.get(i+24*pagenum);
          }
        }
      }
      else error = "Select exactly one member to change information.";
    }
    if (anychange || isadding) {
      if (mouseX > 18 && mouseX < 48) changebox = 0;
      else if (mouseX > 148 && mouseX < 228) changebox = 1;
      else if (mouseX > 248 && mouseX < 328) changebox = 2;
      else if (mouseX > 348 && mouseX < 398) changebox = 3;
      else if (mouseX > 448 && mouseX < 473) changebox = 4;
      else if (mouseX > 548 && mouseX < 683) changebox = 5;
      else if (mouseX > 698 && mouseX < 733) changebox = 6;
      else if (mouseX > 798 && mouseX < 813) changebox = 7;
      else if (mouseX > 898 && mouseX < 923) changebox = 8;
      else if (mouseX > 998 && mouseX < 1023) changebox = 9;
    }
    
    if (anychange && !isadding) {
      if (mouseX > 560 && mouseX < 650 && mouseY > 570 && mouseY < 590) {   //save changes button
        for (int i = 0; i < 24; i++) {
          selected[i] = false;
          if (ischanging[i] == true)
            for (int j = 0; j < 10; j++) {
              memberdata.set(i, changeinput);
            }
            ischanging[i] = selected[i] = false;
        }
        anychange = false;
      }
      numselect = 0;
      writedata(filename);
    }
    
    
    if (mouseX > 450 && mouseX < 540 && mouseY > 570 && mouseY < 590) {   //save changes button, cancel, senior report buddons
      if (isadding && !anychange) {
        memberdata.add(newmember);
        numselect = 0;
        writedata(filename);
        isadding = false;
      }
      else {
        report2 = true;
        screen = 2;
      }
    }
    
    if (mouseX > 230 && mouseX < 320 && mouseY > 570 && mouseY < 590) {    //if the mouse is over the "delete" button
      if (numselect == 0) error = "Select at least one member to delete.";
      isadding = report1 = report2 = false;
      for (int i = 0; i < 24; i++) {
        try {
          if (selected[i] == true) {
            memberdata.remove(i+24*pagenum);           //remove the matching string array from the memberdata arraylist
            selected[i] = false;
            numselect -= 1;
          }
        }
        catch (IndexOutOfBoundsException e) {
          try {
            if (selected[i] == true) {
              memberdata.remove(i+24*pagenum);           //remove the matching string array from the memberdata arraylist
              selected[i] = false;
              numselect -= 1;
            }
          }
          catch (IndexOutOfBoundsException f) { }
        }
      }
      writedata(filename);                     //write current data to the data file
    }
    
    if (mouseX > 340 && mouseX < 430 && mouseY > 570 && mouseY < 590) {    //if the mouse is over the "cancel/balancereport" button
      if (isadding) {
        isadding = report1 = report2 = false;      //no current actions
        input = "";      //clear the input
      }
      else {
        report1 = true;
        isadding = false;
        if (!isadding && !anychange && report1) screen = 3;
        input = "";
      }
    }
    
    if (mouseX > 1110 && mouseX < 1124) {    //if the mouse is over a checkbox
      checkbox = mouseY;
      for (int i = 0; i < 24; i++) {
        if (checkbox > 20+20*(i%24+1) && checkbox < 20+20*(i%24+1)+14) {
          checkbox = 20+20*(i%24+1);
          if (selected[i] == true) numselect -= 1;
          else numselect++;
          selected[i] = !selected[i];
        }
      }
    }
  }
  
  if (screen == 2) {      //if the user is on the senior report page
    if (mouseX > 20 && mouseX < 110 && mouseY > 570 && mouseY < 590) {
      input = "";
      exportreport = true;
    }
    if (mouseX > 1000 && mouseX < 1100 && mouseY > 570 && mouseY < 590) {
      exportreport = report2 = false;
      screen = 1;
    }
    if (mouseX > 885 && mouseX < 985 && mouseY > 570 && mouseY < 590) {
      PrintIt p = new PrintIt();
      p.printJpg(get(0,0,645,520));
    }
  }
  
  if (screen == 3) {    //if the user is on the balance report page
    if (mouseX > 20 && mouseX < 110 && mouseY > 570 && mouseY < 590) {
      input = "";
      exportreport = true;
    }
    if (mouseX > 1000 && mouseX < 1100 && mouseY > 570 && mouseY < 590) {
      exportreport = report1 = false;
      screen = 1;
    }
    if (mouseX > 885 && mouseX < 985 && mouseY > 570 && mouseY < 590) {
      PrintIt p = new PrintIt();
      p.printJpg(get(0,0,990,520));
    }   
  }
  
  if (mouseX > 1100 && mouseX < 1120 && mouseY > 540 && mouseY < 560 && pagenum != memberdata.size()/24 && !anychange) {  //changing pages
    pagenum += 1;
    numselect = 0;
    for (int i = 0; i < 24; i++) selected[i] = false;
  }
  if (mouseX > 1060 && mouseX < 1080 && mouseY > 540 && mouseY < 560 && pagenum != 0 && pagenum != 0 && !anychange) {
    pagenum -= 1;
    numselect = 0;
    for (int i = 0; i < 24; i++) selected[i] = false;
  }
}

void readData(String filename) {        //function that opens the file and stores all info in "memberdata" ArrayList
  
  File file = new File(filename);      //opens the master file
  BufferedReader br = null;            //declares and initializes bufferedreader
  
    try{
    br = new BufferedReader(new FileReader(file));      //gets ready to read from the master file
    String text = new String();

    while((text = br.readLine()) != null) {          //reads a single line of text, looping until the end of the file
      String[] member = new String[10];               //makes a String array of length 6 to hold info before it is put in the memberdata arraylist
      int[] commaindexes = new int[9];               //makes an int array to store the locations of all of the commas in this line
      int j = 0;                                     //int later used to move through the commaindexes array
      for (int i = 0; i < text.length(); i++) {      //for loop that iterates through every character in this line of text
        if (text.charAt(i) == ',') {                 //if the read character is a comma
          commaindexes[j] = i;                       //store the location of the comma, and
          j += 1;                                    //move to the next element of the commaindexes array
        }
      }
        
      member[0] = text.substring(0, commaindexes[0]);                        //stores the membership number in the first element of the member stringarray 
      member[1] = text.substring(commaindexes[0] + 1, commaindexes[1]);      //stores the first name in the second element of the member stringarray
      member[2] = text.substring(commaindexes[1] + 1, commaindexes[2]);      //stores the last name in the third element of the member stringarray 
      member[3] = text.substring(commaindexes[2] + 1, commaindexes[3]);      //stores the high school in the fourth element of the member stringarray 
      member[4] = text.substring(commaindexes[3] + 1, commaindexes[4]);      //stores the state in the fifth element of the member stringarray 

      member[5] = text.substring(commaindexes[4] + 1, commaindexes[5]);      //stores the email address in the sixth element of the member stringarray
      member[6] = text.substring(commaindexes[5] + 1, commaindexes[6]);      //stores the year joined in the seventh element of the member stringarray
      member[7] = text.substring(commaindexes[6] + 1, commaindexes[7]);      //stores the code for active/non-active in the eighth element of the member stringarray
      member[8] = text.substring(commaindexes[7] + 1, commaindexes[8]);      //stores the grade in the ninth element of the member stringarray
      member[9] = text.substring(commaindexes[8] + 1, text.length());        //stores the amount owed in the tenth element of the member stringarray
      
      memberdata.add(member);        //adds all of the member array to the memberdata arraylist; the member array is no longer needed
      
    } 
  }
  catch(FileNotFoundException e) {    //error handling
    e.printStackTrace();
  }
  catch(IOException e) {      //error handling
    e.printStackTrace();
  }
  
  finally{
    try {
      if (br != null){
        br.close();      //closes the master file
      }
    }
    catch (IOException e) {    //error handling
      e.printStackTrace();
    }
  }
}

void writedata(String filename) {        //function that writes current contents of the memberdata arraylist to the datafile
  BufferedWriter bw = null;            //declare and initialize bufferedwriter
  try {
    FileWriter fw = new FileWriter(filename);    //declare and initialize filewriter
    bw = new BufferedWriter(fw);
    for (int j = 0; j < memberdata.size(); j++) {        //for each stringarray in memberdata
      for (int i = 0; i < 9; i++)  {                     //go through each field
        bw.write(memberdata.get(j)[i] + ",");            //and write the contents in the file, separated by commas
      }
      bw.write(memberdata.get(j)[9]);      //write the last field-- done separately so there is no unnecessary comma at the end of each line
      bw.newLine();    //make a new line
    }
  }
  catch (IOException e) {}    //error handling
  finally {
    if (bw != null){ 
      try { 
        bw.close();      //close file
      }
      catch (IOException e) {}    //error handling  
    }
  }
}

void printmemberdata() {
  fill(255);
  textAlign(LEFT);
    text("Membership Number", 10, 20);
    text("First Name", 150, 20);
    text("Last Name", 250, 20);
    text("High School", 350, 20);
    text("State", 450, 20);
    text("Email", 550, 20);
    text("Year Joined", 700, 20);
    text("Active?", 800, 20);
    text("Grade", 900, 20);
    text("Amount Owed ($)", 1000, 20);
    
    //draw some buttons to navigate pages
    if (pagenum != 0) triangle(1060,550,1080,540,1080,560); //back
    if (pagenum != memberdata.size()/24) triangle(1100,540,1100,560,1120,550); //forward
    text("Page " + (pagenum+1) + " of " + (memberdata.size()/24+1), 1055, 580);
    try {      
        for (int i = pagenum*24; i < pagenum*24+24; i++)
          text(memberdata.get(i)[0], 20, 30+20*(i%24+1));
        for (int i = pagenum*24; i < pagenum*24+24; i++)      //prints the memberdata arraylist
          for (int j = 1; j < 6; j++)
            text(memberdata.get(i)[j], 50+100*(j), 30+20*(i%24+1));
        for (int i = pagenum*24; i < pagenum*24+24; i++)
          for (int j = 6; j < 10; j++)
            text(memberdata.get(i)[j], 700+100*(j-6), 30+20*(i%24+1));
      }
    catch(IndexOutOfBoundsException e) {
      try {
        for (int i = pagenum*24; i < pagenum*24+24; i++)      //prints the memberdata arraylist
          for (int j = 1; j < 6; j++)
            text(memberdata.get(i)[j], 50+100*(j), 30+20*(i%24+1));
      }
      catch(IndexOutOfBoundsException f) {
        try {
          for (int i = pagenum*24; i < pagenum*24+24; i++)
            for (int j = 6; j < 10; j++)
              text(memberdata.get(i)[j], 700+100*(j-6), 30+20*(i%24+1));
        }
        catch(IndexOutOfBoundsException g) {}
      }
    }   //error handling
      
    
    rect(10, 570, 100, 20, 4);        //"add member" button    
    rect(120, 570, 100, 20, 4);       //"change record" button
    rect(230, 570, 100, 20, 4);       //"delete member" button
    fill(0);
    text("Add Member", 20, 585);
    if (numselect == 1) fill(0);
    else fill(150);      
    text("Change Record", 122.5, 585);
    if (numselect >= 1) fill(0);
    else fill(150);
    text("Delete Member", 235, 585);
    fill(255);
    
    if (!isadding) {
      rect(340, 570, 100, 20, 4);       //"balance report" button
      fill(0);
      text("Balance Report", 345, 585);
      fill(255);
      rect(450, 570, 100, 20, 4);       //"senior report" button
      fill(0);
      text("Senior Report", 460, 585);
      fill(255);
    }
}

void balancereport(String reportfile) {
  
  class Member{                    //creates a class for each member, with the following properties: 
    public String state;                //member's state
    public String membership_number;    //member number
    public String first_name;           //member's first name
    public String last_name;            //member's last name
    public String year_joined;          //year the member joined
    public String grade;                //member's grade
    public String balance;              //member's current balance
    
    public Member(String st, String memid, String fn, String ln, String yr, String gr, String bal) {
      this.state = st;                                  //creates a function that can be called to set the values of the 
      this.membership_number = memid;                   //variables in the Member class
      this.first_name = fn;
      this.last_name = ln;                              //the parameters of said function are just the desired values
      this.year_joined = yr;
      this.grade = gr;
      this.balance = bal;
    }
  };
  
  class MemberComp implements Comparator<Member>{      //class to compare the states of the members
    @Override                                          //it puts the states into alphabetical order
    public int compare(Member m1, Member m2) {
      if(m1.state.compareTo(m2.state) < 0){
        return -1;
      }
      else {
        return 1;
      }
    }
  }
  List<Member> members_list = new ArrayList<Member>();            //creates a members_list of Member objects
  for (int i = 0; i < memberdata.size(); i++) {                   //and puts data from memberdata inside the list
    members_list.add(new Member(memberdata.get(i)[4], memberdata.get(i)[0], memberdata.get(i)[1], memberdata.get(i)[2],
                                memberdata.get(i)[6], memberdata.get(i)[8], memberdata.get(i)[9]));
  }
  
  Collections.sort(members_list,new MemberComp());        //sorts the members_list in alphabetical order by state
            
  BufferedWriter bw = null;            //declare and initialize bufferedwriter
  try {
    FileWriter fw = new FileWriter(reportfile);    //declare and initialize filewriter
    bw = new BufferedWriter(fw);                           //and bufferedwriter
    int linecounter = 0;          //creates a line counter
    for(int i = 0; i < members_list.size(); i++) {        //goes through members_list
      if (linecounter <= 50) {                            //as long as the linecounter is 50 or below
        if (!(Integer.parseInt(members_list.get(i).balance)==0)) {      //if the member's balance isn't 0
          bw.write(members_list.get(i).state);                          //write the properties of Member
          bw.write("\n\tMembership Number: " + members_list.get(i).membership_number);
          linecounter++;
          bw.write("\n\t\tName: " + members_list.get(i).first_name + " " + members_list.get(i).last_name);
          linecounter++;
          bw.write("\n\t\tYear Joined: " + members_list.get(i).year_joined);
          linecounter++;
          bw.write("\n\t\tGrade: " + members_list.get(i).grade);
          linecounter++;
          bw.write("\n\t\tBalance: $" + members_list.get(i).balance);
          linecounter++;
          bw.newLine();
          linecounter++;
        }
      }
      else {            //when the linecounter exceeds 50
        bw.write("\f");      //new page
        linecounter = 0;     //reset line counter
      }
    }
    int nonactive = 0, membersowing = 0, balanceowed = 0;
    for (int i = 0; i < memberdata.size(); i++) {
      if ((memberdata.get(i)[7]).equals("N") || (memberdata.get(i)[7]).equals("n"))
        nonactive++;
      if (Integer.parseInt(memberdata.get(i)[9]) != 0) {
        membersowing++;
        balanceowed += Integer.parseInt(memberdata.get(i)[9]);
      }
    }
    bw.write("\n\n\nTotal Non-Active Members: " + nonactive);    //writes the footer
    bw.write("\nTotal Active Members: " + (memberdata.size()-nonactive));
    bw.write("\nTotal Members Owing: " + membersowing);
    bw.write("\nTotal Balance Owed: $" + balanceowed);    
  }
  catch (IOException e) {}    //error handling
  finally {
    if (bw != null){ 
      try { 
        bw.close();      //close file
      }
      catch (IOException e) {}    //error handling  
    }
  }
}

void exportseniorreport(String reportfile) {
  class Member{                //creates a Member class
    public String state;          //with the member's state,
    public String first_name;     //name,
    public String last_name;
    public String email;          //and email
    
    public Member(String st, String fn, String ln, String email) {    //function that assigns values to Member
      this.state = st;
      this.first_name = fn;
      this.last_name = ln;
      this.email = email;
    }
  };
  
  class MemberComp implements Comparator<Member>{        //class that compares States values of Members
    @Override
    public int compare(Member m1, Member m2) {
      if(m1.state.compareTo(m2.state) < 0){
        return -1;
      }
      else {
        return 1;
      }
    }
  }
  List<Member> members_list = new ArrayList<Member>();        //members_list of all Member objects
  for (int i = 0; i < memberdata.size(); i++) {                                                          //go through all of the entries in memberdata, and
    if (Integer.parseInt(memberdata.get(i)[8]) == 12)                                                    //if the student is a senior,
      members_list.add(new Member(memberdata.get(i)[4], memberdata.get(i)[1], memberdata.get(i)[2],      //add them to the members_list
                                memberdata.get(i)[5]));
  }
  
  Collections.sort(members_list,new MemberComp());      //put the members_list in alphabetical order by state
   
  BufferedWriter bw = null;            //declare and initialize bufferedwriter
  try {
    FileWriter fw = new FileWriter(reportfile);    //declare and initialize filewriter
    bw = new BufferedWriter(fw);
    
    for (int i = 0; i < members_list.size(); i++) {      //go through every entry in members_list
      bw.write(members_list.get(i).state + "\n\t" + members_list.get(i).first_name + " " + members_list.get(i).last_name
                + "\t" + members_list.get(i).email);      //write state, name, and email of each member
      bw.newLine();
    }
  }
  catch (IOException e) {}
  finally {
    if (bw != null){ 
      try { 
        bw.close();      //close file
      }
      catch (IOException e) {} 
    }
  }
}

void printseniorreport() {
  class Member{                //creates a Member class
    public String state;          //with the member's state,
    public String first_name;     //name,
    public String last_name;
    public String email;          //and email
    
    public Member(String st, String fn, String ln, String email) {    //function that assigns values to Member
      this.state = st;
      this.first_name = fn;
      this.last_name = ln;
      this.email = email;
    }
  };
  
  class MemberComp implements Comparator<Member>{        //class that compares States values of Members
    @Override
    public int compare(Member m1, Member m2) {
      if(m1.state.compareTo(m2.state) < 0){
        return -1;
      }
      else {
        return 1;
      }
    }
  }
  List<Member> members_list = new ArrayList<Member>();        //members_list of all Member objects
  for (int i = 0; i < memberdata.size(); i++) {                                                          //go through all of the entries in memberdata, and
    if (Integer.parseInt(memberdata.get(i)[8]) == 12)                                                    //if the student is a senior,
      members_list.add(new Member(memberdata.get(i)[4], memberdata.get(i)[1], memberdata.get(i)[2],      //add them to the members_list
                                memberdata.get(i)[5]));
  }
  
  Collections.sort(members_list,new MemberComp());      //put the members_list in alphabetical order by state
  
  textAlign(LEFT);
  text("State", 10, 20);
  text("First Name", 160, 20);
  text("Last Name", 310, 20);
  text("Email", 460, 20);

  for (int i = 0; i < members_list.size(); i++) {        //prints the members_list array 
    text(members_list.get(i).state, 10, 30+20*(i+1));
    text(members_list.get(i).first_name, 160, 30+20*(i+1));
    text(members_list.get(i).last_name, 310, 30+20*(i+1));
    text(members_list.get(i).email, 460, 30+20*(i+1));
  }
  rect(1000,570,100,20, 4);
  fill(0);
  text("Back to Main", 1015, 585);
  fill(255);
}

void printbalancereport() {
  class Member{                    //creates a class for each member
    public String state;         
    public String membership_number;   
    public String first_name;          
    public String last_name;          
    public String year_joined;      
    public String grade;
    public String balance;              
    
    public Member(String st, String memid, String fn, String ln, String yr, String gr, String bal) {
      this.state = st;                                  //creates a function that can be called to set the values of the 
      this.membership_number = memid;                   //variables in the Member class
      this.first_name = fn;
      this.last_name = ln;                              //the parameters of said function are just the desired values
      this.year_joined = yr;
      this.grade = gr;
      this.balance = bal;
    }
  };
  
  class MemberComp implements Comparator<Member>{      //class to compare the states of the members
    @Override                                                  //its puts the states into alphabetical order
    public int compare(Member m1, Member m2) {
      if(m1.state.compareTo(m2.state) < 0){
        return -1;
      }
      else {
        return 1;
      }
    }
  }
  List<Member> members_list = new ArrayList<Member>();            //creates a members_list of Member objects
  for (int i = 0; i < memberdata.size(); i++) {                   //and puts data from memberdata inside the list
    if (Integer.parseInt(memberdata.get(i)[9]) != 0) { 
      members_list.add(new Member(memberdata.get(i)[4], memberdata.get(i)[0], memberdata.get(i)[1], memberdata.get(i)[2],
                                  memberdata.get(i)[6], memberdata.get(i)[8], memberdata.get(i)[9]));
    }
  }
  
  Collections.sort(members_list,new MemberComp());        //sorts the members_list in alphabetical order by state
  
  textAlign(LEFT);
  text("State", 10, 20);
  text("Membership Number", 160, 20);
  text("First Name", 310, 20);
  text("Last Name", 460, 20);
  text("Year Joined", 610, 20);
  text("Grade", 760, 20);
  text("Balance", 910, 20);
  
  for (int i = 0; i < members_list.size(); i++) {        //prints the members_list array 
    text(members_list.get(i).state, 10, 30+20*(i+1));
    text(members_list.get(i).membership_number, 160, 30+20*(i+1));
    text(members_list.get(i).first_name, 310, 30+20*(i+1));
    text(members_list.get(i).last_name, 460, 30+20*(i+1));
    text(members_list.get(i).year_joined, 610, 30+20*(i+1));
    text(members_list.get(i).grade, 760, 30+20*(i+1));
    text(members_list.get(i).balance, 910, 30+20*(i+1));
  }
  rect(1000,570,100,20, 4);
  fill(0);
  text("Back to Main", 1015, 585);
  fill(255);
}

class PrintIt{                  //takes a screenshot and prints
  PrintService[] services;
  PrintService service; 
  DocFlavor docflavor;
  Doc myDoc;
  PrintRequestAttributeSet aset;
  DocPrintJob job;
  PrintIt(){
    myDoc = null;
    job = null;
    services = null;
    setService(PrintServiceLookup.lookupDefaultPrintService());
    setDocFlavor(DocFlavor.BYTE_ARRAY.AUTOSENSE);
    aset =  new HashPrintRequestAttributeSet();
  }

  void setService(PrintService p)
  {
    service = p;
  }
  
  void setDocFlavor(DocFlavor d)
  {
    docflavor = d;  
  }

  void listPrinters(){
    services = PrintServiceLookup.lookupPrintServices(null, null);
    for (int i = 0; i < services.length; i++) {
  System.out.println(services[i].getName());
  DocFlavor[] d = services[i].getSupportedDocFlavors();
  for(int j = 0; j < d.length; j++)
    System.out.println("  "+d[j].getMimeType());
    }
    services = null;
  }

  // prints a given image
  void printJpg(PImage img){
    setDocFlavor(DocFlavor.BYTE_ARRAY.JPEG);
    print(bufferImage(img));
  }

  // prints a given string
  void printString(String s){
    setDocFlavor(DocFlavor.BYTE_ARRAY.AUTOSENSE);
    print(s.getBytes());
  }

  boolean print(byte[] b){
    if(!service.isDocFlavorSupported(docflavor)){
     println("MimeType: \""+docflavor.getMimeType()+"\" not supported by the currently selected printer");
     return false;
    }
    
    boolean ret = true;
    try{
  myDoc = new SimpleDoc(b, docflavor, null);  
    }
    catch(Exception e){
  println(e);
  ret = false;
    }  
    
    job = service.createPrintJob();
    try {
  job.print(myDoc, aset);
    } 
    catch (PrintException pe) {
  println(pe);
  ret = false;
    }
    
    return ret;
  }
  
  // used with printJpg()
  byte[] bufferImage(PImage srcimg){
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    BufferedImage img = new BufferedImage(srcimg.width, srcimg.height, 2);
    img = (BufferedImage)createImage(srcimg.width, srcimg.height, 0).getNative();
    for(int i = 0; i < srcimg.width; i++)
    {
  for(int j = 0; j < srcimg.height; j++)
  {
    int id = j*srcimg.width+i;
    img.setRGB(i,j, srcimg.pixels[id]); 
  }
    }
    try{
  JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
  JPEGEncodeParam encpar = encoder.getDefaultJPEGEncodeParam(img);
  encpar.setQuality(1,false);
  encoder.setJPEGEncodeParam(encpar);
  encoder.encode(img);
    }
    catch(FileNotFoundException e){
  System.out.println(e);
    }
    catch(IOException ioe){
  System.out.println(ioe);
    }
    return out.toByteArray();
  }
}
