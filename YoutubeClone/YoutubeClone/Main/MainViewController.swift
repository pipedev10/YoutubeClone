//
//  MainViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var tabsView: TabsView!
    var rootPageViewController: RootPageViewController!
    private var options: [String] = ["HOME", "VIDEOS", "PLAYLIST", "CHANNEL", "ABOUT"]
    var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        //navigationController?.hidesBarsOnSwipe = true
        tabsView.buildView(delegate: self, options: options)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }

    override func dotsButtonPressed() {
        
    }
}

extension MainViewController: RootPageProtocol {
    func currentPage(_ index: Int) {
        print("Current Page ", index)
    }
}

extension MainViewController: TabsViewProtocol {
    func didSelectOptions(index: Int) {
        print("index: ", index)
        
        var direction: UIPageViewController.NavigationDirection = .forward
        if index < currentPageIndex {
            direction = .reverse
        }
        
        rootPageViewController.setViewControllerFromIndex(index: index, direction: direction)
        currentPageIndex = index
    }
}
