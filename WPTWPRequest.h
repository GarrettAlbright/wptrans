//
//  WPTWPRequest.h
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTWPRequest : NSObject <NSURLConnectionDelegate> {
    NSURLConnection *connection;
    NSMutableData *incomingData;
    SEL callback;
    id receiver;
}

- (WPTWPRequest *)initWithQueryTerm:(NSString *)queryTerm langcode:(NSString *)langcode delegate:(id)object;
- (void)handleError: (NSError *)error;

@end
