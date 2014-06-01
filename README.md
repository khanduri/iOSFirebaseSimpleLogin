iOSFirebaseSimpleLogin
======================

 - pod install
 - Downlaod FirebaseSimpleLogin: https://www.firebase.com/docs/security/simple-login-ios-overview.html
 - Add to Frameworks (Make sure to select copy if needed)
 - Add the following under 'build phases' -> 'Link binaries with Libraries'
   - Social.framework
   - Accounts.framework
   - SystemConfiguration.framework
   - Security.framework
   - CFNetwork.framework
   - libc++.dylib
   - libicucore.dylib
 - Edit Constants.h file
 - Edit PList file 
