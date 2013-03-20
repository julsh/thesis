//
//  SZTestNC.m
//  Skillz
//
//  Created by Julia Roggatz on 19.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTestNC.h"

@interface SZTestNC ()

@end

@implementation SZTestNC

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
	UIButton* postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[postButton setTitle:@"next!" forState:UIControlStateNormal];
	[postButton setFrame:CGRectMake(10.0, 400.0, 300.0, 40.0)];
	[postButton addTarget:self action:@selector(postThisShit:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:postButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postThisShit:(id)sender {
	//	PFObject *request = [PFObject objectWithClassName:@"Request"];
	//	[request setObject:self.titleField.text forKey:@"title"];
	//	[request setObject:self.descriptionField.text forKey:@"description"];
	//	[request saveInBackground];
	UIViewController* newController = [[UIViewController alloc] init];
	[self pushViewController:newController animated:YES];
}

@end
