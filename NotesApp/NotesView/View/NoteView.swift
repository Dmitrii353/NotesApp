//
//  NoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

protocol NoteViewProtocol: AnyObject {
    func reloadData()
    func showError(message: String)
}

class NoteView: UIViewController, NoteViewProtocol {
    
    var presenter: ListNotePresenterProtocol!
    private var tableHeightConstaint: NSLayoutConstraint!
    lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        return $0
    }(UIScrollView())
    lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    lazy var categoryIconContainerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 56).isActive = true
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.12
        $0.layer.shadowRadius = 8
        $0.addSubview(categoryIcon)
        return $0
    }(UIView())
    lazy var categoryIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 28).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 28).isActive = true
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    lazy var categoryTitleLabel: UILabel = AddLabel(fontText: 30, fontW: .bold, colorText: .black, textAlignmentLabel: .left)
    lazy var categorySubtitleLabel: UILabel = AddLabel(fontText: 14, fontW: .regular, colorText: .colorDescriptionLabel)
    
    //MARK: - Карточка прогресса
    lazy var progressCardCategoryView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.heightAnchor.constraint(equalToConstant: 98).isActive = true
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        //$0.layer.cornerRadius = 50 - один из возможных вариантов оформления карточки прогресса
        return $0
    }(UIView())
    
    lazy var descriptionTextLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel, textAlignmentLabel: .left)
    lazy var countOfCompletedNotes: UILabel = AddLabel(fontText: 20, fontW: .bold, colorText: .black, textAlignmentLabel: .left)
    lazy var progressViewOfCompletedNotes: UIProgressView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.trackTintColor = .systemGray5
        $0.progressViewStyle = .default
        $0.heightAnchor.constraint(equalToConstant: 8).isActive = true
        $0.layer.cornerRadius = 4
        return $0
    }(UIProgressView())
    lazy var backgroundViewPrecentOfCompleted: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
        $0.layer.cornerRadius = 12
        $0.addSubview(precentOfCompletedNotesLabel)

        return $0
    }(UIView())
    
    lazy var precentOfCompletedNotesLabel: UILabel = AddLabel(fontText: 12, fontW: .bold, textAlignmentLabel: .center)
    // MARK: - Таблица с заметками
    lazy var noteTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .colorBackgroundView
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.register(CustomCellNote.self, forCellReuseIdentifier: CustomCellNote.reuseId )
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.updateNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews(categoryIconContainerView,
                                categoryTitleLabel,
                                categorySubtitleLabel,
                                progressCardCategoryView,
                                noteTableView)
        progressCardCategoryView.addSubViews(descriptionTextLabel,
                                             countOfCompletedNotes,
                                             progressViewOfCompletedNotes,
                                             backgroundViewPrecentOfCompleted)
        installingNavigationBarItemsButtons()
        setupElementscategoryTasks()
        setupConstraints()
        noteTableView.rowHeight = UITableView.automaticDimension
        noteTableView.estimatedRowHeight = 140
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    func installingNavigationBarItemsButtons() {
        let addConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let addNoteButton = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: addConfig), style: .done, target: self, action: #selector(addNote))
        addNoteButton.tintColor = .colorButton
        let sortConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let sortNotesButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: sortConfig), style: .plain, target: self, action: #selector(sortedNote))
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [addNoteButton,sortNotesButton]
    }
    func setupElementscategoryTasks() {
        guard let task = presenter.tasks else { return }
        categoryIconContainerView.backgroundColor = CategoryTask.color(for: task.name ?? "")
        categoryIcon.image = UIImage(systemName: CategoryTask.icon(for: task.name ?? "xmark"))
        categoryIcon.tintColor = CategoryTask.colorIcon(for: task.name ?? "")
        categoryTitleLabel.text = task.name
        categorySubtitleLabel.text = "Создана \(presenter.installElementDateCreationTask()) · \(presenter.installCountNotes())"
        descriptionTextLabel.text = "Прогресс"
        countOfCompletedNotes.text = presenter.countOfCompletedNotesString()
        progressViewOfCompletedNotes.progressTintColor = CategoryTask.colorIcon(for: task.name ?? "")
        progressViewOfCompletedNotes.progress = task.progress
        backgroundViewPrecentOfCompleted.backgroundColor = CategoryTask.color(for: task.name ?? "")
        precentOfCompletedNotesLabel.text = "\(task.progressInt)%"
        precentOfCompletedNotesLabel.textColor = CategoryTask.colorIcon(for: task.name ?? "")

    }
    
    private func updateTableHeight() {
        noteTableView.layoutIfNeeded()
        tableHeightConstaint.constant = max(noteTableView.contentSize.height, 1)
    }
    
    func reloadData() {
        noteTableView.reloadData()
        setupElementscategoryTasks()
        
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            guard let task = presenter.tasks else { return }
            
            updateTableHeight()
            progressViewOfCompletedNotes.progress = task.progress
            countOfCompletedNotes.text = presenter.countOfCompletedNotesString()
            precentOfCompletedNotesLabel.text = "\(task.progressInt)%"
            categorySubtitleLabel.text = "Создана \(presenter.installElementDateCreationTask()) · \(presenter.installCountNotes())"
        }
    }
        
    @objc
    func addNote(){
        let Addnote = Builder.createAddnoteView(tasks: presenter.tasks)
        navigationController?.pushViewController(Addnote, animated: true)
    }
    
    @objc
    func sortedNote()  {
        presenter.sortingNotesByPriority()
    }
    
    func confirmDeleteNote(with id: String) {
        let alert = UIAlertController(title: "Удалить заметку?", message: "Это действие нельзя отменить", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.presenter.deleteNote(with: id)
        }))
        present(alert, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Окей", style: .cancel))
        present(alert,animated: true)
    }
    
    
    private func setupConstraints(){
        tableHeightConstaint = noteTableView.heightAnchor.constraint(equalToConstant: 250)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            categoryIconContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryIconContainerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            
            categoryIcon.centerXAnchor.constraint(equalTo: categoryIconContainerView.centerXAnchor),
            categoryIcon.centerYAnchor.constraint(equalTo: categoryIconContainerView.centerYAnchor),
            
            categoryTitleLabel.leadingAnchor.constraint(equalTo: categoryIconContainerView.trailingAnchor, constant: 12),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryTitleLabel.topAnchor.constraint(equalTo: categoryIconContainerView.topAnchor),
            categoryTitleLabel.heightAnchor.constraint(equalToConstant: 36),
            
            categorySubtitleLabel.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor),
            categorySubtitleLabel.leadingAnchor.constraint(equalTo: categoryTitleLabel.leadingAnchor),
            categorySubtitleLabel.trailingAnchor.constraint(equalTo: categoryTitleLabel.trailingAnchor),
            categorySubtitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            progressCardCategoryView.topAnchor.constraint(equalTo: categorySubtitleLabel.bottomAnchor, constant: 24),
            progressCardCategoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressCardCategoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: progressCardCategoryView.topAnchor, constant: 16),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: progressCardCategoryView.leadingAnchor, constant: 25),
            descriptionTextLabel.heightAnchor.constraint(equalToConstant: 16),
            descriptionTextLabel.widthAnchor.constraint(equalToConstant: 175),
            
            countOfCompletedNotes.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 2),
            countOfCompletedNotes.leadingAnchor.constraint(equalTo: descriptionTextLabel.leadingAnchor),
            countOfCompletedNotes.heightAnchor.constraint(equalToConstant: 28),
            countOfCompletedNotes.trailingAnchor.constraint(equalTo: backgroundViewPrecentOfCompleted.leadingAnchor, constant: 30),
            
            progressViewOfCompletedNotes.topAnchor.constraint(equalTo: countOfCompletedNotes.bottomAnchor, constant: 12),
            progressViewOfCompletedNotes.leadingAnchor.constraint(equalTo: progressCardCategoryView.leadingAnchor, constant: 25),
            progressViewOfCompletedNotes.trailingAnchor.constraint(equalTo: progressCardCategoryView.trailingAnchor, constant: -25),
            progressViewOfCompletedNotes.bottomAnchor.constraint(equalTo: progressCardCategoryView.bottomAnchor, constant: -16),
            
            backgroundViewPrecentOfCompleted.topAnchor.constraint(equalTo: progressCardCategoryView.topAnchor, constant: 27),
            backgroundViewPrecentOfCompleted.trailingAnchor.constraint(equalTo: progressViewOfCompletedNotes.trailingAnchor),
            backgroundViewPrecentOfCompleted.bottomAnchor.constraint(equalTo: progressCardCategoryView.bottomAnchor, constant: -47),
            
            precentOfCompletedNotesLabel.centerXAnchor.constraint(equalTo: backgroundViewPrecentOfCompleted.centerXAnchor),
            precentOfCompletedNotesLabel.centerYAnchor.constraint(equalTo: backgroundViewPrecentOfCompleted.centerYAnchor),
            
            noteTableView.topAnchor.constraint(equalTo: progressCardCategoryView.bottomAnchor, constant: 32),
            noteTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            tableHeightConstaint
            
        ])
    }
}

