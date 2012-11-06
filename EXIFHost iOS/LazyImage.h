//
//  LazyImage.h
//  General utility
//
//  Created by Andrew Wilcox on 04/08/2010.
//  Copyright 2010 Wilcox Technologies. All rights reserved.
//
/*
 Loosely based on LazyTableImages, a sample project from Apple
 Found in the Xcode 3.2 iPhone SDK 3.0 documentation library
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */
/*
 Lazy Image Downloading for iOS Apps
 Originally developed for Findalike IAP controller
 General utility class (drop into any app)
 
 Copyright (c) 2010-2012 Wilcox Technologies LLC.
 All rights reserved.
 
 Developed by: iPhone Software Engineering Team
               Wilcox Technologies LLC
               http://oss.wilcox-tech.com/
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal with the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject
 to the following conditions:
 
 Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimers.
 
 Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimers in
 the documentation and/or other materials provided with the distribution.
 
 Neither the names of Wilcox Technologies, LLC nor the names of its
 contributors may be used to endorse or promote products derived from this
 Software without specific prior written permission.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

@protocol LazyImageDelegate <NSObject>

-(void)lazyImage:(id)lazy didLoad:(UIImage *)image forObject:(id)object;
-(void)lazyImage:(id)lazy forObject:(id)object didFailWithError:(NSError *)error;

@end


@interface LazyImage : NSObject {
	NSMutableData *picData;
	NSURLConnection *picConn;
	UIImage *image;
	BOOL picInProgress;
	NSObject <LazyImageDelegate> *delegate;
	id object;
	CGFloat width;
	CGFloat height;
	BOOL cancelled;
}

-(BOOL)loadImage:(NSURL *)url forObject:(id)newObject withWidth:(CGFloat)newWidth withHeight:(CGFloat)newHeight withDelegate:(NSObject <LazyImageDelegate> *)newDelegate;
-(BOOL)loadImage:(NSURL *)url forObject:(id)newObject withDelegate:(NSObject <LazyImageDelegate> *)newDelegate;
-(void)cancel;
-(BOOL)isCancelled;

@property (nonatomic,retain) id <LazyImageDelegate> delegate;

@end
