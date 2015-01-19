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
    
    //getting around the bounces
    BOOL atTheEnd;
    BOOL movingToTheEnd;
    
    //DEBUGGING
    NSInteger count;
    
    
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
    
    //TODO:REMOVE
    count = 0 ;
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
    
    NSLog(@"DRAG ENDED WITH EXPECTED OFFSET :%f",targetContentOffset->y);
    if(targetContentOffset->y == 0 || targetContentOffset->y == (scrollView.contentSize.height - scrollView.bounds.size.height ) )
    {
        NSLog(@"AT THE END , %d",count);
        atTheEnd = YES;
        movingToTheEnd = NO;
    }
    else
    {
        NSLog(@"NOT AT THE END , %d",count);
        atTheEnd = NO;
        movingToTheEnd = NO;
    }
    
    if((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y  < (scrollView.contentSize.height - scrollView.bounds.size.height )))
    {
        NSLog(@"NOT AT THE END, %d",count);
        atTheEnd = NO;
        movingToTheEnd = YES;
    }
    
    count += 1;


   
    intialOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"Scrolling");
    if(!atTheEnd)
    {
        NSLog(@"Computing");
        if(!movingToTheEnd)
        {
            CGFloat difference = (intialOffset - scrollView.contentOffset.y );
            CGRect currentRect = self.secondView.frame;
            CGFloat newY = currentRect.origin.y + difference;
            newY = MAX(newY, secondMinY);
            newY = MIN(newY, secondMaxY);
            
            self.secondView.frame = CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);
            
            intialOffset = scrollView.contentOffset.y;
        }
        else
        {
            if((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y  < (scrollView.contentSize.height - scrollView.bounds.size.height )))
            {
                CGFloat difference = (intialOffset - scrollView.contentOffset.y );
                CGRect currentRect = self.secondView.frame;
                CGFloat newY = currentRect.origin.y + difference;
                newY = MAX(newY, secondMinY);
                newY = MIN(newY, secondMaxY);
                
                self.secondView.frame = CGRectMake(currentRect.origin.x, newY, currentRect.size.width, currentRect.size.height);
                
                intialOffset = scrollView.contentOffset.y;
            }
        }

    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"Will Descellreate");
//
//    CGFloat offset = scrollView.contentOffset.y;
//    if(offset < 0 || offset > (scrollView.contentSize.height - scrollView.bounds.size.height ) )
//    {
//        atTheEnd = YES;
//    }
//    else
//    {
//        NSLog(@"SHOULD NOT SEE THIS");
//        atTheEnd = NO;
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Ended Decelerating");
    intialOffset = scrollView.contentOffset.y;
//    atTheEnd = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{

}

- (void)resetYPosition:(CGFloat)difference
{
    
}


@end