extension NoteView: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .colorBackgroundView
        
        lazy var titleLabel: UILabel = AddLabel(fontText: 18, fontW: .bold)
        lazy var countLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel)
        if section == 0 {
            titleLabel.text = "Текущие заметки"
            countLabel.text = presenter.countActiveNotesString()
        } else {
            titleLabel.text = "Завершённые"
            countLabel.text = "\(presenter.countOfCompletedNotes)"
        }
        lazy var currentNotesStackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.addArrangesViews(titleLabel,countLabel)
            return $0
        }(UIStackView())
        
        
        headerView.addSubview(currentNotesStackView)
        
        NSLayoutConstraint.activate([
            currentNotesStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            currentNotesStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            currentNotesStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            currentNotesStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? presenter.countActiveNotes : presenter.countOfCompletedNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: CustomCellNote.reuseId, for: indexPath) as! CustomCellNote
        let note = indexPath.section == 0 ? presenter.activeNotes[indexPath.row] : presenter.completedNote[indexPath.row]
        cell.configure(note: note)
        cell.onToggle = { [weak self] id in
            self?.presenter.toggleNote(with: id)
        }
        cell.onDelete = {[weak self] id in
            self?.confirmDeleteNote(with: id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = indexPath.section == 0 ? presenter.activeNotes[indexPath.row]: presenter.completedNote[indexPath.row]
        let oneNote = OneNoteView()
        
            oneNote.titleNote.text = note.name
            oneNote.detailsNote.text = note.details
            oneNote.tasks = presenter.tasks
        navigationController?.pushViewController(oneNote, animated: true)

        }
    }
    


