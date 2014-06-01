//
//  LoggedInViewController.m
//  Up100
//
//  Created by Prashant Khanduri on 5/31/14.
//
//

#import "LoggedInViewController.h"
#import "FirebaseManager.h"
#import "GatewayViewController.h"
#import "UIImage+Embross.h"

@interface LoggedInViewController ()

@end

@implementation LoggedInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view.

    [self setViewItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) logoutUser:(UIButton*) sender {
    FirebaseSimpleLogin * authClient = [[FirebaseManager sharedInstance] authClient];
    [authClient logout];
    
    GatewayViewController * vc = [[GatewayViewController alloc] init];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) setViewItems
{
    UILabel * userIdentification = [[UILabel alloc] init];
    userIdentification.text = self.user.thirdPartyUserData[@"uid"];
    userIdentification.textAlignment = NSTextAlignmentCenter;
    userIdentification.textColor = [UIColor colorWithRed:240.0/255.0 green:60.0/255.0 blue:2.0/255.0 alpha:1.0];
    userIdentification.frame = CGRectMake(0.0, 0.0, 300.0, 20.0);
    userIdentification.center = CGPointMake(self.view.frame.size.width/2, 240);
    [self.view addSubview:userIdentification];
    
    UIButton * logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logout addTarget:self action:@selector(logoutUser:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(0.0, 0.0, 56.0, 20.0);
    logout.frame = rect;
    [logout setAlpha:0.3];
    logout.center = CGPointMake(self.view.frame.size.width/2, 540);
    UIColor * interiorShadow = [[UIColor redColor] colorWithAlphaComponent:1];
    UIColor * upwardShadow = [UIColor colorWithWhite:0.2 alpha:.15];
    UIImage *finalImage = [UIImage imageWithInteriorShadow:interiorShadow
                                              upwardShadow:upwardShadow
                                                    string:@"Logout"
                                                      font:[UIFont systemFontOfSize:15]
                                                 textColor:[UIColor redColor]
                                                      size:rect.size];
    [logout setBackgroundImage:finalImage forState: UIControlStateNormal];
//    [[logout layer] setBorderWidth:1.0f];
//    [[logout layer] setBorderColor:[UIColor greenColor].CGColor];
    [self.view addSubview:logout];

}

@end
