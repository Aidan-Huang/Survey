//
//  SurveyViewController.m
//  survey
//
//  Created by Aidan on 8/19/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController ()

@end

@implementation SurveyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.survey = [self getSurveyFromTestData];
    [self initializeSurveyView];
}


- (void) initializeSurveyView {
    
    [self.expandTableView setDataSourceDelegate:self];
    [self.expandTableView setTableViewDelegate:self];
    [self.expandTableView reloadData];
}

#pragma mark - JKExpandTableViewDelegate
// return YES if more than one child under this parent can be selected at the same time.  Otherwise, return NO.
// it is permissible to have a mix of multi-selectables and non-multi-selectables.
- (BOOL) shouldSupportMultipleSelectableChildrenAtParentIndex:(NSInteger) parentIndex {
    
    Question *question = [self.survey getQuestionAt:parentIndex];
    
    if(question.type == QuestionTypeMultipleSelection){
        return YES;
    }
    
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex {
    
    [[self.survey getQuestionAt:parentIndex] selectAnswerAt:childIndex];
    
    NSLog(@"survey: %@", self.survey);
}

- (void) tableView:(UITableView *)tableView didDeselectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex {
    
    [[self.survey getQuestionAt:parentIndex] cancelSelectAnswerAt:childIndex];
    
    NSLog(@"survey: %@", self.survey);
   
}

// - (UIColor *) foregroundColor {
// return [UIColor darkTextColor];
// }

// - (UIColor *) backgroundColor {
// return [UIColor grayColor];
// }

- (UIFont *) fontForParents {
    return [UIFont fontWithName:@"American Typewriter" size:20];
}

- (UIFont *) fontForChildren {
    return [UIFont fontWithName:@"American Typewriter" size:18];
}

/*
 - (UIImage *) selectionIndicatorIcon {
 return [UIImage imageNamed:@"green_checkmark"];
 }
 */
#pragma mark - JKExpandTableViewDataSource
- (NSInteger) numberOfParentCells {
    return [self.survey.questions count];
}

- (NSInteger) numberOfChildCellsUnderParentIndex:(NSInteger) parentIndex {
    
    return [[self.survey getQuestionAt:parentIndex].answers count];
    
}

- (NSString *) labelForParentCellAtIndex:(NSInteger) parentIndex {
    
    return [[self.survey getQuestionAt:parentIndex] question];

}

- (NSString *) labelForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    
    return [[[self.survey getQuestionAt:parentIndex] getAnswerAt:childIndex] answer];
}

- (BOOL) shouldDisplaySelectedStateForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    
    return [[[self.survey getQuestionAt:parentIndex] getAnswerAt:childIndex] isSelected];
    
}

- (UIImage *) iconForParentCellAtIndex:(NSInteger) parentIndex {
    return [UIImage imageNamed:@"arrow-icon"];
}


- (BOOL) shouldRotateIconForParentOnToggle {
    return YES;
}

- (void) getSurveyFromJSON{
    
    static NSString * const BaseURLString = @"http://bns.idealbiz.com.cn:8080/";
    
    NSString *string = [NSString stringWithFormat:@"%@survey.json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //        self.weather = (NSDictionary *)responseObject;
        
        
        NSDictionary *surveyDict = (NSDictionary *)responseObject;
        
        NSLog(@"jsonDic is:%@", surveyDict);
        
        //        _survey = [self CreateFromJSONDiction:surveyDict];
        
        self.survey = [[Survey alloc] initWithDictionary:surveyDict];
        
        [self initializeSurveyView];
        
        NSLog(@"receive survey is:%@", self.survey);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Survey Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
    
}

- (Survey *) CreateFromJSONDiction:(NSDictionary *)surveyDict
{
    
    Survey *survey = [[Survey alloc] init];
    
    survey.title = surveyDict[@"title"];
    
    survey.details = surveyDict[@"detail"];
    
    NSArray *questionsArray = surveyDict[@"questions"];
    
    [questionsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *questionDict=obj;
        Question *question=[[Question alloc] init];
        
        question.question = questionDict[@"question"];
        
        question.type = QuestionTypeDefault;
        
        if ([questionDict[@"type"] isEqualToString:@"multiple"]){
            question.type = QuestionTypeMultipleSelection;
        }
        
        NSArray *answersArray=questionDict[@"answers"];
        
        [answersArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *answerDict = obj;
            Answer *answer = [[Answer alloc] init];
            
            answer.answer = answerDict[@"answer"];
            
            [question.answers addObject:answer];
            
        }];
        
        [survey.questions addObject:question];
        
    }];
    
    return survey;
}

- (Survey *) getSurveyFromTestData{
    
    Question *question1 = [[Question alloc] initWithQuestion:@"Which animal do you like?"
                                                    withType:QuestionTypeMultipleSelection];
    
    [question1 addAnswer:@"I like cat"];
    [question1 addAnswer:@"I like dog"];
    [question1 addAnswer:@"I like horse"];
    
    [question1 getAnswerAt:1].selected = YES;
    [question1 getAnswerAt:2].selected = YES;
    
    //    NSLog(@"q1 select is:%@", question1.getSelectedAnswers);
    
    
    Question *question2 = [[Question alloc] initWithQuestion:@"How old are you?"
                                                    withType:QuestionTypeSingleSelection];
    
    [question2 addAnswer:@"I am over 18 years"];
    [question2 addAnswer:@"I am under 18"];
    
    
    Question *question3 = [[Question alloc] initWithQuestion:@"test question"
                                                    withType:QuestionTypeSingleSelection];
    
    [question3 addAnswer:@"answer 1"];
    [question3 addAnswer:@"answer 2"];
    [question3 addAnswer:@"answer 3"];
    [question3 addAnswer:@"answer 4"];
    [question3 addAnswer:@"answer 5"];
    
    [question3 getAnswerAt:3].selected = YES;

    
    
    Survey *survey = [[Survey alloc] initWithTitle:@"Test Survey"];
    
    survey.details = @"this is a test survey use for debug";
    
    [survey.questions addObject:question1];
    [survey.questions addObject:question2];
    [survey.questions addObject:question3];
    
    
    return survey;
}


- (IBAction)submitSurvey:(id)sender {
    
    NSLog(@"submit data is:%@", [self.survey getSelectedAnswers]);
}

@end
