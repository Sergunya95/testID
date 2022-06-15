//
//  ViewController.swift
//  InstaDev
//
//  Created by apple on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {

    private let parser = Parser()
    private var hotelsList = Hotels()
    private var activityIndicator: UIActivityIndicatorView!
//    var detail: HotelInfo? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortList: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHotelsList()
        setPopupButton()
        activityIndicator = showSpinner(in: view)
    }
    
    private func getHotelsList() {
        parser.getList { data in
            self.hotelsList = data
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.tableView.reloadData()
            }
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setPopupButton() {
        let sortByDistance = { (action: UIAction) in
            self.sortByDistance()
        }
        let sortBySuitesAvailability = { (action: UIAction) in
            self.sortBySuitesAvailability()
        }
        if #available(iOS 14.0, *) {
            sortList.menu = UIMenu(children: [
                UIAction(title: "Отдаленности от центра", handler: sortByDistance),
                UIAction(title: "Кол-ву свободных номеров", handler: sortBySuitesAvailability)])
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            sortList.showsMenuAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func sortByDistance() {
        self.hotelsList.sort{ $0.distance < $1.distance}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func sortBySuitesAvailability() {
        self.hotelsList.sort{ $0.suitesAvailability.count > $1.suitesAvailability.count}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//        cell.textLabel?.text = hotelsList[indexPath.row].name
        cell.nameLabel.text = hotelsList[indexPath.row].name
        cell.addressLabel.text = hotelsList[indexPath.row].address
        cell.distanceLabel.text = "Расстояние до центра \(String(hotelsList[indexPath.row].distance)) м"
        cell.suitesAvailabilityLabel.text = "Свободных номеров: \(String(hotelsList[indexPath.row].suitesAvailability.count))"
        if hotelsList[indexPath.row].stars < 1 {
            cell.starsImage.image = UIImage(systemName: "star")
        } else if  hotelsList[indexPath.row].stars >= 1 {
            cell.starsImage.image = UIImage(systemName: "star.fill")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        let request = URL(string: "https://bitbucket.org/instadevteam/tests/raw/63a9ecea18ca79c275a2eeafd95bc37f857cf2ec/1.2/\(String(describing: hotelsList[indexPath.row].id)).json")
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            if let data = data, let hotelInfo = try? JSONDecoder().decode(HotelInfo.self, from: data) {
                vc.detail = hotelInfo
                print(hotelInfo.image)
//                vc.imageLabel?.text = hotelInfo.image
            }
        }
        task.resume()
    }
    
}
