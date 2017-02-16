//
//  BulletManager.m
//  弹幕
//
//  Created by sunroam on 17/2/15.
//  Copyright © 2017年 sunroam. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

//弹幕的数据来源
@property (nonatomic, strong)NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong)NSMutableArray *bulletComment;
//存储弹幕view的数组变量
@property (nonatomic, strong)NSMutableArray *bulletViews;

@property BOOL isStopAnimation;

@end

@implementation BulletManager

-(instancetype)init{
    if (self=[super init]) {
        _isStopAnimation =YES;
    }
    return self;
}

-(void)start{
    if (!_isStopAnimation) {
        return;
    }
    _isStopAnimation =NO;
    [self.bulletComment removeAllObjects];
    [self.bulletComment addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}

//初始化弹幕，随机分配弹幕轨迹
-(void)initBulletComment{
    NSMutableArray *trajectorys =[NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i =0 ; i<3; i++) {
        if (self.bulletComment.count>0) {
            //通过随机数获取到弹幕的轨迹
            NSInteger index =arc4random()%trajectorys.count;
            int trajectory =[[trajectorys objectAtIndex:index]intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕数据
            NSString *comment =[self.bulletComment firstObject];
            [self.bulletComment removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
    
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (_isStopAnimation) {
        return;
    }
    BulletView *view =[[BulletView alloc]initWithComment:comment];
    view.trajectory =trajectory;
    [self.bulletViews addObject:view];
    __weak typeof  (view) weakView =view;
    __weak typeof(self) weakSelf =self;
    view.moveStatusBlock =^(MoveStatus status){
        if (_isStopAnimation) {
            return ;
        }
        switch (status) {
            case start:{
            //弹幕开始进入屏幕，将view加入弹幕管理的变量bulletViews
                [weakSelf.bulletViews addObject:weakView];
            }
                break;
            case enter:{
            //弹幕完全进入屏幕，判断是否还有其他弹幕，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment =[weakSelf nextComment];
                if (comment) {
                    //递归方式调用自身方法
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf createBulletView:comment trajectory:trajectory];

                    });
                }
            }
                break;
            case end:{
                //弹幕飞出屏幕后从bulletViews|中删除，释放资源
                //移出屏幕后销毁弹幕并释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if (weakSelf.bulletViews.count ==0) {
                    //屏幕上没有弹幕了，开始循环滚动
                    _isStopAnimation =YES;
                    [weakSelf start];
                }
                
            }
                break;
            default:
                break;
        }
        
       
    };
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
    
}

-(NSString *)nextComment{
    if (self.bulletComment.count==0) {
        return nil;
    }
    NSString *comment =[self.bulletComment firstObject];
    if (comment) {
        [self.bulletComment removeObjectAtIndex:0];
    }
    return comment;
}

-(void)stop{
    if (_isStopAnimation) {
        return;
    }
    _isStopAnimation=YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view =obj;
        [view stopAnimation];
        view=nil;
    }];
    [self.bulletViews removeAllObjects];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource =[NSMutableArray arrayWithArray:@[@"弹幕1~~~~~",@"弹幕2~~~",@"弹幕3~~~~~~~~~~~",@"弹幕4~~~~~",@"弹幕5~~~",@"弹幕6~~~~~~~~~~~",@"弹幕7~~~~~",@"弹幕8~~~",@"弹幕9~~~~~~~~~~~",@"弹幕11~~~~~",@"弹幕12~~~",@"弹幕13~~~~~~~~~~~"]];
    }
    return _dataSource;
}

-(NSMutableArray *)bulletComment{
    if (!_bulletComment) {
        _bulletComment =[NSMutableArray array];
    }
    return _bulletComment;
}

-(NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews =[NSMutableArray array];
    }
    return _bulletViews;
}

@end
