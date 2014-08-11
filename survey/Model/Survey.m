//
//  Survey.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Survey.h"

@implementation Survey

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        
        self.title = title;
    }
    
    return self;
}
- (void)addQuestion:(NSString *)question withType:(QuestionType) questionType
{
    [self.questions addObject:[[Question alloc] initWithQuestion:question withType:questionType]];
}


- (NSMutableArray *)questions{
    if (!_questions) {
        _questions = [[NSMutableArray alloc] init];
    }
    return _questions;
}

- (NSString *)description
{
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n  Details:%@", self.title, self.details];
    
    
    for (Question *question in self.questions){
        
        str = [str stringByAppendingFormat:@"\n\n%@", question];
    }
    
    return str;
    
}

- (Question *)getQuestionAt:(NSInteger) index
{
    return (Question *)self.questions[index];
}

@end
