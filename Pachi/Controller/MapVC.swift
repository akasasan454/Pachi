//
//  MapVC.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/20.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import MapKit
import Pring
import CoreLocation
import UIView_MGBadgeView
import YPImagePicker
import FirebaseUI

class MapVC: UIViewController {
    
    var locationManager: CLLocationManager!
    var dataSource: DataSource<Post>?
    var existingPosts: [Post] = []
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta = 0.02
            region.span.longitudeDelta = 0.02
            mapView.setRegion(region, animated: false)
            mapView.userTrackingMode = .follow
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        let pin = UIImageView()
        pin.image = UIImage(named: "pin")
        pin.frame = .init(x: 0, y: 0, width: 60, height: 60)
        pin.center = view.center
        pin.frame.origin.y -= 25
        view.addSubview(pin)
        self.dataSource = Post.order(by: \Post.createdAt).limit(to: 30).dataSource()
            .onCompleted({ (snapshot, _) in
                snapshot?.documentChanges.forEach { diff in
                    guard let post = Post(snapshot: diff.document) else { return }
                    switch diff.type {
                    case .added:
                        let annotation = CustomAnnotation()
                        annotation.id = post.id
                        annotation.url = post.image?.downloadURL
                        annotation.coordinate.latitude = post.latitude
                        annotation.coordinate.longitude = post.longitude
                        self.mapView.addAnnotation(annotation)
                    case .modified:
                        self.mapView.annotations.forEach {
                            if let annotation = $0 as? CustomAnnotation, annotation.id == post.id, (annotation.coordinate.latitude != post.latitude || annotation.coordinate.longitude != post.longitude) {
                                annotation.coordinate.latitude = post.latitude
                                annotation.coordinate.longitude = post.longitude
                                self.mapView.removeAnnotation(annotation)
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                    case .removed:
                        self.mapView.annotations.forEach {
                            if let annotation = $0 as? CustomAnnotation, annotation.id == post.id {
                                self.mapView.removeAnnotation(annotation)
                            }
                        }
                    }
                }
        }).listen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        // annotationの選択状態を解除
//        if let annotation = selectAnnotationView?.annotation{
//            mapView.deselectAnnotation(annotation, animated: false)
//        }
    }

    @IBAction func setUserLocation(_ sender: UIButton) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }

    @IBAction func post(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()
        config.library.onlySquare = true
        config.startOnScreen = .library
        config.shouldSaveNewPicturesToAlbum = false
        config.showsFilters = false
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if !cancelled {
//                var images: [File] = []
//                for item in items {
//                    switch item {
//                    case .photo(let photo):
//                        guard let imageData = photo.image.jpegData(compressionQuality: 1) else { return }
//                        images.append(File(data: imageData, mimeType: .jpeg))
//                    case .video(let video):
//                        print(video)
//                    }
//                }
                let post = Post()
                if let image = items.singlePhoto?.image, let imageData = image.jpegData(compressionQuality: 1) {
                    post.image = File(data: imageData, mimeType: .jpeg)
                }
                let coodinate = self.mapView.centerCoordinate
                post.latitude = coodinate.latitude
                post.longitude = coodinate.longitude
                post.save()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func returnUrl(images: [[String: Any]]) -> String {
        return (images.first!["url"] as? String)!
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
        guard let makerAnnotationView = annotationView as? MKMarkerAnnotationView else { return MKAnnotationView() }
        if let cluster = annotation as? MKClusterAnnotation {
            //バッジつける方
            guard let lastAnnotation = cluster.memberAnnotations.last as? CustomAnnotation else { return MKAnnotationView() }
            makerAnnotationView.subviews.forEach { $0.removeFromSuperview() }
            let imageView = UIImageView()
            let origin = makerAnnotationView.bounds.origin
            imageView.frame = .init(x: origin.x, y: origin.y, width: 60, height: 60)
            if let image = lastAnnotation.image {
                imageView.image = image
            } else {
                imageView.sd_setImage(with: lastAnnotation.url, completed: { (image, error, _, _) in
                    lastAnnotation.image = image
                })
            }
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            
            let badge = MGBadgeView()
            badge.font = UIFont.systemFont(ofSize: 14)
            badge.badgeValue = cluster.memberAnnotations.count
            badge.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            badge.badgeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            badge.outlineWidth = 0
            badge.center = CGPoint(x: imageView.frame.width - 2, y: 1)
            
            makerAnnotationView.addSubview(imageView)
            makerAnnotationView.addSubview(badge)
            
            cluster.title = ""
            cluster.subtitle = ""
        }else{
            //バッジつけない方
            guard let annotation = annotation as? CustomAnnotation else { return MKAnnotationView() }
            makerAnnotationView.subviews.forEach { $0.removeFromSuperview() }
            let imageView = UIImageView()
            let origin = makerAnnotationView.bounds.origin
            imageView.frame = .init(x: origin.x, y: origin.y, width: 60, height: 60)
            imageView.sd_setImage(with: annotation.url, completed: { (image, error, _, _) in
                annotation.image = image
            })
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            
            makerAnnotationView.addSubview(imageView)
        }
        makerAnnotationView.image = nil
        makerAnnotationView.layer.masksToBounds = false
        makerAnnotationView.glyphTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        makerAnnotationView.markerTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        makerAnnotationView.displayPriority = .required
        makerAnnotationView.animatesWhenAdded = true
        makerAnnotationView.glyphText = ""
        makerAnnotationView.clusteringIdentifier = "Posts"
        return makerAnnotationView
    }
        
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view.annotation as? MKClusterAnnotation {
//            guard
//                let vc = storyboard?.instantiateViewController(withIdentifier: "MapCollection") as? MapCollectionController,
//                let customAnnotations = cluster.memberAnnotations as? [CustomAnnotation]
//                else { return }
//            vc.annotations = customAnnotations
//            self.navigationController?.pushViewController(vc, animated: true)
        }else{
//            guard
//                let vc = storyboard?.instantiateViewController(withIdentifier: "ShowContribution") as? ShowContributionController,
//                let customAnnotation = view.annotation as? CustomAnnotation
//                else { return }
//            vc.contribution_id = customAnnotation.contribution_id
//            vc.index = customAnnotation.index ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
        }
//        selectAnnotationView = view
    }
}

// 画像リサイズのextension
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension MapVC: CLLocationManagerDelegate {
    // 位置情報セッティング
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
}
