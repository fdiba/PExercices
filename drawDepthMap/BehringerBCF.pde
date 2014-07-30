class BehringerBCF{
  
  MidiBus midiBus;
  int slidersList;
  
  BehringerBCF(MidiBus _midiBus){
  
    midiBus = _midiBus;
    slidersList = 0; //chan 154 note 0 or 1
   
  }
  void setSliderPosition(int bGrp, int bId, int behValue){
    
    if(slidersList == bGrp){
      
      midiBus.sendMessage(185, 99, 0);
      midiBus.sendMessage(185, 98, bId);
      midiBus.sendMessage(185, 6, behValue); //target
      midiBus.sendMessage(185, 38, 0); //other one

    }
    
  }
  void midiMessage(int channel, int number, int value){
    
    if(channel == 154 && number != slidersList){
      
      slidersList = number;
      println("reset behrlinger sliders");
      
      menu.resetBSliders();
      
      
      
    }
    
    
  }
  
}
