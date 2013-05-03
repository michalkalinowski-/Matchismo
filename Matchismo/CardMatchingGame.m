//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Michal Kalinowski on 4/29/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "CardMatchingGame.h"


// Class extension
@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // array of Card objects
@property (nonatomic, readwrite) NSString *gameStatus;
@property (nonatomic, readwrite) int score;
@end

// Implementation
// TODO: message returning status of the game after action 
// so that it can be logged or displayed in a fancy blending
// letters animation
@implementation CardMatchingGame

///
// Lazy Instatiations + Getters
///

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSString *)gameStatus {
    NSString *p = [_gameStatus copy];
    _gameStatus = @"";
    return p;
}

///
// Methods
///

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        for (int i=0; i<cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card)
                self = nil;
            else
                self.cards[i] = card;
        }
    }
    return self;
}

- (NSArray *)flippedCards {
    NSMutableArray *fCards= [[NSMutableArray alloc]init];
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [fCards addObject:card];
        }
    }
    return fCards;
}

// Make a set of cards unplayable
- (void)makeCardsUnplayable:(NSArray *)cards {
    for (Card *card in cards) {
        card.unplayable = YES;
    }
}

// Flip a set of cards up or down
- (void)flipCards:(NSArray *)cards Up:(BOOL)up {
    for (Card *card in cards) {
        card.faceUp = up;
    }
}

// Method below needs REFACTORING
// Brains of the game
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = self.cards[index];
    NSArray *flippedCards = [self flippedCards];
    
    // turning card face up and there are other cards to check match
    if (!card.isFaceUp) {
        if (flippedCards.count != 0) {
            int matchScore = [card match:flippedCards];
            // cards match
            if (matchScore) {
                [self makeCardsUnplayable:flippedCards];
                card.unplayable = YES;
                self.score += matchScore * MATCH_BONUS;
                self.gameStatus = [NSString stringWithFormat:@"Matched %@ & %@ for %d points.",card.contents, [flippedCards componentsJoinedByString:@", "], matchScore * MATCH_BONUS];
            }
            // no match
            else {
                [self flipCards:flippedCards Up:NO];
                self.score -= MISMATCH_PENALTY;
                self.gameStatus = [NSString stringWithFormat:@"%@ & %@ don't match! %d points of penalty",card.contents, [flippedCards componentsJoinedByString:@", "], MISMATCH_PENALTY];
            }
        }
        card.faceUp = YES;
    }
    
    // allow flip down only if one card is selected
    else if (card.faceUp) {
        if (!flippedCards.count == 0) {
            self.gameStatus = [NSString stringWithFormat:@"Flipped %@", card.contents];
            card.faceUp = NO;
            self.score -= FLIP_COST;
        }
    }
    
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSString *)modelStatus {
    return Nil;
}


@end
