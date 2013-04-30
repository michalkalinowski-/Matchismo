//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Michal Kalinowski on 4/29/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"


@interface CardMatchingGame : NSObject
// Desinated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

// Flipping card from deck array
- (void)flipCardAtIndex:(NSUInteger)index;

// Returning card object from deck array
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@end
