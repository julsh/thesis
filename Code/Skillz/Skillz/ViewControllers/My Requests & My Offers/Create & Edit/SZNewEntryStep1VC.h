//
//  SZNewEntryStep1VC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStepVC.h"
#import "SZForm.h"

@interface SZNewEntryStep1VC : SZStepVC <SZFormDelegate>

- (id)initWithEntry:(SZEntryVO*)entry;

@end
