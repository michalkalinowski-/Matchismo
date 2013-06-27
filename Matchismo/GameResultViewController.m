//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

// Class extension
@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *dispay;
@end


@implementation GameResultViewController
{/*make first pragma mark section appear workaround */}
# pragma mark - Utilities
- (void)updateUI {
    NSMutableAttributedString * displayText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"HIGH SCORES\n\n"]];
    
    // Is putting dicts below in #def a bad coding style?
    NSDictionary *scoreFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:36]};
    NSDictionary *detailsFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    
    // formating date nicely
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    // build a nice long string of results
    for (GameResult *r in [[GameResult allGameResults]sortedArrayUsingSelector:@selector(compareScores:)]) {
        NSAttributedString *scoreString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n", r.score] attributes:scoreFontAttributes];
        
        NSAttributedString *detailsString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[formatter stringFromDate:r.start]] attributes:detailsFontAttributes];
        
        [displayText appendAttributedString:scoreString];
        [displayText appendAttributedString:detailsString];
    }
    self.dispay.attributedText = displayText;
    
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

// Load all the results
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}
@end
