//
//  WPTWPRequestDelegate.h
//  WPTrans
//
//  Created by Garrett Albright on 12/31/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPTWPRequestDelegate <NSObject>

- (void)wikipediaQueryResultsReceived:(NSDictionary *)results;
- (void)wikipediaQueryDidCauseError:(NSError *)error;

@end
