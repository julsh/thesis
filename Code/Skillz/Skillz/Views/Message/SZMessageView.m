//
//  SZMessageView.m
//  Skillz
//
//  Created by Julia Roggatz on 22.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMessageView.h"
#import "SZUserPhotoView.h"
#import "UITextView+Shadow.h"
#import "NSDate+TimeAgo.h"

@implementation SZMessageView

- (id)initWithMessage:(NSDictionary*)message image:(UIImage*)image position:(SZMessageViewPosition)position {
    self = [super init];
    if (self) {
		
		
        SZUserPhotoView* userPhoto = [SZUserPhotoView emptyUserPhotoWithSize:SZUserPhotoViewSizeSmall];
		[userPhoto.photo setImage:image];
		
		UITextView* messageText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 245.0, 10000.0)];
		[messageText setUserInteractionEnabled:NO];
		[messageText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:11.0]];
		[messageText setTextColor:[SZGlobalConstants gray]];
		[messageText applyWhiteShadow];
		[messageText setText:[message valueForKey:@"messageText"]];
		[messageText sizeToFit];
		
		UILabel* timeAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -5.0, 240.0, 12.0)];
		[timeAgoLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBoldItalic size:11.0]];
		[timeAgoLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[timeAgoLabel applyWhiteShadow];
		NSString* timeAgo = [[NSDate dateWithTimeIntervalSince1970:[[message valueForKey:@"timeStamp"] floatValue]] timeAgo];
		NSLog(@"init message timestamp %@, timeAgo: %@", [message valueForKey:@"timeStamp"], timeAgo);
		[timeAgoLabel setText:timeAgo];
		[timeAgoLabel sizeToFit];
		
		UIImage* messageBgImg;
		UIImageView* messageBg;
		
		CGRect frame;
		switch (position) {
			case SZMessageViewPositionLeft:
				
				frame = userPhoto.frame;
				frame.origin.x = 5.0;
				userPhoto.frame = frame;
				
				frame = timeAgoLabel.frame;
				frame.origin.x = 67.0;
				timeAgoLabel.frame = frame;
				
				frame = messageText.frame;
				frame.origin.x = 5.0;
				messageText.frame = frame;
				
				messageBgImg = [[UIImage imageNamed:@"message_bg_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 11.0, 7.0, 8.0)];
				messageBg = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 13.0, 255.0, messageText.frame.size.height)];
				[messageBg setImage:messageBgImg];
				
				break;
				
			case SZMessageViewPositionRight:
				
				frame = userPhoto.frame;
				frame.origin.x = 260.0;
				userPhoto.frame = frame;
				
				frame = timeAgoLabel.frame;
				frame.origin.x = 253.0 - timeAgoLabel.frame.size.width;
				timeAgoLabel.frame = frame;
				
				messageBgImg = [[UIImage imageNamed:@"message_bg_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 8.0, 7.0, 11.0)];
				messageBg = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 13.0, 255.0, messageText.frame.size.height)];
				[messageBg setImage:messageBgImg];
				
				break;
		}
		
		if ([message valueForKey:@"proposedDeal"]) {
			UIImage* dealBgImg = [[UIImage imageNamed:@"message_deal_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
			UIImageView* dealBg = [[UIImageView alloc] initWithFrame:CGRectMake(1.0 + ((position == SZMessageViewPositionLeft) * 5.0), messageBg.frame.size.height - 1.0, messageBg.frame.size.width - 7.0, 28.0)];
			[dealBg setImage:dealBgImg];
			
			CGRect frame = messageBg.frame;
			frame.size.height += 28.0;
			messageBg.frame = frame;
			
			[messageBg addSubview:dealBg];
			
			PFQuery* query = [PFQuery queryWithClassName:@"Deal"];
			[query getObjectInBackgroundWithId:[message valueForKey:@"proposedDeal"] block:^(PFObject *object, NSError *error) {
				if (object) {
					NSNumber* value = [object valueForKey:@"dealValue"];
					NSString* valueString = [NSString stringWithFormat:@"%i", [value intValue]];
					if ([object valueForKey:@"hours"]) {
						NSNumber* hours = [object valueForKey:@"hours"];
						valueString = [valueString stringByAppendingFormat:@" for %i hours", [hours intValue]];
					}
					else {
						valueString = [valueString stringByAppendingString:@" for the job"];
					}
					
					UILabel* proposedDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 4.0, 90.0, 20.0)];
					[proposedDealLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:11.0]];
					[proposedDealLabel setTextColor:[UIColor whiteColor]];
					[proposedDealLabel applyBlackShadow];
					[proposedDealLabel setText:@"Proposed Deal:"];
					
					UIImageView* skillPointsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
					[skillPointsImg setFrame:CGRectMake(97.0, 4.0, skillPointsImg.frame.size.width, skillPointsImg.frame.size.height)];
					
					UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 4.0, 125.0, 20.0)];
					[valueLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:11.0]];
					[valueLabel setTextColor:[UIColor whiteColor]];
					[valueLabel applyBlackShadow];
					[valueLabel setText:valueString];
				
					[dealBg addSubview:proposedDealLabel];
					[dealBg addSubview:skillPointsImg];
					[dealBg addSubview:valueLabel];
				}
			}];
		}
		
		CGFloat viewHeight = MAX(userPhoto.frame.size.height + 15.0, messageBg.frame.size.height + 25.0);
		[self setFrame:CGRectMake(0.0, 0.0, 320.0, viewHeight)];
		
		[messageBg addSubview:messageText];
		[self addSubview:timeAgoLabel];
		[self addSubview:userPhoto];
		[self addSubview:messageBg];
		
    }
    return self;
}


@end
