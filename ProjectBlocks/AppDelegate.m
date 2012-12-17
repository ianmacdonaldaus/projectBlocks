//
//  AppDelegate.m
//  ProjectBlocks
//
//  Created by Ian MacDonald on 01/12/2012.
//  Copyright (c) 2012 Ian MacDonald. All rights reserved.
//

#import "AppDelegate.h"

#import "ProjectsViewController.h"
#import "Project.h"
#import "ColorPalette.h"
#import "CoreDataHelper.h"
#import "UIColorTransformer.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIColorTransformer *transformer = [[UIColorTransformer alloc] init];
    [UIColorTransformer setValueTransformer:transformer forName:(NSString *)@"UIColorTransformerName"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ColorPalette"];
    if (![self.managedObjectContext countForFetchRequest:request error:nil]> 0 ) {
        [self loadDefaultColorPalettes];
    }
    NSLog(@"number of ColorPalettes %i",[self.managedObjectContext countForFetchRequest:request error:nil]);

    request = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    if (![self.managedObjectContext countForFetchRequest:request error:nil]> 0 ) {
        [self loadDefaultProjects];
    }
    NSLog(@"number of Projects %i",[self.managedObjectContext countForFetchRequest:request error:nil]);
    
    
    
    ProjectsViewController *controller = (ProjectsViewController *)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;

    return YES;
}

-(void)loadDefaultProjects {
    NSMutableArray *array = [CoreDataHelper getObjectsForEntity:@"ColorPalette" withSortKey:@"index" andSortAscending:YES andContext:self.managedObjectContext];
    
    Project* project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_managedObjectContext];

    project.name = @"Christmas Roast";
    project.colorPalette = [array objectAtIndex:0];
    project.index = [NSNumber numberWithInt:0];
    
    project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_managedObjectContext];
    project.name = @"Home renovations";
    project.colorPalette = [array objectAtIndex:1];
    project.index = [NSNumber numberWithInt:1];

    project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_managedObjectContext];
    project.name = @"Plan the 2013 holiday";
    project.colorPalette = [array objectAtIndex:2];
    project.index = [NSNumber numberWithInt:2];

    [_managedObjectContext save:nil];
}

-(void)loadDefaultColorPalettes {
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    //Palette 1
    
    ColorPalette* colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:0];
    color = [UIColor colorWithRed:0.0392 green:0.0745 blue:0.2392 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.1098 green:0.5020 blue:0.5294 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.9882 green:0.9686 blue:0.8784 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.9843 green:0.9255 blue:0.1961 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.7922 green:0.6627 blue:0.1373 alpha:1.0];
    colorPalette.color5 = color;
    
    //Palette 2
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:1];
    color = [UIColor colorWithRed:0.3255 green:0.4392 blue:0.5882 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.5882 green:0.4392 blue:0.1412 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.0824 green:0.2118 blue:0.3686 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.6706 green:0.6980 blue:0.7608 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.5490 green:0.1333 blue:0.1569 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 3
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:2];
    color = [UIColor colorWithRed:0.8235 green:0.1843 blue:0.2000 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.9333 green:0.3059 blue:0.2706 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.9804 green:0.7882 blue:0.5882 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.1882 green:0.1725 blue:0.1451 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.5294 green:0.5137 blue:0.2510 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 4
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:3];
    color = [UIColor colorWithRed:0.7922 green:0.5020 blue:0.1255 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.4275 green:0.4353 blue:0.4784 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.8902 green:0.8118 blue:0.7020 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.5882 green:0.4824 blue:0.3961 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.1373 green:0.1373 blue:0.1059 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 5
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:4];
    color = [UIColor colorWithRed:0.5020 green:0.5373 blue:0.2431 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.8588 green:0.6000 blue:0.2824 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.5176 green:0.4196 blue:0.4588 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.7294 green:0.4000 blue:0.2353 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.1765 green:0.1059 blue:0.1059 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 6
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:5];
    color = [UIColor colorWithRed:0.6353 green:0.2549 blue:0.0000 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.6353 green:0.4157 blue:0.0000 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.6353 green:0.5725 blue:0.0000 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.4902 green:0.4510 blue:0.1020 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.3020 green:0.2784 blue:0.0941 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 7
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:6];
    color = [UIColor colorWithRed:0.2863 green:0.0392 blue:0.2392 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.7412 green:0.0824 blue:0.3137 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.9137 green:0.4980 blue:0.0078 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.9725 green:0.7922 blue:0.0000 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.5412 green:0.6078 blue:0.0588 alpha:1.0];
    colorPalette.color5 = color;
    
    //Palette 8
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:7];
    color = [UIColor colorWithRed:0.9961 green:0.2627 blue:0.3961 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.9882 green:0.6157 blue:0.6039 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.9765 green:0.8039 blue:0.6784 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.7843 green:0.7843 blue:0.6627 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.5137 green:0.6863 blue:0.6078 alpha:1.0];
    colorPalette.color5 = color;
    
    //Palette 9
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:8];
    color = [UIColor colorWithRed:0.3333 green:0.3843 blue:0.4392 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.3059 green:0.8039 blue:0.7686 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.7804 green:0.9569 blue:0.3922 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:1.0000 green:0.4196 blue:0.4196 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.7686 green:0.3020 blue:0.3451 alpha:1.0];
    colorPalette.color5 = color;

    //Palette 10
    
    colorPalette = [NSEntityDescription insertNewObjectForEntityForName:@"ColorPalette" inManagedObjectContext:_managedObjectContext];

    colorPalette.index = [NSNumber numberWithInt:9];
    color = [UIColor colorWithRed:0.4667 green:0.3098 blue:0.2196 alpha:1.0];
    colorPalette.color1 = color;
    color = [UIColor colorWithRed:0.8784 green:0.5569 blue:0.4745 alpha:1.0];
    colorPalette.color2 = color;
    color = [UIColor colorWithRed:0.9451 green:0.8314 blue:0.6863 alpha:1.0];
    colorPalette.color3 = color;
    color = [UIColor colorWithRed:0.9255 green:0.8980 blue:0.8078 alpha:1.0];
    colorPalette.color4 = color;
    color = [UIColor colorWithRed:0.7725 green:0.8784 blue:0.8627 alpha:1.0];
    colorPalette.color5 = color;


    [_managedObjectContext save:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveContext];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

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

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
