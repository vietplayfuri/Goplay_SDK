//
//  KeyChainBridge.m
//  TestiOS
//
//  Created by NND on 8/25/15.
//  Copyright (c) 2015 NND. All rights reserved.
//

#import "KeyChainBridge.h"
#import "KeyChainItemWrapper.h"

@implementation KeyChainBridge

@end


/*
 * Helper
 */
NSString* strToNSStr(const char* str)
{
    if (!str)
        return [NSString stringWithUTF8String: ""];
    
    return [NSString stringWithUTF8String: str];
}

/*
 * Helper
 */
char* strDup(const char* str)
{
    if (!str)
        return NULL;
    
    return strcpy((char*)malloc(strlen(str) + 1), str);
}


extern "C"
{
    char* _KeyChainBridgeGetUIID(){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"GoPlayGame" accessGroup:nil];
        
        NSString *idfv = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        
        if (idfv == nil || idfv.length == 0)
        {
            idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [keychain setObject:idfv forKey:(__bridge id)(kSecAttrAccount)];
        }
        
        const char *stringAsChar = [idfv cStringUsingEncoding:[NSString defaultCStringEncoding]];
        return strDup(stringAsChar);
    }
    
}