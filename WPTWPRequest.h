//
//  WPTWPRequest.h
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTWPRequest : NSObject {
    NSURLConnection *connection;
    NSMutableData *incomingData;
    SEL callback;
    id receiver;
}

- (WPTWPRequest *)initWithQueryTerm:(NSString *)queryTerm langcode:(NSString *)langcode thenCallSelector:(SEL)selector onObject:(id)object;
@end
