//
//  SurveyTableViewController.m
//  survey
//
//  Created by Aidan on 8/5/14.
//  Copyright (c) 2014 aidan. All rights reserved.
//

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
    
    NSLog(@"%@", _survey);
    
    self.navigationItem.title = _survey.title;
    
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    
    Answer *answer = [[_survey getQuestionAt:indexPath.section] getAnswerAt:indexPath.row];
    
//    NSLog(@"%@", answer);
    
    cell.textLabel.text = answer.ansewer;
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if(answer.isSelected){
    
//        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    
        cell.backgroundColor = [UIColor orangeColor];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else{
        
//        cell.accessoryType =  UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
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

    [question changAnswerAt:indexPath.row];
    
    [self.tableView reloadData];
    
    NSLog(@"%@", _survey);

    
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
    
    Question *question1 = [[Question alloc] init];
    
    question1.question = @"Which animal do you like?";
    question1.type = QUESTION_TYPE_MULTIPLE;


    Answer *answer11 = [[Answer alloc] init];
    answer11.ansewer = @"I like cat";
    
    Answer *answer12 = [[Answer alloc] init];
    answer12.ansewer = @"I like dog";
    answer12.selected = YES;
    
    
    Answer *answer13 = [[Answer alloc] init];
    answer13.ansewer = @"I like horse";
    
    
    [question1.answers addObject:answer11];
    [question1.answers addObject:answer12];
    [question1.answers addObject:answer13];
    
    
    
    Question *question2 = [[Question alloc] init];
    
    question2.question = @"How old are you?";

    Answer *answer21 = [[Answer alloc] init];
    answer21.ansewer = @"I am over 18 years";
    
    Answer *answer22 = [[Answer alloc] init];
    answer22.ansewer = @"I am under 18";
    
    [question2.answers addObject:answer21];
    [question2.answers addObject:answer22];

    
    Survey *survey = [[Survey alloc] init];
    
    survey.title = @"Test Survey";
    survey.details = @"this is a test survey use for debug";
    
    [survey.questions addObject:question1];
    [survey.questions addObject:question2];
    
    
    return survey;
}

@end
