//
//  RootPageViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

protocol RootPageProtocol: AnyObject {
    func currentPage(_ index: Int)
}

class RootPageViewController: UIPageViewController {

    var subViewsControllers = [UIViewController]()
    var currentIndex: Int = 0
    weak var delegateRoot: RootPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        subViewsControllers = [
            HomeViewController(),
            VideosViewController(),
            PlaylistsViewController(),
            ChannelsViewController(),
            AboutViewController()
        ]
        
        _ = subViewsControllers.enumerated().map({$0.element.view?.tag = $0.offset})
        
        setViewControllerFromIndex(index: 0, direction: .forward)
    }
    
    func setViewControllerFromIndex(index: Int, direction: NavigationDirection, animated: Bool = true) {
        
        setViewControllers([subViewsControllers[index]], direction: direction, animated: animated)
    }
    
    /*override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        
    }*/
}

extension RootPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewsControllers.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewsControllers.firstIndex(of: viewController) ?? 0
        if index <= 0 {
            return nil
        }
        return subViewsControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewsControllers.firstIndex(of: viewController) ?? 0
        if index >= (subViewsControllers.count-1) {
            return nil
        }
        return subViewsControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("Finished: ", finished)
        if let index = pageViewController.viewControllers?.first?.view.tag {
            currentIndex = index
            delegateRoot?.currentPage(index)
        }
    }
}
