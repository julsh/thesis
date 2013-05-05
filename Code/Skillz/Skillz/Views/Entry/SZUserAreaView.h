//
//  SZUserAreaView.h
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class takes care of displaying and laying out the user area view that is displayed within an <SZEntryView>. It will display the user's photo (using the <SZUserPhotoView> class), the user's name and and the user's average review rating (using the <SZStarsView> class) 
 */
@interface SZUserAreaView : UIView

/**
 Initializes the `SZUserAreaView` with a given user
 @param user The `PFUser` object representing the user.
 @param hasTimeFrameView Indicates whether or not the corresponding <SZEntryView> displays an <SZTimeFrameView>. Layout of the user photo will be slightle different depending on whether or not there is a time frame view.
 @return An instance of `SZUserAreaView`
 */
- (id)initWithUser:(PFUser*)user hasTimeFrameView:(BOOL)hasTimeFrameView;

@end
