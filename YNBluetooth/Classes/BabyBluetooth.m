/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.


#import "BabyBluetooth.h"

@interface BabyBluetooth()

@property(nonatomic, strong) BabyCentralManager *babyCentralManager;
@property(nonatomic, strong) BabyPeripheralManager *babyPeripheralManager;
@property(nonatomic, strong) BabySpeaker *babySpeaker;
@property(nonatomic, assign) int CENTRAL_MANAGER_INIT_WAIT_TIMES;
@property(nonatomic, strong) NSTimer *timerForStop;

@end

@implementation BabyBluetooth

//单例模式
+ (instancetype)shareBabyBluetooth {
    static BabyBluetooth *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[BabyBluetooth alloc] init];
    });
   return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
        self.babyCentralManager = [[BabyCentralManager alloc] init];
        self.babySpeaker = [[BabySpeaker alloc]init];
        self.babyCentralManager->babySpeaker = self.babySpeaker;
        
        self.babyPeripheralManager = [[BabyPeripheralManager alloc]init];
        self.babyPeripheralManager->babySpeaker = self.babySpeaker;
    }
    return self;
    
}

#pragma mark - babybluetooth的委托
/*
 默认频道的委托
 */
//设备状态改变的委托
- (void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block {
    [[self.babySpeaker callback]setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
- (void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[self.babySpeaker callback]setBlockOnDiscoverPeripherals:block];
}
//连接Peripherals成功的委托
- (void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block {
    [[self.babySpeaker callback]setBlockOnConnectedPeripheral:block];
}
//连接Peripherals失败的委托
- (void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnFailToConnect:block];
}
//断开Peripherals的连接
- (void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDisconnect:block];
}
//设置查找服务回叫
- (void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDiscoverServices:block];
}
//设置查找到Characteristics的block
- (void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
- (void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
- (void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
- (void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnReadValueForDescriptors:block];
}

//写Characteristic成功后的block
- (void)setBlockOnDidWriteValueForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDidWriteValueForCharacteristic:block];
}
//写descriptor成功后的block
- (void)setBlockOnDidWriteValueForDescriptor:(void (^)(CBDescriptor *descriptor,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDidWriteValueForDescriptor:block];
}
//characteristic订阅状态改变的block
- (void)setBlockOnDidUpdateNotificationStateForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDidUpdateNotificationStateForCharacteristic:block];
}
//读取RSSI的委托
- (void)setBlockOnDidReadRSSI:(void (^)(NSNumber *RSSI,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDidReadRSSI:block];
}
//discoverIncludedServices的回调，暂时在babybluetooth中无作用
- (void)setBlockOnDidDiscoverIncludedServicesForService:(void (^)(CBService *service,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnDidDiscoverIncludedServicesForService:block];
}
//外设更新名字后的block
- (void)setBlockOnDidUpdateName:(void (^)(CBPeripheral *peripheral))block {
    [[self.babySpeaker callback]setBlockOnDidUpdateName:block];
}
//外设更新服务后的block
- (void)setBlockOnDidModifyServices:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block {
    [[self.babySpeaker callback]setBlockOnDidModifyServices:block];
}

//设置蓝牙使用的参数参数
- (void)setBabyOptionsWithScanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
                          connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
                        scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                  discoverWithServices:(NSArray *)discoverWithServices
                           discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics {
    BabyOptions *option = [[BabyOptions alloc]initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions scanForPeripheralsWithServices:scanForPeripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
    [[self.babySpeaker callback]setBabyOptions:option];
}

/*
 channel的委托
 */
//设备状态改变的委托
- (void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                 block:(void (^)(CBCentralManager *central))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
- (void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverPeripherals:block];
}

//连接Peripherals成功的委托
- (void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnConnectedPeripheral:block];
}

//连接Peripherals失败的委托
- (void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                  block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnFailToConnect:block];
}

//断开Peripherals的连接
- (void)setBlockOnDisconnectAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDisconnect:block];
}

//设置查找服务回叫
- (void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverServices:block];
}

