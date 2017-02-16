//
//  BulletView.m
//  弹幕
//
//  Created by sunroam on 17/2/15.
//  Copyright © 2017年 sunroam. All rights reserved.
//

#import "BulletView.h"
#define  Padding 10 //两边的间距
#define ImageWidth 30 //图片宽高

@interface BulletView ()
@property (nonatomic ,strong)UILabel *commentLabel;
@property (nonatomic ,strong)UIImageView *photoImageView;
@end

@implementation BulletView

-(instancetype)initWithComment:(NSString *)comment{
    if (self =[super init]) {
        self.backgroundColor =[UIColor redColor];
        //计算弹幕的宽度
        NSDictionary *attr =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width =[comment sizeWithAttributes:attr].width;
        self.bounds =CGRectMake(0, 0, width+2*Padding+ImageWidth, 30);
        self.layer.masksToBounds =YES;
        self.clipsToBounds =NO;
        self.layer.cornerRadius =5;
        self.layer.borderColor =[UIColor grayColor].CGColor;
        self.layer.borderWidth =0.5;
        self.commentLabel.text =comment;
        self.commentLabel.frame =CGRectMake(Padding+ImageWidth, 0, width, 30);
        self.photoImageView.frame =CGRectMake(-Padding, -Padding, ImageWidth+Padding, ImageWidth+Padding);
          }
        self.photoImageView.image =[UIImage imageNamed:@"index9.jpeg"];
    return self;
}

-(void)startAnimation{
    //根据弹幕的长度执行动画
    //一共4秒 越长动画越快
    CGFloat screenWidth =[UIScreen mainScreen].bounds.size.width;
    CGFloat duration =4.0;
    CGFloat wholeWidth =screenWidth +CGRectGetWidth(self.bounds);
    
    if (self.moveStatusBlock) {
        self.moveStatusBlock(start);
    }
    // t=s/v
    CGFloat speed =wholeWidth/duration;
    CGFloat enterDuration =CGRectGetWidth(self.bounds)/speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame =self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -=wholeWidth;
        self.frame =frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(end);
        }
    }];
}

-(void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(enter);
    }

}

-(void)stopAnimation{
    //把延迟取消
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        _commentLabel.font =[UIFont systemFontOfSize:14];
        _commentLabel.textColor =[UIColor whiteColor];
        _commentLabel.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}

-(UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView =[[UIImageView alloc]init];
        _photoImageView.layer.masksToBounds =YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.cornerRadius =(ImageWidth+Padding)/2;
        _photoImageView.layer.borderColor =[UIColor yellowColor].CGColor;
        _photoImageView.layer.borderWidth=1.0;
        [self addSubview:_photoImageView];
    }
    return _photoImageView;
}

@end
