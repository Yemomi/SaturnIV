//
//  RecipeTableViewController.m
//  Recipe
//
//  Created by 叶 文俭 on 14-1-24.
//  Copyright (c) 2014年 叶 文俭. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "RecipeDetailViewController.h"

@interface RecipeTableViewController ()
@property (strong,nonatomic) NSMutableArray *recipeName;
@end

@implementation RecipeTableViewController

-(NSMutableArray *)recipeName{
    if (!_recipeName) {
        _recipeName = [[NSMutableArray alloc] init];
        NSArray *jsonFilePath = [[NSBundle mainBundle] pathsForResourcesOfType:@".json" inDirectory:@""];
        NSLog(@"%@",jsonFilePath);
       /*
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:[jsonFilePath firstObject] options:0
                                                            error:nil];
       
        NSLog(@"%@",[jsonFilePath firstObject]);
        NSLog(@"%@",jsonData);

        if (jsonData) {
            NSDictionary *recipeDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:0
                                                                        error:nil];
            
            NSLog(@"json:%@",recipeDic);
            NSLog(@"name:%@",[recipeDic valueForKey:@"name"]);
            NSLog(@"indro:%@",[recipeDic valueForKey:@"getBriefIntroduce"]);
            NSLog(@"ingren:%@",[[[recipeDic valueForKey:@"ingredients"] valueForKey:@"ingredientName"] class]);
            //NSLog(@"ingreu:%@",[[recipeDic valueForKey:@"ingredients"] lastObject]);
            NSLog(@"steps:%@",[recipeDic valueForKey:@"steps"]);
            NSLog(@"url:%@",[recipeDic valueForKey:@"imgUrl"]);


            

        }
         */
        
        for (NSString *filePath in jsonFilePath) {
            NSString *name = [[filePath stringByDeletingPathExtension] lastPathComponent];
            [_recipeName addObject:name];
            NSLog(@"%@", name);
            
        }
       
    }
    return _recipeName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     //NSLog(@"%@",jsonFilePath);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recipe Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.recipeName[indexPath.row];
    
    return cell;
}


#pragma mark - prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"recipe detail"]) {
                if ([segue.destinationViewController isKindOfClass:[RecipeDetailViewController class]]){
                    UIViewController *uvc = segue.destinationViewController;
                    uvc.title = [[sender textLabel] text];
                }
            }
        }
    }
}



@end
