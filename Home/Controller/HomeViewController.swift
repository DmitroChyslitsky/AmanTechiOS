//
//  HomeViewController.swift
//  Amano
//
//  Created by Alex Murray on 2/5/22.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                AuthenticationManager.shared.setUserProfile(homeViewModel: viewModel)
            }
            self.resetView()
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - View Controller
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderAnimationView: AnimationView!
    private let refreshControl = UIRefreshControl()
    var expandedRecommednations = Set([TestRecommendation]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureNotifications()
        self.fetchHomeData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.forceRefresh), name: NotificationName.homeRefreshNeeded, object: nil)
    }
    
    private func configureUI() {
        self.configureTableView()
        self.configureLoaderView()
    }
    
    private func configureTableView() {
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        
        // Refresh controll background color
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.secondaryAccent
        self.tableView.addSubview(view)
        self.tableView.sendSubviewToBack(view)
    }
    
    private func configureLoaderView() {
        self.loaderAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.loaderAnimationView.contentMode = .scaleAspectFit
        self.loaderAnimationView.loopMode = .loop
        self.loaderAnimationView.play()
    }
    
    private func resetView() {
        self.expandedRecommednations.removeAll()
    }
    
    private func fetchHomeData(showFullScreenLoader: Bool = true) {
        if showFullScreenLoader {
            self.loaderView.isHidden = false
        }
        Network.home(completion: { viewModel in
            self.loaderView.isHidden = true
            self.refreshControl.endRefreshing()
            if let viewModel = viewModel {
                self.viewModel = viewModel
            } else {
                self.configureForNoDevice()
            }
        })
//        self.viewModel = HomeViewModel.getTestViewModel()
    }
                                      
    @objc private func didPullToRefresh() {
        self.refreshControl.beginRefreshing()
        self.fetchHomeData(showFullScreenLoader: false)
    }
    
    @objc private func forceRefresh() {
        self.fetchHomeData()
    }
    
    private func configureForNoDevice() {
        self.viewModel = HomeViewModel.noDeviceViewModel()
    }
    
    private func getCurrentDevice() -> Device? {
        // Support for multiple devices later
        return self.viewModel?.devices?.first
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getTableViewCells().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCellType = self.viewModel?.getTableViewCells()[safe: indexPath.row], let device = self.getCurrentDevice() else { return UITableViewCell() }
        switch tableViewCellType {
        case .subheader:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeSubheaderCell) as? HomeSubheaderCell, let batteryLevel = device.status?.battery, let testsRemaining = device.status?.testsRemaining, let temperature = device.status?.waterTempF {
                
                // Battery
                let batteryPercent = "0.\(batteryLevel)"
                cell.batteryProgressView.setProgress(Float(batteryPercent) ?? 0, animated: false)
                cell.batteryLabel.text = "\(batteryLevel)%"
                
                // Tests Remaining
                let testsRemainingPercent = Float(testsRemaining) / Float(Device.totalTestCount)
                cell.testsRemainingProgressView.setProgress(testsRemainingPercent, animated: false)
                cell.testsRemainingLabel.text = "\(testsRemaining)"
                
                // Temperature
                let roundedTemp = round(temperature * 10) / 10.0
                cell.temperatureReadingLabel.text = "\(roundedTemp)°"
                
                cell.selectionStyle = .none
                return cell
            }
        case .ph:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeTestCell) as? HomeTestCell, let phTest = device.measurements?.tests?.first(where: { $0.testName == .pH }) {
                let viewModel = SpectrumChartViewModel(testName: .pH, locationType: device.location?.type ?? .pool, selectedNumber: phTest.value ?? 0.0)
                cell.spectrumChartViewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        case .alkalinity:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeTestCell) as? HomeTestCell, let alkalinityTest = device.measurements?.tests?.first(where: { $0.testName == .alkalinity }) {
                let viewModel = SpectrumChartViewModel(testName: .alkalinity, locationType: device.location?.type ?? .pool, selectedNumber: alkalinityTest.value ?? 0.0)
                cell.spectrumChartViewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        case .bromine:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeTestCell) as? HomeTestCell, let bromineTest = device.measurements?.tests?.first(where: { $0.testName == .bromine }) {
                let viewModel = SpectrumChartViewModel(testName: .bromine, locationType: device.location?.type ?? .pool, selectedNumber: bromineTest.value ?? 0.0)
                cell.spectrumChartViewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        case .freeChlorine:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeTestCell) as? HomeTestCell, let freeChlorineTest = device.measurements?.tests?.first(where: { $0.testName == .freeChlorine }) {
                let viewModel = SpectrumChartViewModel(testName: .freeChlorine, locationType: device.location?.type ?? .pool, selectedNumber: freeChlorineTest.value ?? 0.0)
                cell.spectrumChartViewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        case .combinedChlorine:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeTestCell) as? HomeTestCell, let combinedChlorineTest = device.measurements?.tests?.first(where: { $0.testName == .combinedChlorine }) {
                let viewModel = SpectrumChartViewModel(testName: .combinedChlorine, locationType: device.location?.type ?? .pool, selectedNumber: combinedChlorineTest.value ?? 0.0)
                cell.spectrumChartViewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        case .lastTest:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeLastTestCell) as? HomeLastTestCell {
                if let lastTestText = device.measurements?.timestamp, let timeAgoString = Date.getDateFromServerString(lastTestText)?.timeAgoString() {
                    cell.lastTestLabel.text = "Last test was \(timeAgoString)"
                } else {
                    cell.lastTestLabel.text = "No tests found"
                }
                cell.selectionStyle = .none
                return cell
            }
        case .notificationsHeader:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeNotificationsHeaderCell) as? HomeNotificationsHeaderCell {
                cell.selectionStyle = .none
                return cell
            }
        case .notification:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.homeNotificationCell) as? HomeNotificationCell, let notificationIndex = viewModel?.getNotificationIndex(indexPath.row), let recommendation = device.measurements?.recommendations?[safe: notificationIndex] {
                let shouldHide = !self.expandedRecommednations.contains(recommendation)
                cell.setRecommendation(recommendation, hideDetails: shouldHide)
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = self.viewModel, let device = self.getCurrentDevice(), let tableViewCellType = viewModel.getTableViewCells()[safe: indexPath.row], tableViewCellType == .notification, let recommendation = device.measurements?.recommendations?[safe: viewModel.getNotificationIndex(indexPath.row)] {
            switch recommendation.type {
            case .userProfileIncomplete:
                SessionManager.shared.autoOpenType = .editProfile
                SessionManager.shared.selectTab(type: .account)
            case .noDevice:
                self.performSegue(withIdentifier: SegueIdentifier.showProvisioning, sender: self)
            default:
                if recommendation.details != nil {
                    if self.expandedRecommednations.contains(recommendation) {
                        self.expandedRecommednations.remove(recommendation)
                    } else {
                        self.expandedRecommednations.insert(recommendation)
                    }
                    
                    // Refresh row
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        }
    }
}
