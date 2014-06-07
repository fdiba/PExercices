import java.util.Iterator;

class ParticleSystem{
  
  ArrayList<Particle> particles;
  Iterator<Particle> it;
  
  ParticleSystem(){
    
    particles = new ArrayList<Particle>();
    for (int i=0; i<20; i++){
      particles.add(new Particle());
    }  
  
  }
  void run(){
    host.img.loadPixels();
    update();
    host.img.updatePixels();
    display();
    
  }
  void update(){
    
    int numParticles = particles.size();
    
    for(int i = numParticles-1; i >= 0; i--){
      Particle p = (Particle) particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      } else if (p.lifespan >= 23) {
        particles.add(new Particle(p.location, 20));
        p.lifespan = 10;
      }
    }
    println(particles.size());
  }
  void display(){
    it = particles.iterator();

    while (it.hasNext()) {
    
         Particle p = it.next();
         p.display();
    }
  }
}
