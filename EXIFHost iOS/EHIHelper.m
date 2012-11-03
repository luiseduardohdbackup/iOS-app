//
//  EHIHelper.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIHelper.h"
#import "SBJson.h"

@implementation EHIHelper

+(id)objectFromJSONAtURL:(NSString *)url
{
	// XXX
	// This method is BLOCKING
	// Perform it on another thread.
	// XXX
	
	NSError *error = nil;
	NSURLResponse *response = nil;
	
	
	// Download the JSON
	NSURL *endpoint = [NSURL URLWithString:url];
	NSURLRequest *albumRequest = [NSURLRequest requestWithURL:endpoint
						      cachePolicy:NSURLRequestReloadRevalidatingCacheData
						  timeoutInterval:15.0];
	NSData *jsonData = [NSURLConnection sendSynchronousRequest:albumRequest returningResponse:&response error:&error];
	
	if(jsonData == nil || error != nil || [jsonData length] == 0)
	{
		return nil;
	}
	
	
	// Turn it into usable data
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	id object = [parser objectWithData:jsonData];
	[parser release];
	
	return object;
}

@end
