//
//  RCDHttpTool.h
//  RCloudMessage
//  关于融云的网络请求工具类
//  Created by Liv on 15/4/15.
//  modify by Mackun
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RCUserInfo.h>
#import <RongIMLib/RCGroup.h>
//#import "RCDUserInfo.h"

#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface RCDHttpTool : NSObject


@property (nonatomic,strong) NSMutableArray *allFriends;
@property (nonatomic,strong) NSMutableArray *allGroups;

+ (RCDHttpTool*)shareInstance;


//查看是否好友
//-(void) isMyFriendWithUserInfo:(RCDUserInfo *)userInfo
//                  completion:(void(^)(BOOL isFriend)) completion;

//获取个人信息
-(void) getUserInfoByUserID:(NSString *) userID
                         completion:(void (^)(RCUserInfo *user)) completion;

//获取我的群组
-(void) getMyGroupsWithBlock:(void(^)(NSMutableArray* result)) block;

/**
 *  获取群组列表
 */
- (void) getAllGroupsWithCompletion:(void(^)(NSMutableArray *result)) completion;

//根据id获取单个群组
-(void) getGroupByID:(NSString *) groupID
          successCompletion:(void (^)(RCGroup *group)) completion;



/**
 *  加入群组
 */
-(void) joinGroup:(int) groupID
        complete:(void (^)(BOOL result))joinResult;

/**
 * 退出群组
 */
-(void) quitGroup:(int) groupID
        complete:(void (^)(BOOL result))quitResult;

////更新群组信息
//-(void)updateGroupById:(int) groupID
//         withGroupName:(NSString*)groupName
//          andintroduce:(NSString*)introduce
//              complete:(void (^)(BOOL result))result;
////获取好友列表
//-(void) getFriends:(void (^)(NSMutableArray* result))friendList;
//
////按昵称搜素好友
//-(void) searchFriendListByName:(NSString*)name
//                     complete:(void (^)(NSMutableArray* result))friendList;
////按邮箱搜素好友
//-(void) searchFriendListByEmail:(NSString*)email
//                      complete:(void (^)(NSMutableArray* result))friendList;
//
////请求加好友
//-(void) requestFriend:(NSString*) userId
//            complete:(void (^)(BOOL result))result;
////处理请求加好友
//-(void) processRequestFriend:(NSString*) userId withIsAccess:(BOOL)isAccess
//                   complete:(void (^)(BOOL result))result;
////删除好友
//-(void) deleteFriend:(NSString*) userId
//           complete:(void (^)(BOOL result))result;


@end
