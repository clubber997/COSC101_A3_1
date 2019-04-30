/**************************************************************
* File: a3.pde
* Group: <Group members,group number>
* Date: 14/03/2018
* Course: COSC101 - Software Development Studio 1
* Desc: Astroids is a ...
* ...
* Usage: Make sure to run in the processing environment and press play etc...
* Notes: If any third party items are use they need to be credited (don't use anything with copyright - unless you have permission)
* ...
**************************************************************/
//Create Ship object
Ship ship;

//Create Asteroid objects
Asteroid asteroid0;
Asteroid asteroid1;
Asteroid asteroid2;
Asteroid asteroid3;
Asteroid asteroid4;
Asteroid asteroid5;
Asteroid asteroid6;
Asteroid asteroid7;

ArrayList<Bullet> bullets;
float bulletSpeed = 10;

int astroNums=20;
PVector[] astroids = new PVector[astroNums];
PVector[] astroDirect = new PVector[astroNums];

int score=0;
boolean alive=true;

void setup(){
  size(800,800);
  smooth();
  noCursor();  
    
  //initialise Ship object
  ship = new Ship(width/2, height/2);

  //initialises asteroid objects
  asteroid0 = new Asteroid(random(0,width),random(0, height));
  asteroid1 = new Asteroid(random(0,width),random(0, height));
  asteroid2 = new Asteroid(random(0,width),random(0, height));
  asteroid3 = new Asteroid(random(0,width),random(0, height));
  asteroid4 = new Asteroid(random(0,width),random(0, height));
  asteroid5 = new Asteroid(random(0,width),random(0, height));
  asteroid6 = new Asteroid(random(0,width),random(0, height));
  asteroid7 = new Asteroid(random(0,width),random(0, height));
  
  //Initialise Bullet Array
  bullets = new ArrayList<Bullet>(0);
}

/**************************************************************
* Function: myFunction()

* Parameters: None ( could be integer(x), integer(y) or String(myStr))

* Returns: Void ( again this could return a String or integer/float type )

* Desc: Each funciton should have appropriate documentation. 
        This is designed to benefit both the marker and your team mates.
        So it is better to keep it up to date, same with usage in the header comment

***************************************************************/


   


void collisionDetection(){
  //check if shots have collided with astroids
  //check if ship as collided wiht astroids
}

void draw(){
  background(0);

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw a circle at the mouse location
  fill(255);
  stroke(0);
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  // Calls functions to display and move ship
  ship.arrive(mouse);
  ship.update();
  ship.display();
  
  //drawAstroids();
  asteroid0.wander();
  asteroid0.run();
  asteroid1.wander();
  asteroid1.run();
  asteroid2.wander();
  asteroid2.run();
  asteroid3.wander();
  asteroid3.run();
  asteroid4.wander();
  asteroid4.run();
  asteroid5.wander();
  asteroid5.run();
  asteroid6.wander();
  asteroid6.run();
  asteroid7.wander();
  asteroid7.run();
  
  for(int i = 0; i < bullets.size(); i++){
    bullets.get(i).edges();
    if(bullets.get(i).update()){
      bullets.remove(i);
      i--;
    }
    if(i < 0){
     break; 
    }
    bullets.get(i).render();
    /*
    if(bullets.get(i).checkCollision(asteroids)){
      bullets.remove(i);
      i--;
    }
    */
   }
   
    while(bullets.size() > 30){
    bullets.remove(0); 
   }
}

  //might be worth checking to see if you are still alive first
  // report if game over or won
  // draw score
  
/*
Calls fireBullet function when spacebar is released: call is upon
release as calling the function when the spacebar is pressed may
lead to multiple unwanted calls
*/
void keyReleased() {
  if(key==32){
     fireBullet(ship.velocity);
  }
}

void fireBullet(PVector target){
  PVector pos = new PVector(0, ship.r*2);
  rotate2D(pos,heading2D(target) + PI + PI/2);
  pos.add(ship.location);
  PVector vel  = new PVector(0, bulletSpeed);
  rotate2D(vel, heading2D(target) + PI + PI/2);
  bullets.add(new Bullet(pos, vel));
}

float heading2D(PVector pvect){
   return (float)(Math.atan2(pvect.y, pvect.x));  
}

void rotate2D(PVector v, float theta) {
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}

/*
The class below is adapted from the following source:
Shiffman, D. (2012). The Nature of Code.
Retrieved from natureofcode.com
website: https://natureofcode.com/book/chapter-6-autonomous-agents/
*/
class Ship {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Ship(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 6;
    maxspeed = 4;
    maxforce = 0.1;
  }

/**************************************************************
* Function: update()

* Parameters: NULL

* Returns: Void

* Desc: Updates ship location and velocity by adding vectors, as
        shown in lectures
***************************************************************/

  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
   }

/**************************************************************
* Function: arrive()

* Parameters: PVector target

* Returns: Void

* Desc: Takes in a PVector argument. Calculates a steering heading
        towards the desired target by minusing the target from 
        the location and then minusing velocity from the previous
        result. Includes math to slow ship down when close to
        the mouse so that it doesn't overshoot, and has a 
        more natural feel. 
***************************************************************/
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    float d = desired.mag();
    // Normalize desired and scale with arbitrary damping within 100 pixels
    desired.normalize();
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    acceleration.add(steer);
  }
  
