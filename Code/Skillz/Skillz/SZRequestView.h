//
//  SZRequestView.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryVO.h"

@interface SZRequestView : UIView

@property (nonatomic, strong) SZEntryVO* request;

- (id)initWithRequest:(SZEntryVO*)request;

@end
