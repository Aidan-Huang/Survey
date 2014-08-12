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
    
    _survey = [self getTestSurvey];
    
//    NSLog(@"%@", _survey);
    
    self.navigationItem.title = _survey.title;
    
//    [self.tableView reloadData];
    
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
    
    cell.textLabel.text = answer.ansewer;
    
    
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

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Add your Colour.
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self setCellColor:[UIColor redColor] ForCell:cell];  //highlight colour
//    
//}
//
//- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
//    cell.contentView.backgroundColor = color;
//    cell.backgroundColor = color;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
