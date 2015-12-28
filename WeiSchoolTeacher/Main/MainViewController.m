//
//  MainViewController.m
//  MacKun
//

#import "MainViewController.h"

//#import "AppDelegate.h"

@interface MainViewController ()



@end

@implementation MainViewController

- (id)initWithRootViewController:(MainTabBarController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    self.mainTabBarController=rootViewController;
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        _leftViewController = [[LeftViewController alloc]init];
        self.leftViewBackgroundImage = [UIImage  imageNamed:@"image"];

        if (TYPE == 1)
        {
            [self setLeftViewEnabledWithWidth:250.f
                            presentationStyle:MACSideMenuPresentationStyleScaleFromBig
                         alwaysVisibleOptions:0];

            self.leftViewSwipeGestureEnabled=YES;
        }
        else if (TYPE == 2)
        {
            [self setLeftViewEnabledWithWidth:250.f
                            presentationStyle:MACSideMenuPresentationStyleSlideAbove
                         alwaysVisibleOptions:0];

            self.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];


        }
        else if (TYPE == 3)
        {
            [self setLeftViewEnabledWithWidth:appWidth*0.75
                            presentationStyle:MACSideMenuPresentationStyleSlideBelow
                         alwaysVisibleOptions:0];
            self.leftViewStatusBarVisibleOptions=MACSideMenuAlwaysVisibleOnPhonePortrait|MACSideMenuStatusBarVisibleOnPadPortrait;
            [self.leftView addSubview: _leftViewController.view];

        }
        else if (TYPE == 4)
        {
            [self setLeftViewEnabledWithWidth:200.f
                            presentationStyle:MACSideMenuPresentationStyleScaleFromLittle
                         alwaysVisibleOptions:MACSideMenuAlwaysVisibleOnPadLandscape|MACSideMenuAlwaysVisibleOnPadLandscape];
            self.leftViewStatusBarVisibleOptions = MACSideMenuStatusBarVisibleOnPadLandscape;

        }
        else if (TYPE == 5)
        {
            [self setLeftViewEnabledWithWidth:200.f
                            presentationStyle:MACSideMenuPresentationStyleScaleFromBig
                         alwaysVisibleOptions:MACSideMenuAlwaysVisibleOnPadLandscape|MACSideMenuAlwaysVisibleOnPhoneLandscape];

            //self.leftViewStatusBarVisibleOptions = MACSideMenuStatusBarVisibleOnPadLandscape;
            self.leftViewBackgroundImageInitialScale = 1.5;
            self.leftViewInititialOffsetX = -200.f;
            self.leftViewInititialScale = 1.5;

            self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.f green:1.f blue:0.5 alpha:0.3];
            self.rootViewScaleForLeftView = 0.6;
            self.rootViewLayerBorderWidth = 3.f;
            self.rootViewLayerBorderColor = [UIColor whiteColor];
            self.rootViewLayerShadowRadius = 10.f;
        }
    }
    return self;
}


@end
