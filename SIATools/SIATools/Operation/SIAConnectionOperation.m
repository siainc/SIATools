//
//  SIAConnectionOperation.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAConnectionOperation.h"

#import "Reachability.h"
#import "SIAToolsLogger.h"

@interface SIAConnectionOperation ()
@property (nonatomic, assign) NSTimer         *timeoutTimer;
@property (nonatomic, strong) NSFileHandle    *fileHandle;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation SIAConnectionOperation
@dynamic downloadedProgress;
@dynamic errorOccurd;
@dynamic finished;

#pragma mark -

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SIAToolsDLog(@"通信テンポラリファイルの削除.");
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *path = [SIAConnectionOperation temporaryPath];
        NSError *error = nil;
        [fm removeItemAtPath:path error:&error];
        if (error) {
            SIAToolsDLog(@"ファイル削除エラー:%@", error);
        }
        error = nil;
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            SIAToolsDLog(@"ディレクトリ生成エラー:%@", error);
        }
    });
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request
{
    SIAToolsDLog(@">>request=%@", request);
    self = [super init];
    if (self != nil) {
        _request        = request;
        _storeToDisk    = YES;
        self.concurrent = YES;
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    SIAToolsVLog(@">>URL=%@", URL);
    self = [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
    SIAToolsVLog(@"<<%@", self);
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    SIAToolsDLog(@">>URL=%@, cachePolicy=%d, timeoutInterval=%g", URL, cachePolicy, timeoutInterval);
    self                 = [self initWithURLRequest:[NSURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval]];
    self.timeoutInterval = timeoutInterval;
    return self;
}

- (void)start
{
    if (self.isFinished || self.isCancelled) {
        return;
    }
    if (!self.isReady || self.isExecuting) {
        @throw NSGenericException;
    }
  
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startConnection];
    });
    
    [self setupExecuting];
}

- (void)startConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus == NotReachable) {
        [self finishConnection];
        
        _error = [NSError errorWithDomain:NSURLErrorDomain
                                     code:NSURLErrorCannotConnectToHost
                                 userInfo:nil];
        if (self.failure) {
            self.failure(_error);
        }
        [self setupFinished];
    }
    else {
        if (self.storeToDisk) {
            if (self.downloadedFilePath) {
                self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.downloadedFilePath];
            }
            else {
                NSString   *tmpDir      = [SIAConnectionOperation temporaryPath];
                NSString   *tmpFilePath = [tmpDir stringByAppendingPathComponent:@"downloadFile.XXXXXX"];
                NSUInteger length       = [tmpFilePath lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                char       *pathCString = malloc(length + 1);
                int        fileDescripter;
                do {
                    strncpy(pathCString, [tmpFilePath cStringUsingEncoding:NSUTF8StringEncoding], length);
                    *(pathCString + length) = '\0';
                    fileDescripter          = mkstemp(pathCString);
                } while (fileDescripter == -1);
                
                self.downloadedFilePath = [[NSString alloc] initWithBytes:pathCString length:length encoding:NSUTF8StringEncoding];
                free(pathCString);
                self.fileHandle         = [[NSFileHandle alloc] initWithFileDescriptor:fileDescripter];
            }
        }
        else {
            _downloadedData = [[NSMutableData alloc] initWithLength:0];
        }
        if (self.timeoutInterval > 0.0) {
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutInterval
                                                                 target:self selector:@selector(timeout:)
                                                               userInfo:nil repeats:NO];
        }
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                          delegate:self
                                                  startImmediately:YES];
    }
}

+ (NSString *)temporaryPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"SIAConnectionOperation"];
}

- (void)finishConnection
{
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    
    if (self.connection) {
        [self.connection cancel];
    }
    
    if (self.storeToDisk) {
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
}

- (void)cancel
{
    if (self.connection) {
        [self.connection cancel];
        [self finishConnection];
    }
    
    [self setupCancelled];
    [super cancel];
}

- (void)removeDownloadedFile
{
    if (self.storeToDisk) {
        [self.fileHandle closeFile];
        self.fileHandle = nil;
        [[NSFileManager defaultManager] removeItemAtPath:self.downloadedFilePath error:nil];
    }
}

#pragma mark - Property

- (float)downloadedProgress
{
    float ret = NAN;
    if (self.response.expectedContentLength != NSURLResponseUnknownLength) {
        ret = (double)self.currentContentLength / (double)self.response.expectedContentLength;
    }
    return ret;
}

- (BOOL)errorOccurd
{
    BOOL errorOccurd = (self.error || (self.httpResponse && self.httpResponse.statusCode >= 400));
    return errorOccurd;
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        _httpResponse = (NSHTTPURLResponse *)response;
    }
    _currentContentLength = 0;
    if (self.receiptResponse) {
        self.receiptResponse();
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.storeToDisk) {
        @try {
            [self.fileHandle writeData:data];
        }
        @catch (NSException *exception) {
            _error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorCannotWriteToFile userInfo:nil];
            [self finishConnection];
            
            if (self.failure) {
                self.failure(_error);
            }
            [self setupFinished];
            return;
        }
        @finally {
        }
    }
    else {
        [self.downloadedData appendData:data];
    }
    _currentContentLength += data.length;
    if (self.receiptData) {
        self.receiptData(data);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self finishConnection];
    
    if (self.completion) {
        self.completion();
    }
    [self setupFinished];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error = error;
    [self finishConnection];
    
    if (self.failure) {
        self.failure(_error);
    }
    [self setupFinished];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSHTTPURLResponse *)redirectResponse
{
    if (self.disableRedirect) {
        return nil;
    }
    return request;
}

#pragma mark - Timer

- (void)timeout:(NSTimer *)timer
{
    [self finishConnection];
    
    _error = [NSError errorWithDomain:NSURLErrorDomain
                                 code:NSURLErrorTimedOut
                             userInfo:nil];
    if (self.failure) {
        self.failure(_error);
    }
    [self setupFinished];
}

@end
