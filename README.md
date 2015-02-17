NCCCoreDataClient is a set of Categories to make working with Core Data and Restful API's composable, loosely coupled and easier. Each NSManagedObject should take care of it's own request and data parsing from the web. It has been designed so that you have direct access to the NSMutableURLRequest from the NSManagedObject model and you can send that request with any HTTP Client you choose.

## How To Get Started

- [Download NCCCoreDataClient](https://github.com/Browncoat/NCCCoreDataClient/archive/master.zip) and try out the included iPhone example app

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/ncccoredataclient). (Tag 'ncccoredataclient')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/ncccoredataclient).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Requirements
iOS 5.1+

## Usage

#### To use with Swift

Add `<Product_Name>-Bridging-Header.h` to your project. Add `#import "NCCCoreDataClient.h` to Bridging-Header. Make sure that each entity in your core data xcdatamodel `Class` field is prefixed with the module/product name. If your product name includes spaces or dashes replace those with underscores.

#### Xcode Core Data boilerplate

Remove all of the boilerplate Core Data methods from your appDelegate class. These will be added for you in the Category `UIApplication (NCCCoreData)`

Add NCCCoreDataClient.h to your `<Your-Product-Name>-Prefix.pch` file.

### NSManagedObject Categories

### Passing the request to an HTTP Client and adding Session Headers

`NCCCoreDataClient` requires that you add an NSManagedObject Category that overrides

// Swift
`class func makeRequest(request: NSMutableURLRequest!, progress: ((progress: CGFloat) -> Void)!, completion: (([AnyObject]!, NSError!) -> Void)!)`

// Objective-C
`+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion;`

This allows you to pass the final NSURLRequest object to the HTTP Client of your choice and then pass the parsed JSON response to the completion block for core data to save. Here you can also set the 'session' headers globaly since you have access to the NSURLRequest object before it is sent.

// Swift
```swift
extension NSManagedObject {
    class func makeRequest(request: NSMutableURLRequest!, progress: ((CGFloat) -> Void)!, completion: (([AnyObject]!, NSError!) -> Void)!) {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(Authentication.clientAuthTokenKey) {
            let headers = ["Authorization":"Bearer \(token)"]
            request.setHeaders(headers)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if ((error) != nil) {
                    completion(nil, error)
                } else {
                    var error: NSError?
                    if let responseObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                        completion([responseObject], error?)
                    }
                }
            }
        }
    }
}
```
// Objective-C
`NSManagedObject (RequestAdapter)`
```objective-c
@implementation NSManagedObject (RequestAdapter)

 + (void)makeRequest:(NSMutableURLRequest *)request completion:(void(^)(NSArray *results, NSError *error))completion
 {
    // Session headers
    [request setHeaders:@{@"Authorization":###,
                          @"x-api-key":###,
                          @"x-app-id":###,
                          @"x-device-id":###};];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *results = nil;
        if (!connectionError) {
            NSError *error;
            NSDictionary *responseOject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            results = responseObject[@"result"];
            if (!error) {
                NSLog(@"%@", error);
            }
        }

        completion(results, connectionError);
    }];
 }

 @end
 ```
 Or with AFNetworking...

```objective-c
@implementation NSManagedObject (RequestAdapter)

+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock completion:(void(^)(NSArray *results, NSError *error))completion
{
  // Session headers
    [request setHeaders:@{@"Authorization":###,
                          @"x-api-key":###,
                          @"x-app-id":###,
                          @"x-device-id":###};];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completion(responseObject[@"result"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
```

NCCCoreDataClient also requires that that you add an NSManagedObject Model Category or Swift Extension that overrides

//Swift
`override func updateWithDictionary(dictionary: [NSObject : AnyObject]!)`

// Objective-C
`- (void)updateWithDictionary:(NSDictionary *)dictionary`

for each Core Data Model you that you wish to parse request responses to NSManagedObject attributes and relationships.

// Swift
```swift
extension User {
    override func updateWithDictionary(dictionary: [NSObject : AnyObject]!) {
        self.email = dictionary["email"] as? String
        self.firstName = dictionary["first"] as? String
        self.lastName = dictionary["last"] as? String

        let address: NSDictionary = [
            "city":dictionary["city"] as NSString,
            "state":dictionary["state"] as NSString,
            "address":dictionary["address"] as NSString,
            "zip":dictionary["zip"] as NSString
        ]

        self.address = Address.insertObjectWithDictionary(address, inManagedObjectContext: self.managedObjectContext)
    }
}
```

