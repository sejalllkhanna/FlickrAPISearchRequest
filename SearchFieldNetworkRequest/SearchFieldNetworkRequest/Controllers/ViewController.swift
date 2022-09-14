//
//  ViewController.swift
//  SearchFieldNetworkRequest
//
//  Created by Apple on 03/12/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchedDataFound = [Photo]()
    var shouldShowSearchResults = false
    
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    
     var task: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
        searchBar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedDataFound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.NetworkImage.image = nil;
        cell.setData(data: self.searchedDataFound[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
                
        if indexPath.row  == searchedDataFound.count - 5{
            isLoadingList = true
            getData(pageNumber: currentPage, searchText: SearchBar.text!) { photos in
                DispatchQueue.main.async {
                    self.searchedDataFound.append(contentsOf: photos)
                    self.tableView.reloadData()
                }
            }
        }
        
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
    func searchBar(){
        SearchBar.delegate = self
        SearchBar.endEditing(true)
        SearchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText == ""{
        }else{
            if task != nil {
                print("cancel")
                task?.cancel()
            }
            searchedDataFound = []
            let safeText = searchText.replacingOccurrences(of: " ", with: "%20")
            tableView.reloadData()
           task = getData(pageNumber: currentPage, searchText: safeText) { photos in
                DispatchQueue.main.async {
                    self.searchedDataFound = photos
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
        let components = text.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        if text == filtered {
            
            return true
            
        } else {
            
            return false
        }
    }
    
    func getData(pageNumber: Int, searchText: String ,completion: @escaping ([Photo])-> Void) -> URLSessionDataTask{
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&%20format=json&nojsoncallback=1&safe_search=1&text=\(searchText)&page=\(pageNumber)&per_page=20")
        else{
            fatalError()
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if error != nil {
                print("Error while fetching data")
                return
            }
            if let APIData = data {
                let decoder = JSONDecoder()
                do {
                    let searchData = try decoder.decode(DataModel.self, from: APIData).photos.photo
                    completion(searchData)
                    shouldShowSearchResults = true
                } catch {
                    print("error")
                    return
                }
            }
        }
    task.resume()
        return task
    }
    
}

