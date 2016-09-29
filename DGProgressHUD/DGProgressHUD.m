//
//  DGProgressHUD.m
//  Hud
//
//  Created by Mac on 2016/9/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DGProgressHUD.h"


#define animationTime 0.5
#define hiddenHudAnimationTime 0.5
#define defaultArcColor  [UIColor redColor]
#define viewCornerRadius 4.0

@interface DGProgressHUD ()
{
    
    CAShapeLayer *_arcLayer;
    UIColor      *_layerColor;
}
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UIButton    *closeBtn;
@property(nonatomic,strong)UIView      *frontView;
@property(nonatomic,strong)UILabel     *desLabel;
@property(nonatomic,copy)NSString      *hudFlag;
@property(nonatomic,copy)NSMutableArray *hudArray;

@property (nonatomic,copy) DGProgressHUDCloseBlock closeBlock;
@end

@implementation DGProgressHUD


+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static DGProgressHUD *shareView;
    dispatch_once(&once, ^{
        
        shareView.hudArray = [[NSMutableArray alloc]init];
    });
    return shareView;
}


-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 160, 160)];
    if (self) {
        
        CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.layer.cornerRadius = viewCornerRadius;
        self.layer.masksToBounds = true;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8f;
        
        _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(48, 48, 64, 64)];
        [_logoView setImage:[UIImage imageNamed:@"hud_logo"]];
        [self addSubview:_logoView];
        _frontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_frontView];
        
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 0, 30, 30)];
        [_closeBtn setImage:[UIImage imageNamed:@"hud_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeHud) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 124, 140, 21)];
        _desLabel.font = [UIFont systemFontOfSize:14.0f];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor whiteColor];
        [self addSubview:_desLabel];
        
        
        
        UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_logoView.frame.size.width/2-1 startAngle:0 endAngle:M_PI*2 clockwise:true];
        _arcLayer = [[CAShapeLayer alloc] init];
        _arcLayer.path = arcPath.CGPath;
        _arcLayer.lineWidth = 4;
        _arcLayer.strokeStart = 11/16.0;
        _arcLayer.strokeEnd=13/16.0;
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor = [UIColor orangeColor].CGColor;
        [self.frontView.layer addSublayer:_arcLayer];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

//关闭指示器
-(void)closeHud
{
    if (self.closeBlock) {
        self.closeBlock(self);
    }
    [self endAnimation];
}

-(void)beginAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI-1, 0, 0, 1)];
    rotationAnimation.duration = animationTime;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = true;
    [self.frontView.layer addAnimation:rotationAnimation forKey:self.hudFlag];
    
}


-(void)endAnimation
{
    [UIView animateWithDuration:hiddenHudAnimationTime animations:^(void){
        self.alpha = 0.0f;
    }completion:^(BOOL finish){
        if (finish) {
            [self.layer removeAnimationForKey:self.hudFlag];
            [self removeFromSuperview];
//            NSInteger index = [[DGProgressHUD shareInstance].hudArray indexOfObject:self];
            [[DGProgressHUD shareInstance].hudArray removeObject:self];
        }
    }];
}


+(void)showHudWithTitle:(NSString *)title flag:(NSString *)flag inView:(UIView *)fatherView closeBlock:(DGProgressHUDCloseBlock)closeBlock
{
    
    DGProgressHUD *hud = [[DGProgressHUD alloc]init];
    hud.closeBlock = closeBlock;
    hud.hudFlag = flag;
    hud.desLabel.text = title;
    [[DGProgressHUD shareInstance].hudArray addObject:hud];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    hud.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    [fatherView addSubview:hud];
    [hud beginAnimation];
    
}

-(void)hideHudWithFlag:(NSString *)flag
{
    for (DGProgressHUD *hudview in [DGProgressHUD shareInstance].hudArray) {
        if ([hudview.hudFlag isEqualToString:flag] ) {
            [hudview endAnimation];
        }
    }
}



@end
