//
//  SZCreateAccountSuccessViewController.h
//  Skillz
//
//  Created by Julia Roggatz on 23.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

/** This class represents the view controller that is displayed when a user successfully created an account.
 */
@interface SZCreateAccountSuccessVC : SZViewController

/** Initializes an SZCreateAccountSuccessVC with the PFUser object that has just been created.
 @param user The PFUser object that has just been created
 */
- (id)initWithUser:(PFUser*)user;

@end