//设置查找到Characteristics的block
- (void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
- (void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
- (void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
- (void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForDescriptors:block];
}

//写Characteristic成功后的block
- (void)setBlockOnDidWriteValueForCharacteristicAtChannel:(NSString *)channel
                                                        block:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidWriteValueForCharacteristic:block];
}
//写descriptor成功后的block
- (void)setBlockOnDidWriteValueForDescriptorAtChannel:(NSString *)channel
                                      block:(void (^)(CBDescriptor *descriptor,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidWriteValueForDescriptor:block];
}
//characteristic订阅状态改变的block
- (void)setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:(NSString *)channel
                                                                     block:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidUpdateNotificationStateForCharacteristic:block];
}
//读取RSSI的委托
- (void)setBlockOnDidReadRSSIAtChannel:(NSString *)channel
                                block:(void (^)(NSNumber *RSSI,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidReadRSSI:block];
}
//discoverIncludedServices的回调，暂时在babybluetooth中无作用
- (void)setBlockOnDidDiscoverIncludedServicesForServiceAtChannel:(NSString *)channel
                                                          block:(void (^)(CBService *service,NSError *error))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidDiscoverIncludedServicesForService:block];
}
//外设更新名字后的block
- (void)setBlockOnDidUpdateNameAtChannel:(NSString *)channel
                                  block:(void (^)(CBPeripheral *peripheral))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidUpdateName:block];
}
//外设更新服务后的block
- (void)setBlockOnDidModifyServicesAtChannel:(NSString *)channel
                                      block:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBlockOnDidModifyServices:block];
}


//设置蓝牙运行时的参数
- (void)setBabyOptionsAtChannel:(NSString *)channel
 scanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
  connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
    scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
          discoverWithServices:(NSArray *)discoverWithServices
   discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics {
    
    BabyOptions *option = [[BabyOptions alloc]initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions scanForPeripheralsWithServices:scanForPeripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
     [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBabyOptions:option];
}

#pragma mark - babybluetooth filter委托
//设置查找Peripherals的规则
- (void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[self.babySpeaker callback]setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
- (void)setFilterOnConnectToPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[self.babySpeaker callback]setFilterOnconnectToPeripherals:filter];
}
//设置查找Peripherals的规则
- (void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
- (void)setFilterOnConnectToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnconnectToPeripherals:filter];
}

#pragma mark - babybluetooth Special
//babyBluettooth cancelScan方法调用后的回调
- (void)setBlockOnCancelScanBlock:(void(^)(CBCentralManager *centralManager))block {
    [[self.babySpeaker callback]setBlockOnCancelScan:block];
}
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
- (void)setBlockOnCancelAllPeripheralsConnectionBlock:(void(^)(CBCentralManager *centralManager))block{
    [[self.babySpeaker callback]setBlockOnCancelAllPeripheralsConnection:block];
}
//babyBluettooth cancelScan方法调用后的回调
- (void)setBlockOnCancelScanBlockAtChannel:(NSString *)channel
                                    block:(void(^)(CBCentralManager *centralManager))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelScan:block];
}
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
- (void)setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:(NSString *)channel
                                                        block:(void(^)(CBCentralManager *centralManager))block {
    [[self.babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelAllPeripheralsConnection:block];
}

#pragma mark - 链式函数
//查找Peripherals
- (BabyBluetooth *(^)(void)) scanForPeripherals {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needScanForPeripherals"];
        return self;
    };
}

//连接Peripherals
- (BabyBluetooth *(^)(void)) connectToPeripherals {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needConnectPeripheral"];
        return self;
    };
}

//发现Services
- (BabyBluetooth *(^)(void)) discoverServices {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverServices"];
        return self;
    };
}

//获取Characteristics
- (BabyBluetooth *(^)(void)) discoverCharacteristics {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverCharacteristics"];
        return self;
    };
}

//更新Characteristics的值
- (BabyBluetooth *(^)(void)) readValueForCharacteristic {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needReadValueForCharacteristic"];
        return self;
    };
}

//设置查找到Descriptors名称的block
- (BabyBluetooth *(^)(void)) discoverDescriptorsForCharacteristic {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverDescriptorsForCharacteristic"];
        return self;
    };
}

//设置读取到Descriptors值的block
- (BabyBluetooth *(^)(void)) readValueForDescriptors {
    return ^BabyBluetooth *() {
        [self.babyCentralManager->pocket setObject:@"YES" forKey:@"needReadValueForDescriptors"];
        return self;
    };
}

