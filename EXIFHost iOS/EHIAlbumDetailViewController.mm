//
//  EHIAlbumDetailViewController.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAlbumDetailViewController.h"
#import "EHIImage.h"
#import <libGwen/WTMIMEEncoder.h>

@interface EHIAlbumDetailViewController ()

-(void)addPhoto:(id)action;
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




#pragma mark - Image picker controller delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
	{
		// Write the original picture to Photos, only if camera was used
		UIImage *original = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		UIImageWriteToSavedPhotosAlbum(original, nil, nil, nil);
	}
	
	UIImage *edited = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	
	vector<WTMIMEAttachment *> attachments;
	
	/********************
	 ******************** Album ID ********************
	                               ********************/
	NSString *albumIdString = [NSString stringWithFormat:@"%d", [album albumId]];
	
	WTMIMEAttachment *attachment = new WTMIMEAttachment;
	attachment->data.buffer = [albumIdString UTF8String];
	attachment->datatype = MIME_DATATYPE_BUFFER;
	attachment->disposition = MIME_DISPOSITION_FORM;
	attachment->extra_disposition = "; name=\"image[album_id]\"";
	attachment->transfer_enc = MIME_TRANSFER_7BIT;
	attachment->length = [albumIdString length];
	attachment->type = "text/plain";
	
	attachments.push_back(attachment);
	
	/********************
	 ******************** Title ********************
				    ********************/
	attachment = new WTMIMEAttachment;
	attachment->data.buffer = "Test Image from iOS App";
	attachment->datatype = MIME_DATATYPE_BUFFER;
	attachment->disposition = MIME_DISPOSITION_FORM;
	attachment->extra_disposition = "; name=\"image[title]\"";
	attachment->transfer_enc = MIME_TRANSFER_7BIT;
	attachment->length = 23;
	attachment->type = "text/plain";
	
	attachments.push_back(attachment);
	
	/********************
	 ******************** Description ********************
				          ********************/
	attachment = new WTMIMEAttachment;
	attachment->data.buffer = "Test Image from iOS App";
	attachment->datatype = MIME_DATATYPE_BUFFER;
	attachment->disposition = MIME_DISPOSITION_FORM;
	attachment->extra_disposition = "; name=\"image[description]\"";
	attachment->transfer_enc = MIME_TRANSFER_7BIT;
	attachment->length = 23;
	attachment->type = "text/plain";
	
	attachments.push_back(attachment);
	
	/********************
	 ******************** Public ********************
				     ********************/
	attachment = new WTMIMEAttachment;
	attachment->data.buffer = "1";
	attachment->datatype = MIME_DATATYPE_BUFFER;
	attachment->disposition = MIME_DISPOSITION_FORM;
	attachment->extra_disposition = "; name=\"image[public]\"";
	attachment->transfer_enc = MIME_TRANSFER_7BIT;
	attachment->length = 1;
	attachment->type = "text/plain";
	
	attachments.push_back(attachment);
	
	
	/********************
	 ******************** Image ********************
	                            ********************/
	NSData *imageData = UIImageJPEGRepresentation(edited, 0.87);
	
	attachment = new WTMIMEAttachment;
	attachment->data.buffer = [imageData bytes];
	attachment->datatype = MIME_DATATYPE_BUFFER;
	attachment->disposition = MIME_DISPOSITION_FORM;
	attachment->extra_disposition = "; name=\"image[image]\"";
	attachment->transfer_enc = MIME_TRANSFER_BINARY;
	attachment->length = [imageData length];
	attachment->type = "image/jpeg";
	
	attachments.push_back(attachment);
	
	
	
	// upload to EXIFHost	
	WTConnection *connection = new WTConnection(NULL);
	if(!connection->connect("https://exifhost-codeblock.rhcloud.com/images"))
	{
		NSLog(@"Failed to connect");
		return;
	}
	
	uint64_t result_len = 0;
	char *result = static_cast<char *>(WTMIMEEncoder::encode_multiple_to_url(attachments, connection, &result_len));
	
	NSLog(@"%s", result);
	
	// no longer need picture data or attachment
	for(NSUInteger i = 0; i < attachments.size(); i++)
		delete attachments.at(i);
	
	free(result);
	connection->disconnect();
	
	
	/*AuXBridge *bridge = [[AuXBridge alloc] initCall:AuUploadPicture
					       withData:[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithPointer:site],@"site",[NSData dataWithData:UIImageJPEGRepresentation(edited, 0.87)],@"imageData",nil]
					       delegate:self];
	[queue addOperation:bridge];
	[bridge release];
	
	[[loadingView textLabel] setText:@"Uploading"];
	[loadingView setLoading:YES];
	[loadingView show];
	 */
	
	[self dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}




#pragma mark - Action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	
	if([picker respondsToSelector:@selector(setAllowsEditing:)])
		[picker setAllowsEditing:YES];
	else
		[picker setAllowsImageEditing:YES];
	[picker setDelegate:self];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) --buttonIndex;
	
	switch(buttonIndex)
	{
		case -1:
			[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
			break;
		case 0:
			[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			break;
		default:
			[picker release];
			return;
	}
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}




#pragma mark - Actions

-(void)addPhoto:(id)action
{
	UIActionSheet *sheet;
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		sheet = [[UIActionSheet alloc] initWithTitle:nil
						    delegate:self
					   cancelButtonTitle:@"Cancel"
				      destructiveButtonTitle:nil
					   otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
	else
		sheet = [[UIActionSheet alloc] initWithTitle:nil
						    delegate:self
					   cancelButtonTitle:@"Cancel"
				      destructiveButtonTitle:nil
					   otherButtonTitles:@"Choose Photo", nil];
	
	[sheet showFromTabBar:self.tabBarController.tabBar];
	[sheet release];
}




#pragma mark - View lifecycle

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[self performSelectorInBackground:@selector(loadImages) withObject:nil];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhoto:)] autorelease];
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
