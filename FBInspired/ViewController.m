//
//  ViewController.m
//  FBInspired
//
//  Created by ROBERA GELETA on 1/18/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

//+ hide it, - move it out
#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//--->
@property (weak, nonatomic) IBOutlet UISearchBar *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;



@end

@implementation ViewController
{
    CGFloat intialOffset;
    
    //First item Min/Max Y Position
    CGFloat firstMaxY;
    CGFloat firstMinY;
    
    //Second item Min/Max Y Position
    CGFloat secondMaxY;
    CGFloat secondMinY;
    
    //Original Position
    CGFloat originalYPosition;
    
    //getting around the bounces
    BOOL atTheEnd;
    BOOL movingToTheEnd;
    

    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height *2);
    intialOffset = self.scrollView.contentOffset.y;
    

    for (NSInteger itr = 1; itr < 10 ; itr++)
    {
        
        UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(0,itr *100, 200, 5)];
        subview.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:subview];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self settingYPositionRanges];
}


- (void)settingYPositionRanges
{
    firstMaxY = self.firstView.frame.origin.y ;
    secondMaxY = self.secondView.frame.origin.y ;

    
    firstMinY = self.firstView.frame.origin.y - self.firstView.bounds.size.height;
    secondMinY = self.firstView.frame.origin.y - self.firstView.bounds.size.height;
    

    originalYPosition = self.secondView.frame.origin.y - self.secondView.frame.size.height;
//self.firstView.frame.origin.y;
    NSLog(@"Serach Bar Y::::=> %f",originalYPosition);
    NSLog(@"STUPID VIEW Y::::=> %f",self.secondView.frame.origin.y);
    
    
    CGFloat check = self.secondView.frame.origin.y - self.secondView.frame.size.height;
    CGFloat actualPosition = self.firstView.frame.origin.y;
    NSLog(@"actual:-> %f  Calculated:-> %f",actualPosition,check);
    
    
    atTheEnd = NO;
    movingToTheEnd = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ScrollView Delelgates
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if(targetContentOffset->y == 0 || targetContentOffset->y == (scrollView.contentSize.height - scrollView.bounds.size.height ) )
    {
        atTheEnd = YES;
        movingToTheEnd = NO;
    }
    else
    {
        atTheEnd = NO;
        movingToTheEnd = NO;
    }
    
    if((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y  < (scrollView.contentSize.height - scrollView.bounds.size.height )))
    {
        atTheEnd = NO;
        movingToTheEnd = YES;
    }
    
   
    intialOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//     NSLog(@"Serach Bar Y: %f",self.secondView.frame.origin.y);
//     NSLog(@"STUPID VIEW Y: %f",self.secondView.frame.origin.y);
    if(!atTheEnd)
    {
        if(!movingToTheEnd)
        {
            [self resetYPositionWithScrollView:scrollView];

                intialOffset = scrollView.contentOffset.y;
        }
        else
        {
            if((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y  < (scrollView.contentSize.height - scrollView.bounds.size.height )))
            {

                [self resetYPositionWithScrollView:scrollView];
                    intialOffset = scrollView.contentOffset.y;
            }
        }

    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    intialOffset = scrollView.contentOffset.y;
    atTheEnd = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{

}

- (void)resetYPositionWithScrollView:(UIScrollView *)scrollView
{
    
    CGFloat difference = (intialOffset - scrollView.contentOffset.y );

    CGRect currentRect = self.secondView.frame;
    CGFloat newY = currentRect.origin.y + difference;
    newY = MAX(newY, secondMinY);
    newY = MIN(newY, secondMaxY);
    
    CGRect newRect =  CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);
    self.secondView.frame = newRect;

    if(newRect.origin.y <= originalYPosition )
    {
        NSLog(@"Original Position %f",newRect.origin.y);
        self.firstView.frame = newRect;
    }
    else
    {
        CGFloat check = self.secondView.frame.origin.y - self.secondView.frame.size.height;
        CGFloat actualPosition = self.firstView.frame.origin.y;
        NSLog(@"actual:-> %f  Calculated:-> %f",actualPosition,check);
        [UIView animateWithDuration:.05 animations:^{
            self.firstView.frame = CGRectMake(self.firstView.frame.origin.x,originalYPosition, self.firstView.bounds.size.width, self.firstView.bounds.size.height);
        }];
    }

}

- (void)resetY1PositionWithScrollView:(UIScrollView *)scrollView
{
//    CGFloat difference = (intialOffset - scrollView.contentOffset.y );
////
////    difference += self.firstView.bounds.size.height;
//    NSLog(@"%f",difference);
//    CGRect currentRect = self.firstView.frame;
//    CGFloat newY = currentRect.origin.y + difference;
//    newY = MAX(newY, firstMinY);
//    newY = MIN(newY, firstMaxY);
//    
//    self.firstView.frame = CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);
//    
//    intialOffset = scrollView.contentOffset.y;
    
    CGFloat difference = (intialOffset - scrollView.contentOffset.y );
    
    CGRect currentRect = self.secondView.frame;
    CGFloat newY = currentRect.origin.y + difference;
    newY = MAX(newY, secondMinY);
    newY = MIN(newY, secondMaxY);
    
    CGRect newRect =  CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);
    self.secondView.frame = newRect;
    
    if(newRect.origin.y <= originalYPosition )
    {
        NSLog(@"Original Position %f",newRect.origin.y);
        self.firstView.frame = newRect;
    }
}


@end
