//
//  EMClientWrapper.m
//  
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "EMClientWrapper.h"
#import "EMSDKMethod.h"
#import "EMChatManagerWrapper.h"
#import "EMContactManagerWrapper.h"
#import "EMConversationWrapper.h"
#import "EMGroupManagerWrapper.h"
#import "EMChatroomManagerWrapper.h"
#import "EMPushManagerWrapper.h"
#import "EMDeviceConfig+Flutter.h"
#import "EMOptions+Flutter.h"
#import "EMUserInfoManagerWrapper.h"

@interface EMClientWrapper () <EMClientDelegate, EMMultiDevicesDelegate>
@end

@implementation EMClientWrapper


- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([EMMethodKeyInit isEqualToString:call.method])
    {
        [self initSDKWithDict:call.arguments result:result];
    }
    else if ([EMMethodKeyCreateAccount isEqualToString:call.method])
    {
        [self createAccount:call.arguments result:result];
    }
    else if ([EMMethodKeyLogin isEqualToString:call.method])
    {
        [self login:call.arguments result:result];
    }
    else if ([EMMethodKeyLogout isEqualToString:call.method])
    {
        [self logout:call.arguments result:result];
    }
    else if ([EMMethodKeyChangeAppKey isEqualToString:call.method])
    {
        [self changeAppKey:call.arguments result:result];
    }
    else if ([EMMethodKeyUploadLog isEqualToString:call.method])
    {
        [self uploadLog:call.arguments result:result];
    }
    else if ([EMMethodKeyCompressLogs isEqualToString:call.method])
    {
        [self compressLogs:call.arguments result:result];
    }
    else if ([EMMethodKeyGetLoggedInDevicesFromServer isEqualToString:call.method])
    {
        [self getLoggedInDevicesFromServer:call.arguments result:result];
    }
    else if ([EMMethodKeyKickDevice isEqualToString:call.method])
    {
        [self kickDevice:call.arguments result:result];
    }
    else if ([EMMethodKeyKickAllDevices isEqualToString:call.method])
    {
        [self kickAllDevices:call.arguments result:result];
    }
    else if([EMMethodKeyIsLoggedInBefore isEqualToString:call.method])
    {
        [self isLoggedInBefore:call.arguments result:result];
    }
    else if([EMMethodKeyCurrentUser isEqualToString:call.method])
    {
        [self getCurrentUser:call.arguments result:result];
    }
    else {
        [super handleMethodCall:call result:result];
    }
}

#pragma mark - Actions
- (void)initSDKWithDict:(NSDictionary *)param result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    EMOptions *options = [EMOptions fromJson:param];
//    options.enableConsoleLog = YES;
    [EMClient.sharedClient initializeSDKWithOptions:options];
    [EMClient.sharedClient addDelegate:self delegateQueue:nil];
    [EMClient.sharedClient addMultiDevicesDelegate:self delegateQueue:nil];
    [self registerManagers];
    // 如果有证书名，说明要使用Apns
    if (options.pushKitCertName.length > 0) {
        [self _registerAPNs];
    }
    [weakSelf wrapperCallBack:result
                  channelName:EMMethodKeyInit
                        error:nil
                       object:@{
                           @"currentUsername": EMClient.sharedClient.currentUsername ?: @"",
                           @"isLoginBefore": @(EMClient.sharedClient.isLoggedIn)
                       }];
}


