//
//  AppDelegate.h
//  baiduMap
//
//  Created by 爱尚家 on 16/6/29.
//  Copyright © 2016年 爱尚家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "MapViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@end

