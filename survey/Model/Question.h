//
//  Question.h
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, QuestionType) {
    QuestionTypeSingleSelection,
    QuestionTypeMultipleSelection,
    QuestionTypeDefault = QuestionTypeSingleSelection
};


@interface Question : NSObject

@property (strong, nonatomic) NSString *question;

@property (strong, nonatomic) NSMutableArray *answers;

@property (nonatomic) QuestionType type;

+ (NSArray *)typeStrings;

- (Answer *)getAnswerAt:(NSInteger) index;

- (BOOL) isAnswered;
- (NSString *)getSelectedAnswers;

- (void)selectAnswerAt:(NSInteger) index;
- (void)cancelSelectAnswerAt:(NSInteger) index;
- (void)changAnswerAt:(NSInteger) index;

- (NSArray *)getNeedSelectAnswersWhenSelectedAt:(NSInteger) index;
- (NSArray *)getNeedCancelSelectAnswersWhenSelectedAt:(NSInteger) index;

- (instancetype)initWithQuestion:(NSString *)question
                        withType:(QuestionType) quetionType;

- (void)addAnswer:(NSString *)answer;

@end
