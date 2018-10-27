//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
NS_ASSUME_NONNULL_BEGIN

@class ThemesViewController;

@protocol ​ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

@interface ThemesViewController : UIViewController <​ThemesViewControllerDelegate> {
    Themes *_model;
}

@property (nonatomic, assign) id <​ThemesViewControllerDelegate>delegate;
@property (nonatomic, retain) Themes* model;

@end



NS_ASSUME_NONNULL_END
