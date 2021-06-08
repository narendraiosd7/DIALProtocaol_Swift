/*
 * DIALManager.m
 * Copyright (C) 2011 Roku, Inc. All rights reserved.
 */

#import "DIALManager.h"


@implementation DIALManager : NSObject

// Example URL to launch
NSString *videoURL = @"http://video.ted.com/talks/podcast/DavidKelley_2002_480.mp4";

- (NSString *) launchApp: (NSString *)URL :(NSString *)textAppName
{
    
    NSURL *url = [NSURL URLWithString: URL];
    NSDictionary *dictionary;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: url];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    NSError *err;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        dictionary = [response allHeaderFields];
    }
    
    if (dictionary == nil)
        return nil;
    
    // should poilsh this up so we display a more graceful message that we couldn't find DIAL or w/e
    if (err)
    {
        return nil;
    }
    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    
    if (content != nil)
    {
        //NSLog(@"Content Payload %@", content);
    }
    
    NSString *launchURL = [NSString stringWithFormat: @"%@/%@", [dictionary valueForKey: @"Application-URL"], textAppName];
    
    NSLog(@"Launch URL: %@", launchURL);
    
    [self postXML: launchURL : videoURL];
    
    return launchURL;
}

// fetches the details by calling the dd.xml on the device
- (void) fetchDetails: (DiscoveredRokuBox *) box
{
    
    NSLog(@"PARSE XML FILE AT URL CALLED");
    NSURL* url = [NSURL URLWithString: box.dialURL];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    DetailsFetchListener *listener = [[DetailsFetchListener alloc] initWithOwner:self];
    [parser setDelegate: listener];
    [parser parse];
    
    box.modelName = listener.modelName;
    box.serialNumber = listener.serialNumber;
    
    return;
}

// posts the application parameters to launch the app
- (void) postXML: (NSString *)URL :(NSString *) postURL
{
    
    NSMutableString *post = [[NSMutableString alloc] init];
    
    // videoURL is not a required parameter,
    // it's just what we use for our DIAL example BrightScript app
    [post appendString: @"videoURL="];
    
    // escape the URL for post parameters
    NSString *escapedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (__bridge CFStringRef) postURL,
                                                                                                     NULL,
                                                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                     kCFStringEncodingUTF8));
    [post appendString: escapedString];
    NSLog(@"DIALManager: postXML: post parameters: %@", post);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: [NSURL URLWithString: URL]];
    [request setHTTPMethod: @"POST"];
    [request setValue: postLength forHTTPHeaderField: @"Content-Length"];
    [request setValue: @"text/plain; charset=\"utf-8\"" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody: postData];
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request
                                          returningResponse: &response
                                          error: &err];
    
    // should polish this up so we display a more graceful message
    // that we couldn't find DIAL or w/e
    if (err)
    {
        return;
    }
    
    /// debug
    if (returnData != nil)
    {
        //        NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
        //        NSLog(@"DIALManager: postXML: responseData: %@", content);
    }
}

// sends the HTTP DELETE command to stop playing the app
- (void) sendDelete: (NSString *) URL
{
    if (URL == nil)
        return;
    
    NSLog(@"DIALManager sendDelete: %@", URL);
    
    // the "stop" command requires an HTTP DELETE method be sent
    // also, the url is the app launch url + /run
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/run", URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"DELETE"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
}


@end


@implementation DetailsFetchListener

// sets the parent
- (id)initWithOwner:(NSObject *)owner
{
    self = [super init];
    if (self != nil) {
        self.owner = owner;
    }
    return self;
}

// parses out the data between the element tags
- (void) parser:(NSXMLParser *) parser
foundCharacters:(NSString *) elementValue
{
    if (self.element == nil)
        self.element = [[NSMutableString alloc] init];
    
    self.element = elementValue;
}

// processes the closing tag for the element
- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
{
    if ([elementName isEqual: @"serialNumber"])
    {
        self.serialNumber = self.element;
    }
    else if ([elementName isEqual: @"modelName"])
    {
        self.modelName = self.element;
    }
}

// just lets us know the document has finished
-(void) parserDidEndDocument: (NSXMLParser *)parser
{
    NSLog(@"DetailsFetchListener parserDidEndDocument");
}

@end