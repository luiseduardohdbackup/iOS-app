//
//  EHIAuthViewController.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-02.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAuthViewController.h"

@interface EHIAuthViewController ()

-(void)setSignInItemsEnabled:(BOOL)enabled;
-(void)showAlertWithIssue:(NSString *)issueDescription;

@end

@implementation EHIAuthViewController

#pragma mark - Properties

@synthesize emailField, passwordField, activityIndicator;

-(void)setSignInItemsEnabled:(BOOL)enabled
{
	self.navigationItem.rightBarButtonItem.enabled = enabled;
	self.emailField.enabled = self.passwordField.enabled = enabled;
	
	if(enabled)
	{
		[activityIndicator stopAnimating];
	}
	else
	{
		[activityIndicator startAnimating];
	}
}




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
	
	NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
	
	if(email != nil)
	{
		self.emailField.text = email;
	}
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Actions

-(void)signInTapped:(id)action
{
	[[UIApplication sharedApplication] resignFirstResponder];
	
	[self setSignInItemsEnabled:NO];
	
	NSMutableURLRequest *authRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://exifhost-codeblock.rhcloud.com/users/sign_in"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0];
	[authRequest setHTTPMethod:@"POST"];
	[authRequest setHTTPBody:[[NSString stringWithFormat:@"user[email]=%@&user[password]=%@&user[remember_me]=0&user[remember_me]=1&commit=Sign+in", self.emailField.text, self.passwordField.text] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:authRequest delegate:self];
	if(!connection)
	{
		[self showAlertWithIssue:@"Cannot connect to EXIFHost."];
		[self setSignInItemsEnabled:YES];
	}
	
	[authRequest release];
}


-(void)showAlertWithIssue:(NSString *)issueDescription
{
	UIAlertView *ohCrap = [[UIAlertView alloc] initWithTitle:@"Cannot Sign In"
							 message:issueDescription
							delegate:nil
					       cancelButtonTitle:@"Dismiss"
					       otherButtonTitles:nil];
	[ohCrap show];
	[ohCrap release];
}




#pragma mark - Connection delegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self showAlertWithIssue:@"There may be a network issue.  Please try again later."];
	[self setSignInItemsEnabled:YES];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if([[[response URL] lastPathComponent] compare:@"sign_in"] == NSOrderedSame)
	{
		authSuccess = NO;
	}
	else
	{
		authSuccess = YES;
	}
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if(!authSuccess)
	{
		[self showAlertWithIssue:@"Invalid email or password.  Try signing in again."];
		[self setSignInItemsEnabled:YES];
	}
	else
	{
		NSURLCredential *credential = [NSURLCredential credentialWithUser:self.emailField.text
									 password:self.passwordField.text
								      persistence:NSURLCredentialPersistencePermanent];
		
		NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
							 initWithHost:@"exifhost-codeblock.rhcloud.com"
							 port:0
							 protocol:@"https"
							 realm:nil
							 authenticationMethod:nil];
		
		
		[[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential
								    forProtectionSpace:protectionSpace];
		[protectionSpace release];
		[self dismissModalViewControllerAnimated:YES];
	}
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
	
	return YES;
}


@end
