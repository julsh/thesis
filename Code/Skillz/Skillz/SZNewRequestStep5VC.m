//
//  SZNewRequestStep5VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep5VC.h"

@interface SZNewRequestStep5VC ()

@end

@implementation SZNewRequestStep5VC

- (id)init
{
    return [super initWithStepNumber:5 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setTitle:@"Post a Request"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)continue:(id)sender {
	NSLog(@"final vc");
}

@end
