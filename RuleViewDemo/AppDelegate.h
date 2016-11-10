//
//  AppDelegate.h
//  RuleViewDemo
//
//  Created by 张豪豪 on 16/11/10.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

