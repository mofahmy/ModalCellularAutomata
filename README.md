# Modal Cellular Automaton

A Cellular Automaton similar to Conway's Game of Life, with rules based on [modal operators](https://en.wikipedia.org/wiki/Modal_operator).

Modified from original source at [https://processing.org/examples/gameoflife.html](https://processing.org/examples/gameoflife.html)

(Example Animations)[https://github.com/mofahmy/ModalCellularAutomaton#example-animations] illustrating some interesting runs can be further down in this README.


## Controls

The `.pde` can be opened, modified, and run with the [Processing IDE](https://processing.org/).

Experimenting with a custom, simple initial generation is recommended to observe more interesting behaviors than seen in a randomly-generated grid. See [Example Animations](#example-animations) for some starters and inspiration. 

| Key | Function | Explanation|
| --- | --- | --- |
| `Spacebar` | Pause | Pauses or unpauses execution.|
| `c` | Clear | Clears the grid.|
| `r` | Random | Instantiates a random configuration on the grid.|
| `g` | Generation | Shows or hides the generation counter.|
| `n` | Next | Iterates one generation forward. Useful for examining behavior when paused.|
| `Mouse Click`| Toggle Cell | Toggles the state of an individual cell (alive / dead). Only usable when paused.|

## Rules

The rules for this CA make use of the mechanics of modal logic, however there is no particular interpretation intended (though that is some interesting food for thought).

### Technical

Each square cell on a 2-dimentional, finite, bounded grid can be thought of as a possible world.

For any given cell *w*, each non-*w* cell in its [Moore Neighborhood](https://en.wikipedia.org/wiki/Moore_neighborhood) is considered accessible. This means each cell can have up to eight accessible neighbors -- cells lying on the edge of the grid will have less -- and the cell is not accessible to itself (the accessibility relation is not reflexive).

At a given time *t*, the state of a cell at *t+1* (in the next generation) can be computed as follows:

![Modal CA Rules](http://imgur.com/HkwD3pu.png)

### English

At each time step, the transition to the next generation happens as follows.

**Rule 1** Any cell (live or dead) with at least one, but not all, live neighbors lives on or becomes a live cell.

**Rule 2** Any cell (live or dead) with all live neighbors dies or remains dead.

**Rule 3** Any dead cell without any live neighbors remains dead.

**Rule 4** Any live cell without any live neighbors lives on.


## Example Animations

Thus far I've found that a small number simple shapes (solitary cells, squares, lines, etc.) produce the most interesting results.

![Animation1](http://imgur.com/tUBkHsP.gif)

![Animation2](http://imgur.com/ab0br79.gif)

![Animation3](http://imgur.com/M044N7A.gif)

![Animation4](http://imgur.com/PfAGsIj.gif)

![Animation5](http://imgur.com/pVGgeZm.gif)
