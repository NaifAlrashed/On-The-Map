//
//  Map.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/3/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//
import MapKit
class MapAndTableNetworkingModule {
    func getPins(completionHandler: @escaping (_ pin: Pin?, _ error: String?) -> Void) {
        let _ = Convenience.shared.makeRequest(path: .studentLocation, method: .get, json: nil, completionHandler: { (theJson, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let theJson = theJson else {
                completionHandler(nil, "theJson is nil")
                return
            }
            
            guard let results = theJson["results"] as? [[String:Any]] else {
                completionHandler(nil, "problems parsing json")
                return
            }
            
            for result in results {
                do {
                    let studentInfo = try StudentInformation(json: result)
                    let studentPin = self.makePin(from: studentInfo)
                    Convenience.pins.append(studentInfo)
                    completionHandler(studentPin, nil)
                } catch {
                    print("++++++++++++++++++++++++++++++++++++++++++++++++++ couldn't parse this ++++++++++++++")
                    print(result)
                    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                }
                
                print("----------------------------------------------------------------------")
            }
        })
    }
    private func makePin(from studentInfo: StudentInformation) -> Pin {
        return Pin(coordinate: CLLocationCoordinate2DMake(studentInfo.latitude, studentInfo.longitude), title: studentInfo.firstName + " " + studentInfo.lastName, subTitle: studentInfo.mediaURL)
    }
    
    func downloadAndSetUserInfo() {
        let _ = Convenience.shared.makeRequest(path: .userInfo, method: .get, json: nil, completionHandler: { (json, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let json = json else {
                print("json is nil")
                return
            }
            
            guard let user = json["user"] as? [String:Any] else {
                print("couldn't get user from \(json)")
                return
            }
            guard let firstName = user["first_name"] as? String else {
                print("could't get first_name from \(json)")
                return
            }
            
            guard let lastName = user["last_name"] as? String else {
                print("could't get last_name from \(json)")
                return
            }
            
            print("first name: \(firstName), last name: \(lastName)")
            
            Convenience.personalInfo.firstName = firstName
            Convenience.personalInfo.lastName = lastName
        })
    }
    
    func logout (completionHandler: @escaping (_ success: Bool) -> Void) {
        let _ = Convenience.shared.makeRequest(path: .login, method: .delete, json: nil, completionHandler: { (json, error) in
            
            guard error == nil else {
                print("got error: \(error)")
                completionHandler(false)
                return
            }
            
            guard let json = json else {
                print("json is nil!")
                completionHandler(false)
                return
            }
            
            print("got json!!!: \(json)")
            completionHandler(true)
        })
    }
}
