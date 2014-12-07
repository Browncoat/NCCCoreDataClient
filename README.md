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

Remove all of the boilerplate Core Data methods from your appDelegate class. These will be added for you in Category `AppDelegate (NCCCoreData)`

### NSManagedObject Categories

### Passing the request to an HTTP Client and adding Session Headers

`NCCCoreDataClient` requires that you add an NSManagedObject Category that overrides 

`+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion;` 

This allows you to pass the final NSURLRequest object to the HTTP Client of your choice and then pass the parsed JSON response to the completion block for core data to save. Here you can also set the 'session' headers globaly since you have access to the NSURLRequest object before it is sent.

`NSManagedObject (RequestAdapter)`
```objective-c
@implementation NSManagedObject (RequestAdapter)

 + (void)makeRequest:(NSMutableURLRequest *)request withCompletion:(void(^)(id results, NSError *error))completion
 {
    // Session headers
    [request setHeaders:@{@"Authorization":###,
                          @"x-api-key":###,
                          @"x-app-id":###,
                          @"x-device-id":###};];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id results = nil;
        if (!connectionError) {
            NSError *error;
            results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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

+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
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
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
```

NCCCoreDataClient also requires that that you add an NSManagedObject Category that overrides

`- (void)updateWithDictionary:(NSDictionary *)dictionary` 

for each Core Data Model you that you wish to parse request responses to NSManagedObject attributes and relationships.

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

`[Address upsertObjectWithDictionary:dictionary uid:dictionary[@"id"] inManagedObjectContext:self.managedObjectContext];`

The helper method `[NSManagedObject mainContext]` is also available to alsways reach the main NSManagedObjectContext.

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