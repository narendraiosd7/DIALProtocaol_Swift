/*
 * DIALManager.h
 * Copyright (C) 2013 Roku, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "Discovery.h"

// delegate for XML fetches
@protocol FetchEventsDelegate <NSXMLParserDelegate>

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string;

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName;

-(void) parserDidEndDocument: (NSXMLParser *)parser;

@end

// listener for the device description details query
@interface DetailsFetchListener : NSObject<FetchEventsDelegate>

@property NSObject *owner;
@property (nonatomic, copy) NSString *element;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *serialNumber;
- (id)initWithOwner:(NSObject *) owner;

@end


// DIALManager interface
@interface DIALManager : NSObject

- (NSString *) launchApp: (NSString *)URL :(NSString *)textAppName;
- (void) fetchDetails: (DiscoveredRokuBox *)box;
- (void) postXML: (NSString *)URL :(NSString *) postURL;
- (void) sendDelete: (NSString *) URL;

@end

