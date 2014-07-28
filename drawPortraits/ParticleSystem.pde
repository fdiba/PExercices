import java.util.Iterator;

class ParticleSystem{
  
  ArrayList<Particle> particles;
  
  //---- param ----//
  int particlesMaxNumber = 70;
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
      
      p.run(particles);
        
      if (p.isDead()) {   
      
        particles.remove(i);
      
      } else if (p.lifespan >= lifespanToGiveBirth) {   
        
        int count = 0;
    
        for (Particle other : particles) {
      
          float distance = PVector.dist(p.location, other.location);
      
          if ((distance > 0) && (distance < 50)) count++;
       
        }
        
        int maxClosePoints = int(random(5)+5);
        
        if(count < maxClosePoints){
          
          //set child location
          PVector randLoc = new PVector(random(-1,1), random(-1,1));
          PVector newLoc = PVector.add(p.location, randLoc);
          
          if(particles.size() < 500) particles.add(new Particle(newLoc, 10));
        
        }
    
      }
    } 
  }
}
