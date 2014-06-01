//
//  Firebase.m
//  Up100
//
//  Created by Prashant Khanduri on 6/1/14.
//
//

#import "FirebaseManager.h"

@implementation FirebaseManager

+ (id)sharedInstance {
    static Firebase * sharedFirebase = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFirebase = [[self alloc] init];
    });
    
    return sharedFirebase;
}

- (id)init {
    if (self = [super init]) {
        _firebase = [[Firebase alloc] initWithUrl:kFirebaseRootLink];
        _authClient = [[FirebaseSimpleLogin alloc] initWithRef:_firebase];

    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
@end
