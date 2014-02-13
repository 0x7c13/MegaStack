//
//  MSGameViewController.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSGameViewController.h"
#import "MSMegaStackGameBoard.h"

@interface MSGameViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameboardView;
@property (strong, nonatomic) MSMegaStackGameboard *gameboard;


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

    _gameboard = [[MSMegaStackGameboard alloc]initWithFrame:self.gameboardView.frame rows:11 columns:7 gameboardColor:[UIColor grayColor]];
    [self.view addSubview:self.gameboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.gameboard drawBlockAtRow:7 column:3 withColor:[UIColor blueColor]];
    [self.gameboard removeBlockAtRow:1 column:1];
    //[self.gameboard removeBlockAtRow:7 column:3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
