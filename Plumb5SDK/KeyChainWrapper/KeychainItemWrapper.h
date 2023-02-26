#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeychainWrapper : NSObject

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)writeToKeychain;

@end
