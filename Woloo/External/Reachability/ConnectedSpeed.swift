

import Foundation
import SystemConfiguration
import UIKit

// MARK:-  Call this method to get toast and call back

public func checkNetworkSpeed(completionHandler:@escaping (_ megabytesPerSecond: Double?, _ isWeakSignal: Bool) -> ()) {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    })else {
//         Logger.shared.showLog("Network Unreachable - Zero Address")
        return
        
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//         Logger.shared.showLog("Network Unreachable - Check Flags")
        return
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    ConnectedSpeed().testDownloadSpeedWithTimout(timeout: 5.0) { (megabytesPerSecond, error) -> () in
        
        if ((error == nil) && isReachable && !needsConnection){
            
            if megabytesPerSecond! >= 0.05 {
//                Logger.shared.showLog("=======Network Speed=======\nkBps: \(megabytesPerSecond!)\nerror: \(String(describing: error))\n=======-------------=======\n")
                completionHandler(megabytesPerSecond,false)
            }
            else{
//                Logger.shared.showLog("======| WEAK SIGNAL |======*\nkBps: \(megabytesPerSecond!)\nerror: \(String(describing: error))\n*=======-------------=======*\n")
                ConnectedSpeed().showBottomToast()
               completionHandler(megabytesPerSecond,true)
            }
        }
        else{
//            Logger.shared.showLog("NETWORK ERROR: \(String(describing: error))")
        }
    }
    
}

class ConnectedSpeed: NSObject,URLSessionDelegate {
    
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: Error?) -> ())!
    
    func testDownloadSpeedWithTimout(timeout: TimeInterval, completionHandler:@escaping (_ megabytesPerSecond: Double?, _ error: Error?) -> ()) {
        
        let url = URL(string: "https://vitune.publicam.in/test.jpg")!
        
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionHandler = completionHandler
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.current)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil{
                
                self.bytesReceived! += data?.count ?? 0
                self.stopTime = CFAbsoluteTimeGetCurrent()
                
                let elapsed = self.stopTime - self.startTime
                
                let speed = elapsed != 0 ? Double(self.bytesReceived) / elapsed / 1024.0/1024.0 : -1
                print("************** Internet Speed = \(speed) **************")
                self.speedTestCompletionHandler((speed * 8), nil)
            }
            else
            {
                let elapsed = self.stopTime - self.startTime
                
                guard elapsed != 0 && (error == nil) else {
                    self.speedTestCompletionHandler(nil, error)
                    return
                }
            }
        }
        
        dataTask.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
        let elapsed = stopTime - startTime
        
        guard elapsed != 0 && (error == nil) else {
            speedTestCompletionHandler(nil, error)
            return
        }
        
        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        speedTestCompletionHandler(speed, nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    func showBottomToast() {
        
        let notifyLabel = UILabel()
        var notifyLabelHeight:CGFloat = 0.0
      
        #if os(iOS)

        if Device.IS_IPHONE_6_OR_LESS{
            notifyLabelHeight = 20
        }
        else{
            notifyLabelHeight = 50.0
        }
        #elseif os(tvOS)
            notifyLabelHeight = 40.0
        #endif
       
          notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
        notifyLabel.backgroundColor = .main
        notifyLabel.numberOfLines = 0
        notifyLabel.text = "Slow internet connection"
        notifyLabel.textAlignment = .center
        notifyLabel.textColor = UIColor.white
        notifyLabel.alpha = 1.0
        notifyLabel.tag = 70707070
        
        #if os(iOS)
        notifyLabel.font = ThemeManager.Font.MavenPro_Regular()
        #elseif os(tvOS)
        notifyLabel.font = ThemeManager.Font.MavenPro_Regular(size: 24)
        #endif
      
       
        DELEGATE.window?.addSubview(notifyLabel)
        // Fallback on earlier versions
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveEaseIn, animations:{
            
            notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height - notifyLabelHeight , width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
            
        }, completion:{ finished in
            
            UIView.animate(withDuration: 0.3, delay: 2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations:{
                
                notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
            }, completion: { finished in
                
                notifyLabel.removeFromSuperview()
            })
        })
    }
    
    func removeLabel()  {
       
        if let subviews =  DELEGATE.window?.subviews{
           
            for notifyLabel in subviews{
                
                if ((notifyLabel as? UILabel) != nil){
                    
                    if notifyLabel.tag == 70707070{
                        notifyLabel.removeFromSuperview()
                        break
                    }
                }
            }
        }

    }
}

