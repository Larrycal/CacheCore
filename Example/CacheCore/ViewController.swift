//
//  ViewController.swift
//  CacheCore
//
//  Created by Larrycal on 04/24/2018.
//  Copyright (c) 2018 Larrycal. All rights reserved.
//

import UIKit
import Moya
import CocoaAsyncSocket
import CacheCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .lightGray
        self.databaseTest()
//        let config = CacheBusinessConfig(length: 10, tableName: "test")
//        let dbPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
//                                                         FileManager.SearchPathDomainMask.userDomainMask,
//                                                         true).first!
//        print(dbPath)
//        let t = NetWorkSocketManager(host: "127.0.0.1", port: 12345, config: config)
//        t.start()
    }

    // MARK: - socket测试
//    func socketTest() {
//        let btn = UIButton(type: .system)
//        btn.setTitle("发送数据", for: UIControlState())
//        btn.rx.tap.subscribe(onNext: {
//            self.writeData()
//        })
//            .disposed(by: self.disposeBag)
//        self.view.addSubview(btn)
//        btn.snp.makeConstraints { (make) in
//            make.width.equalTo(100)
//            make.height.equalTo(30)
//            make.center.equalToSuperview()
//        }
//        debugPrint("开始socket测试")
//        do {
//            try self.socket.connect(toHost: "127.0.0.1", onPort: 12345)
//        } catch {
//            debugPrint("socket链接失败")
//        }
//    }

    func writeData() {
        guard let t = "Hello World".data(using: String.Encoding.utf8) else {
            debugPrint("string to data 失败")
            return
        }
        self.socket.write(t, withTimeout: -1, tag: 0)
    }

    func configDelegate() {
        self.socketDelegate.socketDidReadDataWithTagHandler = {
            (_ sock: GCDAsyncSocket, _ data: Data, _ tag: Int) -> Void in
            guard let s = String(data: data, encoding: String.Encoding.utf8) else {
                debugPrint("Data 转换 String 失败")
                return
            }
            if !s.dropReturnSymbol().isEmpty {
                print(s.dropReturnSymbol())
            }
        }
        self.socketDelegate.socketDidConnectToHostHandler = {
            (_ sock: GCDAsyncSocket, _ host: String, _ port: UInt16) -> Void in
            debugPrint("链接到 host: \(host) port:\(port) 成功")
            self.socket.readData(withTimeout: -1, tag: 0)
        }

        self.socketDelegate.socketDidWriteDataWithTagHandler = {
            (_ sock: GCDAsyncSocket, _ tag: Int) -> Void in
            debugPrint("发送数据成功")
            self.socket.readData(withTimeout: -1, tag: 0)
        }
    }

    func openSocketBackgroundThread() {
        let socketThread = Thread(target: self, selector: #selector(onBackgroundThreadToReadData), object: nil)
        socketThread.start()
    }

    @objc func onBackgroundThreadToReadData() {
        debugPrint("当前线程：\(Thread.current)  主线程：\(Thread.main)")
        // 开启runloop
        let runloop = RunLoop.current
        runloop.add(Timer(timeInterval: 0.5, repeats: true, block: { [unowned self](timer) in
            self.socket.readData(withTimeout: -1, tag: 0)
        }), forMode: RunLoopMode.defaultRunLoopMode)
        runloop.run()
    }

    //MARK: - 数据库测试
    func databaseTest() {
        let network = MoyaProvider<NetworkService>()
        let config = CacheBusinessConfig(length: 10, tableName: "test")
        let helper = CacheHelper(provider: network, config: config, target: NetworkService.photos)
        helper.deleteTableWith(config: config) { b in
            if b {
                debugPrint("删除表成功")
            }
        }
        helper.fetchCachedData(config: config, flag: nil) { (s: Bool, msg: String?, data: [Model]?, f: String?) in
            if s {
                for item in data! {
                    print(item.id)
                }
                print(msg!)
            } else {
                debugPrint("\(msg!)")
            }
        }
    }

    // MARK: - 私有属性
    private lazy var socket:GCDAsyncSocket = {
        let temp = GCDAsyncSocket(delegate: self.socketDelegate, delegateQueue: DispatchQueue.global())
        return temp
    }()

    private lazy var socketDelegate:NetworkSocketDelegate = {
        let temp = NetworkSocketDelegate()
        return temp
    }()

}



