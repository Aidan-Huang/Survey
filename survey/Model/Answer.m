//
//  Answer.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        self.answer = [dict objectForKey:@"answer"];
    }
    return self;
}

- (instancetype)initWithAnswer:(NSString *)answer
{
    self = [super init];
    
    if (self) {
        
        self.answer = answer;
    }
    
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%i", self.answer, self.isSelected];
}


@end
