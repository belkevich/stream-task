//
//  ViewController.m
//  StreamTask-ios
//
//  Created by Oleksii Belkevych on 9/10/16.
//
//

#import "ViewController.h"
#import "URLSession.h"

@interface ViewController ()
@property (nonatomic, strong) URLSession *session;
@property (nonatomic, strong) NSURLSessionStreamTask *task;
@end

@implementation ViewController

- (IBAction)create:(id)sender
{
    self.session = [[URLSession alloc] init];
    NSLog(@"create");
}

- (IBAction)run:(id)sender
{
    self.task = [self.session start];
    NSLog(@"run");
}

- (IBAction)capture:(id)sender
{
    NSLog(@"Capturing streams...");
    [self.session captureWithCompletion:^(NSInputStream *inputStream, NSOutputStream *outputStream)
    {
    }];
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"Cancelling stream task...");
    [self.task cancel];
}

- (IBAction)invalidate:(id)sender
{
    NSLog(@"URL Session invalidate...");
    [self.session invalidate];
}

- (IBAction)release:(id)sender
{
    NSLog(@"URL Session delegate wait for release...");
    self.session = nil;
}

@end
