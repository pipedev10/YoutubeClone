//
//  MainViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

class MainViewController: ViewController {

    var rootPageViewController: RootPageViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }

}

extension MainViewController: RootPageProtocol {
    func currentPage(_ index: Int) {
        print("Current Page ", index)
    }
    
    
}
