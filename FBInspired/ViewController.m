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
    CGFloat originalY1Position;
    
    //getting around the bounces
    BOOL atTheEnd;
    BOOL movingToTheEnd;
    
    //Original Frames
    CGRect firstOriginalFrame;
    CGRect secondOriginalFrame;
    
    //
    CGRect finalFrame ;
    
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

    
    firstMinY = 0 - self.firstView.frame.size.height;//self.firstView.frame.origin.y - self.firstView.bounds.size.height;
    secondMinY = firstMinY;//self.firstView.frame.origin.y - self.firstView.bounds.size.height;
    

    originalY1Position = self.secondView.frame.origin.y - self.secondView.frame.size.height;

    UIEdgeInsets edgeInset  = UIEdgeInsetsMake(self.firstView.bounds.size.height + self.secondView.bounds.size.height, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = edgeInset;
    //------>
    atTheEnd = NO;
    movingToTheEnd = NO;
    
    //------>
    firstOriginalFrame = self.firstView.frame;
    secondOriginalFrame = self.secondView.frame;
    
    //--->
    finalFrame = CGRectMake(0, firstMinY,self.firstView.bounds.size.width, self.firstView.bounds.size.height);
    
    
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
    
    //---->
    [self animateToCorrectPosition:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    
    //---->
    [self animateToCorrectPosition:scrollView];
    
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

    if(newRect.origin.y <= originalY1Position )
    {
        self.firstView.frame = newRect;
        CGFloat distance = originalY1Position  - firstMinY;
        CGFloat computedAlpha = (1.0 *(newY  - firstMinY))/ distance;
        self.firstView.alpha = computedAlpha;
        self.secondView.alpha  = (0.2)*computedAlpha;
    }
    else
    {
        [UIView animateWithDuration:.05 animations:^{
            self.firstView.frame = CGRectMake(self.firstView.frame.origin.x,originalY1Position, self.firstView.bounds.size.width, self.firstView.bounds.size.height);
            self.firstView.alpha = 1.0;
            self.secondView.alpha = 1.0;
        }];
    }

}


- (void)animateToCorrectPosition:(UIScrollView *)scrollView
{
    CGFloat difference = (intialOffset - scrollView.contentOffset.y );
    
    CGRect currentRect = self.secondView.frame;
    CGFloat newY = currentRect.origin.y + difference;
    newY = MAX(newY, secondMinY);
    newY = MIN(newY, secondMaxY);
    CGRect newRect =  CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);

    if(newRect.origin.y > originalY1Position)
    {
        [UIView animateWithDuration:.2 animations:^{
            self.firstView.frame = firstOriginalFrame;
            self.secondView.frame = secondOriginalFrame;
            self.firstView.alpha = 1.0;
        }];
    }else
    {
        [UIView animateWithDuration:.2 animations:^{
            self.firstView.frame = finalFrame;
            self.secondView.frame = finalFrame;
            self.firstView.alpha = 0.0;
        }];
    }
}


@end
