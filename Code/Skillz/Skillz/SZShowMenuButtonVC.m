//
//  SZRootVC.m
//  Skillz
//
//  Created by Julia Roggatz on 22.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZShowMenuButtonVC.h"

@interface SZShowMenuButtonVC ()

@end

@implementation SZShowMenuButtonVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(showMenu:)];
	[self.navigationItem setLeftBarButtonItem:menuButton];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
}

@end