//开始并执行
- (BabyBluetooth *(^)(void)) begin {
    return ^BabyBluetooth *() {
        //取消未执行的stop定时任务
        [self.timerForStop invalidate];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self resetSeriseParmeter];
            //处理链式函数缓存的数据
            if ([[self.babyCentralManager->pocket valueForKey:@"needScanForPeripherals"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needScanForPeripherals = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needConnectPeripheral"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needConnectPeripheral = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needDiscoverServices"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needDiscoverServices = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needDiscoverCharacteristics"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needDiscoverCharacteristics = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needReadValueForCharacteristic"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needReadValueForCharacteristic = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needDiscoverDescriptorsForCharacteristic"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needDiscoverDescriptorsForCharacteristic = YES;
            }
            if ([[self.babyCentralManager->pocket valueForKey:@"needReadValueForDescriptors"] isEqualToString:@"YES"]) {
                self.babyCentralManager->needReadValueForDescriptors = YES;
            }
            //调整委托方法的channel，如果没设置默认为缺省频道
            NSString *channel = [self.babyCentralManager->pocket valueForKey:@"channel"];
            [self.babySpeaker switchChannel:channel];
            //缓存的peripheral
            CBPeripheral *cachedPeripheral = [self.babyCentralManager->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
            //校验series合法性
            [self validateProcess];
            //清空pocjet
            self.babyCentralManager->pocket = [[NSMutableDictionary alloc]init];
            //开始扫描或连接设备
            [self start:cachedPeripheral];
        });
        return self;
    };
}


//私有方法，扫描或连接设备
- (void)start:(CBPeripheral *)cachedPeripheral {
    BOOL poweredOn = NO;
    if (@available(iOS 10.0, *)) {
        if (self.babyCentralManager->centralManager.state == CBManagerStatePoweredOn) {
            poweredOn = YES;
        }
    } else {
        if (self.babyCentralManager->centralManager.state == CBCentralManagerStatePoweredOn) {
            poweredOn = YES;
        }
    }

    if (poweredOn) {
        self.CENTRAL_MANAGER_INIT_WAIT_TIMES = 0;
        //扫描后连接
        if (self.babyCentralManager->needScanForPeripherals) {
            //开始扫描peripherals
            [self.babyCentralManager scanPeripherals];
        }
        //直接连接
        else {
            if (cachedPeripheral) {
                [self.babyCentralManager connectToPeripheral:cachedPeripheral];
            }
        }
        return;
    }
    //尝试重新等待CBCentralManager打开
    self.CENTRAL_MANAGER_INIT_WAIT_TIMES ++;
    if (self.CENTRAL_MANAGER_INIT_WAIT_TIMES >= KBABY_CENTRAL_MANAGER_INIT_WAIT_TIMES ) {
        BabyLog(@">>> 第%d次等待CBCentralManager 打开任然失败，请检查你蓝牙使用权限或检查设备问题。", self.CENTRAL_MANAGER_INIT_WAIT_TIMES);
        return;
        //[NSException raise:@"CBCentralManager打开异常" format:@"尝试等待打开CBCentralManager5次，但任未能打开"];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, KBABY_CENTRAL_MANAGER_INIT_WAIT_SECOND * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self start:cachedPeripheral];
    });
    BabyLog(@">>> 第%d次等待CBCentralManager打开", self.CENTRAL_MANAGER_INIT_WAIT_TIMES);
}

//sec秒后停止
- (BabyBluetooth *(^)(int sec)) stop {
    
    return ^BabyBluetooth *(int sec) {
        BabyLog(@">>> stop in %d sec",sec);
        
        //听见定时器执行babyStop
        self.timerForStop = [NSTimer timerWithTimeInterval:sec target:self selector:@selector(babyStop) userInfo:nil repeats:NO];
        [self.timerForStop setFireDate: [[NSDate date]dateByAddingTimeInterval:sec]];
        [[NSRunLoop currentRunLoop] addTimer:self.timerForStop forMode:NSRunLoopCommonModes];
        
        return self;
    };
}

