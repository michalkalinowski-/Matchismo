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

// TODO: take string formatting duty to the new method
// and change it into attributed string with nice big font for score and small
// one for details. Add awesome colors as well.
- (void)updateUI {
    NSString *displayText = @"";
    // setting sorting selector
    SEL sortSelector = @selector(compareScores:);
    // formating date nicely
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    // build a nice long string of results
    for (GameResult *r in [[GameResult allGameResults]sortedArrayUsingSelector:sortSelector]) {
        displayText = [displayText stringByAppendingFormat:@"%d\n(%@)\n", r.score,
                       [formatter stringFromDate:r.start]];
    }
    self.dispay.text = displayText;
    
}


# pragma mark - Setup Code
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
