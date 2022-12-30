//
//  TabsView.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 28-12-22.
//

import Foundation
import UIKit

protocol TabsViewProtocol: AnyObject {
    func didSelectOptions(index: Int)
}

class TabsView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .backgroundColor
        
        // Register cell
        collection.register(UINib(nibName: "\(OptionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionCell.self)")
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configCollectionView()
    }
    
    
    
    private var options: [String] = []
    weak private var delegate: TabsViewProtocol?
    
    func buildView(delegate: TabsViewProtocol, options: [String]) {
        self.delegate = delegate
        self.options = options
        collectionView.reloadData()
    }
    
    private func configCollectionView(){
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}


extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OptionCell.self)", for: indexPath) as? OptionCell else {
            return UICollectionViewCell()
        }
        cell.configCell(option: options[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectOptions(index: indexPath.item)
    }
}

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = options[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16)
        let extraPadding: CGFloat = 20.0
        
        return CGSize(width: label.intrinsicContentSize.width+extraPadding, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