//私有方法，停止扫描和断开连接，清空pocket
- (void)babyStop {
    BabyLog(@">>>did stop");
    [self.timerForStop invalidate];
    [self resetSeriseParmeter];
    self.babyCentralManager->pocket = [[NSMutableDictionary alloc]init];
    //停止扫描，断开连接
    [self.babyCentralManager cancelScan];
    [self.babyCentralManager cancelAllPeripheralsConnection];
}

//重置串行方法参数
- (void)resetSeriseParmeter {
    self.babyCentralManager->needScanForPeripherals = NO;
    self.babyCentralManager->needConnectPeripheral = NO;
    self.babyCentralManager->needDiscoverServices = NO;
    self.babyCentralManager->needDiscoverCharacteristics = NO;
    self.babyCentralManager->needReadValueForCharacteristic = NO;
    self.babyCentralManager->needDiscoverDescriptorsForCharacteristic = NO;
    self.babyCentralManager->needReadValueForDescriptors = NO;
}

//持有对象
- (BabyBluetooth *(^)(id obj)) having {
    return ^(id obj) {
        [self.babyCentralManager->pocket setObject:obj forKey:NSStringFromClass([obj class])];
        return self;
    };
}


//切换委托频道
- (BabyBluetooth *(^)(NSString *channel)) channel {
    return ^BabyBluetooth *(NSString *channel) {
        //先缓存数据，到begin方法统一处理
        [self.babyCentralManager->pocket setValue:channel forKey:@"channel"];
        return self;
    };
}

- (void)validateProcess {
    
    NSMutableArray *faildReason = [[NSMutableArray alloc]init];
    
    //规则：不执行discoverDescriptorsForCharacteristic()时，不能执行readValueForDescriptors()
    if (!self.babyCentralManager->needDiscoverDescriptorsForCharacteristic) {
        if (self.babyCentralManager->needReadValueForDescriptors) {
            [faildReason addObject:@"未执行discoverDescriptorsForCharacteristic()不能执行readValueForDescriptors()"];
        }
    }
    
    //规则：不执行discoverCharacteristics()时，不能执行readValueForCharacteristic()或者是discoverDescriptorsForCharacteristic()
    if (!self.babyCentralManager->needDiscoverCharacteristics) {
        if (self.babyCentralManager->needReadValueForCharacteristic
            || self.babyCentralManager->needDiscoverDescriptorsForCharacteristic) {
            [faildReason addObject:@"未执行discoverCharacteristics()不能执行readValueForCharacteristic()或discoverDescriptorsForCharacteristic()"];
        }
    }
    
    //规则： 不执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()
    if (!self.babyCentralManager->needDiscoverServices) {
        if (self.babyCentralManager->needDiscoverCharacteristics
            || self.babyCentralManager->needDiscoverDescriptorsForCharacteristic
            || self.babyCentralManager->needReadValueForCharacteristic
            || self.babyCentralManager->needReadValueForDescriptors) {
             [faildReason addObject:@"未执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()"];
        }
        
    }

    //规则：不执行connectToPeripherals()时，不能执行discoverServices()
    if(!self.babyCentralManager->needConnectPeripheral) {
        if (self.babyCentralManager->needDiscoverServices) {
             [faildReason addObject:@"未执行connectToPeripherals()不能执行discoverServices()"];
        }
    }
    
    //规则：不执行needScanForPeripherals()，那么执行connectToPeripheral()方法时必须用having(peripheral)传入peripheral实例
    if (!self.babyCentralManager->needScanForPeripherals) {
        CBPeripheral *peripheral = [self.babyCentralManager->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
        if (!peripheral) {
            [faildReason addObject:@"若不执行scanForPeripherals()方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral"];
        }
    }
    
    //抛出异常
    if ([faildReason lastObject]) {
        NSException *e = [NSException exceptionWithName:@"BadyBluetooth usage exception" reason:[faildReason lastObject]  userInfo:nil];
        @throw e;
    }
  
}

- (BabyBluetooth *)and {
    return self;
}
- (BabyBluetooth *)then {
    return self;
}
- (BabyBluetooth *)with {
    return self;
}

- (BabyBluetooth *(^)(void)) enjoy {
    return ^BabyBluetooth *(void) {
        self.connectToPeripherals().discoverServices().discoverCharacteristics()
        .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        return self;
    };
}

#pragma mark - 工具方法
//断开连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    [self.babyCentralManager cancelPeripheralConnection:peripheral];
}
//断开所有连接
- (void)cancelAllPeripheralsConnection {
    [self.babyCentralManager cancelAllPeripheralsConnection];
}
//停止扫描
- (void)cancelScan{
    [self.babyCentralManager cancelScan];
}
//读取Characteristic的详细信息
- (BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) characteristicDetails {
    //切换频道
    [self.babySpeaker switchChannel:[self.babyCentralManager->pocket valueForKey:@"channel"]];
    self.babyCentralManager->pocket = [[NSMutableDictionary alloc]init];
    
    return ^(CBPeripheral *peripheral,CBCharacteristic *characteristic) {
        //判断连接状态
        if (peripheral.state == CBPeripheralStateConnected) {
            self.babyCentralManager->oneReadValueForDescriptors = YES;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral discoverDescriptorsForCharacteristic:characteristic];
        }
        else {
            BabyLog(@"!!!设备当前处于非连接状态");
        }
        
        return self;
    };
}

