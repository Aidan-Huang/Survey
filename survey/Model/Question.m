//
//  Question.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Question.h"

@implementation Question

- (NSString *)description
{
    
    NSString *str = [NSString stringWithFormat:@"%@  type:%@", self.question, [Question typeStrings][self.type]];

    
    for (Answer *answer in self.answers){
        
        str = [str stringByAppendingFormat:@"\n%@",answer];
    }
    
    return str;
    
}

- (Answer *)getAnswerAt:(NSInteger) index
{
    return (Answer *)self.answers[index];
}


+ (NSArray *)typeStrings{
    
    return @[@"SingleSelect", @"MultiSelect"];
}

- (NSMutableArray *)answers{
    if (!_answers) {
        _answers = [[NSMutableArray alloc] init];
    }
    return _answers;
}

- (void)setAnswerSelectedAt:(NSInteger) index :(BOOL) selected
{
    //越界检查
    if(index > [self.answers count] - 1){
        return;
    }

    //若问题单选，且设置为选中，则先把所有答案设为没有选中
    if(self.type == QUESTION_TYPE_SINGLE && selected == YES){
        
        for (Answer *answer in self.answers){
            answer.selected = NO;
        }
    }
    
    //设置选择标志
    [self getAnswerAt:index].selected = selected;
    
}

- (void)selectAnswerAt:(NSInteger) index
{
    [self setAnswerSelectedAt:index :YES];
}

- (void)cancelSelectAnswerAt:(NSInteger) index
{
    [self setAnswerSelectedAt:index :NO];
}

- (void)changAnswerAt:(NSInteger) index
{
    Answer *answer = [self getAnswerAt:index];
    
    [self setAnswerSelectedAt:index :!answer.isSelected];
}


@end
