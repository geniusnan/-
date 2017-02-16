//
//  BulletManager.h
//  弹幕
//
//  Created by sunroam on 17/2/15.
//  Copyright © 2017年 sunroam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;

@interface BulletManager : NSObject
@property (nonatomic,copy)void(^generateViewBlock)(BulletView *view);
//弹幕开始执行
-(void)start;

//弹幕停止执行
-(void)stop;
@end
