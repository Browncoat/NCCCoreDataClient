NCCCoreDataClient is a set of Categories to make working with Core Data and Restful API's quick and easy. Each NSManagedObject should take care of it's own request and data parsing from the web. It has been designed so that you have direct access to the NSMutableURLRequest from the NSManagedObject model and you can send that request with any HTTP Client you choose.

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

### NSManagedObject Categories

`NCCCoreDataClient` requires that you add an NSManagedObject Category that implements `+ (void)makeRequest:(NSURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion;` to pass the final NSURLRequest object to the HTTP Client of your choice and then pass the parsed JSON response to the completion block for core data to save.

`NSManagedObject (RequestAdapter)``
```objective-c
@implementation NSManagedObject (RequestAdapter)

+ (void)makeRequest:(NSURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
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

`User (Request)``
```objective-c
@interface User (Request)

- (void)userForUid:(NSString *)uid withCompletion:(CompletionBlock)completion;
- (void)saveUserWithCompletion:(CompletionBlock)completion;
- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion;
- (void)saveValuesForKeyPathMappings:(NSDictionary *)keyMappings withCompletion:(CompletionBlock)completion;
- (void)deleteUserWithCompletion:(CompletionBlock)completion;

@end
```

`User.m (Request)``

### Set BasePth and Default Headers

Each NSManagedObject Category can set it's own basePath and defaultHeaders by overriding `+ (void)prepare` The path and headers can also be modified in the `POST`, `PUT`, `GET`, and `DELETE` request block by modifying the NSMUtableURLRequest directly.

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
```objective-c
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