/*
 * globals.pde
 *
 * All variables that need global scope
 *
 *  Created on: December 23, 2019
 *      Author: Sean LaPlante
 */

int TIME = 0;
boolean DEBUG = false;  // Displays cheat lines and other useful info

enum GameState {
    START_SCREEN,
    PLAYING
}

enum InputType {
    TOUCH_START,
    TOUCH_END,
    TOUCH_MOVE
}

GameState currentState;

StartScreen startScreen;

MainGame ENGINE;


int FRAME_RATE = 90;

//
// Globally set these based on DPI
//
// These are set in setup()
//
float BALL_RADIUS;              // The radius of the game ball
float PICKUP_BALL_RADIUS;       // The radius of the ring around pickup balls
float COIN_RADIUS;              // The radius of a coin
float SHOT_SPEED;               // The speed the ball travels for a shot
float BLOCK_WIDTH;              // The width of a game block
int EXPLODE_PART_COUNT;         // Number of particles a block turns into when it explodes
int EXPLODE_ALPHA_CHANGE;       // Rate of change for the alpha of an explostion particle (how fast do they fade out?)
float EXPLODE_PART_MAX_SPEED;   // Minimum speed (used to set the velocity) - Should be negative.
float EXPLODE_PART_MIN_SPEED;   // Max speed (used to set the velocity) - Should be positive.
float EXPLODE_PART_BWIDTH;      // An explosion particle is also a square. What's its width and height?
float BLOCK_XY_SPACING;         // The whitespace between the blocks
float DEFAULT_TEXT_SIZE;        // Size of the rest of the text
float SMALL_TEXT_SIZE;          // Size of small text
int BLOCK_COLUMNS;              // Number of columns for blocks
float HUD_TOP_SIZE_PERCENT;     // Percentage of the screen height that should be taken for the top of the HUD
float HUD_BOTTOM_SIZE_PERCENT;  // Percentage of the screen height that should be taken for the bottom of the HUD
float SLIDE_VELOCITY;           // y direction velocity for sliding blocks down when the level changes


void startTimer() {
    /*
     * Used to profile the program when DEBUG is true
     */
    if (!DEBUG) {
        return;
    }
    TIME = millis();
}


void stopTimer(String func) {
    /*
     * Used to profile the program when DEBUG is true
     */
    if (!DEBUG) {
        return;
    }
    println(func, ": ", millis() - TIME);
}


void startGame() {
    /*
     * Called in setup and game over
     */
    currentState = GameState.START_SCREEN;
    startScreen = new StartScreen();
    ENGINE = new MainGame();
    ENGINE.hud.loadGame();
    ENGINE.world.generateNewRow();
}


void gameOver() {
    /*
     * Called when they lose
     */
    ENGINE.hud.gameOver();  // This will save what is required.
    startGame();
}
