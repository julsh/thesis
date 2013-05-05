//
//  SZNewEntryStep3VC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStepVC.h"
#import "SZForm.h"
#import "SZSegmentedControlVertical.h"

/**
 This class represents the third step of creating or editing an entry. Asks the user to specify details about the entry's location.
 */
@interface SZNewEntryStep3VC : SZStepVC <SZSegmentedControlVerticalDelegate, SZFormDelegate>

@end
