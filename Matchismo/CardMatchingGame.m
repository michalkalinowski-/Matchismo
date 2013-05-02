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
// Lazy Instatiations
///

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
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

// Method below needs REFACTORING
// Brains of the game
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = self.cards[index];
    // Another way of doing this would be to keep another array with all the cards
    // that have already been flipped up and just match them if array is not empty
    if (!card.isUnplayable && !card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.unplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.gameStatus = [NSString stringWithFormat:@"Matched %@ & %@ for %d points.",card.contents, otherCard.contents, matchScore];
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.gameStatus = [NSString stringWithFormat:@"%@ & %@ don't match! %d points of penalty",card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
    else {
        self.gameStatus = [NSString stringWithFormat:@"Flipped %@", card.contents];
    }
    card.faceUp = !card.isFaceUp;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSString *)modelStatus {
    return Nil;
}


@end
