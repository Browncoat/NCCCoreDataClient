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

struct Authentication {
    static var clientId = ""
    static var clientAuthTokenKey = "auth_token"
}

class GooglePlusViewController: UIViewController, GPPSignInDelegate {
    
    @IBOutlet weak var signInButton: GPPSignInButton!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var postConfirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let signIn: GPPSignIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true;
        //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        signIn.clientID = Authentication.clientId;
        
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
        userDefaults.setValue(oauthToken, forKey: Authentication.clientAuthTokenKey)
        println("AccessToken: \(userDefaults.valueForKey(Authentication.clientAuthTokenKey))")
    }
    
    func didDisconnectWithError(error: NSError?) {
        //println(\(error))
    }
    
    //Mark: Actions
    
    @IBAction func didPressGetPersonButton(sender: AnyObject) {
        Person.personWithId("me", completion: { (person, error) -> () in
            if error != nil {
                let alert = UIAlertController(title: "Network Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                if let thePerson = person {
                    self.displayNameLabel.text = thePerson.displayName
                    println("Person: \(thePerson)")
                }
            }
        })
    }
    
    @IBAction func didPressPostMomentButton(sender: AnyObject) {
        let moment: Moment = Moment(inManagedObjectContext: NSManagedObjectContext.mainContext())
        moment.saveMomentWithCompletion { (results, error) -> () in
            if (error == nil) {
                self.postConfirmationLabel.text = "View your posts at https://plus.google.com/apps"
            } else {
                self.postConfirmationLabel.text = "Oops, didn't work."
            }
        }
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