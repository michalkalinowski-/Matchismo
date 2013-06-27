//
//  GameResult.m
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "GameResult.h"

// Class extension
@interface GameResult()
@property (nonatomic, readwrite) NSDate *start;
@property (nonatomic, readwrite) NSDate *end;
@end

@implementation GameResult
{/*make first pragma mark section appear workaround */}
# pragma mark - Constructors
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

# pragma mark - Getters + Setters
- (NSTimeInterval)duration {
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score {
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

# pragma mark - Compare methods
- (NSComparisonResult)compareScores:(GameResult *)otherResult {
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    }
    else if (self.score == otherResult.score) {
        return NSOrderedSame;
    }
    else {
        return NSOrderedDescending;
    }
}

# pragma mark - Utilities
// Defines
#define ALL_RESULTS_KEY @"AllGameResult"
#define NUM_HIGH_SCORES 5

// Write last score to NSUserDefaults
// Need to convert game result to property list before writting it down
// Game Score is identified by unique start time -> that is it's dictionary key
- (void)synchronize {
    // Get previously synchronized data.
    NSMutableDictionary *mutableGameResults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResults) mutableGameResults = [[NSMutableDictionary alloc] init];
    
    // Check if my result makes it to top scores
    NSString *lastScoreKey = [[mutableGameResults keysSortedByValueUsingComparator:^(id r1, id r2) {
        int score1 = [r1[SCORE_KEY] intValue];
        int score2 = [r2[SCORE_KEY] intValue];
        if (score1 > score2) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedDescending;
        }
    }] lastObject];

    // TODO: revise this block, maybe there's no need to touch NSUserDefaults every time
    // since it's not an efficient operation
    if ([mutableGameResults count] < NUM_HIGH_SCORES) {
        mutableGameResults[[self.start description]] = [self asPropertyList];
    }
    else if ([mutableGameResults count] >= NUM_HIGH_SCORES &&
             self.score > [mutableGameResults[lastScoreKey][SCORE_KEY] intValue])
    {
        mutableGameResults[[self.start description]] = [self asPropertyList];
        [mutableGameResults removeObjectForKey:lastScoreKey];
    }


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
