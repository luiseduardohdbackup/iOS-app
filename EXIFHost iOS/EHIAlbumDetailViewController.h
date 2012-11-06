//
//  EHIAlbumDetailViewController.h
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHIAlbum.h"
#import "LazyImage.h"

@interface EHIAlbumDetailViewController : UITableViewController <LazyImageDelegate> {
	EHIAlbum *album;
	NSArray *images;
	NSMutableDictionary *thumbs, *downloads;
}

-(id)initWithAlbum:(EHIAlbum *)album;

@end
