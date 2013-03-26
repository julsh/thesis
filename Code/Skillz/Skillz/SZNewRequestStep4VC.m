//
//  SZNewRequestStep4VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep4VC.h"
#import "SZNewRequestStep5VC.h"

@interface SZNewRequestStep4VC ()

@end

@implementation SZNewRequestStep4VC

- (id)init
{
    return [super initWithStepNumber:4 totalSteps:5];
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
	SZNewRequestStep5VC* step5 = [[SZNewRequestStep5VC alloc] init];
	[self.navigationController pushViewController:step5 animated:YES];
}

@end
