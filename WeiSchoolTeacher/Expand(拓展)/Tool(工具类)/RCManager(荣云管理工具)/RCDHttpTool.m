//
//  RCDHttpTool.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  modify by Mackun
//

#import "RCDHttpTool.h"

#import "RCDRCIMDataSource.h"

@implementation RCDHttpTool

+ (RCDHttpTool*)shareInstance
{
    static RCDHttpTool* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        instance.allGroups = [NSMutableArray new];
    });
    return instance;
}

//-(void) isMyFriendWithUserInfo:(RCDUserInfo *)userInfo
//                  completion:(void(^)(BOOL isFriend)) completion
//{
//    
//}
#pragma mark - 根据id获取群组信息
-(void) getGroupByID:(NSString *) groupID
   successCompletion:(void (^)(RCGroup *group)) completion{
    //通过网络取自己服务器中群组的信息，这个项目只有自己班级群组，后台也没有提供接口；所以用用户类中的 rongid className 属性就行了
    
    RCGroup *group = [[RCGroup alloc]initWithGroupId:groupID groupName:@"className" portraitUri:nil];
    completion(group);
}
#pragma mark - 根据id获取个人信息
-(void) getUserInfoByUserID:(NSString *) userID
                         completion:(void (^)(RCUserInfo *user)) completion{
    

    //对userID 加上 “-”才能在后台查到 😢
    //07d21db0fd8448c1b77cdd43cca1507c
    //07d21db0-fd84 48c1 b77c dd43cca1507c
    //a35f050b-f93c-4375-ab63-1bc1bd89536b
    @try {
        NSMutableString *insertID = [NSMutableString stringWithString:userID];
        [insertID insertString:@"-" atIndex:8];
        [insertID insertString:@"-" atIndex:13];
        [insertID insertString:@"-" atIndex:18];
        [insertID insertString:@"-" atIndex:23];
        //这里每次都请求网络了 ； 现在理解的不做本地存储，这样可以实时更新用户信息了
//        
//        [ZSNetRequest netGETHTTPsWithInterfaceName:GetUserBaseInfo andParameters:@{@"userID":insertID} isWithCache:NO receiveJsonResult:^(NSArray *resultArray) {
//            if (resultArray.count > 0) {
//                /*
//                 {
//                 className = "\U521d\U4e2d1\U73ed";
//                 grjj = "";
//                 xm = "\U5b66\U751f3";
//                 yhbh = "07d21db0-fd84-48c1-b77c-dd43cca1507c";
//                 zp = "http://10.8.1.48:8088/Upload/Employee/201509221002245321755_L.jpg";
//                 }
//                 */
//                NSDictionary *userDic = [resultArray firstObject];
//                RCUserInfo *user = [RCUserInfo new];
//                user.userId = [[userDic objectForKey:@"yhbh"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                user.portraitUri = [userDic objectForKey:@"zp"];
//                user.name = [userDic objectForKey:@"xm"];
//                //插入coreData
//                if (completion) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completion(user);
//                    });
//                }
//            }else{
//                NSLog(@"err");
//                RCUserInfo *user = [RCUserInfo new];
//                
//                user.userId = userID;
//                user.portraitUri = @"";
//                user.name = [NSString stringWithFormat:@"用户名%@", userID];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(user);
//                });
//            }
//        }];
    }
    @catch (NSException *exception) {
        RCUserInfo *user = [RCUserInfo new];
        
        user.userId = userID;
        user.portraitUri = @"";
        user.name = [NSString stringWithFormat:@"用户名%@", userID];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(user);
        });
    }
    @finally {
        
    }
    
    //NSLog(@"insertID = %@",insertID);
    
}


- (void)getAllGroupsWithCompletion:(void (^)(NSMutableArray* result))completion
{

    
}


-(void) getMyGroupsWithBlock:(void(^)(NSMutableArray* result)) block{
    //同步群组信息 项目不让自己创建群组，所以群组只有一个班级群组
   // User *nowUser = [User nowUser];
  //  NSString *groupID = [nowUser.urongID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    RCGroup *group = [[RCGroup alloc]initWithGroupId:@"groupID" groupName:@"nowUser.uclassName" portraitUri:@""];
    NSMutableArray *groupArr = [NSMutableArray arrayWithObject:group];
    block(groupArr);
}

- (void)joinGroup:(int)groupID complete:(void (^)(BOOL))joinResult
{
    ;
}

- (void)quitGroup:(int)groupID complete:(void (^)(BOOL))result
{
    ;
}

//- (void)updateGroupById:(int)groupID withGroupName:(NSString*)groupName andintroduce:(NSString*)introduce complete:(void (^)(BOOL))result
//
//{
//    
//    __block typeof(id) weakGroupId = [NSString stringWithFormat:@"%d", groupID];
//    [AFHttpTool updateGroupByID:groupID withGroupName:groupName andGroupIntroduce:introduce success:^(id response) {
//        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
//        
//        if (result) {
//            if ([code isEqualToString:@"200"]) {
//                
////                for (RCDGroupInfo *group in _allGroups) {
////                    if ([group.groupId isEqualToString:weakGroupId]) {
////                        group.groupName=groupName;
////                        group.introduce=introduce;
////                    }
////                    
////                }
//                dispatch_async(dispatch_get_main_queue(), ^(void) {
//                    result(YES);
//                });
//                
//            }else{
//                result(NO);
//            }
//            
//        }
//    } failure:^(id response) {
//        if (result) {
//            result(NO);
//        }
//    }];
//
//}
//
//- (void)getFriends:(void (^)(NSMutableArray*))friendList
//{
//    
//    
//    
//}
//
//- (void)searchFriendListByEmail:(NSString*)email complete:(void (^)(NSMutableArray*))friendList
//{
//   
//    ;
//}
//
//- (void)searchFriendListByName:(NSString*)name complete:(void (^)(NSMutableArray*))friendList
//{
//    
//}
//- (void)requestFriend:(NSString*)userId complete:(void (^)(BOOL))result
//{
//    ;
//}
//- (void)processRequestFriend:(NSString*)userId withIsAccess:(BOOL)isAccess complete:(void (^)(BOOL))result
//{
//    ;
//}
//
//- (void)deleteFriend:(NSString*)userId complete:(void (^)(BOOL))result
//{
//    ;
//}

@end