- (void)notify:(CBPeripheral *)peripheral
characteristic:(CBCharacteristic *)characteristic
        block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    //设置通知
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    [self.babySpeaker addNotifyCallback:characteristic withBlock:block];
}

- (void)cancelNotify:(CBPeripheral *)peripheral
     characteristic:(CBCharacteristic *)characteristic {
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    [self.babySpeaker removeNotifyCallback:characteristic];
}

//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals {
     return [self.babyCentralManager findConnectedPeripherals];
}

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName {
     return [self.babyCentralManager findConnectedPeripheral:peripheralName];
}

//获取当前corebluetooth的centralManager对象
- (CBCentralManager *)centralManager {
    return self.babyCentralManager->centralManager;
}

/**
 添加断开自动重连的外设
 */
- (void)AutoReconnect:(CBPeripheral *)peripheral{
    [self.babyCentralManager sometimes_ever:peripheral];
}

/**
 删除断开自动重连的外设
 */
- (void)AutoReconnectCancel:(CBPeripheral *)peripheral{
    [self.babyCentralManager sometimes_never:peripheral];
}
 
- (CBPeripheral *)retrievePeripheralWithUUIDString:(NSString *)UUIDString {
    CBPeripheral *p = nil;
    @try {
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:UUIDString];
        p = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]][0];
    } @catch (NSException *exception) {
        BabyLog(@">>> retrievePeripheralWithUUIDString error:%@",exception)
    } @finally {
    }
    return p;
}

#pragma mark - peripheral model

//进入外设模式

- (CBPeripheralManager *)peripheralManager {
    return self.babyPeripheralManager.peripheralManager;
}

- (BabyPeripheralManager *(^)(void)) bePeripheral {
    return ^BabyPeripheralManager* () {
        return self.babyPeripheralManager;
    };
}
- (BabyPeripheralManager *(^)(NSString *localName)) bePeripheralWithName {
    return ^BabyPeripheralManager* (NSString *localName) {
        self.babyPeripheralManager.localName = localName;
        return self.babyPeripheralManager;
    };
}

- (void)peripheralModelBlockOnPeripheralManagerDidUpdateState:(void(^)(CBPeripheralManager *peripheral))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidUpdateState:block];
}
- (void)peripheralModelBlockOnDidAddService:(void(^)(CBPeripheralManager *peripheral,CBService *service,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidAddService:block];
}
- (void)peripheralModelBlockOnDidStartAdvertising:(void(^)(CBPeripheralManager *peripheral,NSError *error))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidStartAdvertising:block];
}
- (void)peripheralModelBlockOnDidReceiveReadRequest:(void(^)(CBPeripheralManager *peripheral,CBATTRequest *request))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidReceiveReadRequest:block];
}
- (void)peripheralModelBlockOnDidReceiveWriteRequests:(void(^)(CBPeripheralManager *peripheral,NSArray *requests))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidReceiveWriteRequests:block];
}
- (void)peripheralModelBlockOnDidSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidSubscribeToCharacteristic:block];
}
- (void)peripheralModelBlockOnDidUnSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block {
    [[self.babySpeaker callback]setBlockOnPeripheralModelDidUnSubscribeToCharacteristic:block];
}

@end


