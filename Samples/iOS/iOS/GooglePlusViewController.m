//
//  GooglePlusViewController.m
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/3/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "GooglePlusViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "Person+Request.h"
#import "Moment+Request.m"

@interface GooglePlusViewController ()

@end

@implementation GooglePlusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = ClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    [GPPSignIn sharedInstance].actions = [NSArray arrayWithObjects:
                                          @"http://schema.org/AddAction",
                                          @"http://schema.org/BuyAction",
                                          @"http://schema.org/CheckInAction",
                                          @"http://schema.org/CommentAction",
                                          @"http://schema.org/CreateAction",
                                          @"http://schema.org/ListenAction",
                                          @"http://schema.org/ReserveAction",
                                          @"http://schema.org/ReviewAction",
                                          nil];
    
    signIn.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark Google+ Signin

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    NSString *oauthToken = auth.accessToken;
    [[NSUserDefaults standardUserDefaults] setValue:oauthToken forKey:ClientAuthTokenKey];
    NSLog(@"AccessToken: %@", [[NSUserDefaults standardUserDefaults] valueForKey:ClientAuthTokenKey]);
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - Actions

- (IBAction)didPressGetPersonButton:(id)sender
{
    [Person personWithId:@"me" completion:^(Person *person, NSError *error) {
        NSLog(@"Person: %@", person);
    }];
}

- (IBAction)didPressPostMomentButton:(id)sender
{
    Moment *moment = [Moment objectInManagedObjectContext:[NSManagedObjectContext mainContext]];
    [moment saveWithCompletion:^(Moment *moment, NSError *error) {
        NSLog(@"Moment: %@", moment);
    }];
}
@end
