class BehringerBCF{
  
  MidiBus midiBus;
  int slidersList;
  
  //last slider values
  int chan185num98Value; //number 0 to 7
  int chan185num6Value; //value 0 to 127
  
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
      
      menu.resetBSliders();
     
    } else if(channel == 185){
      
      menu.reveal();
      
      if(number==98) chan185num98Value = value;
      if(number==6) chan185num6Value = value;
      
      int id=999;
      
      if(slidersList == 0){ //first sliders grp
      
        id = chan185num98Value;
        
        
      } else if (slidersList >= 1){ //second sliders grp
      
        return;
        
      }
      
      //id<7 because slider 8 do not exist
      if(number==38 && id<=7) menu.sliders[id].editValWithBeh(chan185num6Value);
      
      
    }
    
  }
  
}
