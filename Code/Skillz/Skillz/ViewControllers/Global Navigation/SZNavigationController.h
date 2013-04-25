//
//  SZRootViewController.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZMenuVC.h"

@interface SZNavigationController : UIViewController <SZMenuVCDelegate>

- (id)initWithRootViewController:(UIViewController *)rootViewController;

@end
