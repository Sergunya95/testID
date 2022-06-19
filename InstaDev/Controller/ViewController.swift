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
    @IBOutlet weak var rightSortListButton: UIButton!
    @IBOutlet weak var leftSortListButton: UIButton!
    
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHotelsList()
        activityIndicator = showActivityIndicator(in: view)
        if #available(iOS 14.0, *) {
            setPopupButton()
            rightSortListButton.isHidden = false
            leftSortListButton.isHidden = true
        } else {
            rightSortListButton.isHidden = true
            leftSortListButton.isHidden = false
        }
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

    @available(iOS 14.0, *)
    private func setPopupButton() {
        let sortByDistance = { (action: UIAction) in
            self.sortByDistance()
        }
        let sortBySuitesAvailability = { (action: UIAction) in
            self.sortBySuitesAvailability()
        }
        rightSortListButton.menu = UIMenu(children: [
            UIAction(title: "Отдаленности от центра", handler: sortByDistance),
            UIAction(title: "Кол-ву свободных номеров", handler: sortBySuitesAvailability)])
        rightSortListButton.showsMenuAsPrimaryAction = true
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
    
    private func showActionSheet() {
       let actionSheet = UIAlertController(title: "Сортировать по:", message: nil, preferredStyle: .actionSheet)
       let distanseSort = UIAlertAction(title: "Отдаленности от центра", style: .default) { _ in
           self.sortByDistance()
       }
       let suitesAvailabilitySort = UIAlertAction(title: "Кол-ву свободных номеров", style: .default) { _ in
           self.sortBySuitesAvailability()
       }
       actionSheet.addAction(distanseSort)
       actionSheet.addAction(suitesAvailabilitySort)
       present(actionSheet, animated: true)
   }
    
    @IBAction func leftButtonTapped() {
        showActionSheet()
    }
    
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
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
    }
}
