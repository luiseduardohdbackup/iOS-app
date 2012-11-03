//
//  EHIAuthViewController.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-02.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAuthViewController.h"

@interface EHIAuthViewController ()

@end

@implementation EHIAuthViewController

#pragma mark - Properties

@synthesize emailField, passwordField, activityIndicator;




#pragma mark - View lifecycle

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	UIBarButtonItem *signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In"
									 style:UIBarButtonItemStyleDone
									target:self
									action:@selector(signInTapped:)];
	signInButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = signInButton;
	[signInButton release];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Actions

-(void)signInTapped:(id)action
{
	[[UIApplication sharedApplication] resignFirstResponder];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.emailField.enabled = self.passwordField.enabled = NO;
	
	[activityIndicator startAnimating];
	// Sign in…
}




#pragma mark - Text field delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if(self.emailField.text.length > 0 && self.passwordField.text.length > 0)
		self.navigationItem.rightBarButtonItem.enabled = YES;
	
	return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == self.emailField)
	{
		[passwordField becomeFirstResponder];
	}
	 else if(textField == self.passwordField)
	{
		[passwordField resignFirstResponder];
		[self signInTapped:passwordField];
	}
}


@end
