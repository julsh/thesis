//
//  SZSubcategoriesVC.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSubcategoriesVC.h"
#import "SZUtils.h"
#import "SZCategoryCell.h"
#import "SZDataManager.h"
#import "SZSearchResultsVC.h"

@interface SZSubcategoriesVC ()

@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSArray* subcategories;

@end

@implementation SZSubcategoriesVC


- (id)initWithCategory:(NSString*)category {
	self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
		self.category = category;
		
		if (self.category) {
			NSMutableArray* subcategories = [NSMutableArray arrayWithObject:[NSNull null]];
			[subcategories addObjectsFromArray:[SZDataManager sortedSubcategoriesForCategory:category]];
			self.subcategories = subcategories;
		}
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Select a Subcategory"];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [self.subcategories count];
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
		NSString* offersOrRequests = [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"Requests" : @"Offers";
		if (self.category) {
			[cell.textLabel setText:[NSString stringWithFormat:@"All %@ %@", self.category, offersOrRequests]];
		}
		else {
			[cell.textLabel setText:[NSString stringWithFormat:@"All %@", offersOrRequests]];
		}
		[cell.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:16.0]];
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
		if (cell == nil) {
			cell = [[SZCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCell];
		}
		[cell.textLabel setText:[self.subcategories objectAtIndex:indexPath.row]];
	}
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* entryType = [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"request" : @"offer";
	PFQuery* query = [PFQuery queryWithClassName:@"Entry"];
	[query whereKey:@"entryType" equalTo:entryType];
	
	if (self.category) {
		[query whereKey:@"category" equalTo:self.category];
	}
	if (indexPath.row > 0) [query whereKey:@"subcategory" equalTo:[self.subcategories objectAtIndex:indexPath.row]];
	
	[self.navigationController pushViewController:[[SZSearchResultsVC alloc] initWithQuery:query] animated:YES];
}

@end