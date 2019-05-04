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
Used ASCII code for spacebar(32) as it's clearer to me, can be 
substituted with key==' ' if desired.
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
  PImage img1 = loadImage("asteroid_ship.png");
  
  

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
    // Draw the ship rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(255);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    //Arbitrarily chose Greg's small ship, Greg's bigger ship can be swapped in if desired.
    img1.resize(64,76);
    image(img1,-r,-r*1.5,2*r,3*r);
    /*
    //This is an alternative PShape ship, just a simple triangle
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    */
    popMatrix();   
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
