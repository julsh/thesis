//
//  SZSortFilterMenu.m
//  Skillz
//
//  Created by Julia Roggatz on 18.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSortFilterMenu.h"
#import "SZMenuVC.h"

@interface SZSortFilterMenu ()

@property (nonatomic, strong) UINavigationItem* navItem;

@end

@implementation SZSortFilterMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.view setFrame:CGRectMake(90.0, 0.0, 230.0, 480.0)];
	
	UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 230.0, 44.0)];
	[navBar setTintColor:[SZGlobalConstants veryDarkPetrol]];
	[navBar setTitleTextAttributes:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
	  UITextAttributeTextColor,
	  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
	  UITextAttributeTextShadowColor,
	  [NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)],
	  UITextAttributeTextShadowOffset,
	  [SZGlobalConstants fontWithFontType:SZFontBold size:18.0],
	  UITextAttributeFont, nil]];
	
	self.navItem = [[UINavigationItem alloc] init];
	UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"buttonIcon_hide"] style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
	[self.navItem setLeftBarButtonItem:hideButton];
	
	[navBar setItems:[NSArray arrayWithObject:self.navItem]];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 44.0, 230.0, 416.0)];
	[self.scrollView setClipsToBounds:NO];
	[self.scrollView setContentSize:self.scrollView.frame.size];
	
	UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[self.scrollView addGestureRecognizer:tapRecognizer];
	
	[self.view addSubview:self.scrollView];
	[self.view addSubview:navBar];
	
}

- (void)toggle {
	self.isShowing = !self.isShowing;
	[[SZMenuVC sharedInstance].parentViewController performSelector:@selector(toggleSortOrFilterMenu)];
	if (!self.isShowing) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_FILTER_OR_SORT_MENU_HIDDEN object:nil];
	}
}

- (void)setTitle:(NSString *)title {
	[self.navItem setTitle:title];
}

@end
