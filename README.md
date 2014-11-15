NCCCoreDataClient is a set of Categories to make working with Core Data and Restful API's quick and easy. The core feature being that each NSManagedObject subclass takes care of it's own request and data parsing from the web.

## How To Get Started

- [Download NCCCoreDataClient](https://github.com/AFNetworking/AFNetworking/archive/master.zip) and try out the included Mac and iPhone example apps

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/afnetworking). (Tag 'afnetworking')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/ncccoredataclient).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Requirements
iOS 5+

## Usage

### NSManagedObject Categories

`NCCCoreDataClient` encapsulates the common patterns of communicating with a web application over HTTP, including request creation, response serialization, network reachability monitoring, and security, as well as request operation management.

### Setup

```objective-c
+ (void)prepare
{
    [self setBasePath:@"http://example.com/user/"];
    
    NSString *base64Header = [NSString base64WithString:[[NCCSession sharedSession] userInfo][SESSION_TOKEN_NAME]];
    NSDictionary *headers = @{@"Authorization":base64Header,
                              @"x-api-key":API_KEY,
                              @"x-app-id":APP_ID,
                              @"x-device-id":[NCCSession uuid]};
    [self setDefaultHeaders:headers];
    
    [self setUniqueIdentifierKey:@"id"];
}
```

#### `GET` Request

`User.h (Request)``
```objective-c
- (void)userForUid:(NSString *)uid withCompletion:(CompletionBlock)completion
{
  [User GET:uid progress:nil request:^(NSMutableURLRequest *request) {
        NSString *base64Header = [NSString base64WithString:token.accessToken];
        NSDictionary *headers = @{@"Authorization":base64Header,
                                  @"x-api-key":PW_API_KEY,
                                  @"x-app-id":PW_APP_ID,
                                  @"x-device-id":[NSString uuid]};
        [request setHeaders:headers];
    } withCompletion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }];
  }
```

#### `POST` URL-Form-Encoded Request

`User.h (Request)``
```objective-c
- (void)saveUserWithCompletion:(CompletionBlock)completion
{
    [self POST:@"" request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionaryWithKeys:keys] options:0 error:&error];
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

#### `POST` URL-Form-Encoded Request

`User.h (Request)``
```objective-c
- (void)saveUserWithCompletion:(CompletionBlock)completion
{
    [self POST:@"" request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[user dictionaryWithAttributeToKeyValuePathMappings:@{@"email":@"email",
                                                  @"firstName":@"firstName",
                                                  @"lastName":@"lastName",
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

- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion
{
    [self PUT:@"user" request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionaryForKeys:keys] options:0 error:&error];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!error) {
            [request setData:data ofContentType:postBodyContentTypeJSON];
        } else {
            NSLog(@"Error serializing data for request");
        }
    } withCompletion:^(NSArray *results, NSError *error) {
        User *user = results.lastObject;
        completion(results, error);
    }];
}