//
//  EHIAlbumsViewController.h
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHIAlbumsViewController : UITableViewController <NSURLConnectionDelegate> {
	NSArray *albums;
}

@property (nonatomic, retain) NSArray *albums;

@end
