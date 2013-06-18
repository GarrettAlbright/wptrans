//
//  WPTBookmarksBase.h
//  WPTrans
//
//  Created by Garrett Albright on 6/18/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTBookmarksBase : NSObject
{
    NSMutableDictionary *theBookmarks;
}

+ (WPTBookmarksBase *)sharedBase;
- (NSDictionary *)allBookmarks;
- (NSString *)langcodeForIndex:(NSUInteger)index;
- (NSString *)getTermForIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger) numberOfTermsInLanguageAtIndex:(NSUInteger)index;
- (BOOL)addSearchTerm:(NSString *)term forLangcode:(NSString *)langcode;
- (BOOL)deleteSearchTerm:(NSString *)term forLangcode:(NSString *)langcode;
- (void)saveState;
- (void)nilOut;

@end
