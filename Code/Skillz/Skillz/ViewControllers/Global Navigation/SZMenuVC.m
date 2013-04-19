//
//  SZMenuVC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMenuVC.h"
#import "SZUtils.h"
#import "SZMenuCell.h"
#import "UILabel+Shadow.h"

#define CELL_HEIGHT 40.0
#define SECTION_HEADER_HEIGHT 22.0

@interface SZMenuVC ()

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableDictionary *sectionTitles;
@property (nonatomic, strong) UIViewController* hiddenViewController;
@property (nonatomic, strong) UIView* hiddenView;

@end

@implementation SZMenuVC

@synthesize tableView = _tableView;

+ (SZMenuVC*)sharedInstance {
	
	static dispatch_once_t singletonPredicate;
	static SZMenuVC* singleton = nil;
	
	dispatch_once(&singletonPredicate, ^{
        singleton = [[super allocWithZone:nil] init];
	});
	return singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
	return [self sharedInstance];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setNumberOfSections:4];
		[self setSectionTitle:@"DISCOVER" forSection:0];
		[self setSectionTitle:@"MY ACCOUNT" forSection:1];
		[self setSectionTitle:@"MY LISTINGS" forSection:2];
		[self setSectionTitle:@"MORE" forSection:3];
		
		// DISCOVER SECTION
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Search", @"SZSearchVC", nil] forKeys:
					   [NSArray arrayWithObjects:@"title", @"class", nil]] toSection:0];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Browse", @"SZBrowseVC", nil] forKeys:
					   [NSArray arrayWithObjects:@"title", @"class", nil]] toSection:0];
		
		// MY ACCOUNT SECTION
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Open Deals"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:1];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Messages"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:1];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Account Balance", nil, nil] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:1];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Profile"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:1];
		
		// MY LISTINGS SECTION
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"My Offers", @"SZMyOffersVC", nil] forKeys:
					   [NSArray arrayWithObjects:@"title", @"class", nil]] toSection:2];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"My Requests", @"SZMyRequestsVC", nil] forKeys:
					   [NSArray arrayWithObjects:@"title", @"class", nil]] toSection:2];
		
		// MORE SECTION
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Help"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:3];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Settings"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:3];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Terms & Conditions"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:3];
		[self addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObject:@"Logout"] forKeys:
					   [NSArray arrayWithObject:@"title"]] toSection:3];
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
	
	self.hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.hiddenView];
	[self.hiddenView setHidden:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
		[_tableView setFrame:CGRectMake(0.0, 0.0, 240.0, 460.0)];
		[_tableView setBackgroundColor:[SZGlobalConstants menuCellColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (NSMutableArray*)sections {
	if (_sections == nil) {
		_sections = [[NSMutableArray alloc] init];
	}
	return _sections;
}

- (NSMutableDictionary*)sectionTitles {
	if (_sectionTitles == nil) {
		_sectionTitles = [[NSMutableDictionary alloc] init];
	}
	return _sectionTitles;
}

#pragma mark - Menu

- (void)setNumberOfSections:(NSInteger)newNumberOfSections {
    _numberOfSections = newNumberOfSections;
    
    if (self.sections) {
        self.sections = nil;
        self.sectionTitles = nil;
    }
    
    self.sections = [[NSMutableArray alloc] init];
    self.sectionTitles = [[NSMutableDictionary alloc] init];
    
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        [self.sections addObject: [[NSMutableArray alloc] init]];
    }
}

- (void)addItem:(NSDictionary *)itemDictionary toSection:(NSInteger)sectionIndex {
	
	NSMutableArray *sectionArray = [self.sections objectAtIndex:sectionIndex];
	[sectionArray addObject:itemDictionary];
	
	[self.tableView reloadData];
}

- (NSDictionary *)dictionaryForRow:(NSInteger)rowIndex inSection:(NSInteger)sectionIndex {
	
	NSMutableArray *sectionArray = [self.sections objectAtIndex:sectionIndex];
	NSDictionary *dict = [sectionArray objectAtIndex:rowIndex];
	return dict;
}

- (void)setSectionTitle:(NSString *)sectionTitle forSection:(NSInteger)sectionIndex {
	
	NSString *sectionKey = [NSString stringWithFormat:@"section%d", sectionIndex];
	[self.sectionTitles setObject:sectionTitle forKey:sectionKey];
}

- (NSDictionary *)getSectionTitles {
	return self.sectionTitles;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *sectionArray = [self.sections objectAtIndex:section];
	
	return [sectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"menuCellId";
	
	SZMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId width:self.view.frame.size.width height:CELL_HEIGHT];
	}
	
	NSDictionary *dict = [self dictionaryForRow:indexPath.row inSection:indexPath.section];
	NSString *title = [dict objectForKey:@"title"];
	
	if (title) {
		cell.textLabel.text = title;
		cell.accessibilityLabel = title;
		cell.isAccessibilityElement = YES;
	}
	
	// set icon, if specified
	if (cell.imageView.image == nil) {
		NSDictionary* dict = [self dictionaryForRow:indexPath.row inSection:indexPath.section];
		NSString* iconName = [dict objectForKey:@"iconName"];
		
		if (iconName) {
			UIImage* image = [UIImage imageNamed:iconName];
			if (image) {
				cell.imageView.image = image;
			}
		}
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.sectionTitles count] > 0) {
		NSString *key = [NSString stringWithFormat:@"section%d", section];
		return [self.sectionTitles objectForKey:key];
	}
	
	return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    NSString* key = [NSString stringWithFormat:@"section%d", section];
    NSString* sectionTitle = [[self getSectionTitles] objectForKey:key];
    
    UIView* headerView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, SECTION_HEADER_HEIGHT)];
    headerView.backgroundColor = [SZGlobalConstants menuSectionColor];
	
    UIView* topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
	[topSeparator setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.08]];
	UIView* bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0.0, SECTION_HEADER_HEIGHT - 1.0, self.view.frame.size.width, 1.0)];
	[bottomSeparator setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    
    CGFloat titleHeight = SECTION_HEADER_HEIGHT - topSeparator.frame.size.height - bottomSeparator.frame.size.height;
    CGFloat y = floorf((SECTION_HEADER_HEIGHT - titleHeight) / 2.0);
    UILabel* titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(11.0, y, self.view.bounds.size.width - 10.0, titleHeight)];
	[titleLabel applyBlackShadow];
    titleLabel.text = [sectionTitle uppercaseString];
    titleLabel.adjustsFontSizeToFitWidth = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [SZGlobalConstants fontWithFontType:SZFontBold size:12.0];
    titleLabel.textColor = [SZGlobalConstants menuSectionTextColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview: topSeparator];
    [headerView addSubview: bottomSeparator];
    [headerView addSubview: titleLabel];
    
    return headerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return SECTION_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict = [self dictionaryForRow:indexPath.row inSection:indexPath.section];
	NSString* class = [dict objectForKey:@"class"];
    [self.delegate menu:self switchToViewControllerWithClassName:class];
         
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (void)addHiddenMenu:(UIViewController*)vc {
	self.hiddenViewController = vc;
	[self.hiddenView addSubview:vc.view];
	[self addChildViewController:vc];
}

- (void)removeHiddenMenu {
	for (UIView* subview in [self.hiddenView subviews]) {
		[subview removeFromSuperview];
	}
	[self.hiddenViewController removeFromParentViewController];
	self.hiddenViewController = nil;
}

- (void)showHiddenMenu {
	[self.hiddenView setHidden:NO];
}

- (void)hideHiddenMenu {
	[self.hiddenView setHidden:YES];

}

@end
