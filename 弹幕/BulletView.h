//
//  BulletView.h
//  弹幕
//
//  Created by sunroam on 17/2/15.
//  Copyright © 2017年 sunroam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MoveStatus){
    start,
    enter,
    end
};

@interface BulletView : UIView

@property (nonatomic ,assign)int trajectory; //弹道
@property (nonatomic ,copy)void(^moveStatusBlock)(MoveStatus status);

//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment;

//开始动画
-(void)startAnimation;

//结束动画
-(void)stopAnimation;

@end
