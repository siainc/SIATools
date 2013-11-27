//
//  SIAAppDelegate.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import "SIAAppDelegate.h"
#import "SIATools/SIATools.h"
#import "SIATools/FTP/SIAFTP.h"

@interface SIAAppDelegate () <SIAFTPClientDelegate>
@property (nonatomic, strong) SIAFTPClient *ftpClient;
@end

@implementation SIAAppDelegate

+ (void)initialize
{
    [SIALogger sharedLogger].outputLevel = SIALoggerLevelVerbose;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSTimer scheduledTimerWithTimeInterval:3 userInfo:@"a" repeats:YES queue:nil usingBlock:^ (NSTimer *timer){
        NSLog(@"%@", timer.userInfo);
    }];
    
    NSLog(@"date=%@", [NSDate date]);
    for (int i = 0; i < 1000; i++) {
        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"]);
        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd" locale:[NSLocale currentLocale] timeZone:[NSTimeZone localTimeZone]]);
        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd" locale:nil timeZone:nil]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss"]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss" locale:[NSLocale currentLocale] timeZone:[NSTimeZone localTimeZone]]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss" locale:nil timeZone:nil]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss"]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] timeZone:[NSTimeZone localTimeZone]]);
//        NSLog(@"%@", [NSString stringFromDate:[NSDate date] withFormat:@"yyyyMMdd hhmmss" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja"] timeZone:nil]);
    }
    NSLog(@"date=%@", [NSDate date]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)start
{
    SIA_DEFINE_WEAK_SELF(SIAAppDelegate, wself);
    self.ftpClient               = [SIAFTPClient clientWithHostName:@"180.37.70.210" port:21];
    self.ftpClient.delegate      = self;
    self.ftpClient.recivingReply = ^(SIAFTPReply *reply) {
        DLog(@"FTP", @"%@", reply.stringValue);
    };
    [self.ftpClient scheduleAndOpen];
    
    SIAFTPLoginOperation SIA_WEAK(lo, wlo) = [SIAFTPLoginOperation operationWithUserName:@"ftpuser" password:@"FtpUser4748"];
    lo.completionBlock = ^void () {
        if (wlo.error) {
        }
        else {
            SIAFTPRenameOperation SIA_WEAK(ro, wro) =
            [SIAFTPRenameOperation operationWithFromPath:@"test/CategoryList7.csv" toPath:@"test/CategoryList8.csv"];
            ro.completionBlock = ^void () {
                if (wro.error) {
                }
                else {
                    DLog(@"FTP", @"リネーム完了");
                }
            };
            [wself.ftpClient addOperation:ro];
        }
    };
    [self.ftpClient addOperation:lo];
}

- (void)ftpClient:(SIAFTPClient *)client stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    DLog(@"FTP", @">>client=%@, aStream=%@, eventCode=%d", client, aStream, eventCode);
    DLog(@"FTP", @"<<");
}

- (void)ftpClient:(SIAFTPClient *)client didFailWithError:(NSError *)error
{
    DLog(@"FTP", @">>client=%@, error=%@", client, error);
    [self.ftpClient closeAndRemoveSchedule];
    DLog(@"FTP", @"<<");
}

@end
