//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *dispay;
@end

@implementation GameResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    NSString *displayText = @"";
    for (GameResult *r in [GameResult allGameResults]) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", r.score, r.start, round(r.duration)];
    }
    self.dispay.text = displayText;
    
}

// Setup Code
- (void)setup {
    // Initialization that can not wait till viewDidLoad
}
- (void)awakeFromNib {
    [self setup];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}
@end
