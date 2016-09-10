//
//  URLSession.m
//  StreamTask
//
//  Created by Oleksii Belkevych on 9/11/16.
//

#import "URLSession.h"

@interface URLSession () <NSURLSessionStreamDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionStreamTask *task;
@property (nonatomic, strong) void (^completion)(NSInputStream *, NSOutputStream *);
@end

@implementation URLSession

- (instancetype)init  {
    self = [super init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:nil];
    return self;
}

- (void)dealloc
{
    NSLog(@"URL Session released delegate");
}

#pragma mark - public

- (NSURLSessionStreamTask *)start
{
    NSURL *url = [NSURL URLWithString:@"https://www.google.com.ua"];
    self.task = [self.session streamTaskWithHostName:url.host port:443];
    [self.task resume];
    return self.task;
}

- (void)captureWithCompletion:(void (^)(NSInputStream *, NSOutputStream *))completion
{
    self.completion = completion;
    [self.task captureStreams];
}

- (void)invalidate
{
    [self.task cancel];
    self.task = nil;
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionStreamDelegate

- (void)  URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSLog(@"Streams are captured");
        self.completion ? self.completion(inputStream, outputStream) : nil;
    });
}

- (void)  URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSLog(@"URLSession task (%@) become invalid with error:\n%@", task.originalRequest.URL,
          error.localizedDescription);
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"URLSession become invalid with error:\n%@", error.localizedDescription);
}

@end