// Objective-C
`User (JSON)`
```objective-c
@implementation User (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.email = dictionary[@"email"];
    self.firstName = dictionary[@"first"];
    self.lastName = dictionary[@"last"];

    Address *address = [Address insertObjectWithDictionary:@{@"city":dictionary[@"city"],
                                                             @"state":dictionary[@"state"],
                                                             @"address":dictionary[@"address"],
                                                             @"zip":dictionary[@"zip"]}
                                              inManagedObjectContext:self.managedObjectContext];

    self.address = address;
}

@end
```

If the relationship is an update/create (upsert) then you can use the method

// Swift
`Address.upsertObjectWithDictionary(address, uid: address["id"] as NSString, inManagedObjectContext: self.managedObjectContext)`

// Objective-C
`[Address upsertObjectWithDictionary:dictionary uid:dictionary[@"id"] inManagedObjectContext:self.managedObjectContext];`

The following helper method is also available to alsways reach the main NSManagedObjectContext.

// Swift
`NSManagedObjectContext.mainContext()`

// Objective-C
`[NSManagedObjectContext mainContext]` 

### Set BasePath and Object Id Keys

Each NSManagedObject Category can set it's own basePath, responseObjectUidKey and managedObjectUidKey by overriding `+ (void)initialize` Only properties that you expect not to change should be modified in the `+ (void)initialize` method. The path and headers can also be modified in the `POST`, `PUT`, `GET`, and `DELETE` request block by modifying the NSMutableURLRequest directly. These can also be modified in the `RequestAdapter` Category if they are the same for every NSManagedObject.

`User (Request)`

```objective-c
+ (void)initialize
{
    [self setResponseObjectUidKey:@"id"];
    [self setManagedObjectUidKey:@"uid"];
    [self setBasePath:@"http://example.com/user/"];
}
```

The Core data objects are upserted based on their `objectUidKey`. The `objectUidKey` defaults to "id" but can be modified `[self setResponseObjectUidKey:@"id"];` and `[self setManagedObjectUidKey:@"uid"];` for the response dictionary and managedObject model respectively.

#### `GET` Request

```objective-c
- (void)userForUid:(NSString *)uid withCompletion:(CompletionBlock)completion
{
    [User GET:uid progress:nil request:nil withCompletion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }];
}
```

#### `POST` Request

You can modify the NSMutableURLRequest directly in the request block to add additional headers or post body data

`User.h (Request)``
```objective-c
- (void)saveUserWithCompletion:(CompletionBlock)completion
{
    [self POST:@"" request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[user dictionaryWithAttributeToKeyValuePathMappings:@{@"email":@"email",
                                                  @"first":@"firstName",
                                                  @"last":@"lastName",
                                                  @"address":@"address.street",
                                                  @"city":@"address.city",
                                                  @"state":@"address.state",
                                                  @"zip":@"address.zip",] options:0 error:&error];
        if (!error) {
            [request setData:data ofContentType:postBodyContentTypeJSON];
        } else {
            NSLog(@"Error serializing data for request");
        }
    } withCompletion:^(NSArray *results, NSError *error) {
        User *user = results.lastObject;
        completion(user, error);
    }];
}
```

#### `PUT` Request

You can also use several request helper methods such as `setJSON` and `setPNG`

```objective-c
- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion
{
    [self PUT:@"user" request:^(NSMutableURLRequest *request) {
       [request setJSON:[self dictionaryForKeys:keys]];
    } withCompletion:^(NSArray *results, NSError *error) {
        User *user = results.lastObject;
        completion(results, error);
    }];
}
```

#### `PUT` Request
```objective-c
- (void)saveValuesForKeyPathMappings:(NSDictionary *)keyMappings withCompletion:(CompletionBlock)completion
{
    [self PUT:@"user" request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionaryWithAttributeToKeyPathMappings:keyMappings] options:0 error:&error];

        if (!error) {
            [request setData:data ofContentType:postBodyContentTypeJSON];
        } else {
            NSLog(@"Error serializing data for request");
        }
    } withCompletion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }];
}
```

#### `DELETE` Request
```objective-c
- (void)deleteUserWithCompletion:(CompletionBlock)completion
{
    [self DELETE:@"" request:nil withCompletion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }
}
```
