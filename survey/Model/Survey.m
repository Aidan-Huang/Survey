//
//  Survey.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Survey.h"

@implementation Survey


- (id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        self.title = [dict objectForKey:@"title"];
        self.details = [dict objectForKey:@"detail"];
        
        NSArray* rawArray_questions = [dict objectForKey:@"questions"];
        NSMutableArray* array_questions = [NSMutableArray arrayWithCapacity:[rawArray_questions count]];
        for (NSDictionary* sub_questions in rawArray_questions)
        {
            Question* item = [[Question alloc] initWithDictionary:sub_questions];
            [array_questions addObject:item];
        }
        self.questions = array_questions;
        
    }
    return self;
}

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

- (NSString *)getSelectedAnswers{
    
    NSString *rtStr = @"";
    
    for (int i=0;i<[self.questions count];i++){
        Question *question = [self getQuestionAt:i];
        
        rtStr = [rtStr stringByAppendingFormat:@";%@",question.getSelectedAnswers];
    }
    
    if ([rtStr hasPrefix:@";"]){
        rtStr = [rtStr substringFromIndex:1];
    }
    
    return rtStr;

}

@end
