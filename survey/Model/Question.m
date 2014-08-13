//
//  Question.m
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        self.question = [dict objectForKey:@"question"];
        
        self.type = QuestionTypeDefault;
        
        if ([dict[@"type"] isEqualToString:@"multiple"]){
            self.type = QuestionTypeMultipleSelection;
        }

        
        NSArray* rawArray_answers = [dict objectForKey:@"answers"];
        NSMutableArray* array_answers = [NSMutableArray arrayWithCapacity:[rawArray_answers count]];
        for (NSDictionary* sub_answers in rawArray_answers)
        {
            Answer* item = [[Answer alloc] initWithDictionary:sub_answers];
            [array_answers addObject:item];
        }
        self.answers = array_answers;
        
    }
    return self;
}

- (instancetype)initWithQuestion:(NSString *)question
                        withType:(QuestionType) quetionType
{
    self = [super init];
    
    if (self) {
        
        self.question = question;
        self.type = quetionType;
    }
    
    return self;
}


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

- (void)addAnswer:(NSString *)answer
{
    
    [self.answers addObject:[[Answer alloc] initWithAnswer:answer]];
}


+ (NSArray *)typeStrings{
    
    return @[@"Single", @"Multiple", @"Default"];
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
    
    //单选问题不取消已经选中的选项
    if(self.type == QuestionTypeSingleSelection && selected == NO){
        
        return;
    }


    //若问题单选，且设置为选中，则先把所有答案设为没有选中
    if(self.type == QuestionTypeSingleSelection && selected == YES){
        
        for (Answer *answer in self.answers){
            answer.selected = NO;
        }
    }
    
    //设置选择标志
    [self getAnswerAt:index].selected = selected;
    
}
/*
当选择某个答案时，返回需要设置的变化了，二维数组，第一行是需要设置选中的行号，第二行是需要设置取消的行号

选择的行         单选题                          多选题
已经选择的       无变化                           该行取消
未选择的         该行选中，原先选中的行取消          该行选中
 */
- (NSArray *)getNeedSelectAnswersWhenSelectedAt:(NSInteger) index
{
    
    NSMutableArray *needSelect = [[NSMutableArray alloc] init];
    
    Answer *answer = [self getAnswerAt:index];
    
    if (answer.isSelected == NO) {
        [needSelect addObject:[NSNumber numberWithLong:index]];
    }
    return needSelect;
}

- (NSArray *)getNeedCancelSelectAnswersWhenSelectedAt:(NSInteger) index
{
    
    NSMutableArray *needCancelSelect = [[NSMutableArray alloc] init];
    
    Answer *currentAnswer = [self getAnswerAt:index];
    
    if (currentAnswer.isSelected == YES && self.type == QuestionTypeMultipleSelection){
        
        [needCancelSelect addObject:[NSNumber numberWithLong:index]];
        
    }else if (currentAnswer.isSelected == NO && self.type == QuestionTypeSingleSelection){
        
        for(int i=0; i<[self.answers count]; i++){
            
            Answer *answer = [self getAnswerAt:i];
            
            if(answer.isSelected == YES){
                [needCancelSelect addObject:[NSNumber numberWithInt:i]];
                break;
            }
        }
        
    }
    
    return needCancelSelect;
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

- (BOOL) isAnswered
{
    for (Answer *answer in self.answers){
        
        if (answer.isSelected) return YES;
    }
    
    return  NO;
}

- (NSString *)getSelectedAnswers
{
    
    NSString *rtStr = @"";
        
    for (int i=0;i<[self.answers count];i++){
        Answer *answer = [self getAnswerAt:i];
        if (answer.isSelected){
            rtStr = [rtStr stringByAppendingFormat:@",%i", i];
        }
    }
    
    
    if ([rtStr hasPrefix:@","]){
        rtStr = [rtStr substringFromIndex:1];
    }
    
    return rtStr;
    
}


@end
