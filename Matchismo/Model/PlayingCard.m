//
//  PlayingCard.m
//  Matchismo
//
//  Created by Michal Kalinowski on 4/18/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)description {
    return self.contents;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    for (PlayingCard *card in otherCards) {
        if ([card.suit isEqualToString:self.suit]) {
            score += 1;
        }
        else if (card.rank == self.rank) {
            score += 4;
        }
        // no match
        else if (card.rank != self.rank && ![card.suit isEqualToString:self.suit]) {
            score = 0;
            break;
        }
    }
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

// providing setter AND getter for suit property
@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

// class methods
+ (NSArray *)validSuits {
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7",
             @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count -1; // Can invoke rankStrings using self
                                        // because class methods can access other
                                        // class methods :)
}

@end
