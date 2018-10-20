//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (IBAction)themeButtonPressed:(UIButton *)sender {
    NSString *buttonTitle = sender.titleLabel.text;
    
    if ([buttonTitle isEqualToString:@"Светлая"]) {
        
        UIColor *themeOne = [[self model] theme1];
        [self.delegate themesViewController:self didSelectTheme: themeOne];
        self.view.backgroundColor = themeOne;
        
    } else if ([buttonTitle isEqualToString:@"Темная"]) {
        
        UIColor *themeTwo = [[self model] theme2];
        [self.delegate themesViewController:self didSelectTheme: themeTwo];
        self.view.backgroundColor = themeTwo;
        
    } else if ([buttonTitle isEqualToString:@"Шампань"]) {
        
        UIColor *themeThree = [[self model] theme3];
        [self.delegate themesViewController:self didSelectTheme: themeThree];
        self.view.backgroundColor = themeThree;
        
    }
}

- (void)setModel:(Themes *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
}
- (IBAction)tapDone:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (Themes *)model {
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *lightThemeColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    UIColor *darkThemeColor = [[UIColor alloc] initWithRed:75.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f alpha:1.0];
    UIColor *champagneThemeColor = [[UIColor alloc] initWithRed:197.0f/255.0f green:179.0f/255.0f blue:88.0f/255.0f alpha:1.0];
    
    Themes *model = [[Themes alloc] initWithColorOne: lightThemeColor ColorTwo: darkThemeColor colorThree: champagneThemeColor];
    [self setModel:model];
    [model release];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)dealloc {
    [_model release];
    [super dealloc];
}

- (void)themesViewController:(nonnull ThemesViewController *)controller didSelectTheme:(nonnull UIColor *)selectedTheme {
}
@end
