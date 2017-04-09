// Extended from https://processing.org/examples/gameoflife.html

// Size of cells
int cellSize = 5;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 1;

// Variables for timer
int interval = 150;
int lastRecordedTime = 0;

// Generation counter
int generation = 1;

// Colors for active/inactive cells and generation counter
color alive = color(0, 200, 0);
color dead = color(0);

color counterBG = color(0);
color counter = color(255);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

// Show generation counter
boolean generationCounter = true;

void setup() {
  // Window size
  size(475,475);
  
  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(48);

  noSmooth();

  // Initialization of cells
  for (int x = 0; x < width / cellSize; x++) {
    for (int y = 0; y < height / cellSize; y++) {
      float state = random (100);
      if (state > probabilityOfAliveAtStart) { 
        state = 0;
      } else {
        state = 1;
        //state = 0; // Debug - begin with blank grid
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  // Draw grid
  for (int x = 0; x < width / cellSize; x++) {
    for (int y = 0; y < height / cellSize; y++) {
      if (cells[x][y] == 1) { // If alive
        fill(alive); 
      } else {                // If dead
        fill(dead); 
      }
      rect (x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  
  // Iterate if timer ticks
  if (millis() - lastRecordedTime > interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    } 
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width / cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height / cellSize));
    yCellOver = constrain(yCellOver, 0, height / cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver] == 1) { // Cell is alive
      cells[xCellOver][yCellOver] = 0; // Kill
      fill(dead);
    } else { // Cell is dead
      cells[xCellOver][yCellOver] = 1; // Make alive
      fill(alive);
    }
  } else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x = 0; x < width / cellSize; x++) {
      for (int y = 0; y < height / cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
  
  // Draw generation counter if enabled
  //
  if (generationCounter) {
    String gen = "Generation: " + generation;
    textAlign(CENTER);
    textSize(24);
    
    // Draw counter twice, slightly shifted, with different colors for emphasis.
    // This is a bit of a hack to make the text more discernible among the rest of the canvas.
    fill(counterBG);
    text(gen, width/2-1, height-25-1); // 
    fill(counter);
    text(gen, width/2, height-25);
  }
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x = 0; x <width/cellSize; x++) {
    for (int y = 0; y <height/cellSize; y++) {
      // And visit all the neighbors of each cell
      int neighbors = 0; // We'll count the neighbors
      int neighborhood = 0; //
      for (int xx = x-1; xx <= x+1; xx++) {
        for (int yy = y-1; yy <= y+1; yy++) {  
          if ( ((xx >= 0) && (xx < width/cellSize)) && ((yy >= 0) && (yy < height/cellSize)) ) { // Out of bounds check
            if (!((xx == x) && (yy == y))) { // Ignore self
              neighborhood++; // Count number of cells in neighborhood
              if (cellsBuffer[xx][yy] == 1) {
                neighbors++; // Check alive neighbors and count them
                //print ("Cell " + x + "," + y + " has neighbor at " + xx + "," + yy + "\n"); //Debug
              }
            }
          }
        }
      }

      //MODAL GAME OF LIFE RULES

      if ( (neighbors > 0) && (neighbors != neighborhood) ) {        // Rule 1
        cells[x][y] = 1;
      } else if ( (neighbors > 0) && (neighbors == neighborhood) ) { // Rule 2
        cells[x][y] = 0;
      } else if ( (cellsBuffer[x][y] == 0) && (neighbors == 0) ) {   // Rule 3
        cells[x][y] = 0;
      } else if ( (cellsBuffer[x][y] == 1) && (neighbors == 0) ) {   // Rule 4
        cells[x][y] = 1; // 4a = 1, 4b = 0
      } else { // DEBUG - Should never happen. Flash red and print info if it does.
        // print ("Error at " + x + "," + y + "\n");
        // print ("Self = " + cellsBuffer[x][y] + "\n");
        // print ("Neighborhood = " + neighborhood + "\n");
        // print ("Neighbors = " + neighbors + "\n");
        // print ("---------------------------\n");
        //background(255, 0, 0); // With other draw calls, a red flash is observed
   
      }

      // ORIGINAL GAME OF LIFE RULES
      /*
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
        if (neighbors < 2 || neighbors > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbors
        }
      } else { // The cell is dead: make it live if necessary      
        if (neighbors == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbors
        }
      }
      */
      
      
    }
  }
  
  // Increment generation counter
  generation++;
} 

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x = 0; x < width / cellSize; x++) {
      for (int y = 0; y < height/ cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
    generation = 1; // Reset generation counter
  }
  
  if (key == ' ') { // On/off of pause
    pause = !pause;
  }
  
  if (key == 'c' || key == 'C') { // Clear all
    for (int x = 0; x < width / cellSize; x++) {
      for (int y = 0; y < height / cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
    generation = 1; // Reset generation counter
  }
  
  if (key == 'n' || key == 'N') { // Iterate one step (next gneration)
    iteration();
    redraw();
  }
  
  if (key == 'g' || key == 'G') {
   generationCounter = !generationCounter; 
  }
  
}