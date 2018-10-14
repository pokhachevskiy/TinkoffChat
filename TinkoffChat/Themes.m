//
//  Themes.m
//  TinkoffChat
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype) initWithColorOne:(UIColor *)theme1 ColorTwo:(UIColor *)theme2 colorThree:(UIColor *)theme3 {
    self = [super init];
    
    if (self) {
        _theme1 = theme1;
        _theme2 = theme2;
        _theme3 = theme3;
    }
    
    return self;
}

- (void)dealloc
{
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    
    [super dealloc];
}

- (void)setTheme1:(UIColor *)theme1 {
    if (_theme1 != theme1) {
//        [_theme1 release];
        _theme1 = [theme1 retain];
    }
}

- (void)setTheme2:(UIColor *)theme2{
    if (_theme2 != theme2) {
        [_theme2 release];
        _theme2 = [theme2 retain];
    }
}

- (void)setTheme3:(UIColor *)theme3{
    if (_theme3 != theme3) {
        [_theme3 release];
        _theme3 = [theme3 retain];
    }
}


- (UIColor *)theme1 {
    return _theme1;
}
- (UIColor *)theme2 {
    return _theme2;
}
- (UIColor *)theme3 {
    return _theme3;
}
@end