/**************************************************************
* Function: display()

* Parameters: NULL

* Returns: Void

* Desc: Renders the ship on the screen. translate(), rotate()
        and theta = velocity.heading2D() are required for steering.
***************************************************************/
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(255);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();   
  }
}

/*
The class below is adapted from the following source:
Shiffman, D. (2012). The Nature of Code.
Retrieved from natureofcode.com
website: https://natureofcode.com/book/chapter-6-autonomous-agents/
*/
class Asteroid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float wandertheta;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

   Asteroid(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 6;
    wandertheta = 0;
    maxspeed = 1;
    maxforce = 0.05;
  }

  void run() {
    update();
    borders();
    display();
  }

/**************************************************************
* Function: update()

* Parameters: NULL

* Returns: Void

* Desc: Updates ship location and velocity by adding vectors, as
        shown in lectures
***************************************************************/
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

/**************************************************************
* Function: wander()

* Parameters: NULL

* Returns: Void

* Desc: Sets boundaries for wandering asteroids, and changes
        asteroid heading randomly. 
***************************************************************/
  void wander() {
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 80;         // Distance for our "wander circle"
    float change = 0.3;
    wandertheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new location to steer towards on the wander circle
    PVector circleloc = velocity.get();    // Start with velocity
    circleloc.normalize();            // Normalize to get heading
    circleloc.mult(wanderD);          // Multiply by distance
    circleloc.add(location);               // Make it relative to boid's location
    
    float h = velocity.heading2D();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circleloc,circleOffSet);
    seek(target);
  }

/**************************************************************
* Function: seek()

* Parameters: NULL

* Returns: Void

* Desc: Calculates and applies steering force towards randomised
        target generated in wander. Steering is achieved by 
        subtracting velocity from desired heading
***************************************************************/
void seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    acceleration.add(steer);
  }

/**************************************************************
* Function: display()

* Parameters: NULL

* Returns: Void

* Desc: Renders the ship on the screen. translate(), rotate()
        and theta = velocity.heading2D() are required for steering.
***************************************************************/
  void display() {
    float theta = velocity.heading2D() + radians(90);
    fill(127);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(25,0);
    vertex(50,25);
    vertex(50,50);
    vertex(25,75);
    vertex(0,50);
    vertex(0,25);
    endShape();
    popMatrix();
  }

/**************************************************************
* Function: borders()

* Parameters: NULL

* Returns: Void

* Desc: Detects if asteroid is off screen. If asteroid is offscreen,
asteroid is translated to opposite edge to recreate the Atari
never-ending screen feel. Not implemented with Ship unfortunately,
as is not possible with cursor-foloowing behavior. Could be easily
implemented if Ship was controlled by arrow keys or WASD keys,
but I prefer the cursor-following feel.
***************************************************************/  
  void borders() {
    if (location.x < 0) location.x = width;
    if (location.y < 0) location.y = height;
    if (location.x > width) location.x = 0;
    if (location.y > height) location.y = 0;
  }
}

/*
The class below is adapted from the following source:
Gillespie, M. (2013). Asteroids.
Retrieved from openprocessing.org
website: https://www.openprocessing.org/sketch/106239/
*/
class Bullet{
 PVector position;
 PVector velocity;
 int radius = 5;
 int counter = 0;
 int timeOut = 24 * 2;
 float alpha;
 //Retrieved from https://www.openprocessing.org/sketch/106239/
 PImage img = loadImage("laser.png");

 public Bullet(PVector pos, PVector vel){
  position = pos;
  velocity = vel;
  alpha = 255;
 } 
 
/**************************************************************
* Function: edges()

* Parameters: NULL

* Returns: Void

* Desc: Detects if bullet is off screen. If bullet is offscreen,
bullet is translated to opposite edge to recreate the Atari
never-ending screen feel.
***************************************************************/  
 void edges(){
  if (position.x < 0){
      position.x = width;
    }
    if (position.y < 0) {
      position.y = height;
    }
    if (position.x > width) {
      position.x = 0;
    }
    if (position.y > height){
      position.y = 0;
    } 
 }
/* 
 boolean checkCollision(ArrayList<Asteroid> asteroids){
   for(Asteroid a : asteroids){
     PVector dist = PVector.sub(position, a.position);
     if(dist.mag() < a.radius){ 
      a.breakUp(asteroids);      
      return true;
     }
   }
   return false;
 }
 */

/**************************************************************
* Function: update()

* Parameters: NULL

* Returns: boolean

* Desc: Checks to see if bullet has timed out. If not, returns false
and adds velcity to bullet's position. If bullet has timed out, 
will return true, and the bullet will be removed in another loop.
***************************************************************/
 boolean update(){
   alpha *= .9;
  counter++;
  if(counter>=timeOut){
    return true;
  }
  position.add(velocity);
  return false; 
 }

 
/**************************************************************
* Function: render()

* Parameters: NULL

* Returns: void

* Desc: Displays laser bullet on screen, rotated in direction 
that the ship is pointing in. Adapted from the Ship.render()
function.
***************************************************************/
 void render(){
    float theta = velocity.heading2D() + PI/2;
    fill(255);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    image(img, -radius/2, -2*radius, radius, radius*5); 
    popMatrix();
 }
}
