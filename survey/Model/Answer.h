//
//  Answer.h
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (strong, nonatomic) NSString *answer;

@property (nonatomic, getter=isSelected) BOOL selected;

- (id)initWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithAnswer:(NSString *)answer;

@end
