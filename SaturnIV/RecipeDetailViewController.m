//
//  RecipeDetailViewController.m
//  Recipe
//
//  Created by 叶 文俭 on 14-1-24.
//  Copyright (c) 2014年 叶 文俭. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *recipeImg;
@property (strong, nonatomic) NSString *imgUrl;
@property (weak, nonatomic) IBOutlet UITextView *recipeText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation RecipeDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//lazy instantation
-(NSString *)imgUrl{
    if (!_imgUrl) {
        _imgUrl = [[NSString alloc] init];
    }
    
    return _imgUrl;
}
-(void) downloadRecipeImg{
    //UIImage *recipeImg = nil;
    NSString *recipeImgFileName = [self.title stringByAppendingString:@".jpg"];
    NSString *imgUrlStr = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",recipeImgFileName]];
    //NSData *imgData = [[NSData alloc] initWithContentsOfFile:imgUrlStr];
    self.recipeImg.image = [UIImage imageWithContentsOfFile:imgUrlStr];
    
    //return recipeImg;
}
-(void) setDetailText:(NSDictionary *)recipeDic{
    NSString *recipeIntro = nil;
    NSDictionary *ingredients = nil;
    NSArray *ingredientName = nil;
    NSArray *ingredientUnit = nil;
    NSArray *steps = nil;
    
    if ([[recipeDic valueForKey:@"getBriefIntroduce"] isKindOfClass: [NSString class]]) {
        recipeIntro = [recipeDic valueForKey:@"getBriefIntroduce"];
    }
    
    if ([[recipeDic valueForKey:@"ingredients"] isKindOfClass: [NSDictionary class]]) {
        ingredients = (NSDictionary *) [recipeDic valueForKey:@"ingredients"];
        
        if ([[ingredients valueForKey:@"ingredientName"] isKindOfClass:[NSArray class]] && [[ingredients valueForKey:@"IngredientUnit" ]isKindOfClass:[NSArray class]]) {
            ingredientName = [ingredients valueForKey:@"ingredientName"];
            ingredientUnit = [ingredients valueForKey:@"IngredientUnit"];
        }
    }
    
    if ([[recipeDic valueForKey:@"steps"] isKindOfClass:[NSArray class]]) {
        steps = [recipeDic valueForKey:@"steps"];
    }

    NSString *formattedIndr = [NSString stringWithFormat:@"“%@”\n", recipeIntro];
    NSLog(@"%@",formattedIndr);
    NSMutableString *bodyStr = [[NSMutableString alloc] init];
    [bodyStr appendString:formattedIndr];

    NSLog(@"body:%@",bodyStr);
    
    for (int i = 0; i < MAX([ingredientUnit count], [ingredientName count])-1; i++) {
        NSLog(@"%@",ingredientName[i]);
        [bodyStr appendString:[NSString stringWithFormat:@"%@\t:\t%@\n", ingredientName[i], ingredientUnit[i]]];
        
    }
    
    for (int i = 0; i < [steps count]; i++) {
        [bodyStr appendString:[NSString stringWithFormat:@"%@\n",steps[i]]];
    }
    
    NSMutableAttributedString *body = [[NSMutableAttributedString alloc] initWithString:bodyStr];
    
    self.recipeText.attributedText = body;
    [self.recipeText.textStorage addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:15]
                                        range:NSMakeRange(0, body.length)];
    
    /*

    //intro
    [self.recipeText.textStorage addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:18]
                                        range:NSMakeRange(1, [recipeIntro length]-3)];
    //“
    [self.recipeText.textStorage addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0,1)];
    
    [self.recipeText.textStorage addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor colorWithRed:100.0f/255.0f
                                                              green:100.0f/255.0f
                                                               blue:100.0f/255.0f
                                                              alpha:1.0f]
                                        range:NSMakeRange(0,1)];
    //”
    [self.recipeText.textStorage addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:18]
                                        range:NSMakeRange([recipeIntro length], 1)];
    
    [self.recipeText.textStorage addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f]
                                        range:NSMakeRange([recipeIntro length], 1)];
     */

}

-(UIImage *) getImageByName:(NSString *)imageName{
    NSString *recipeImgFileName = imageName;
    NSString *imgUrlStr = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",recipeImgFileName]];
    return [UIImage imageWithContentsOfFile:imgUrlStr];
}


//init the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self downloadRecipeImg];
    
    //get the recipe json file
    NSDictionary *recipeDict = [self jsonToNsdictionay];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0,self.recipeText.bounds.size.width,240)];
    imageView.bounds = CGRectMake(0,0,self.recipeText.bounds.size.width,240);
    imageView.clipsToBounds = YES;
                              
    imageView.image = [self getImageByName:[self.title stringByAppendingString:@".jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.recipeText addSubview:imageView];
    self.recipeText.textContainerInset = UIEdgeInsetsMake(imageView.bounds.size.height, 0, 0, 0);
                              
    if (recipeDict) {
        [self setDetailText:recipeDict];
        //self.recipeText.text = [recipeDict valueForKey:@"getBriefIntroduce"];
    }

         /*
    NSURL *url = [[NSURL alloc] initWithString:self.imgUrl];
    NSData *imgdata = [[NSData alloc] initWithContentsOfURL:url
                                                    options:0
                                                      error:nil];
    NSLog(@"data:%@",imgdata);
    UIImage *img = [[UIImage alloc] initWithData:imgdata];
    self.recipeImg.image = img;
	// Do any additional setup after loading the view.
          */
}



//turn a json file to nsdictionary
//return nil if failed
-(NSDictionary *) jsonToNsdictionay{
    NSString *fileName = [NSString stringWithFormat:@"/%@.json",self.title];
    NSString *jsonFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:fileName];
    
    NSError *error;
    NSData *jsonFileData = [[NSData alloc]initWithContentsOfFile:jsonFilePath
                                                         options:0
                                                           error:&error];
    if (!error) {
        if (jsonFileData) {
            NSError *jsonFormatErr;
            NSDictionary *recipeDic = [NSJSONSerialization JSONObjectWithData:jsonFileData
                                                                      options:0
                                                                        error:&jsonFormatErr];
            if (!jsonFormatErr) {
                return recipeDic;
                //self.imgUrl = [recipeDic valueForKey:@"imgUrl"];
                //NSLog(@"imgurl:%@",self.imgUrl);
            } else return nil;
            

            
            /*
             NSLog(@"json:%@",recipeDic);
             NSLog(@"name:%@",[recipeDic valueForKey:@"name"]);
             NSLog(@"indro:%@",[recipeDic valueForKey:@"getBriefIntroduce"]);
             NSLog(@"ingren:%@",[[[recipeDic valueForKey:@"ingredients"] valueForKey:@"ingredientName"] class]);
             //NSLog(@"ingreu:%@",[[recipeDic valueForKey:@"ingredients"] lastObject]);
             NSLog(@"steps:%@",[recipeDic valueForKey:@"steps"]);
             NSLog(@"url:%@",[recipeDic valueForKey:@"imgUrl"]);
             */
        } else return nil;
    }else return nil;

}


@end
