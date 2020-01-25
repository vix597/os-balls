/*
 * main_game.pde
 *
 * Class that represents the main game
 *
 *  Created on: January 12, 2020
 *      Author: Sean LaPlante
 */


class MainGame {
    /*
     * This is where the main game logic exists
     */    
    private Hud hud;
    
    private Action action;
    
    // Game screen area
    public GameScreen screen;

    private Ball launchPointBall;
    public ShotLine launchLine;
    
    private int level;
    private int numBalls;
    private int score;
    private int coins;
    
    public ArrayList<Ball> balls;
    public ArrayList<Block> blocks;
    public ArrayList<Block> deleteBlocks;
        
    MainGame() {
        balls = new ArrayList<Ball>();
        blocks = new ArrayList<Block>();
        deleteBlocks = new ArrayList<Block>();
        action = null;
        
        loadGame();
        
        hud = new Hud(level, numBalls, score, coins);  
        screen = new GameScreen(0, width, hud.getTopLine(), hud.getBottomLine());  // left, right, top, bottom of play area
        launchPointBall = new Ball(screen.launchPoint);  // Pass in the PVector so that if the screen launchPoint is updated, so is this.
        
        generateBlocks();
    }
    
    void loadGame() {
        /*
         * Load the game state
         */
        level = 10;
        numBalls = 400;
        score = 0;
        coins = 0;
    }
    
    void saveGame() {
        /*
         * Called to save the current game state
         */
        // TODO
    }
    
    int getBlockValue() {
        /*
         * Get a random value for a block
         * based on the current level
         */
         int min = int(level / 3.0);
         if (min < 1) {
           min = 1;
         }
         int max = int(level * 1.33);
         return int(random(min, max));
    }
   
    void generateBlocks() {
        /*
         * Generate blocks for the
         * current level
         */
        int largest = 0;
        int min;
        int max;
        
        if (level < 8) {
            min = 1;
            max = level;
        } else {
            min = 10;
            max = 50;
        }

        int gen = int(random(min, max));
         
        float x = 0;
        float y = screen.top + BLOCK_WIDTH;
        for (int i = 1; i <= gen; i++) {
            int val = getBlockValue();
            Block block = new Block(new PVector(x, y), val);
            blocks.add(block);

            x += BLOCK_WIDTH;
            if (i % 7 == 0 && i > 0) {
                y += BLOCK_WIDTH;
                x = 0;
            }
            
            if (val > largest) {
                largest = val;
            }
        }
        
        /*
        for (Block block : blocks) {
            block.maxHSB = largest;
        }
        */
    }
    
    void display() {
        /*
         * Called on each iteration of the draw loop
         */
        hud.display();
 
        action = getAction(action);
        action.display();
         
        // Display the balls
        for (Ball ball: balls) {
            ball.display();
        }
        
        // Delete any blocks that should be deleted
        for (Block block : deleteBlocks) {
            blocks.remove(block);
        }
        deleteBlocks.clear();
        
        // Display the blocks
        for (Block block : blocks) {
            block.display();
        }
        
        // Display the current launch point
        launchPointBall.display();
    }
    
    void handleInput(InputType input) {
        /*
         * Called on each input event to handle input
         */
        
        if (input == InputType.TOUCH_START && hud.isTouchInHud()) {
            hud.handleInput(input);
            return;
        }
        
        if (action != null) {
            action.handleInput(input);
            return;
        }
    }
}
