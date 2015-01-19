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
    
    //at the ends
    BOOL atTheEnd;
    
    
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
    
    atTheEnd = NO;
    
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
    }
    else
    {
        atTheEnd = NO;
    }
    intialOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if(!atTheEnd)
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

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.y;
    if(offset < 0 || offset > (scrollView.contentSize.height - scrollView.bounds.size.height ) )
    {
        atTheEnd = YES;
    }
    else
    {
        atTheEnd = NO;
    }
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

- (void)resetYPosition:(CGFloat)difference
{
    
}


@end
