//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Michal Kalinowski on 6/3/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "GameResultViewController.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *dispay;
@end

@implementation GameResultViewController



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
