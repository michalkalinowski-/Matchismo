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
@property (nonatomic) int score;
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

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

// Brains of the game
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = self.cards[index];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.unplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}


@end
