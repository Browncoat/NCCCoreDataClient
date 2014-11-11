// AppDelegate+NCCCoreData.m
//
// Copyright (c) 2013-2014 NCCCoreDataClient (http://coredataclient.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <objc/runtime.h>
#import "AppDelegate+NCCCoreData.h"

@implementation AppDelegate (NCCCoreData)

+ (NSManagedObjectContext *)mainContext
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

#pragma mark Getters/Setters (AssociatedObjects)

- (void)setNCCPrivateSaveToDiskContext:(id)newPrivateSaveToDiskContext {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, @selector(NCCPrivateSaveToDiskContext), newPrivateSaveToDiskContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (id)NCCPrivateSaveToDiskContext {
    return objc_getAssociatedObject(self, @selector(NCCPrivateSaveToDiskContext));
}

- (void)setNCCManagedObjectContext:(id)newManagedObjectContext {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, @selector(NCCManagedObjectContext), newManagedObjectContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (id)NCCManagedObjectContext {
    return objc_getAssociatedObject(self, @selector(NCCManagedObjectContext));
}

- (void)setNCCManagedObjectModel:(id)newManagedObjectModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, @selector(NCCManagedObjectModel), newManagedObjectModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (id)NCCManagedObjectModel {
    return objc_getAssociatedObject(self, @selector(NCCManagedObjectModel));
}

- (void)setNCCPersistentStoreCoordinator:(id)newPersistentStoreCoordinator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, @selector(NCCPersistentStoreCoordinator), newPersistentStoreCoordinator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (id)NCCPersistentStoreCoordinator {
    return objc_getAssociatedObject(self, @selector(NCCPersistentStoreCoordinator));
}

#pragma mark - Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)privateSaveToDiskContext
{
    if (self.NCCPrivateSaveToDiskContext != nil) {
        return self.NCCPrivateSaveToDiskContext;
    }
    
    self.NCCPrivateSaveToDiskContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.NCCPrivateSaveToDiskContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return self.NCCPrivateSaveToDiskContext;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (self.NCCManagedObjectContext != nil) {
        return self.NCCManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        self.NCCManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.managedObjectContext.parentContext = self.privateSaveToDiskContext;
    }
    
    return self.NCCManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (self.NCCManagedObjectModel != nil) {
        return self.NCCManagedObjectModel;
    }
//    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CoreDataPersistentStoreName"];
//    if (!appName) {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
//    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:appName withExtension:@"momd"];
    self.NCCManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return self.NCCManagedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (self.NCCPersistentStoreCoordinator != nil) {
        return self.NCCPersistentStoreCoordinator;
    }
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CoreDataPersistentStoreName"];
    if (!appName) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    }
    NSString *pathComponent = [NSString stringWithFormat:@"%@.%@",appName, @"sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pathComponent];
    
    NSError *error = nil;
    self.NCCPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return self.persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
