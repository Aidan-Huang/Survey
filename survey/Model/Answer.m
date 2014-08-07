//
//  Answer.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%i", self.ansewer, self.isSelected];
}


@end
