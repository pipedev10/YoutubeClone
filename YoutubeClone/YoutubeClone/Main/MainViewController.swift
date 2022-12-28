//
//  MainViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

class MainViewController: BaseViewController {

    var rootPageViewController: RootPageViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        navigationController?.hidesBarsOnSwipe = true
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
