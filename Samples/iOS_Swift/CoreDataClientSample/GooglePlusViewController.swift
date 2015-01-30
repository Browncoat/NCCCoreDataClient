//
//  ViewController.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/18/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class GooglePlusViewController: UIViewController, GPPSignInDelegate {
    
    @IBOutlet var signInButton: GPPSignInButton!
    
    let clientId = "978903998184-mh9ot989abn0iv95qvti8oianos9ttfn.apps.googleusercontent.com"
    let clientAuthTokenKey = "auth_token"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let signIn: GPPSignIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true;
        //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        signIn.clientID = clientId;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        signIn.scopes = [ kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe ];  // "https://www.googleapis.com/auth/plus.login" scope
        //signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        signIn.actions = [
                            "http://schema.org/AddAction",
                            "http://schema.org/BuyAction",
                            "http://schema.org/CheckInAction",
                            "http://schema.org/CommentAction",
                            "http://schema.org/CreateAction",
                            "http://schema.org/ListenAction",
                            "http://schema.org/ReserveAction",
                            "http://schema.org/ReviewAction"
                        ];
        
        signIn.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark: G+
    
    func finishedWithAuth(auth: GTMOAuth2Authentication, error: NSError?) {
        println("Received error \(error) and auth object \(auth)");
        let oauthToken: NSString = auth.accessToken;
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(oauthToken, forKey: clientAuthTokenKey)
        println("AccessToken: \(userDefaults.valueForKey(clientAuthTokenKey))")
    }
    
    func didDisconnectWithError(error: NSError?) {
        //println(\(error))
    }
    
    //Mark: Actions
    
    @IBAction func didPressGetPersonButton(sender: AnyObject) {
        
    }
    
    @IBAction func didPressPostMomentButton(sender: AnyObject) {
        
    }
    /*
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
*/
}