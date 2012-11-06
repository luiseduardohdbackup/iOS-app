//
//  EHIAlbumDetailViewController.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAlbumDetailViewController.h"
#import "EHIImage.h"

@interface EHIAlbumDetailViewController ()

-(void)loadImages;
-(void)imagesLoaded;

@end

@implementation EHIAlbumDetailViewController

-(id)initWithAlbum:(EHIAlbum *)_album
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if(self)
	{
		album = [_album retain];
		downloads = [[NSMutableDictionary alloc] init];
		thumbs = [[NSMutableDictionary alloc] init];
	}
	return self;
}


-(void)dealloc
{
	[thumbs release];
	[downloads release];
	[album release];
	[super dealloc];
}




#pragma mark - Album info downloading

-(void)imagesLoaded
{
	[self.tableView reloadData];
}


-(void)loadImages
{
	images = [[album images] retain];
	[self performSelectorOnMainThread:@selector(imagesLoaded) withObject:nil waitUntilDone:NO];
}




#pragma mark - View lifecycle

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[self performSelectorInBackground:@selector(loadImages) withObject:nil];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhoto:)] autorelease];
}




#pragma mark - Lazy image downloading

-(void)startDownloadForIndexPath:(NSIndexPath *)indexPath
{
	LazyImage *lazyImage = [downloads objectForKey:indexPath];
	EHIImage *image = [images objectAtIndex:[indexPath row]];
	if(lazyImage == nil || [lazyImage isCancelled])
	{
		if([image thumbURL] == nil)
		{
			[self lazyImage:nil didLoad:nil forObject:indexPath];
			return;
		}
		
		if(lazyImage == nil)
		{
			lazyImage = [[LazyImage alloc] init];
			[downloads setObject:lazyImage forKey:indexPath];
			[lazyImage release];
		}
		[lazyImage loadImage:[image thumbURL] forObject:indexPath withWidth:80.0 withHeight:80.0 withDelegate:self];
	}
}


-(void)lazyImage:(LazyImage *)lazy didLoad:(UIImage *)image forObject:(id)object
{
	[thumbs setObject:image forKey:object];
	if([[self.tableView indexPathsForVisibleRows] containsObject:object])
	{
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:object] withRowAnimation:UITableViewRowAnimationNone];
	}
}


-(void)lazyImage:(LazyImage *)lazy forObject:(id)object didFailWithError:(NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
}




#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [images count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	EHIImage *model = [images objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = @"Image";
	
	UIImage *image = [thumbs objectForKey:indexPath];
	if(image == nil)
	{
		cell.imageView.image = nil;
		[self startDownloadForIndexPath:indexPath];
	}
	else
	{
		cell.imageView.image = image;
	}
	
	
	return cell;
}

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
	 [detailViewController release];
	 */
}

@end
