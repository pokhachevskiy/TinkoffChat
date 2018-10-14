//
//  Themes.h
//  TinkoffChat
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Themes : NSObject {
    UIColor *_theme1, *_theme2, *_theme3;
}

@property (nonatomic, retain) UIColor* theme1;
@property (nonatomic, retain) UIColor* theme2;
@property (nonatomic, retain) UIColor* theme3;

- (instancetype)initWithColorOne: (UIColor *)theme1 ColorTwo: (UIColor *) theme2 colorThree: (UIColor *) theme3;
- (void)dealloc;


@end

NS_ASSUME_NONNULL_END
