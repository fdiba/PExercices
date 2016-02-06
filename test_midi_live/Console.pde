class Console{
  
  PVector loc;
  String message;
  
 Console(float x, float y){
  
   loc = new PVector(x, y);
   message = "ch:\npitch:\nvelocity:";
 }
 void update(int channel, int pitch, int velocity){
   message = "ch: " + Integer.toString(channel)
   + "\npitch: " + Integer.toString(pitch)
   + "\nvelocity: " + Integer.toString(velocity);
 }
 void update(String str){
   message = str;
 }
 void display(){
   fill(255, 197, 49);
   noStroke();
   rect(0, 0, width, 60);
   fill(0);
   text(message, loc.x, loc.y);
 }
}
