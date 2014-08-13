//
//  SurveyTableViewController.m
//  survey
//
//  Created by Aidan on 8/5/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b) RGBAColor(r,g,b,1.0)

#define SELECTED_COLOR RGBColor(255, 127, 0)

//RGBColor(255, 127, 0)

#import "SurveyTableViewController.h"


@interface SurveyTableViewController ()


@end

Survey *_survey;

@implementation SurveyTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBarHidden = false;
    
    [self getSurveyFromJSON];
    
    
//    NSLog(@"%@", _survey);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [_survey.questions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [((Question *)_survey.questions[section]).answers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    Question *question = [_survey getQuestionAt:indexPath.section];
    
//    NSLog(@"%@", question);
    
    Answer *answer = [question getAnswerAt:indexPath.row];
    
//    NSLog(@"%@", answer);
    
    cell.textLabel.text = answer.answer;
    
    
    if(answer.isSelected){
        
        cell.backgroundColor = SELECTED_COLOR;
        
    } else {
        
        cell.backgroundColor = [UIColor clearColor];
    }


    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    Question *question = [_survey getQuestionAt:section];
    
    
    return question.question;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeSelectionAt:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeSelectionAt:indexPath];
}

- (void)changeSelectionAt:(NSIndexPath *)indexPath
{
    
    Question *question = [_survey getQuestionAt:indexPath.section];
//
//    
//    NSArray *needSelect = [question getNeedSelectAnswersWhenSelectedAt:indexPath.row];
//    NSArray *needCancelSelect = [question getNeedCancelSelectAnswersWhenSelectedAt:indexPath.row];
////    NSLog(@"needSelect:%@, needCancel:%@", needSelect, needCancelSelect);
//    
//    for (NSNumber *num in needSelect){
//    
//        
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:num.intValue inSection:indexPath.section]
//                                    animated:YES
//                              scrollPosition:UITableViewScrollPositionNone];
//    }
//    
//    for (NSNumber *num in needCancelSelect){
//        
//        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:num.intValue inSection:indexPath.section]
//                                      animated:YES];
//    }
//    
//    
    [question changAnswerAt:indexPath.row];
    
    [self.tableView reloadData];
    
    NSLog(@"%@", _survey);
    NSLog(@"selected answers are (%@)", _survey.getSelectedAnswers);

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
        
        _survey = [[Survey alloc] initWithDictionary:surveyDict];
        
        
        NSLog(@"receive survey is:%@", _survey);
        
        
        self.navigationItem.title = @"JSON Retrieved";
//        self.navigationItem.title = _survey.title;

        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
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


- (Survey *) getTestSurvey{
    
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
    
    
    Survey *survey = [[Survey alloc] initWithTitle:@"Test Survey"];
    
    survey.details = @"this is a test survey use for debug";
    
    [survey.questions addObject:question1];
    [survey.questions addObject:question2];
    [survey.questions addObject:question3];
    
    
    return survey;
}

@end
