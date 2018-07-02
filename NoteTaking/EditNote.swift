//
//  EditNote.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 11/22/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import MessageUI
import AssetsLibrary
import Photos

var imageArray: [UIImage] = []
var longitudeArray:[Double] = []
var lattitudeArray:[Double] = []
var indexCounter:Int = -1

class EditNote: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var note: UITextView!
    var noteVal = String()
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var newRow:Bool = false
    @IBOutlet weak var mapView: MKMapView!
    let locationManage = CLLocationManager()
    var imageData:NSData!
    var lat:Double!
    var long:Double!
    var location: CLLocation!
    
    ///http://maps.google.com/?saddr=34.052222,-118.243611&daddr=37.322778,-122.031944
    ///https://www.google.com/maps?saddr=My+Location&daddr=37.785834,-122.406417
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as! CLLocation
    }
    
    func displayMapOnSelectImg(selectionType:String){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.10, 0.10)
        
        if selectionType == "album"{
            
            let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation,span: span)
            /*mapView.setRegion(region, animated: true)
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = userLocation
            objectAnnotation.title = "location"
            self.mapView.addAnnotation(objectAnnotation)
            self.mapView.showsUserLocation = true
             */
        }else{
            
            let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
           /* let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation,span: span)
            mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
            
           
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = userLocation
            objectAnnotation.title = "location"
            self.mapView.addAnnotation(objectAnnotation)
            */
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.note.delegate = self as? UITextViewDelegate
        self.view.backgroundColor = UIColor.yellow
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.requestWhenInUseAuthorization()
        locationManage.startUpdatingLocation()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNotes))
        let addPhotoButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(clickAlbum))
        ///self.navigationItem.rightBarButtonItem = addButton
        
        let addButtonCam = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(clickCamera))
        let addButtonCompose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(clickCompose))
        
        self.navigationItem.rightBarButtonItems = [addButton,addButtonCam,addPhotoButton,addButtonCompose]
        
        note.text = ""
        //note.text = data[counter]
        ///loadNotes()
        loadImg()
        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewShouldReturn(_ textField: UITextView)->Bool{
        textField.resignFirstResponder()
        return(true)
    }
    
    @objc func clickCompose(){
        if MFMailComposeViewController.canSendMail(){
            let subject = "Shumaz NoteApp"
            var messageBody = "Hey, how are you...?\n\(note.text!)\nCheck out the following link for directions\n"
            for index in 0 ..< imageArray.count{
            messageBody += "\n https://www.google.com/maps?saddr=My+Location&daddr=\(lattitudeArray[index]),\(longitudeArray[index])"
            }
            let toRecipients = ["abc@gmail.com"]
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(messageBody, isHTML: false)
            mailComposer.setToRecipients(toRecipients)
            ///let mimeType = MIMEType(type: "png")
            for index in 0 ..< imageArray.count{
                imageData = UIImagePNGRepresentation(imageArray[index])! as NSData
                mailComposer.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "image\(index+1)")
                
                
            }
            present(mailComposer,animated: true,completion: nil)
            print("in Compose")
        }
        print("in Compose")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Close")
        print(result.rawValue)
        self.dismiss(animated: true, completion: nil)
    }
   
    @objc func clickCamera(){
        print("Cam Click")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: false, completion: nil)
            displayMapOnSelectImg(selectionType: "camera")
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
            
        }
    }
    
    @objc func clickAlbum(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageData = UIImagePNGRepresentation(image)! as NSData
            if let URL = info[UIImagePickerControllerReferenceURL] as? URL {
                let opts = PHFetchOptions()
                opts.fetchLimit = 1
                let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
                if assets.count > 0 {
                    let asset = assets[0]
                    
                    if let location: CLLocation = asset.location {
                        let longitude = location.coordinate.longitude
                        let latitude = location.coordinate.latitude
                        lat = latitude
                        long = longitude
                        print("Photo Selection long-\(longitude)")
                        print("Photo Selection lat-\(latitude)")
                        displayMapOnSelectImg(selectionType: "album")
                    }
                }
             }
            var length:Int = imageArray.count
            print("length = \(length)")
            print("CAM Selection long-\(long)")
            print("CAM Selection lat-\(lat)")
            imageArray.insert(image, at: imageArray.count)
            longitudeArray.insert(long, at: longitudeArray.count)
            lattitudeArray.insert(lat, at: lattitudeArray.count)
            saveImg(imageData)
            showImageScrollView()
            
        }else{
            print("Error loading image...")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func saveImg(_ imgData:NSData){
        let imgDataStream = imgData.base64EncodedString(options: .lineLength64Characters)
        let contactDB = FMDatabase(path: databasePath as String)
        var name = note.text
        print(databasePath)
        if (contactDB.open()) {
            if(newRow){
                var insertSQL = "INSERT INTO notes (id, extra) VALUES (\(counter!),'\(note.text!)')"
                
                var result = contactDB.executeUpdate(insertSQL, withArgumentsIn:[])
                print(result)
                if !result {
                    print("Failed to Add row")
                } else {
                    // row was inserted
                    print("Row inserted...")
                }
            }else{
                var insertSQL = "UPDATE notes SET extra = '\(note.text!)' WHERE ID = \(counter!) "
                
                var result = contactDB.executeUpdate(insertSQL, withArgumentsIn:[])
                ///print(result)
               
                if !result {
                    print("Failed to update row")
                } else {
                    // row was inserted
                    print("Row updated...")
                }
            }
            let insertSQL = "INSERT INTO notesimage (note_id, img, long, lat) VALUES (\(counter!),'\(imgDataStream)','\(long!)','\(lat!)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn:[])
            ///print("Insert image sql=\(insertSQL)")
            
        } else {
            print ("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    func saveWithoutImg(){
        
        let contactDB = FMDatabase(path: databasePath as String)
        var name = note.text
        print(databasePath)
        if (contactDB.open()) {
            if(newRow){
                 var insertSQL = "INSERT INTO notes (id, extra) VALUES (\(counter!),'\(note.text!)')"
                let result = contactDB.executeUpdate(insertSQL, withArgumentsIn:[])
                ///print(result)
                if !result {
                    print("Failed to Add row")
                } else {
                    // row was inserted
                    print("Row inserted...")
                }
            }else{
                
                let insertSQL = "UPDATE notes SET extra = '\(note.text!)' WHERE ID = \(counter!) "
                let result = contactDB.executeUpdate(insertSQL, withArgumentsIn:[])
                ///print(result)
                if !result {
                    print("Failed to update row")
                } else {
                    // row was inserted
                    print("Row updated...")
                }
            }
        } else {
            print ("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    
    func loadImg(){
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            let querySQL = "SELECT extra FROM notes WHERE id = '\(counter!)'"
            
            imageArray.removeAll()
            longitudeArray.removeAll()
            lattitudeArray.removeAll()
            print (querySQL)
            let results: FMResultSet = contactDB.executeQuery(querySQL, withArgumentsIn: [])!
            
            if results.next() == true {
                note.text = results.string(forColumn: "extra")
                
                let querySubSQL = "SELECT img, id, long, lat FROM notesimage WHERE note_id = '\(counter!)'"
                let res: FMResultSet = contactDB.executeQuery(querySubSQL, withArgumentsIn: [])!
                var imageCounter:Int = 0
                while res.next() {
                let imgStream = res.string(forColumn: "img")
                var imgStreamID = res.int(forColumn: "id")
                    print("notesimage sql id=\(imgStreamID)")
                   
                     print("notesimage sql id=\(imgStreamID)")
                if imgStream != nil{
                    let data: NSData = NSData(base64Encoded: imgStream! , options: .ignoreUnknownCharacters)!
                    // turn  Decoded String into Data
                    let dataImage = UIImage(data: data as Data)
                    imageArray.insert(dataImage!, at: imageCounter)
                    long = res.double(forColumn: "long")
                    lat = res.double(forColumn: "lat")
                    
                    longitudeArray.insert(long!, at: imageCounter)
                    lattitudeArray.insert(lat!, at: imageCounter)
                    print("Long-Lat from DB------\(imageCounter)")
                    imageCounter = imageCounter + 1
                      }
                }
                
             } else {
                newRow = true
                
            }
            showImageScrollView()
            contactDB.close()
        } else {
            print ("Error \(contactDB.lastErrorMessage())")
        }
    }
    func showImageScrollView(){
        let imageWidth:CGFloat = 315
        let imageHeight:CGFloat = 150
        var yPos:CGFloat = 0
        var scrollViewSize:CGFloat = 0
        for index in 0 ..< imageArray.count
        {
            let myImage:UIImageView = UIImageView()
            myImage.image = imageArray[index]
            myImage.tag = index
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            myImage.isUserInteractionEnabled = true
            myImage.addGestureRecognizer(tapGestureRecognizer)
            
            myImage.frame.size.width = imageWidth
            myImage.frame.size.height = imageHeight
            myImage.frame.origin.x = 10
            myImage.center = self.view.center
            myImage.frame.origin.y = yPos
            scrollView.addSubview(myImage)
            let spacer:CGFloat = 20
            
            yPos+=imageHeight + spacer
            scrollViewSize+=imageHeight + spacer
            scrollView.contentSize = CGSize(width: imageWidth, height: scrollViewSize)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Selected Image...\(longitudeArray[tappedImage.tag])")
        print("Selected Image...\(lattitudeArray[tappedImage.tag])")
        indexCounter = tappedImage.tag
        performSegue(withIdentifier: "map", sender: self)
        // Your action
    }
    
    @objc func addNotes()  {
        if (note.text != nil) {
                  saveWithoutImg()
        }
    }
    func saveNotes() {
        UserDefaults.standard.set(note.text, forKey: "Extranotes\(counter)")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "mainsegue", sender: self)
    }
    func loadNotes() {
        if let loadedData = UserDefaults.standard.value(forKey: "Extranotes\(counter)") as? String {
            note.text = loadedData
        }else{
            note.text = " "
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

