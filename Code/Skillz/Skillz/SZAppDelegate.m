//
//  SZAppDelegate.m
//  Skillz
//
//  Created by Julia Roggatz on 19.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZAppDelegate.h"

#import <Parse/Parse.h>
#import "SZEntryObject.h"

#import "SZNavigationController.h"
#import "SZSignInVC.h"
#import "SZCreateAccountSuccessVC.h"
#import "SZNewEntryStep1VC.h"
#import "SZUtils.h"
#import "SZDataManager.h"
#import "SZStartScreenVC.h"

@implementation SZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[SZEntryObject registerSubclass];
	[Parse setApplicationId:@"ltQB4UH8RtuQ84RTJOWg16IfJh0fojlzrYEbwwUr"
				  clientKey:@"Hi4lrAsfSq0iWDi6npeYMlgrmL65l5iWFtoKl5Ef"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

	
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
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
		}];
	}
	
	[[UINavigationBar appearance] setTitleTextAttributes:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
	  UITextAttributeTextColor,
	  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
	  UITextAttributeTextShadowColor,
	  [NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)],
	  UITextAttributeTextShadowOffset,
	  [SZGlobalConstants fontWithFontType:SZFontBold size:18.0],
	  UITextAttributeFont, nil]];
	
	UIViewController* rootVC;
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		// show start screen
		rootVC = [[SZStartScreenVC alloc] init];
	} else {
		// show login screen
		rootVC = [[SZSignInVC alloc] init];
	}
	
	UIViewController *root = [[SZNavigationController alloc] initWithRootViewController:rootVC];
	[self.window setRootViewController:root];
	
	
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
	[currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
	[currentInstallation setObject:[[PFUser currentUser] objectId] forKey:@"userId"];
    [currentInstallation saveInBackground];
	NSLog(@"did register! yay!");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"register failed. aww. %@", error);
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
