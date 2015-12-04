//
//  enums.h
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#ifndef FAUIKit_enums_h
#define FAUIKit_enums_h

typedef NS_ENUM(NSInteger, FAContainerViewTransition) {
    FAContainerViewTransitionFlipHorizontal =  (1 << 0),
    FAContainerViewTransitionFlipVertical =  (1 << 1),
    FAContainerViewTransitionCrossDisolve =  (1 << 2),
    FAContainerViewTransitionSlide =  (1 << 3)
};


#endif
