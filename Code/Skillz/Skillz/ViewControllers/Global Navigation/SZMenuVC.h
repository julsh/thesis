//
//  SZMenuVC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZMenuVCDelegate;


@interface SZMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

/// The object that acts as the delegate of the receiving left menu.
@property (nonatomic, weak) id <SZMenuVCDelegate> delegate;

/// Singleton
+ (SZMenuVC*)sharedInstance;

- (void)addHiddenMenu:(UIViewController*)vc;
- (void)removeHiddenMenu;
- (void)showHiddenMenu;
- (void)hideHiddenMenu;
	
@end

@protocol SZMenuVCDelegate <NSObject>
- (void)menu:(SZMenuVC*)menu switchToViewControllerWithClassName:(NSString*)className;
@end