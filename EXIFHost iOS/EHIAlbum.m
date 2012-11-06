//
//  EHIAlbum.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAlbum.h"
#import "EHIHelper.h"
#import "EHIImage+Private.h"

@interface EHIAlbum()

-(id)initWithJSONDictionary:(NSDictionary *)dict usingDateFormatter:(NSDateFormatter *)formatter;

@end



@implementation EHIAlbum

+(NSArray *)myAlbums
{
	// XXX
	// This method is BLOCKING
	// Perform it on another thread.
	// XXX
	
	NSArray *rawAlbums = [EHIHelper objectFromJSONAtURL:@"https://exifhost-codeblock.rhcloud.com/albums.json"];
	
	// Why do we allocate a formatter here?
	// Because it can take 300-400ms (literally) on-device to allocate this.
	// Doing it in a tight loop where there could be 30, maybe 40 albums is
	// a recipe for "LOL THIS APP SUCKS AND IS SLOW'.
	// Let's not suck.
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	NSMutableArray *albums = [NSMutableArray arrayWithCapacity:[rawAlbums count]];
	
	
	for(NSDictionary *rawAlbum in rawAlbums)
	{
		EHIAlbum *album = [[EHIAlbum alloc] initWithJSONDictionary:rawAlbum usingDateFormatter:dateFormatter];
		[albums addObject:album];
		[album release];
	}
	
	
	return albums;
}




#pragma mark - Private initialisation
-(id)initWithJSONDictionary:(NSDictionary *)dict usingDateFormatter:(NSDateFormatter *)formatter
{
	self = [super init];
	if(self)
	{
		_albumDescription = [[dict valueForKey:@"description"] retain];
		albumId = [[dict valueForKey:@"id"] unsignedIntegerValue];
		createdOn = [formatter dateFromString:[dict valueForKey:@"created_at"]];
		_isPublic = [[dict valueForKey:@"public"] boolValue];
		_title = [[dict valueForKey:@"title"] retain];
		updatedOn = [formatter dateFromString:[dict valueForKey:@"updated_at"]];
	}
	return self;
}




#pragma mark - Properties

@synthesize albumId, createdOn, updatedOn;


-(NSString *)description
{
	return [self title];
}


-(void)setAlbumDescription:(NSString *)albumDescription
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Editing the description of an album is not yet supported."];
}


-(NSString *)albumDescription
{
	return _albumDescription;
}


-(void)setIsPublic:(BOOL)isPublic
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Changing permissions on an album is not yet supported."];
}


-(BOOL)isPublic
{
	return _isPublic;
}


-(void)setTitle:(NSString *)title
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Editing the title of an album is not yet supported."];
}


-(NSString *)title
{
	return _title;
}




#pragma mark - Picture methods

-(NSArray *)images
{
	// XXX
	// This method is BLOCKING
	// Perform it on another thread.
	// XXX
	
	NSDictionary *rawAlbum = [EHIHelper objectFromJSONAtURL:[NSString stringWithFormat:@"https://exifhost-codeblock.rhcloud.com/albums/%d.json", albumId]];
	
	NSMutableArray *images = [NSMutableArray arrayWithCapacity:[[rawAlbum objectForKey:@"images"] count]];
	
	for(NSDictionary *rawImage in [[rawAlbum objectForKey:@"album"] objectForKey:@"images"])
	{
		// because Ruby sucks sometimes.  only sometimes.
		NSDictionary *realRawImage = [rawImage valueForKey:@"image"];
		EHIImage *image = [[EHIImage alloc] initWithId:[[realRawImage valueForKey:@"id"] unsignedIntegerValue]
						     thumbnail:[NSURL URLWithString:[realRawImage valueForKey:@"thumbnail"]]];
		[images addObject:image];
	}
	
	return images;
}


-(void)addImage:(UIImage *)image
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Editing of pictures in an album is not yet supported."];
}


-(void)removeImageAtIndex:(NSUInteger)index
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Editing of pictures in an album is not yet supported."];
}


-(void)removeImageWithURL:(NSURL *)url
{
	[NSException raise:@"NotImplementedExceptioN" format:@"Editing of pictures in an album is not yet supported."];
}

@end
