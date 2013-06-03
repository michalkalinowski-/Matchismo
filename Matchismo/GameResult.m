//
//  GameResult.m
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (nonatomic, readwrite) NSDate *start;
@property (nonatomic, readwrite) NSDate *end;
@end

@implementation GameResult
// designated initializer
- (id)init {
    self = [super init];
    if (self) {
        _start = [NSDate date]; // returns time right now, werid name, huh?
        _end = _start;          // just to have it always initialized 
        
    }
    return self;
}

// convenience initializer
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

- (id)initFromPropertyList:(id)plist {
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end || !_score) self = nil;
        }
    }
    return self;
}

- (NSTimeInterval)duration {
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score {
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

// Write last score to NSUserDefaults
// Need to convert game result to property list before writting it down
// Game Score is identified by unique start time -> that is it's dictionary key
#define ALL_RESULTS_KEY @"AllGameResult"
 
- (void)synchronize {
    NSMutableDictionary *mutableGameResults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResults) mutableGameResults = [[NSMutableDictionary alloc] init];
    mutableGameResults[[self.start description]] = [self asPropertyList]; // NSDate can't be dictionary key, strings can
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize]; // write it down
    
}

- (id)asPropertyList {
    return @{START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score)};
}

+ (NSArray *)allGameResults {
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

@end
