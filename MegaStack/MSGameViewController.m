//
//  MSGameViewController.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSGameViewController.h"

@interface MSGameViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameboardView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) MSMegaStackGamebrain *gamebrain;


@end

@implementation MSGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self setNeedsStatusBarAppearanceUpdate];
    
    MSMegaStackGameboard *gameboard = [[MSMegaStackGameboard alloc]initWithFrame:self.gameboardView.frame rows:16 columns:12 gameboardColor:[UIColor grayColor]];
    [self.view addSubview:gameboard];
    _gamebrain = [[MSMegaStackGamebrain alloc] initWithGameboard:gameboard gameMode:MSGameModeCrazy];
    _gamebrain.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gameStartButtonPressed:(id)sender {
    [self.gamebrain startGame];
}

- (IBAction)resetButtonPressed:(id)sender {
    [self.gamebrain resetGame];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)scoreDidUpdate:(NSInteger)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", (int)score];
}

@end
