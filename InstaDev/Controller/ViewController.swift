//
//  ViewController.swift
//  InstaDev
//
//  Created by apple on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties
    private let parser = Parser()
    private var hotelsList = Hotels()
    private var activityIndicator: UIActivityIndicatorView!
    var detail: HotelInfo?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortList: UIButton!
   
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHotelsList()
        setPopupButton()
        activityIndicator = showSpinner(in: view)
    }
    
    // MARK: - Methods
    private func getHotelsList() {
        parser.getList { data in
            self.hotelsList = data
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
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
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func sortBySuitesAvailability() {
        self.hotelsList.sort{ $0.suitesAvailability.trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: ":", with: ", ").stringToArray().count > $1.suitesAvailability.trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: ":", with: ", ").stringToArray().count}
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
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

// MARK: - DataSource, Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    
        let hotel = hotelsList[indexPath.row]
        cell.configure(with: hotel)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hotel = hotelsList[indexPath.row]
        let detailVC = DetailViewController(hotel: hotel)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        let request = URL(string: "https://bitbucket.org/instadevteam/tests/raw/63a9ecea18ca79c275a2eeafd95bc37f857cf2ec/1.2/\(String(describing: hotel.id)).json")
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            if let data = data, let hotelInfo = try? JSONDecoder().decode(HotelInfo.self, from: data) {
                detailVC.detail = hotelInfo
            }
        }
        task.resume()
    }
}
