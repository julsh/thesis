//
//  SZUserPhotoView.h
//  Skillz
//
//  Created by Julia Roggatz on 06.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SZUserPhotoViewSizeSmall,
	SZUserPhotoViewSizeMedium,
	SZUserPhotoViewSizeLarge
} SZUserPhotoViewSize;

/**
 This class represents a user photo with a photo frame around it. It can be instanciated in different sizes and offers the flexibility of assigning the actual image data later. As long as no photo is explicitly assigned to the SZUserPhotoView, it will display a placeholder image within the frame instead of an actual photo.
 */

@interface SZUserPhotoView : UIView

/** 
 The photo of the user that the `SZUserPhotoView` is showing.
 */
@property (nonatomic, strong) UIImage* photo;

/**
 Creates an instance of `SZUserPhotoView` that displays a placeholder image. This is used if the actual image should be set manually at a later time, or if there is no user photo available.
 @param size The desired size of the `SZUserPhotoView`. Uses the `SZUserPhotoViewSize` enumerator. Allowed values are:
 
 - `SZUserPhotoViewSizeSmall`
 - `SZUserPhotoViewSizeMedium`
 - `SZUserPhotoViewSizeLarge`
 
 @return An instance of `SZUserPhotoView`
 */
+ (SZUserPhotoView*)emptyUserPhotoViewWithSize:(SZUserPhotoViewSize)size;

/**
 Creates an instance of `SZUserPhotoView` that first displays a placeholder image, fetches the image data in the background and sets the correct image as soon the image data was successfully downloaded.
 @param size The desired size of the `SZUserPhotoView`. Uses the `SZUserPhotoViewSize` enumerator. Allowed values are:
 
 - `SZUserPhotoViewSizeSmall`
 - `SZUserPhotoViewSizeMedium`
 - `SZUserPhotoViewSizeLarge`
 
 @param file A reference to the file property that needs to be fetched
 @return An instance of `SZUserPhotoView`
 */
+ (SZUserPhotoView*)userPhotoViewWithSize:(SZUserPhotoViewSize)size fileReference:(PFFile*)file;

/**
 Creates an instance of `SZUserPhotoView` that displayes a user photo. This is used if the user photo object already exisits and doesn't need to be explicitly fetched.
 @param size The desired size of the `SZUserPhotoView`. Uses the `SZUserPhotoViewSize` enumerator. Allowed values are:
 
 - `SZUserPhotoViewSizeSmall`
 - `SZUserPhotoViewSizeMedium`
 - `SZUserPhotoViewSizeLarge`
 
 @param photo A `UIImage` object of the user photo
 @return An instance of `SZUserPhotoView`
 */
+ (SZUserPhotoView*)userPhotoViewWithSize:(SZUserPhotoViewSize)size photo:(UIImage*)photo;

@end
