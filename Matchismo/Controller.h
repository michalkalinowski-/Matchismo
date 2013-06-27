//
//  Controller.h
//  Matchismo
//
//  Created by Michal Kalinowski on 6/6/13.
//  Copyright (c) 2013 Galaxis Ahoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardMatchingGame.h"

@interface Controller : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end
