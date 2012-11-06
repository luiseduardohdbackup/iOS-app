//
//  EHIImage.h
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHIImage : NSObject {
	NSUInteger imageId;
	NSURL *thumbURL;
}

@property (retain) NSURL *thumbURL;

@end
