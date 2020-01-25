/*
 * ball.pde
 *
 * Class for a Ball
 *
 *  Created on: December 23, 2019
 *      Author: Sean LaPlante
 */


class Ball {
    /*
     * A ball with velocity, direction, size, and location
     */

    public boolean isDelete;
    public boolean isDone;
    public boolean fired;
    public float distTraveled;

    private PVector velocity;  // Location for an ellipse is the center of the ellipse.
    private PVector location;
    
    Ball(PVector loc) {
        /*
         * This constructor takes a PVector and stores the reference.
         * Any updates to the PVector from the caller will happen here too.
         */
        location = loc;
        velocity = new PVector(0, 0);
        isDelete = false;
        isDone = false;
        fired = false;
        distTraveled = 0;
    }
    
    Ball(float x, float y) {
      /*
       * This constructor takes an x, y coordinate and constructs a local
       * PVector.
       */
       location = new PVector(x, y);
       velocity = new PVector(0, 0);
       isDelete = false;
       fired = false;
       isDone = false;
       distTraveled = 0;
    }
        
    void display() {
        /*
         * Called from the main draw method. Used to display the ball
         * on the screen.
         */
        if (isDelete) {
            return;
        }

        pushMatrix();
        fill(255);
        ellipse(location.x, location.y, (BALL_RADIUS * 2), (BALL_RADIUS * 2));
        popMatrix();
    }
    
    void setVelocity(PVector vel) {
        /*
         * Set the ball's velocity
         */
        velocity = vel.copy();
    }
    
    void setVelocityMag(float mag) {
        /*
         * Used to speed up the play. Max speed cannot exceed
         * BALL_RADIUS * 1.25 for collision detection
         */ 
        if (mag >= (BALL_RADIUS * 1.25) - 1) {
            mag = (BALL_RADIUS * 1.25) - 1;
        }
        velocity.setMag(mag);
    }
    
    void fire() {
        /*
         * Set the ball's state to fired
         */
        fired = true;
    }
    
    void move() {
        /*
         * Called to add velocity to the ball
         */        
        if (isDelete) {
            return;
        } else if (isDone) {
            checkIsDelete();
            return;
        }
         
        distTraveled += velocity.mag();
        location.add(velocity);
        
        checkBoundaryCollision();
        for (Block block : mainGame.blocks) {
            if (!block.isDelete && !block.isExplode) {
                checkCollision(block);
            }
        }
    }
    
    void checkIsDelete() {
        if (location.x == mainGame.screen.launchPoint.x) {
            isDelete = true;
            return;
        } else if (velocity.x < 0 && location.x < mainGame.screen.launchPoint.x) {
            isDelete = true;
            return;
        } else if (velocity.x > 0 && location.x > mainGame.screen.launchPoint.x) {
            isDelete = true;
            return;
        }
        
        if (location.x > mainGame.screen.launchPoint.x + (BALL_RADIUS * 2)) {
            velocity.x = BALL_RADIUS * -1;
            location.add(velocity);
        } else if (location.x < mainGame.screen.launchPoint.x - (BALL_RADIUS * 2)) {
            velocity.x = BALL_RADIUS;
            location.add(velocity);
        } else {
            location.x = mainGame.screen.launchPoint.x;
        }
    }
    
    void checkBoundaryCollision() {
        /*
         * Check for collision with the screen boundary
         */
        if (!fired) {
            return;
        }
         
        if (location.x > mainGame.screen.right - BALL_RADIUS) {
          location.x = mainGame.screen.right - BALL_RADIUS;
          velocity.x *= -1;
        } else if (location.x < BALL_RADIUS) {
          location.x = BALL_RADIUS;
          velocity.x *= -1;
        } else if (location.y > mainGame.screen.bottom - BALL_RADIUS) {
          isDone = true;
          velocity.y = 0;
          velocity.x = 0;
          location.y = mainGame.screen.launchPoint.y;
        } else if (location.y < mainGame.screen.top + BALL_RADIUS) {
          location.y = mainGame.screen.top + BALL_RADIUS;
          velocity.y *= -1;
        }
    }
    
    void checkCollision(Block other) {
        /*
         * Check for a collision with a block
         */
        if (!fired) {
            return;
        }
      
        // Get distances between the objects
        PVector distVec = PVector.sub(other.middle, location);  // Location for ellipse is middle
        float dist = distVec.mag();
    
        // Minimum distance before they are touching
        float minDistance = BALL_RADIUS + other.radius;
    
        if (dist < minDistance) {
            // Collision is impossible until this is true.
            boolean above = false, below = false, left = false, right = false;
            
            // Get the leading point on the circle
            PVector radiusVec = velocity.setMag(null, BALL_RADIUS);
            PVector edgePoint = PVector.add(location, radiusVec);
            
            if (location.x > other.right) {
                // ball is on the right of the block
                edgePoint = new PVector(location.x - BALL_RADIUS, location.y);
                right = true;
            } else if (location.x < other.left) {
                // ball is on the left of the block
                edgePoint = new PVector(location.x + BALL_RADIUS, location.y);
                left = true;
            } else if (location.y > other.bottom) {
                // ball is underneith
                edgePoint = new PVector(location.x, location.y - BALL_RADIUS);
                below = true;
            } else if (location.y < other.top) {
                // ball is above
                edgePoint = new PVector(location.x, location.y + BALL_RADIUS);
                above = true;
            }
            
            if (edgePoint.x > other.left && edgePoint.x < other.right && edgePoint.y > other.top && edgePoint.y < other.bottom) {
                if (left || right) {
                    velocity.x *= -1;
                } else if (above || below) {
                    velocity.y *= -1;
                }
                
                if (left) {
                    location.x = other.left - BALL_RADIUS;
                } else if (right) {
                    location.x = other.right + BALL_RADIUS;
                } else if (above) {
                    location.y = other.top - BALL_RADIUS;
                } else if (below) {
                    location.y = other.bottom + BALL_RADIUS;
                }
                
                other.hit();
            } 
        }
    }
}
