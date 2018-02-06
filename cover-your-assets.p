DEFINE FRAME frGamePrompts.
DEFINE FRAME frPlayerCards.

DEFINE VARIABLE loGameLoop       AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE VARIABLE loDiscardAndDraw AS LOGICAL NO-UNDO.
DEFINE VARIABLE inDiscardCard    AS INTEGER NO-UNDO.
DEFINE VARIABLE loPickUpLayDown  AS LOGICAL NO-UNDO.
DEFINE VARIABLE inMatchCard      AS INTEGER NO-UNDO.
DEFINE VARIABLE loMatch          AS LOGICAL NO-UNDO.
DEFINE VARIABLE loCheckMatch     AS LOGICAL NO-UNDO.

{cya-include.i}

RUN p-CreateCards(INPUT 5000,  INPUT chFivers).
RUN p-CreateCards(INPUT 10000, INPUT chTenners).
RUN p-CreateCards(INPUT 15000, INPUT chFifteeners).
RUN p-CreateCards(INPUT 20000, INPUT chHome).
RUN p-CreateCards(INPUT 25000, INPUT chSilver).
RUN p-CreateCards(INPUT 50000, INPUT chGold).

RUN p-ShuffleDeck.



UPDATE inNumPlayers LABEL "How many are playing?" WITH FRAME frGamePrompts.
IF inNumPlayers <= 0 THEN DO:
    MESSAGE "Not enough players." VIEW-AS ALERT-BOX.
    QUIT.
END.
/* More than 8 and I believe we should increase cards in the deck */
ELSE IF inNumPlayers > 8 THEN DO:
    MESSAGE "Current players limit is 8. Setting to 8" VIEW-AS ALERT-BOX.
    ASSIGN inNumPlayers = 8.
END.
DO itx = 1 TO inNumPlayers:
    CREATE tt-player.
    ASSIGN tt-player.player-id = itx.
    UPDATE tt-player.player-name LABEL "What should we call you?" WITH FRAME frGamePrompts.
END.


RUN p-DealHand.

DO WHILE loGameLoop:
    
    DO itx = 1 TO inNumPlayers:
        FIND tt-player WHERE tt-player.player-id = itx.
        DISPLAY tt-player.player-name
                tt-player.player-hand WITH FRAME frPlayerCards.       
        
        /* For action Discard and Draw */
        UPDATE loDiscardAndDraw LABEL "Discard and Draw?" WITH FRAME frGamePrompts.
        DO WHILE loDiscardAndDraw:
            
            UPDATE inDiscardCard    LABEL "Which card to discard? (1-4)".            
            
            RUN p-Discard(INPUT tt-player.player-name,
                          INPUT inDiscardCard).                        
                          
            RUN p-DrawCard(INPUT tt-player.player-name,
                           INPUT "Deck",
                           INPUT inDiscardCard).                          
            
            DISPLAY tt-player.player-hand WITH FRAME frPlayerCards.
            UPDATE loDiscardAndDraw LABEL "Discard and Draw?" WITH FRAME frGamePrompts.                                                                        
        END.       
        DISPLAY tt-player.player-hand WITH FRAME frPlayerCards.   

        /* For action Pickup and Laydown Stack */
        UPDATE loPickUpLayDown LABEL "Pickup from discard?" WITH FRAME frGamePrompts.
        DO WHILE loPickUpLayDown:
            
            UPDATE inMatchCard     LABEL "Which card to match?".
            RUN p-PickupAndLayDown(INPUT tt-player.player-name,
                                   INPUT inMatchCard).
            DISPLAY tt-player.player-hand WITH FRAME frPlayerCards.
            FOR EACH tt-stack WHERE tt-stack.player-id = tt-player.player-name:
                DISPLAY tt-stack.stack-num
                        tt-stack.stack-contents.
            END.                
            UPDATE loPickUpLayDown LABEL "Pickup from discard?" WITH FRAME frGamePrompts.        
        END.   
        
        /* For action check matches in hand */
        UPDATE loCheckMatch LABEL "Check for matches in hand?" WITH FRAM frGamePrompts.
        DO WHILE loCheckMatch:
            
            RUN p-MatchCards(INPUT tt-player.player-name,
                         OUTPUT loMatch). 
            IF loMatch THEN  MESSAGE "You Matched!" VIEW-AS ALERT-BOX.
            ELSE MESSAGE "No Match!" VIEW-AS ALERT-BOX.
            
            /* Get out of the loop... */
            ASSIGN loCheckMatch = FALSE.
            
        END.            
        
                 
              
    END.        
    
    loGameLoop = FALSE.
    
END.    

