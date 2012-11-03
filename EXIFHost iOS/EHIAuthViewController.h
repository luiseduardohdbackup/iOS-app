//
//  EHIAuthViewController.h
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-02.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHIAuthViewController : UIViewController <UITextFieldDelegate>

-(void)signInTapped:(id)action;

@property (nonatomic, assign) IBOutlet UITextField *emailField;
@property (nonatomic, assign) IBOutlet UITextField *passwordField;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
