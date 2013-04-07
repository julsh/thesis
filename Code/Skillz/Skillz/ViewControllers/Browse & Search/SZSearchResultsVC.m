//
//  SZSearchResultsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSearchResultsVC.h"
#import "SZSearchResultCell.h"
#import "SZEntryVO.h"
#import "SZUtils.h"
#import "MBProgressHUD.h"
#import "SZEntryDetailVC.h"
#import "SZDataManager.h"

@interface SZSearchResultsVC ()

@property (nonatomic, strong) NSMutableArray* results;
@property (nonatomic, assign) NSInteger fetchCount;
@property (nonatomic, strong) UIView* activityIndicator;

@end

@implementation SZSearchResultsVC

@synthesize results = _results;
@synthesize activityIndicator = _activityIndicator;

- (id)initWithQuery:(PFQuery*)query {
	
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

		[self showActivityIndicator];
		
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects) {
				if ([objects count] > 0) { // found something!
					for (int i = 0; i < [objects count]; i++) {
						PFObject* result = [objects objectAtIndex:i];
						if ([[result objectForKey:@"isActive"] boolValue]) { // only display if entry is activated
							
							PFUser *user = [result objectForKey:@"user"]; // fetch the user object that owns the entry
							[user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
								if (object) {
									[self.results addObject:[SZEntryVO entryVOFromPFObject:result user:(PFUser*)object]];
									self.fetchCount++;
									if (self.fetchCount == [objects count]) {
										[self hideActivityIndicator];
										[self.tableView reloadData]; // once all results are complete, display them
									}
								}
								else if (error) {
									NSLog(@"Error: %@ %@", error, [error userInfo]);
									self.fetchCount++;
									if (self.fetchCount == [objects count]) {
										[self hideActivityIndicator];
										[self.tableView reloadData];
									}
								}
							}];
						}
						
					}
				}
				else { // nothing found
					[self hideActivityIndicator];
					[self showNothingFound];
				}
			}
			else if (error) {
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
		}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Results"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (NSMutableArray*)results {
	if (_results == nil) {
		_results = [[NSMutableArray alloc] init];
	}
	return _results;
}

- (void)showActivityIndicator {
	
	if (_activityIndicator == nil) {
		_activityIndicator = [[UIView alloc] initWithFrame:CGRectMake(100.0, 160.0, 120.0, 120.0)];
		
		UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[spinner setCenter:CGPointMake(60.0, 30.0)];
		[spinner startAnimating];
		[_activityIndicator addSubview:spinner];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 120.0, 20.0)];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:16.0]];
		[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
		[label applyWhiteShadow];
		[label setText:@"Loading"];
		[_activityIndicator addSubview:label];
		
	}
	
	[self.tableView addSubview:self.activityIndicator];
}

- (void)hideActivityIndicator {
	
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
}

- (void)showNothingFound {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 160.0, 320.0, 80.0)];
	[label setNumberOfLines:0];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:30.0]];
	[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
	[label applyWhiteShadow];
	[label setText:@"No results\nfound"];
	[self.tableView addSubview:label];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.results count];
}

- (SZSearchResultCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"resultCell";
	
	SZSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	SZEntryVO *entry = [self.results objectAtIndex:indexPath.row];
	
	cell.titleLabel.text = entry.title;

	NSString* category = entry.category;
	if (entry.subcategory) category = [category stringByAppendingFormat:@" > %@", entry.subcategory];
	cell.categoryLabel.text = category;
	
	if (entry.priceIsNegotiable) {
		cell.pointsLabel.text = @"negotiable";
	}
	else {
		if (entry.price) {
			cell.pointsLabel.text = [NSString stringWithFormat:@"%i/%@", [entry.price intValue], entry.priceIsFixedPerHour ? @"hour" : @"job"];
		}
	}
	
	if ([entry.user objectForKey:@"firstName"]) {
		cell.userName.text = [entry.user objectForKey:@"firstName"];
	}
	
	PFFile* photo = [entry.user objectForKey:@"photo"];
	[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (data) {
			UIImage* img = [UIImage imageWithData:data];
			[cell.userPhoto.photo setImage:img];
		}
		else if (error) {
			NSLog(@"ERORRRR %@", error);
		}
	}];

	if ([entry.user objectForKey:@"reviewPoints"]) {
		[cell.starsView setStarsForReviewsArray:[entry.user objectForKey:@"reviewPoints"]];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 114.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SZEntryVO* request = [self.results objectAtIndex:indexPath.row];
	SZEntryDetailVC* vc = [[SZEntryDetailVC alloc] initWithEntry:request type:[SZDataManager sharedInstance].currentEntryType];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)setUserPhoto:(UIImage*)photo forCellAtIndex:(NSInteger)index {
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	SZSearchResultCell* cell = (SZSearchResultCell*)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell.userPhoto.photo setImage:photo];
	
}

@end
