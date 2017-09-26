//
//  ApiRequest.h
//  BoxBazar
//
//  Created by bharat on 20/07/16.
//  Copyright © 2016 Bharat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiRequestdelegate;
@protocol ApiRequestdelegate <NSObject>
@optional

- (void)responsewithToken: (NSMutableDictionary *)responseToken;
- (void)responsewithToken1: (NSMutableDictionary *)responseToken;
- (void)responsewithToken2: (NSMutableDictionary *)responseToken;
- (void)responsewithToken3: (NSMutableDictionary *)responseToken;
- (void)responsewithToken4: (NSMutableDictionary *)responseToken;
- (void)responsewithToken5: (NSMutableDictionary *)responseToken;
- (void)responsewithToken6: (NSMutableDictionary *)responseToken;
- (void)responsewithToken7: (NSMutableDictionary *)responseToken;
- (void)responsewithToken8: (NSMutableDictionary *)responseToken;
- (void)responsewithToken9: (NSMutableDictionary *)responseToken;




- (void)responseSubCategory: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory2: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory3: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory4: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory5: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory6: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory7: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory8: (NSMutableDictionary *)responseDict;
- (void)responseSubCategory9: (NSMutableDictionary *)responseDict;



@end



@interface ApiRequest : NSObject

@property (nonatomic, assign) id <ApiRequestdelegate> delegate;
@property BOOL isInternetConnectionAvailable;

-(void)checkNetworkStatus;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

-(void)sendRequest:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest1:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest2:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest3:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest4:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest5:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest6:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest7:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest8:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)sendRequest9:(NSString*)parameters withUrl:(NSString *)strUrl;



-(void)SubCategoryRequest:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest2:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest3:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest4:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest5:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest6:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest7:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest8:(NSString*)parameters withUrl:(NSString *)strUrl;
-(void)SubCategoryRequest9:(NSString*)parameters withUrl:(NSString *)strUrl;



@end
