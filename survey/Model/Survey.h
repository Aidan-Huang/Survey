//
//  Survey.h
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface Survey : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;

@property (strong, nonatomic) NSMutableArray *questions;
@property (nonatomic, getter=isEnable) BOOL enable;


- (instancetype)initWithTitle:(NSString *)title;

- (Question *) getQuestionAt:(NSInteger) index;


@end
