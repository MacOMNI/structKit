//
//  MainViewController.h
//  MacKun
//

#import "MACSideMenuController.h"
#import "LeftViewController.h"
#import "MainTabBarController.h"
//#warning CHOOSE TYPE 1 .. 5
#define TYPE 3
@interface MainViewController :MACSideMenuController
@property (strong, nonatomic) LeftViewController *leftViewController;
@property (strong, nonatomic) MainTabBarController *mainTabBarController;
@end
