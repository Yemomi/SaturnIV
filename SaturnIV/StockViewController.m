//
//  StockViewController.m
//  SaturnIV
//
//  Created by 叶 文俭 on 14-2-5.
//  Copyright (c) 2014年 叶 文俭. All rights reserved.
//

#import "StockViewController.h"
#import "recommandRecipeTableViewCell.h"
#import "RecipeDetailViewController.h"

#define SECOND_ALL_DAY (24*60*60)

@interface StockViewController ()
@property (strong,nonatomic) NSMutableArray *stockArray;
//@property (strong,nonatomic) NSMutableArray *recommandRecipeImage;
@property (nonatomic) NSInteger image;
//@property (weak, nonatomic) IBOutlet UIImageView *recommandRecipeImageView;
@property (strong,nonatomic) NSMutableArray *recommandRecipeArray;

@end

@implementation StockViewController

//LAZY INSTANTATION
-(NSMutableArray *)recommandRecipeArray{
    if (!_recommandRecipeArray) {
        _recommandRecipeArray = [[NSMutableArray alloc] init];
        NSArray *dirContents = [[NSBundle mainBundle] pathsForResourcesOfType:@".json" inDirectory:@""];
        
        for (NSString *tString in dirContents) {
            for (NSString *gre in self.stockArray[0]) {
                if ([tString rangeOfString:gre].location == NSNotFound) {
                    // NSLog(@"string does not contain bla");
                } else {
                    NSLog(@"%@",tString);
                    [_recommandRecipeArray addObject:[[tString lastPathComponent] stringByDeletingPathExtension]];
                }
            }
            // NSLog(@"%@",tString);
        }
    }

    return _recommandRecipeArray;
}
-(NSMutableArray *)stockArray{
    if (!_stockArray) {
        _stockArray = [[NSMutableArray alloc] init];
    }
    
    return _stockArray;
}
-(NSInteger)image{
    if (!_image) {
        _image = 0;
    }
    
    return _image;
}
/*
-(NSMutableArray *)recommandRecipeImage{
    if (!_recommandRecipeImage) {
        _recommandRecipeImage = [[NSMutableArray alloc] init];
        [_recommandRecipeImage addObject:[UIImage imageNamed:@"丁香花生.jpg"]];
        [_recommandRecipeImage addObject:[UIImage imageNamed:@"三丝鱼皮.jpg"]];

    }
    
    return _recommandRecipeImage;
}
*/

-(NSMutableArray *)fetchInfo{
    NSMutableArray *stockInfo = [[NSMutableArray alloc] init];
    //get the things from server
    NSURL *fileUrl = [[NSURL alloc] initWithString:@"ftp://pi:Ywj8278@192.168.1.5/Debug/foodInfo.json"];
    NSData *fileData = [self fetchDataFromUrl:fileUrl];
    if (fileData) {
        NSError *error;
        NSDictionary *stockItems = [NSJSONSerialization JSONObjectWithData:fileData
                                                                   options:0
                                                                     error:&error];
        if (!error) {

            [stockInfo addObject:[stockItems valueForKey:@"name"]];
            [stockInfo addObject:[stockItems valueForKey:@"year"]];
            [stockInfo addObject:[stockItems valueForKey:@"month"]];
            [stockInfo addObject:[stockItems valueForKey:@"day"]];
            [stockInfo addObject:[stockItems valueForKey:@"QGT"]];
            [stockInfo addObject:[stockItems valueForKey:@"pre"]];

        }else{
            //handle error below
            //file not found error
        }
        
    }else{
        //handle the error if file data not recieved
    }
    NSLog(@"stockInfo%@%d",stockInfo, [stockInfo count]);
    return stockInfo;
}

-(NSData *)fetchDataFromUrl:(NSURL *)url{
    NSData *fileData = nil;
    NSLog(@"test");
#warning block the main queue
    fileData = [NSData dataWithContentsOfURL:url];
    NSLog(@"%@", [fileData description]);
    return fileData;
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
-(void) updateRecommandRecipeView{
    if (self.image < [self.recommandRecipeImage count] -1) {
        self.image ++;
    }else{
        self.image = 0;
    }
    NSLog(@"%d  %d",self.image, [self.recommandRecipeImage count]);
    self.recommandRecipeImageView.image = self.recommandRecipeImage[self.image];
}
*/

- (void)viewDidLoad{
    [super viewDidLoad];
    self.stockArray = [self fetchInfo];
    /*
     [self.tableView registerNib:[UINib nibWithNibName:@"recommandReciptTableCell" bundle:nil] forCellReuseIdentifier:@"Recommand Recipe"];
    NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                             target:self
                                           selector:@selector(updateRecommandRecipeView)
                                           userInfo:nil
                                            repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];
     */
    NSLog(@"%@",[self.recommandRecipeArray description]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.stockArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Stock Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.stockArray firstObject] objectAtIndex:indexPath.row];
    //NSString *startTime = [NSString stringWithFormat:@"%@-%@-%@",[self.stockArray[1] objectAtIndex:indexPath.row],[self.stockArray[2] objectAtIndex:indexPath.row],[self.stockArray[3] objectAtIndex:indexPath.row]];
    //cell.detailTextLabel.text = startTime;
    // cell.textLabel.text = @"test";
    
    NSInteger day,month,year,interval;
    day     = [[self.stockArray[3] objectAtIndex:indexPath.row] intValue];
    month   = [[self.stockArray[2] objectAtIndex:indexPath.row] intValue];
    year    = [[self.stockArray[1] objectAtIndex:indexPath.row] intValue];
    interval= [[self.stockArray[4] objectAtIndex:indexPath.row] intValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:day+1];
    [dateComp setMonth:month];
    [dateComp setYear:year];
    NSDate *startDate = [calendar dateFromComponents:dateComp];
    NSTimeInterval timeInterval = interval*SECOND_ALL_DAY;
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    NSTimeInterval fin = [endDate timeIntervalSinceNow];
    
    NSLog(@"year:%@ month:%@ day:%@", [self.stockArray[1] objectAtIndex:indexPath.row],[self.stockArray[2] objectAtIndex:indexPath.row],[self.stockArray[3] objectAtIndex:indexPath.row]);
    NSLog(@"End time:%@ startDate:%@ interval:%@", endDate, startDate, [self.stockArray[4] objectAtIndex:indexPath.row]);
    fin /= SECOND_ALL_DAY;
    NSLog(@"Fin:%f", fin/SECOND_ALL_DAY);
    if (fin < 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"食品已过期，请尽快处理"];
    }else if (fin < 4){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f天后过期，请尽快食用", fin];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"食品很新鲜"];
    }
    
    return cell;
    
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 100:44;
}
 */
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"G2R"]) {
                if ([segue.destinationViewController isKindOfClass:[RecipeDetailViewController class]]){
                    UIViewController *uvc = segue.destinationViewController;
                    //uvc.title = [[sender textLabel] text];
                    for (NSString *gre in self.recommandRecipeArray) {
                        if ([gre rangeOfString:[[sender textLabel] text]].location != NSNotFound) {
                            uvc.title = gre;
                        }
                    }
                }
            }
        }
    }
}


@end
