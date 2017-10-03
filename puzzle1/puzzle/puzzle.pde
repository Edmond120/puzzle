char[] passcode = toCharAry("extinguish");
String password = "clubs";
char[] toCharAry(String s){
  char[]c = new char[s.length()];
  for(int i = 0; i < s.length();i++){
     c[i] = s.charAt(i); 
  }
  return c;
}
char[] chars = toCharAry("abcdefghijklmnopqrstuvwxyz");
char randomChar(){
  return chars[int(random(26))];
}
void setup(){
  fullScreen(P3D);
  frameRate(30);
  background(0);
}
void draw(){
 switch (mode){
  case HIDDEN_WORD: hiddenWord();
                    break;
  case THE_CUBE:    theCube();
                    break;
  case INPUT_CODE:  inputCode_display();
                    break;
   
 }
}
final int HIDDEN_WORD = 0;
final int THE_CUBE = 1;
final int INPUT_CODE = 2;
int mode = INPUT_CODE;
int frame = 0;
int ii = 0;
float minutesUntilHint = 15;
void hiddenWord(){
  camera(width - 500,height,(height/2)/tan(PI/6),width/2,height/2,0,0,1,0);
  if(!(frame++ % 5 == 0)){
    return;
  }
  background(0);
  float size = 30;
  float a = size * 1.5;
  float ycor = 495;
  float xStart = 6;
  float xEnd = xStart + passcode.length;
  textSize(size);
  fill(255);
  for(float x = 0;x < width; x += size * 1.5){
    for(float y = 0;y < height; y += size * 1.5){
      if(xStart < xEnd &&((x == xStart * a) && y == ycor)){
        if(frame >= 30 * 60 * minutesUntilHint){
          fill(#FF0004);
          text(passcode[ii++],x,y);
          fill(255);
        }
        else{
          text(passcode[ii++],x,y); 
        }
        xStart++;
      }
      else{text(randomChar(),x,y);}
    }
  }
  ii = 0;
}
float rotation = 0;
float size = 200;
void theCube(){
  camera(width - mouseX,height - mouseY,(height/2)/tan(PI/6),width/2,height/2,0,0,1,0);
  background(255);
  pushMatrix();
  translate(width/2,height/2);
  //rotateX(radians(45));
  //rotateY(radians(rotation++));
  stroke(255);
  strokeWeight(1);
  fill(0);
  box(size);
  popMatrix();
  
  pushMatrix();
  textSize(50);
  fill(#FF0303);
  rotateY(radians(180));
  //rotateX(radians(0));
  text("press w",width/2 - 5,height/2);
  popMatrix();
}
char[] passcodeInputBox = new char[password.length()];
int inputIndex = 0;
void inputCode_display(){
  camera();
  textSize(100);
  stroke(255);
  strokeWeight(5);
  fill(0);
  background(0);
  float sizeX = password.length() * 100 + 10;
  float sizeY = 200;
  rect(width/2 - sizeX/2,height/2 - sizeY/2,sizeX,sizeY);
  fill(255);
  for(int i = 0; i < inputIndex;i++){
   text(passcodeInputBox[i],width/2 - (sizeX-10)/2 + (i * 100),height/2 + 25);
  }
  if(!firstCode){
    textSize(18);
    fill(255);
   text("the passcode is x+10",width /2 - 100,height /2 - 150);
  
  }
}
void inputCode(char x){
  if(inputIndex < passcodeInputBox.length){
   passcodeInputBox[inputIndex++] = x; 
  }
}
boolean checkCode(String password,char[] input){
   for(int i = 0; i < input.length; i++){
      if(input[i] != password.charAt(i)){
         return false; 
      }
   }
   return true;
}
void inputCode_submit(){
  if(checkCode(password,passcodeInputBox)){
      mode = afterInputCode;
  }
  else{
     passcodeInputBox = new char[password.length()]; 
     inputIndex = 0;
  }
}
int find(char a, String x){
  for(int i = 0; i < x.length(); i++){
   if(x.charAt(i) == a){
     return i;
   }
  }
  return -1;
}
char lower(char x){
  int i = find(x,"ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  if(i != -1){
     return "abcdefghijklmnopqrstuvwxyz".charAt(i); 
  }
  else{
     return x; 
  }
}
boolean firstCode = true;
int afterCube = HIDDEN_WORD;
int afterInputCode = THE_CUBE;
void keyPressed(){
  if(mode == INPUT_CODE){
    if(key != CODED){
      if(key == '\n' || key == '\r'){
        inputCode_submit();
      }
      else{
        inputCode(lower(key));
      }
    }
  }
  else if(mode == THE_CUBE){
    if(key != CODED){
       if(lower(key) == 'w'){
           afterInputCode = HIDDEN_WORD;
           password = "x+10";
           mode = INPUT_CODE;
           firstCode = false;
           passcodeInputBox = new char[password.length()];
           inputIndex = 0;
       }
    }
  }
}
