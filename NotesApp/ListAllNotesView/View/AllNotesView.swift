//
//  AllNotesView.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.10.2026.
//
import SwiftConfettiView
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
        $0.searchBarStyle = .minimal
        $0.clipsToBounds = true
        $0.tintColor = .colorDescriptionLabel
        $0.barTintColor = .colorBackgroundView
        $0.backgroundColor = .white
        $0.delegate = self
        $0.searchTextField.borderStyle = .none
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 0.4
        $0.layer.borderColor = UIColor.black.cgColor
        $0.clipsToBounds = true
        return $0
    }(UISearchBar())
    
    // MARK: - Collection with sections note
    lazy var noteSectionCollectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(CustomNoteSectionCell.self, forCellWithReuseIdentifier: CustomNoteSectionCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    // MARK: - Table with notes
    lazy var allNotesTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        $0.register(CustomAllNotesCell.self, forCellReuseIdentifier: CustomAllNotesCell.reuseId)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    private lazy var confettiView: SwiftConfettiView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.emissionAngle = 4 * .pi / 2
        $0.burstCount = 150
        $0.hapticFeedback = true
        $0.density = 1.5
        $0.intensity = 2
        $0.isUserInteractionEnabled = false
        $0.spread = 180
        return $0
    }(SwiftConfettiView())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateAllNotes()
    }
    
    func reloadData() {
        noteSectionCollectionView.reloadData()
        allNotesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        view.addSubViews(searchNotesBar,noteSectionCollectionView,allNotesTableView,confettiView)
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
        presenter.sortingNotesByPriority()
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
            
            confettiView.topAnchor.constraint(equalTo: view.topAnchor,constant: 350),
            confettiView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 150),
            confettiView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -150),
            confettiView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -350),
            
            allNotesTableView.topAnchor.constraint(equalTo: noteSectionCollectionView.bottomAnchor, constant: 24),
            allNotesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allNotesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allNotesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
}

extension AllNotesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = NotesFilter.allCases[indexPath.item]
        let title = presenter.filterTitle(for: filter)
        
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let textSize = (title as NSString).size(withAttributes: [.font: font])
        let padding: CGFloat = 14
        let width = textSize.width + padding * 2
        let height: CGFloat = 32
        
        return CGSize(width: ceil(width), height: height)
    }
}

extension AllNotesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.displayedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allNotesTableView.dequeueReusableCell(withIdentifier: CustomAllNotesCell.reuseId, for: indexPath) as! CustomAllNotesCell
        
        let item = presenter.displayedNotes[indexPath.row]
        cell.configurate(note: item)
        cell.onToggle = { [weak self] id, isCompletedNotes in
            self?.presenter.toggleNote(with: id, isCompletedNotes: isCompletedNotes)
            if isCompletedNotes == true {
                self?.confettiView.startConfetti()
            }
        }
        return cell
    }
}

extension AllNotesView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.updateSearchText("")
        searchBar.resignFirstResponder()
    }
}
