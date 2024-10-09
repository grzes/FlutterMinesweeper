# blocminesweeper

Minesweeper in Flutter, mostly generated through a leading LLM chatbot using the following prompts:
I mostly just copy pasted code, sometimes fixing errors flagged by the editor, and if the app didn't work
I just described what's wrong, sometimes pasting back the relevant code that I thought needed fixing.

1. Write an implementation in flutter for the classic game minesweeper. Use bloc for state management.

(here lost the original prompt and repasted all generated code)

2. I have a flutter minesweeper scaffold you made for me:
main.dart:
(...)
but it seems the game state doesn't work as I can always reveal all cells and there's never any mines


3. great, but this only reveals a single cell, how to change it so when you hit a blank space it also reveals neighbouring blank spaces?

4. null is flagged here that its not a cellbloc in:
        CellBloc? neighborBloc = allCells.firstWhere(
        (cell) => cell._cellState.x == neighborX && cell._cellState.y == neighborY,
        orElse: () => null);

5. give me a replacement for:
          if (neighborBloc != null && !neighborBloc._cellState.isRevealed) {
            neighborBloc.revealCell(allCells);  // Recursively reveal neighbors
          }

when usiing the dummy
CellBloc? neighborBloc = allCells.firstWhere(
  (cell) => cell._cellState.x == neighborX && cell._cellState.y == neighborY,
  orElse: () => CellBloc(CellState(neighborX, neighborY, hasMine: false)) // Dummy default CellBloc, adjust accordingly
);

6. now in the widget code this flags as an error:
bloc.revealCell(cellCollectionBloc.cellsStream.value);

7. can we add a topbar that along with the name of the app shows a button to restart the game?


8. on a previous project I had a restart done like this:
context.read<GameCubit>().initializeGame();

can we do something similar?
I'd rather keep my widgets stateless


(here it gave me a solution, which I messed up (ignored an Expanded() widget, which broke it's solution and I proceeded to grill it on fixing it)


9. This doesn't work, I tried to isolate what the problem is and simply wrapping the streambuilder with a Column widget with no other changes breaks the game (the grid is no longer rendered)

10. Try again, there's no expanded widget, just added:
    return Column(
      children: [
        StreamBuilder<List<CellBloc>>(
    ...
instead of return StreamBuilder...
there's also no changes to the CellCollectionBloc yet.

11. Hang on, again simply adding Column around StreamBuilder breaks the game! it no longer displays anything, we need to fix this before moving on

12. Found a solution on stackoverflow:
Wrap Streambuilder with Flexible(),then wrap Flexible with Column()
do you know why this works and what the problem was?

13. ok, so with the way it is now, the restart button adds an additional grid below the first one.


14. no, I want a stateless widget, and manage the state with Bloc. So I want the bloc to somehow rebuild and have that reflected in my stateless widget!


(this is the first point where I felt having any flutter knowledge helped me guide the chatbot in a better direction instead of blindly following it's ideas)


15. Let's backout for a second, originally you suggested using blocprovider's create method, however I don't have that because my blocprovider is an implementation provided by you. I have flutter_bloc in my pubspec.yaml. perhaps I need another package with a "standard" BlocProvider that does include the create method?

16. ok trying to use the standard BlocProvider from the flutter_bloc package, but I'm getting:
Couldn't infer type parameter 'T'.

17. This is the current implementation, how exactly to I rework it into a cubit, and do I need to change anything else in the app?
class CellCollectionBloc {
    (...)

18. ok , now that we have a cubit for the cell list, and the initializegame in theory emits the state, but still nothing changes on refresh()

19. This is my main widget:
(...)
there's a bloc builder there but it doesn't refresh when the button calls initializeGame, can I put a debug log somewhere or a popup to verify the blocbuilder rebuilds the grid?

20. oh it's because I'm getting this exception:
The following ProviderNotFoundException was thrown while handling a gesture:
Error: Could not find the correct Provider<CellCollectionBloc> above this MyApp Widget

(this is the second time I felt like I actually know how to fix it, but despite my hints the chatbot insisted it's version should just work)


21. I'm getting an exception when pressing the refresh button, because the context var is actually from "above" the blocprovider?
should we have a blocbuilder in between the bloc provider and the button reading the context?

22. no that doesn't work, can you as a courtesy give me a version with a blocbuilder directly nested under blocprovider

23. yep that worked, I'd like to add win and loss detection. Loss when you reveal a mine, a game over popup, and if all cells are revealed or marked (correctly) a win popup

(here it gave me some code that couldn't work, because it assumed I can access the context from within the cell collection cubit)

24. I added bool methods to determine when to show win loss dialogs, how do I implement them in my widget onTap and onLongTap instead?

25. I have this win condition check:
(...)
but actually this returns true when there's still one unrevealed and unmarked cell left?


(now I tried to get it to make it look more like the classic minesweeper)

26. Let's focus on the widgets and make them "tighter" instead of expanding each cell? more like the classic window minesweeper? Can we also give the hidden cells a beveled edge?

27. can we make the grid look like this?
https://minesweeper.online/img/homepage/intermediate.png

28. The grid still fills the whole browser window instead of showing a smaller grid with fixed grid cell size, also there are no beveled edges on the unrevealed tiles

29. The grid is still dependent on my browser window size I want the cells to be fixed size (20x20)? and centered or scrolled depending on the browser window size

30. The grid still stretches with the app window... :/
