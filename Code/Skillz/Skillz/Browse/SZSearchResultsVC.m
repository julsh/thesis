//
//  SZSearchResultsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSearchResultsVC.h"
#import "SZEntryCell.h"
#import "SZEntryVO.h"

@interface SZSearchResultsVC ()

@property (nonatomic, strong) NSMutableArray* results;

@end

@implementation SZSearchResultsVC

@synthesize results = _results;

- (id)initWithQuery:(PFQuery*)query {
	
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (!error) {
				// The find succeeded.
				NSLog(@"Success! %@", objects);
				for (PFObject* object in objects) {
					PFUser *user = [object objectForKey:@"user"];
					[user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
						NSLog(@"got user");
						[self.results addObject:[SZEntryVO entryVOFromPFObject:object user:(PFUser*)object address:nil]];
						[self.tableView reloadData];
					}];
//					PFObject *address = [object objectForKey:@"address"];
//					if ((NSObject*)address != [NSNull null]) {
//						[address fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//							NSLog(@"got address");
//						}];
//						
//					}
				}
			} else {
				// Log details of the failure
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"entryCell";
	
	SZEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZEntryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	SZEntryVO *result = [self.results objectAtIndex:indexPath.row];

	cell.textLabel.text = result.title;
//
//	NSString* category = request.category;
//	if (request.subcategory) category = [category stringByAppendingFormat:@" > %@", request.subcategory];
//	cell.detailTextLabel.text = category;
//	
//	cell.activeSwitch.on = request.isActive;
//	[cell.activeSwitch setTag:indexPath.row - 1];
//	[cell.activeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//	
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
