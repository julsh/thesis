//
//  SZCategoriesVC.m
//  Skillz
//
//  Created by Julia Roggatz on 04.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZCategoriesVC.h"
#import "SZUtils.h"
#import "SZCategoryCell.h"
#import "SZSubcategoriesVC.h"
#import "SZDataManager.h"
#import "SZSearchResultsVC.h"

@interface SZCategoriesVC ()

@property (nonatomic, strong) NSArray* categories;

@end

@implementation SZCategoriesVC


- (id)init {
	self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSMutableArray* categories = [NSMutableArray arrayWithObject:[NSNull null]];
		[categories addObjectsFromArray:[SZUtils sortedCategories]];
		self.categories = categories;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Select a Category"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* topCell = @"topCell";
    static NSString* categoryCell = @"categoryCell";
    SZCategoryCell* cell;
	
	if (indexPath.row == 0) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:topCell];
		if (cell == nil) {
			cell = [[SZCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
		}
		[cell.textLabel setText:@"All Categories"];
		[cell.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:16.0]];
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
		if (cell == nil) {
			cell = [[SZCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCell];
		}
		NSString* category = [self.categories objectAtIndex:indexPath.row];
		[cell.imageView setImage:[UIImage imageNamed:[[category lowercaseString] substringToIndex:3]]];
		[cell.textLabel setText:[self.categories objectAtIndex:indexPath.row]];
	}
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* category;
	if (indexPath.row > 0) {
		category = [self.categories objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:[[SZSubcategoriesVC alloc] initWithCategory:category] animated:YES];
	}
	else {
		NSString* className = [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"Request" : @"Offer";
		PFQuery* query = [PFQuery queryWithClassName:className];
		[self.navigationController pushViewController:[[SZSearchResultsVC alloc] initWithQuery:query] animated:YES];
	}
}

@end
