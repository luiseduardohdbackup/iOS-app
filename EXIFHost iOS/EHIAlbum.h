//
//  EHIAlbum.h
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-03.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHIAlbum : NSObject {
	NSString *_albumDescription;
	NSUInteger albumId;
	BOOL _isPublic;
	NSString *_title;
}

+(NSArray *)myAlbums;

// Album properties
@property (retain) NSString *albumDescription;
@property (readonly) NSDate *createdOn;
@property (assign) BOOL isPublic;
@property (retain) NSString *title;
@property (readonly) NSDate *updatedOn;

// Picture methods
@property (readonly) NSArray *images;
-(void)addImage:(UIImage *)image;
-(void)removeImageAtIndex:(NSUInteger)index;
-(void)removeImageWithURL:(NSURL *)url;

@end
