# Cover-Your-Assets
#### Recreating Grandpa Beck's card game Cover Your Assets in OpenEdge Progress 4GL

##### Game Actions:
- [x] Discard and draw                                  
- [x] Pick-up card from discard pile and make stack
- [x] Match 2 cards in hand <-- need to modify to make stack as well
- [ ] NEW! Work on GUI.  Will be hard to design/test Challenge sequence without proper GUI.
- [ ] Challenge Player
  - challenge and response cadence
  - draw *n* cards after challenge

##### Notes:  
First iteration will just be proof of concept, possible one player game with AI.  Really just want to make sure the logic is there.
Then, add functionality for multiple players to connect.  I'm thinking of creating a DB and making a table for the deck, adding a batch-id field (in leu of current temp-table solution).  Players could connect and reference batch-id of deck table to be in the same game.  Game engine could include queries of deck table to play the game accross multiple computers.

##### Wishlist:
- After 6 players, add additional deck(s).
- Time limit before turn skipped?
