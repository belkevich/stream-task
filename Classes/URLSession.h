//
//  URLSession.h
//  StreamTask
//
//  Created by Oleksii Belkevych on 9/11/16.
//

#import <Foundation/Foundation.h>

@interface URLSession : NSObject

- (NSURLSessionStreamTask *)start;
- (void)captureWithCompletion:(void (^)(NSInputStream *, NSOutputStream *))completion;
- (void)invalidate;

@end