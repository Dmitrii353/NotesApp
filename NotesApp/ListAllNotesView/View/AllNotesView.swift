//
//  AllNotesView.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.10.2026.
//

import UIKit

protocol AllNotesViewProtocol: AnyObject {
    func reloadData()
}

final class AllNotesView: UIViewController, AllNotesViewProtocol {
   
    var presenter: AllNotesPresenterProtocol!
    
    lazy var searchNotesBar: UISearchBar = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.placeholder = "Поиск заметок"
        $0.layer.cornerRadius = 10
        $0.searchBarStyle = .minimal
        $0.tintColor = .colorDescriptionLabel
        $0.barTintColor = .colorBackgroundView
        return $0
    }(UISearchBar())
    
    lazy var noteSectionCollectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(CustomNoteSectionCell.self, forCellWithReuseIdentifier: CustomNoteSectionCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateAllNotes()
    }
    
    func reloadData() {
        noteSectionCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        view.addSubViews(searchNotesBar,noteSectionCollectionView)
        title = "Все заметки"
        navigationController?.navigationBar.prefersLargeTitles = true
        installNavigationBarItemSortedButton()
        setupConstraints()
    }

   
    
    private func installNavigationBarItemSortedButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(sortedAllNotes))
        navigationItem.rightBarButtonItem = sortedButton
    }
    
    @objc func sortedAllNotes() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchNotesBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchNotesBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchNotesBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            noteSectionCollectionView.topAnchor.constraint(equalTo: searchNotesBar.bottomAnchor, constant: 16),
            noteSectionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteSectionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteSectionCollectionView.heightAnchor.constraint(equalToConstant: 36),
            
        ])
    }
    
}

extension AllNotesView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NotesFilter.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNoteSectionCell.reuseId, for: indexPath) as! CustomNoteSectionCell
        
        let filter = NotesFilter.allCases[indexPath.item]
        let title = presenter.filterTitle(for: filter)
        let isSelected = presenter.selectedFilter == filter
        
        cell.configure(title: title, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = NotesFilter.allCases[indexPath.item]
        presenter.selectFilter(filter: filter)
    }
    
    
}

