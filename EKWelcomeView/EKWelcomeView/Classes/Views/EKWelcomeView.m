//
//  EKWelcomeView.m
//  EKWelcomeView
//
//  Created by EvgenyKarkan on 09.08.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKWelcomeView.h"
#import "EKFirstHintView.h"
#import "EKSecondHintView.h"
#import "EKThirdHintView.h"
#import "EKFourthHintView.h"

@interface EKWelcomeView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL pageControlBeingUsed;
@property (nonatomic, strong) EKFirstHintView *firstView;
@property (nonatomic, strong) EKSecondHintView *secondView;
@property (nonatomic, strong) EKThirdHintView *thirdView;
@property (nonatomic, strong) EKFourthHintView *fourthView;

@end


@implementation EKWelcomeView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
		[self createSubViews];
	}
	
	return self;
}

#pragma mark - Init subviews stuff

- (void)createSubViews
{
	self.scrollView  = [[UIScrollView alloc] init];
	self.scrollView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.6f];
	self.scrollView.delegate = self;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.pagingEnabled = YES;
	[self addSubview:self.scrollView];
	
	self.firstView   = [[EKFirstHintView alloc] init];
	[self.scrollView addSubview:self.firstView];
	
	self.secondView  = [[EKSecondHintView alloc] init];
	[self.scrollView addSubview:self.secondView];
	
	self.thirdView   = [[EKThirdHintView alloc] init];
	[self.scrollView addSubview:self.thirdView];
	
	self.fourthView  = [[EKFourthHintView alloc] init];
	[self.scrollView addSubview:self.fourthView];
	
	self.pageControl = [[UIPageControl alloc] init];
	self.pageControl.numberOfPages = [[self.scrollView subviews] count];
	self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.pageControl];
	
	self.button = [[UIButton alloc] init];
	[self.button setTitle:@"Skip" forState:UIControlStateNormal];
	[self.button addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.button];
}

#pragma mark - Layout subviews stuff

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.scrollView.frame = CGRectMake(0.0f, self.frame.origin.y + 20.0f, self.frame.size.width, self.frame.size.height - 90.0f);
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [[self.scrollView subviews] count], self.scrollView.frame.size.height);
	self.pageControl.frame = CGRectMake(self.frame.origin.x, self.frame.size.height - 45.0f, self.frame.size.width, 40.0f);
	
	for (NSUInteger i = 0; i < [[self.scrollView subviews] count]; i++) {
		[[[self.scrollView subviews] objectAtIndex:i] setFrame:CGRectMake(40.0f + (i * self.frame.size.width), 40.0f,
		                                                                  self.frame.size.width - 80.0f, self.frame.size.height - 170.0f)];
	}
	
	self.button.frame = CGRectMake(self.frame.size.width - 50.0f, 10.0f, 50.0f, 30.0f);
}

#pragma mark - ScrollView's delegate stuff

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!self.pageControlBeingUsed) {
		CGFloat pageWidth = self.scrollView.frame.size.width;
		NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2.0f) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.pageControlBeingUsed = NO;
}

#pragma mark - Action on pageControl pressed

- (void)changePage:(id)sender
{
	if (sender) {
		[self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.pageControl.currentPage, 0) animated:YES];
		self.pageControlBeingUsed = YES;
	}
}

#pragma mark - Delegate stuff

- (void)goNext
{
	if (self.delegate) {
		[self.delegate dismissWelcomeScreen];
	}
}

@end
