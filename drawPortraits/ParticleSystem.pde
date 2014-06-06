import java.util.Iterator;

class ParticleSystem{
  
  ArrayList<Particle> particles;
  Iterator<Particle> it;
  
  ParticleSystem(){
    
    particles = new ArrayList<Particle>();
    for (int i=0; i<100; i++){
      particles.add(new Particle());
    }  
  
  }
  void update(){
    it = particles.iterator();

    while (it.hasNext()) {
    
         Particle p = it.next();
         p.update();
         
         /*if (p.isDead()) {
             it.remove();
         }*/
    }
    
  }
  void run(){
    update();
    display(); 
  }
  void display(){
    it = particles.iterator();

    while (it.hasNext()) {
    
         Particle p = it.next();
         p.display();
         
    }
  }
}
