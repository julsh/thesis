//
//  SZSortMenuVC.h
//  Skillz
//
//  Created by Julia Roggatz on 18.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSortFilterMenu.h"
#import "SZSegmentedControlVertical.h"
#import "SZForm.h"

/**
 This class represents an additonal menu to sort search results.
 */
@interface SZSortMenuVC : SZSortFilterMenu <SZSegmentedControlVerticalDelegate, SZFormDelegate>

@end
