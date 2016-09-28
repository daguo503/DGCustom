//
//  DGProgressHUD.h
//  Hud
//
//  Created by Mac on 2016/9/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGProgressHUD;

typedef void(^DGProgressHUDCloseBlock)(DGProgressHUD *progressHud);

@interface DGProgressHUD : UIView

+ (instancetype)shareInstance;

+(void)showHudWithTitle:(NSString *)title flag:(NSString *)flag inView:(UIView *)fatherView closeBlock:(DGProgressHUDCloseBlock)closeBlock;

@end
