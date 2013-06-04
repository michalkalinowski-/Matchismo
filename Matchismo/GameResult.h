//
//  GameResult.h
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // array of gameResults

@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic) int score;

// Take other result and compare scores
// Return NSComparisionResult rather than BOOL because
// it will be used for sorting arrays (as selector)
- (NSComparisonResult)compareScores:(GameResult *)otherResult;
@end
