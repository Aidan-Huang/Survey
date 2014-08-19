//
//  SurveyViewController.h
//  survey
//
//  Created by Aidan on 8/19/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKExpandTableView.h"
#import "Survey.h"

@interface SurveyViewController : UIViewController
<JKExpandTableViewDelegate, JKExpandTableViewDataSource>

@property(nonatomic,weak) IBOutlet JKExpandTableView * expandTableView;

@property(nonatomic,strong) Survey *survey;

@end
