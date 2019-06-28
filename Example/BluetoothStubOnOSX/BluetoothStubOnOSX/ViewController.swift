//
//  ViewController.swift
//  BluetoothStubOnOSX
//
//  Created by ZTELiuyw on 15/9/30.
//  Copyright © 2015年 liuyanwei. All rights reserved.
//

import Cocoa
import CoreBluetooth



class ViewController: NSViewController,CBPeripheralManagerDelegate{

//MARK:- static parameter

    let localNameKey =  "BabyBluetoothStubOnOSX";
    let ServiceUUID =  "FFF0";
    let notiyCharacteristicUUID =  "FFF1";
    let readCharacteristicUUID =  "FFF2";
    let readwriteCharacteristicUUID =  "FFE3";
    
    var peripheralManager:CBPeripheralManager!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    //publish service and characteristic
    func publishService(){
        
        let notiyCharacteristic = CBMutableCharacteristic(type: CBUUID(string: notiyCharacteristicUUID), properties:  [CBCharacteristicProperties.notify], value: nil, permissions: CBAttributePermissions.readable)
        let readCharacteristic = CBMutableCharacteristic(type: CBUUID(string: readCharacteristicUUID), properties:  [CBCharacteristicProperties.read], value: nil, permissions: CBAttributePermissions.readable)
        let writeCharacteristic = CBMutableCharacteristic(type: CBUUID(string: readwriteCharacteristicUUID), properties:  [CBCharacteristicProperties.write,CBCharacteristicProperties.read], value: nil, permissions: [CBAttributePermissions.readable,CBAttributePermissions.writeable])
        
        //设置description
        let descriptionStringType = CBUUID(string: CBUUIDCharacteristicUserDescriptionString)
        let description1 = CBMutableDescriptor(type: descriptionStringType, value: "canNotifyCharacteristic")
        let description2 = CBMutableDescriptor(type: descriptionStringType, value: "canReadCharacteristic")
        let description3 = CBMutableDescriptor(type: descriptionStringType, value: "canWriteAndWirteCharacteristic")
        notiyCharacteristic.descriptors = [description1];
        readCharacteristic.descriptors = [description2];
        writeCharacteristic.descriptors = [description3];
        
        //设置service
        let service:CBMutableService =  CBMutableService(type: CBUUID(string: ServiceUUID), primary: true)
        service.characteristics = [notiyCharacteristic,readCharacteristic,writeCharacteristic]
        peripheralManager.add(service)
        
    }
    //发送数据，发送当前时间的秒数
    @objc
    func sendData(t: Timer)->Bool{
        let characteristic = t.userInfo as!  CBMutableCharacteristic;
        let dft = DateFormatter();
        dft.dateFormat = "ss";
        NSLog("%@", dft.string(from: Date()))
        
        //执行回应Central通知数据
        return peripheralManager.updateValue(dft.string(from: Date()).data(using: String.Encoding.utf8) ?? Data(), for: characteristic, onSubscribedCentrals: nil)
    }

    //MARK:- CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            NSLog("power on")
            publishService();
        case .poweredOff:
            NSLog("power off")
        default:break;
        }
    }
    
    
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        peripheralManager.startAdvertising(
            [
                CBAdvertisementDataServiceUUIDsKey : [CBUUID(string: ServiceUUID)]
                ,CBAdvertisementDataLocalNameKey : localNameKey
            ]
        )
    }
    
    private func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        NSLog("in peripheralManagerDidStartAdvertisiong");
    }
    
    //订阅characteristics
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        NSLog("订阅了 %@的数据",characteristic.uuid)
        //每秒执行一次给主设备发送一个当前时间的秒数
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(sendData(t:)) , userInfo: characteristic, repeats: true)
    }
    
    
    //取消订阅characteristics
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        NSLog("取消订阅 %@的数据",characteristic.uuid)
        //取消回应
        timer.invalidate()
    }
   
    
    //读characteristics请求
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        NSLog("didReceiveReadRequest")
        //判断是否有读数据的权限
        if(request.characteristic.properties.contains(CBCharacteristicProperties.read))
        {
            request.value = request.characteristic.value;
            peripheral.respond(to: request, withResult: CBATTError.success)
        }
        else{
            peripheral.respond(to: request, withResult: CBATTError.readNotPermitted)
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
        NSLog("didReceiveWriteRequests")
        let request:CBATTRequest = requests[0];
        
        //判断是否有写数据的权限
        if (request.characteristic.properties.contains(CBCharacteristicProperties.write)) {
            //需要转换成CBMutableCharacteristic对象才能进行写值
            let c:CBMutableCharacteristic = request.characteristic as! CBMutableCharacteristic
            c.value = request.value;
            peripheral.respond(to: request, withResult: CBATTError.success);
        }else{
            peripheral .respond(to: request, withResult: CBATTError.readNotPermitted);
        }
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
            NSLog("peripheralManagerIsReadyToUpdateSubscribers")
    }
}

