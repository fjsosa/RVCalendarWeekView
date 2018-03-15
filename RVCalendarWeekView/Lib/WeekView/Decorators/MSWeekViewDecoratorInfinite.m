//
//  MSWeekViewDecoratorInfinite.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorInfinite.h"
#import "NSDate+Easy.h"

#define DAYS_TO_LOAD 30
@interface MSWeekView()
-(void)groupEventsByDays;
@end

@implementation MSWeekViewDecoratorInfinite

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewInfiniteDelegate>)delegate{
    MSWeekViewDecoratorInfinite * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.infiniteDelegate = delegate;
    return weekViewDecorator;
}
//======================================================
#pragma mark - INFINITE SCROLL
//======================================================
bool enableDataLoad;
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    enableDataLoad = YES;
    NSLog(@"Scroll Starts");
    [super scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [super scrollViewDidScroll:scrollView];
    NSLog(@"Ready to load Data");
    if(enableDataLoad)
    {
        NSLog(@"Load Data");
        NSInteger currentOffset = scrollView.contentOffset.x;
        NSInteger maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
        
        
        // Change 10.0 to adjust the distance from side
        if (maximumOffset - currentOffset <= 10.0 && !mLoading /*&& mShouldLoadMore*/) {
            NSLog(@"Forward Scroll Detected");
            [self loadNextDays];
        }else if (currentOffset < 0.0 && !mLoading /*&& mShouldLoadMore*/) {
            NSLog(@"Back Scroll Detected: %li", (long)currentOffset);
            [self loadPreviousDays];
        }
        enableDataLoad = NO;
    }
    
}

-(void)loadNextDays{
    mLoading = true;
    
    NSDate * startDate  = [self.baseWeekView.lastDay   addDays:1];
    NSDate * endDate    = [startDate addDays:self.baseWeekView.daysToLoadOnForwardScroll-1];
    [self.baseWeekView loadAndShowDaysFrom:startDate to:endDate onCompletion:^{
        mLoading = false;
    }];
    
}


-(void)loadPreviousDays{
    mLoading = true;
    NSDate * startDate  = [self.baseWeekView.firstDay addDays: - self.baseWeekView.daysToLoadOnBackwardScroll];
    NSDate * endDate    = [self.baseWeekView.firstDay addDays:-1 ];
    
    [self.baseWeekView loadAndShowDaysFrom:startDate to:endDate onCompletion:^{
        mLoading = false;
    }];
    
}

@end

