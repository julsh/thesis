//
//  SZRootVC.m
//  Skillz
//
//  Created by Julia Roggatz on 22.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSectionRootVC.h"

@interface SZSectionRootVC ()

@end

@implementation SZSectionRootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(toggleMenu:)];
	[self.navigationItem setLeftBarButtonItem:menuButton];
	[self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
}

@end
