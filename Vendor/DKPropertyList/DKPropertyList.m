//
//  DKPropertyList.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/06/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKPropertyList.h"
#import "objc/runtime.h"

@implementation DKPropertyList

+ (void)setValue:(id)value forProperty:(NSString *)property {
    
    id propertyList = [[[self class] new] autorelease];
    
    [propertyList setValue:value forKey:property];
    [propertyList save];
    
}

+ (id)valueForProperty:(NSString *)property {
    
    id propertyList = [[[self class] new] autorelease];
    
    return [propertyList valueForKey:property];
    
}

+ (NSString *)propertyListFileName {

    return [[self class] description];

}

- (id)init {
	
	if ((self = [super init])) {

		// Figure out the ~/Documents folder for the iPhone. We can only write stuff here.
		NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // The file name for the PList
        NSString * fileName = [[[self class] propertyListFileName] stringByAppendingPathExtension:@"plist"];
        
        // Construct the path
		_plistPath = [rootPath stringByAppendingPathComponent:fileName];
        [_plistPath retain];
		
		// If the plist doesn't exist, copy the bundled one with app the to ~/Documents
		// directory (so we can write back to it).
		if (![[NSFileManager defaultManager] fileExistsAtPath:_plistPath]) {
			
			NSString * bundled = [[NSBundle mainBundle] pathForResource:[[self class] propertyListFileName] ofType:@"plist"];
            
            // If we have a bundled version?
            if(bundled) {
                
                // Attempt to copy the file
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:bundled toPath: _plistPath error:&error];
                
                // TODO: Handle this error betterer
                if (error) {
                    NSLog(@"[DKPropertyList] %@", error);
                    abort();
                }
                
            } else {
                
                // Create an empty file
                [[NSDictionary dictionary] writeToFile:_plistPath atomically:YES];
                
            }
			
        }
		
        [self reload];
				
	}
	
	return self;
	
}

- (void)save {
	
	// Extract the data into a dictionary.
	NSMutableDictionary * temp = [[NSMutableDictionary alloc] initWithContentsOfFile: _plistPath];
	
	// Re-set it back to the dictionary.
    for (NSString * property in _properties) {
        
        id value = [self valueForKey:property];
        
        // If we have a value, save it to the dictionary
        if (value)
            [temp setObject:value forKey:property];
        
    }
	
	// Save the dictionary to the plist file
	[temp writeToFile:_plistPath atomically:YES];
	
	// Cleanup
	[temp release];
	
}

- (void)reset {
    
    for (NSString * property in _properties)
        [self setValue:nil forKey:property];
    
}

- (void)reload {
    
    [self reset];
    
    // Extract the data into a dictionary.
    NSMutableDictionary * temp = [[NSMutableDictionary alloc] initWithContentsOfFile: _plistPath];
    
    // Load the properties of the class into an array
    NSMutableArray * collection = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {        
        objc_property_t property = properties[i];
        [collection addObject:[NSString stringWithCString:property_getName(property)
                                                 encoding:NSASCIIStringEncoding]];
    }
    
    _properties = collection;
    [_properties retain];
    
    // Load them into the current class
    for (NSString * property in _properties)
        [self setValue:[temp objectForKey:property] forKey:property];
    
    [temp release];
    
}

- (void)dealloc {
    
    [_properties release];
    [_plistPath release];
    
    [super dealloc];
    
}

@end