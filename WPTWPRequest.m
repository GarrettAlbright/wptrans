//
//  WPTWPRequest.m
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTWPRequest.h"

@implementation WPTWPRequest

-(WPTWPRequest *) initWithQueryTerm:(NSString *)queryTerm langcode:(NSString *)langcode thenCallSelector:(SEL)selector onObject:(id)object {
    // @todo There's basically no error checking going on here. =[
    self = [super init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@.wikipedia.org/w/api.php?action=query&prop=langlinks&format=json&redirects=&lllimit=500&titles=%@", langcode, queryTerm, nil];
    NSURL *url = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    incomingData = [[NSMutableData alloc] init];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    callback = selector;
    receiver = object;
    return self;
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    [incomingData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSError *jsonError;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:incomingData options:0 error:&jsonError];
    if (jsonResult == nil) {
        NSLog(@"%@", jsonError);
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
    NSArray *langlinks = [[[[[jsonResult objectForKey:@"query"] objectForKey:@"pages"] allValues] objectAtIndex:0] objectForKey:@"langlinks"];
    // Create a dictionary to store language results
    NSMutableArray *langResults = [[NSMutableArray alloc] init];
    for (NSDictionary *langSet in langlinks) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setValue:[langSet objectForKey:@"*"] forKey:@"translation"];
        [result setValue:[langSet objectForKey:@"lang"] forKey:@"langcode"];
        [langResults addObject:(NSDictionary *)result];
    }
    [result setObject:langResults forKey:@"languageResults"];
    // @todo This is probably the wrong pattern - we probably want to use a
    // delegate pattern so that the callback is predefined (if that makes any
    // sense).
    [receiver performSelector:callback withObject:result];
}

@end
