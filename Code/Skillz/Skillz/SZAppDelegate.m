//
//  SZAppDelegate.m
//  Skillz
//
//  Created by Julia Roggatz on 19.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZAppDelegate.h"

#import <Parse/Parse.h>

#import "SZNavigationController.h"
#import "SZSignInVC.h"
#import "SZCreateAccountSuccessVC.h"
#import "SZNewEntryStep1VC.h"
#import "SZUtils.h"

@implementation SZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
	
	
	[Parse setApplicationId:@"ltQB4UH8RtuQ84RTJOWg16IfJh0fojlzrYEbwwUr"
				  clientKey:@"Hi4lrAsfSq0iWDi6npeYMlgrmL65l5iWFtoKl5Ef"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		[SZDataManager sharedInstance].currentUser = [SZUserVO userVOfromPFUser:currentUser];
	} else {
		NSLog(@"not logged in!");
	}
	
//	uncomment following line to reset and reload categories from server
//	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"categories"];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] == nil) {
		PFQuery* categoriesQuery = [PFQuery queryWithClassName:@"Category"];
		[categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (!error) {
				NSMutableArray* categoriesArray = [[NSMutableArray alloc] init];
				for (PFObject* object in objects) {
					NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
					[dict setObject:[object objectForKey:@"categoryName"] forKey:@"categoryName"];
					if ([object objectForKey:@"subcategories"]) {
						[dict setObject:[object objectForKey:@"subcategories"] forKey:@"subcategories"];
					}
					[categoriesArray addObject:dict];
				}
				[[NSUserDefaults standardUserDefaults] setObject:categoriesArray forKey:@"categories"];
				NSLog(@"categories set!!");
			} else {
				// Log details of the failure
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
		}];
	}
	
	UIViewController *root = [[SZNavigationController alloc] initWithRootViewController:[[SZSignInVC alloc] init]];
//	UIViewController *root = [[SZNavigationController alloc] initWithRootViewController:[[SZNewRequestStep1VC alloc] init]];
	[self.window setRootViewController:root];
	
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