- (void)registerManagers {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    EMChatManagerWrapper * chatManagerWrapper = [[EMChatManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_chat_manager")registrar:self.flutterPluginRegister];
    
    EMContactManagerWrapper * contactManagerWrapper = [[EMContactManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_contact_manager") registrar:self.flutterPluginRegister];
    
    EMConversationWrapper *conversationWrapper = [[EMConversationWrapper alloc] initWithChannelName:EMChannelName(@"em_conversation") registrar:self.flutterPluginRegister];
    
    EMGroupManagerWrapper * groupManagerWrapper = [[EMGroupManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_group_manager") registrar:self.flutterPluginRegister];
    
    EMChatroomManagerWrapper * chatroomManagerWrapper =[[EMChatroomManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_chat_room_manager") registrar:self.flutterPluginRegister];
    
    EMPushManagerWrapper * pushManagerWrapper =[[EMPushManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_push_manager") registrar:self.flutterPluginRegister];
    
    EMUserInfoManagerWrapper *userInfoManagerWrapper = [[EMUserInfoManagerWrapper alloc] initWithChannelName:EMChannelName(@"em_userInfo_manager") registrar:self.flutterPluginRegister];
    
#pragma clang diagnostic pop
    
}

- (void)createAccount:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *password = param[@"password"];
    [EMClient.sharedClient registerWithUsername:username
                                         password:password
                                       completion:^(NSString *aUsername, EMError *aError)
    {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyCreateAccount
                            error:aError
                           object:aUsername];
    }];
}

- (void)login:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *pwdOrToken = param[@"pwdOrToken"];
    BOOL isPwd = [param[@"isPassword"] boolValue];
    
    if (isPwd) {
        [EMClient.sharedClient loginWithUsername:username
                                        password:pwdOrToken
                                      completion:^(NSString *aUsername, EMError *aError)
        {
            
            [weakSelf wrapperCallBack:result
                          channelName:EMMethodKeyLogin
                                error:aError
                               object:@{
                                   @"username": aUsername,
                                   @"token": EMClient.sharedClient.accessUserToken
            }];
        }];
    }else {
        [EMClient.sharedClient loginWithUsername:username
                                           token:pwdOrToken
                                      completion:^(NSString *aUsername, EMError *aError)
        {
            [weakSelf wrapperCallBack:result
                          channelName:EMMethodKeyLogin
                                error:aError
                               object:@{
                                   @"username": aUsername,
                                   @"token": EMClient.sharedClient.accessUserToken
                               }];
        }];
    }
}

- (void)logout:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    BOOL unbindToken = [param[@"unbindToken"] boolValue];
    [EMClient.sharedClient logout:unbindToken completion:^(EMError *aError) {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyLogout
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)changeAppKey:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *appKey = param[@"appKey"];
    EMError *aError = [EMClient.sharedClient changeAppkey:appKey];
    [weakSelf wrapperCallBack:result
                  channelName:EMMethodKeyChangeAppKey
                        error:aError
                       object:@(!aError)];
}


- (void)getCurrentUser:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString* username = EMClient.sharedClient.currentUsername;
    [weakSelf wrapperCallBack:result
                  channelName:EMMethodKeyCurrentUser
                        error:nil
                       object:username];

}

- (void)uploadLog:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    [EMClient.sharedClient uploadDebugLogToServerWithCompletion:^(EMError *aError) {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyUploadLog
                            error:aError
                           object:nil];
    }];
}

- (void)compressLogs:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    [EMClient.sharedClient getLogFilesPathWithCompletion:^(NSString *aPath, EMError *aError) {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyCompressLogs
                            error:aError
                           object:aPath];
    }];
}

- (void)kickDevice:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *password = param[@"password"];
    NSString *resource = param[@"resource"];
    
    [EMClient.sharedClient kickDeviceWithUsername:username
                                         password:password
                                         resource:resource
                                       completion:^(EMError *aError)
    {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyKickDevice
                            error:aError
                           object:nil];
    }];
}

- (void)kickAllDevices:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *password = param[@"password"];
    [EMClient.sharedClient kickAllDevicesWithUsername:username
                                             password:password
                                           completion:^(EMError *aError)
    {
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyKickAllDevices
                            error:aError
                           object:nil];
    }];
}

- (void)isLoggedInBefore:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    [weakSelf wrapperCallBack:result
                  channelName:EMMethodKeyIsLoggedInBefore
                        error:nil
                       object:@(EMClient.sharedClient.isLoggedIn)];

}

- (void)onMultiDeviceEvent:(NSDictionary *)param result:(FlutterResult)result {
    
}


- (void)getLoggedInDevicesFromServer:(NSDictionary *)param result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *password = param[@"password"];
    [EMClient.sharedClient getLoggedInDevicesFromServerWithUsername:username
                                                           password:password
                                                         completion:^(NSArray *aList, EMError *aError)
    {
        
        NSMutableArray *list = [NSMutableArray array];
        for (EMDeviceConfig *deviceInfo in aList) {
            [list addObject:[deviceInfo toJson]];
        }
        
        
        [weakSelf wrapperCallBack:result
                      channelName:EMMethodKeyGetLoggedInDevicesFromServer
                            error:aError
                           object:nil];
    }];
}

#pragma - mark EMClientDelegate

- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    BOOL isConnected = aConnectionState == EMConnectionConnected;
    if (isConnected) {
        [self onConnected];
    }else {
        [self onDisconnected:2]; // 需要明确具体的code
    }
}

- (void)autoLoginDidCompleteWithError:(EMError *)aError {
    if (aError) {
        [self onDisconnected:1];  // 需要明确具体的code
    }else {
        [self onConnected];
    }
}

- (void)userAccountDidLoginFromOtherDevice {
    [self onDisconnected:206];
}

- (void)userAccountDidRemoveFromServer {
    [self onDisconnected:207];
}

- (void)userDidForbidByServer {
    [self onDisconnected:305];
}

- (void)userAccountDidForcedToLogout:(EMError *)aError {
    [self onDisconnected:1]; // 需要明确具体的code
}

#pragma mark - EMMultiDevicesDelegate

- (void)multiDevicesContactEventDidReceive:(EMMultiDevicesEvent)aEvent
                                  username:(NSString *)aUsername
                                       ext:(NSString *)aExt {
        
}

- (void)multiDevicesGroupEventDidReceive:(EMMultiDevicesEvent)aEvent
                                 groupId:(NSString *)aGroupId
                                     ext:(id)aExt {
    
}

#pragma mark - Merge Android and iOS Method
- (void)onConnected {
    [self.channel invokeMethod:EMMethodKeyOnConnected
                     arguments:@{@"connected" : @(YES)}];
}

- (void)onDisconnected:(int)errorCode {
    [self.channel invokeMethod:EMMethodKeyOnDisconnected
                     arguments:@{@"errorCode" : @(errorCode)}];
}



#pragma mark - register APNs
- (void)_registerAPNs {
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }
#endif
}

@end
