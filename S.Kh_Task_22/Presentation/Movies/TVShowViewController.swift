//
//  MoviesViewController.swift
//  S.Kh_Task_22
//
//  Created by Saba Khitaridze on 13.08.22.
//

import UIKit


class TVShowViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tvShowsCollectionView: UICollectionView!
    
    
    //MARK: - Vars
    var tvShows = [TVShowModel]()
    //for login as guest
    let customView = UIView()
    let customButton = UIButton()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvShowsCollectionView.backgroundColor = .clear.withAlphaComponent(0)
        visitAsGuest()
        fetchTVShows()
        setupCollectionView()
    }
    
   //MARK: - Methods
    private func fetchTVShows() {
        Fetcher.shared.fetchData(with: TVShowUrlBuilder.shared, as: TVShowData.self) { allShow in
            self.tvShows = allShow.results
            self.tvShowsCollectionView.reloadData()
        } fail: { message in
            print(message)
        }
    }
    
    private func generateGuestUser() {
        //Fetching Guest
        Fetcher.shared.fetchData(with: GuestUrlBuilder.shared, as: GuestModel.self) { guest in
            UserDefaults.standard.setValue(guest.guestSessionID, forKey: GuestUrlBuilder.guestSessionId)
        } fail: { message in
            print(message)
        }

    }
    
    private func setupCollectionView() {
        //registering cell
        tvShowsCollectionView.registerNib(class: TVShowCell.self)
        //flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        tvShowsCollectionView.collectionViewLayout = flowLayout
    }
    
    private func visitAsGuest() {
        //view
        customView.frame = view.frame
        customView.backgroundColor = .systemBackground
        customView.center = view.center
        //button
        customButton.configuration = .filled()
        customButton.setTitle("Visit as Guest", for: .normal)
        customButton.addTarget(self, action: #selector(visitAsGuestTapped(_:)), for: .touchUpInside)
        customButton.frame = CGRect(origin: CGPoint(x: customView.center.x-70, y: customView.center.y), size: CGSize(width: 150, height: 50))
        
        customView.addSubview(customButton)
        view.addSubview(customView)
    }
    
    @objc func visitAsGuestTapped(_ sender: UIButton) {
        sleep(1)  //creating guest account simulation
        generateGuestUser()
        customView.isHidden = true
        customButton.isHidden = true
    }
    
}
