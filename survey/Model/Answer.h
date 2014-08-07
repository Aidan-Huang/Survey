//
//  Answer.h
//  survey
//
//  Created by Aidan on 8/6/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (strong, nonatomic) NSString *ansewer;

@property (nonatomic, getter=isSelected) BOOL selected;


@end
