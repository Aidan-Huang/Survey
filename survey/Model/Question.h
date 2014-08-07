//
//  Question.h
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QUESTION_TYPE_SINGLE    0
#define QUESTION_TYPE_MULTIPLE  1

@interface Question : NSObject

@property (strong, nonatomic) NSString *question;

@property (strong, nonatomic) NSMutableArray *answers;

@property (nonatomic) NSInteger type;

+ (NSArray *)typeStrings;

- (Answer *)getAnswerAt:(NSInteger) index;

- (void)selectAnswerAt:(NSInteger) index;
- (void)cancelSelectAnswerAt:(NSInteger) index;
- (void)changAnswerAt:(NSInteger) index;

@end
