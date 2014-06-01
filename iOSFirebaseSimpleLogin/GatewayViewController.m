//
//  GatewayViewController.m
//  Up100
//
//  Created by Prashant Khanduri on 5/31/14.
//
//

#import "GatewayViewController.h"
#import "FirebaseManager.h"
#import "LoggedInViewController.h"
#import "UIImage+Embross.h"
#import "ProgressHUD.h"

@interface GatewayViewController ()
{
	NSArray *accounts;
	NSInteger selected;
}

@end

@implementation GatewayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    [self setViewItems];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Create a reference to a Firebase location
    
    [ProgressHUD show:kMessageLogginInPleaseWait];
    
    FirebaseSimpleLogin * authClient = [[FirebaseManager sharedInstance] authClient];
    [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            // Oh no! There was an error performing the check
            [self setViewItems];
            
        } else if (user == nil) {
            // No user is logged in
            [self setViewItems];
            
        } else {
            // There is a logged in user
            [self logUserIn: user];
            
        }
    }];
}

- (void)logUserIn: (FAUser*) user {
    
    [ProgressHUD dismiss];
    
    LoggedInViewController *vc = [[LoggedInViewController alloc] init];
    vc.user = user;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)anonymousLoginTriggered:(UIButton*)button
{
    [ProgressHUD show:kMessageLogginInPleaseWait];

    FirebaseSimpleLogin * authClient = [[FirebaseManager sharedInstance] authClient];
    [authClient loginAnonymouslywithCompletionBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            // There was an error logging in to this account
            [self setViewItems];
        } else {
            // We are now logged in
            [self logUserIn: user];
        }
        [ProgressHUD dismiss];
    }];
}


- (void)fbLoginTriggered:(UIButton*)button
{
    [ProgressHUD show:kMessageLogginInPleaseWait];
    
    FirebaseSimpleLogin * authClient = [[FirebaseManager sharedInstance] authClient];
    [authClient loginToFacebookAppWithId:kFacebookAppID
                             permissions:kFacebookPermissionsLogin
                                audience:ACFacebookAudienceOnlyMe
                     withCompletionBlock:^(NSError *error, FAUser *user) {
                         
                         if (error != nil) {
                             // There was an error logging in
                             [self setViewItems];
                             
                         } else {
                             // We have a logged in facebook user
                             [self logUserIn: user];
                             
                         }
                         [ProgressHUD dismiss];

                     }];
}


- (void)twLoginTriggered:(UIButton*)button
{
    [ProgressHUD show:kMessageLogginInPleaseWait];
    
 	selected = 0;
	ACAccountStore *account = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	[account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             accounts = [account accountsWithAccountType:accountType];
             if ([accounts count] == 0)
                 [self performSelectorOnMainThread:@selector(showError:) withObject:@"No Twitter account was found" waitUntilDone:NO];
             if ([accounts count] == 1)	[self performSelectorOnMainThread:@selector(loginTwitter) withObject:nil waitUntilDone:NO];
             if ([accounts count] >= 2)	[self performSelectorOnMainThread:@selector(selectTwitter) withObject:nil waitUntilDone:NO];
         }
         else [self performSelectorOnMainThread:@selector(showError:) withObject:@"Access to Twitter account was not granted" waitUntilDone:NO];
     }];
}

- (void)showError:(id)message
{
	[[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)selectTwitter
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter account" delegate:self cancelButtonTitle:nil
										  destructiveButtonTitle:nil otherButtonTitles:nil];
	for (NSInteger i=0; i<[accounts count]; i++)
	{
		ACAccount *account = [accounts objectAtIndex:i];
		[action addButtonWithTitle:account.username];
	}
	[action addButtonWithTitle:@"Cancel"];
	action.cancelButtonIndex = accounts.count;
	[action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		selected = buttonIndex;
		[self loginTwitter];
	}
}

- (void)loginTwitter
{
    FirebaseSimpleLogin * authClient = [[FirebaseManager sharedInstance] authClient];
	[authClient loginToTwitterAppWithId:kTwitterAppID multipleAccountsHandler:^int(NSArray *usernames)
     {
         return selected;
     }
                    withCompletionBlock:^(NSError *error, FAUser *user)
     {
         if (error == nil) {
             [self logUserIn: user];
         } else {
             [self setViewItems];
         }
     }];
}


- (void) setViewItems
{
    [ProgressHUD dismiss];
    
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }

    // GOOD: 01 : 04 : 05 : 06 : 09
    UIImage *img = [UIImage imageNamed:@"09.png"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView];
    
    // Your logo
    // TODO: make the logo 110 pixels
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [loginImage setImage:[UIImage imageNamed:@"logoclubby.png"]];
    // TODO: think about the hardcoded 120 here
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.view addSubview:loginImage];

    // Facebook button
    UIButton * fbLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fbLoginButton addTarget:self
                      action:@selector(fbLoginTriggered:)
            forControlEvents:UIControlEventTouchUpInside];
    fbLoginButton.frame = CGRectMake(0.0, 0.0, 250.0, 50.0);
    fbLoginButton.center = CGPointMake(self.view.frame.size.width/2, 400);
    [self.view addSubview:fbLoginButton];
    [fbLoginButton setBackgroundImage:[UIImage imageNamed:@"fb.png"] forState: UIControlStateNormal];
    [fbLoginButton setAlpha:0.8];
    
    // Twitter button
    UIButton * twLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [twLoginButton addTarget:self
                      action:@selector(twLoginTriggered:)
            forControlEvents:UIControlEventTouchUpInside];
    twLoginButton.frame = CGRectMake(0.0, 0.0, 250.0, 50.0);
    twLoginButton.center = CGPointMake(self.view.frame.size.width/2, 470);
    [self.view addSubview:twLoginButton];
    [twLoginButton setBackgroundImage:[UIImage imageNamed:@"tw.png"] forState: UIControlStateNormal];
    [twLoginButton setAlpha:0.8];

    // Anonymous login
    UIButton * anonLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [anonLoginButton addTarget:self
                        action:@selector(anonymousLoginTriggered:)
              forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(0.0, 0.0, 80.0, 20.0);
    anonLoginButton.frame = rect;
    [anonLoginButton setAlpha:0.3];
    anonLoginButton.center = CGPointMake(self.view.frame.size.width/2, 530);
    UIColor * interiorShadow = [UIColor colorWithWhite:.9 alpha:.1];
    UIColor * upwardShadow = [UIColor colorWithWhite:0.9 alpha:.15];
    UIImage *finalImage = [UIImage imageWithInteriorShadow:interiorShadow
                                              upwardShadow:upwardShadow
                                                    string:@"Skip Login"
                                                      font:[UIFont systemFontOfSize:15]
                                                 textColor:[UIColor whiteColor]
                                                      size:rect.size];
    [anonLoginButton setBackgroundImage:finalImage forState: UIControlStateNormal];
//    [[anonLoginButton layer] setBorderWidth:1.0];
//    [[anonLoginButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:anonLoginButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
