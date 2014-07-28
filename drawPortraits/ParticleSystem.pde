import java.util.Iterator;

class ParticleSystem{
  
  ArrayList<Particle> particles;
  
  //---- param ----//
  int particlesMaxNumber = 20;
  int lifespanToGiveBirth = 80;
  
  ParticleSystem(){
    
    particles = new ArrayList<Particle>();
        
    for (int i=0; i<particlesMaxNumber; i++){
      particles.add(new Particle());
    }
    
  }
  void run(){
    
    int numParticles = particles.size();
    
    for(int i=numParticles-1; i>=0; i--){
        
      Particle p = (Particle) particles.get(i);
      
      p.update();
        
      if (p.isDead()) {   
        particles.remove(i);
      } else if (p.lifespan >= lifespanToGiveBirth) {   
        
        //set child location
        PVector randLoc = new PVector(random(-1,1), random(-1,1));
        PVector newLoc = PVector.add(p.location, randLoc);
        
        if(particles.size() < 500 && p.delay <= 0) particles.add(new Particle(newLoc, 10));
        
        p.lifespan = 10;
        p.setDelay();
        
      }
    }
    
  }
}
