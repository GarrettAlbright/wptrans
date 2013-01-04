//
//  WPTWPRequest.m
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTWPRequest.h"
#import "WPTWPRequestDelegate.h"
#import "WPTLangBase.h"

@implementation WPTWPRequest

-(WPTWPRequest *) initWithQueryTerm:(NSString *)queryTerm langcode:(NSString *)langcode delegate:(id)delegateObject {
    self = [super init];
    if (self) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@.wikipedia.org/w/api.php?action=query&prop=langlinks&format=json&redirects=&lllimit=500&titles=%@", langcode, queryTerm, nil];
        NSURL *url = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setValue:@"WPTrans/1.0 (http://github.com/GarrettAlbright/wptrans; albright@abweb.us)" forHTTPHeaderField:@"User-Agent"];
        incomingData = [[NSMutableData alloc] init];
        connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        receiver = delegateObject;
    }
    return self;
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    [incomingData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self handleError:error];
}

-(void)handleError:(NSError *)error {
    [receiver wikipediaQueryDidCauseError:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSError *jsonError;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:incomingData options:0 error:&jsonError];
    if (jsonResult == nil) {
        [self handleError:jsonError];
        return;
    }
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSURL *origUrl = [[conn currentRequest] URL];
    NSString *origUrlString = [NSString stringWithContentsOfURL:origUrl encoding:NSUTF8StringEncoding error:nil];
    [result setValue:origUrlString forKey:@"accessedUrl"];
    // Were we redirected to a different title?
    NSArray *redirects = [[jsonResult objectForKey:@"query"] objectForKey:@"redirects"];
    NSArray *normalized = [[jsonResult objectForKey:@"query"] objectForKey:@"normalized"];
    if (redirects) {
        NSString *redirectedTitle = [[redirects lastObject] objectForKey:@"to"];
        [result setObject:redirectedTitle forKey:@"finalTitle"];
    }
    else if (normalized) {
        NSString *normalizedTitle = [[normalized lastObject] objectForKey:@"to"];
        [result setObject:normalizedTitle forKey:@"finalTitle"];
    }
    NSDictionary *page = [[[[jsonResult objectForKey:@"query"] objectForKey:@"pages"] allValues] objectAtIndex:0];
    if ([[page objectForKey:@"missing"] isEqual:@""]) {
        [self handleError:[NSError errorWithDomain:@"WPTWPRequest" code:404 userInfo:nil]];
        return;
    }
    NSArray *langlinks = [page objectForKey:@"langlinks"];
    // Create a dictionary to store language results
    NSMutableArray *langResults = [[NSMutableArray alloc] initWithCapacity:[langlinks count]];
    WPTLangBase *langBase = [WPTLangBase sharedBase];
    for (NSDictionary *langSet in langlinks) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:3];
        [result setValue:[langSet objectForKey:@"*"] forKey:@"translation"];
        NSString *langCode = [langSet objectForKey:@"lang"];
        [result setValue:langCode forKey:@"langcode"];
        [result setValue:[langBase languageForCode:langCode] forKey:@"language"];
        [langResults addObject:(NSDictionary *)result];
    }
    [result setObject:langResults forKey:@"languageResults"];
    [receiver wikipediaQueryResultsReceived:(NSDictionary *)result];
}

@end
