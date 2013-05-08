//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Michal Kalinowski on 4/18/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"card.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];        
        if ((cardButton.selected = card.isFaceUp)) {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        else {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        }
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"FLIPS: %d", self.flipCount];
}

// Segmented Control Action: Change game mode (match 2 or 3 cards)
- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.game.mode = 2;
    }
    else {
        self.game.mode = 3;
    }
    // not sure why simple ? : doesnt work here?!
}

// Deal Button Action, reset the score and redial the cards
- (IBAction)resetGame:(UIButton *)sender {
    NSInteger mode = self.game.mode;
    self.game = nil; // Make sure I'm not leaking memory here
    self.flipCount = 0;
    self.game.mode = mode; // Restore game mode as it is the only
                          // game property that is retained
    self.modeControl.enabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.modeControl.enabled = NO; // Disable mode selection once game has started
    [self updateUI];
    
    NSString *gameStatus = self.game.gameStatus; // Careful! getting status resets the string!
    if (gameStatus) NSLog(@"%@", gameStatus);
    // NSLog(@"flips updated to %d", self.flipCount);
}

@end
