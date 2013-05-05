//
//  SZStartScreenVC.h
//  Skillz
//
//  Created by Julia Roggatz on 26.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class represents the view controller that is displayed upon application launch when the user is already signed in. User sessions will be cached on the device, so after logging in users will remain logged in "forever" until they specifically log out.
 */
@interface SZStartScreenVC : SZViewController <UITableViewDelegate, UITableViewDataSource>

@end
