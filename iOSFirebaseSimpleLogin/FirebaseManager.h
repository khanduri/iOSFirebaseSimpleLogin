//
//  Firebase.h
//  Up100
//
//  Created by Prashant Khanduri on 6/1/14.
//
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@interface FirebaseManager : NSObject;

@property (nonatomic, retain) Firebase * firebase;
@property (nonatomic, retain) FirebaseSimpleLogin * authClient;


+ (id) sharedInstance;

@end

