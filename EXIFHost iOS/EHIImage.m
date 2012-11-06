//
//  EHIImage.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIImage.h"

@implementation EHIImage

@synthesize thumbURL;

-(id)initWithId:(NSUInteger)_imageId thumbnail:(NSURL *)_thumbURL
{
	self = [super init];
	if(self)
	{
		imageId = _imageId;
		self.thumbURL = _thumbURL;
	}
	return self;
}

@end
