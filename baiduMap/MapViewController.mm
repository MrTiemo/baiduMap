//
//  MapViewController.m
//  baiduMap
//
//  Created by 爱尚家 on 16/6/29.
//  Copyright © 2016年 爱尚家. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong)BMKMapView* mapView;//地图
@property (nonatomic,strong)BMKUserLocation *userLocation; //定位功能
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch* searchAddress;
@end
@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.zoomLevel=17;//地图显示的级别
    self.view = _mapView;
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    _searchAddress.delegate = self;
}
//点击地图上边的建筑物标记事件
-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    CLLocationCoordinate2D coordinate = mapPoi.pt;
    //长按之前删除所有标注
    NSArray *arrayAnmation=[[NSArray alloc] initWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arrayAnmation];
    //设置地图标注
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    BMKReverseGeoCodeOption *re = [[BMKReverseGeoCodeOption alloc] init];
    re.reverseGeoPoint = coordinate;
    [_searchAddress reverseGeoCode:re];
    BOOL flag =[_searchAddress reverseGeoCode:re];
    if (!flag){
        NSLog(@"search failed!");
    }
}
////地图双击事件(显示所在街道)
//-(void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate{
//    //长按之前删除所有标注
//    NSArray *arrayAnmation=[[NSArray alloc] initWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:arrayAnmation];
//    //设置地图标注
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    annotation.coordinate = coordinate;
//    [_mapView addAnnotation:annotation];
//    BMKReverseGeoCodeOption *re = [[BMKReverseGeoCodeOption alloc] init];
//    re.reverseGeoPoint = coordinate;
//    [_searchAddress reverseGeoCode:re];
//    BOOL flag =[_searchAddress reverseGeoCode:re];
//    if (!flag){
//        NSLog(@"search failed!");
//    }
//}
//根据经纬度返回点击的位置的名称
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{

    NSLog(@"%@",result.address);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result.address message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//加载当前位置的经纬度，并显示到地图上
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"当前位置%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_locService stopUserLocationService];//取消定位
}
-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
