//
//  ViewController.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

protocol TaskViewProtocol: AnyObject {
    func reloadData()
    func deleteItem(at id: String)
    func createNewTask(_ category: String)
}

final class TasksView: UIViewController, TaskViewProtocol {
    

    private let categoryPickerView: CategoryPickerViewControllerProtocol
    var mainTaskPresenter: MainTaskPresenterProtocol!
    
    init(categoryPickerView: CategoryPickerViewControllerProtocol) {
        self.categoryPickerView = categoryPickerView
        super.init(nibName: nil, bundle: nil)
    }
    // MARK: начальные значения высот для коллекции и таблицы
    private var collectionHeightConstraint: NSLayoutConstraint!
    private var tableHeightConstraint: NSLayoutConstraint!
    
    lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
        return $0
    }(UIScrollView())
    
    //MARK: contentView на который наложена коллекция и таблица
    lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var categoriesLabel:UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Категории"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .colorLabel
        $0.textAlignment = .center
        return $0
    }(UILabel())
    lazy var allCategoriesButton: UIButton = AddButton(text: "Изменить")
    lazy var categoriesStack: UIStackView = AddUIStackView(height: 28)
    
    lazy var upcomingAffairsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Ближайшие дела"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .colorLabel
        $0.textAlignment = .center
        return $0
    }(UILabel())
    lazy var showAllUpComingAffairsButton: UIButton = AddButton(text: "Все")
    lazy var upComingAffairsStack: UIStackView = AddUIStackView(height: 28)
    
    // MARK: Карточка прогресса
    lazy var progressCardView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 50
        $0.backgroundColor = .colorButton
        $0.clipsToBounds = true
        $0.heightAnchor.constraint(equalToConstant: 156).isActive = true
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 20, height: 20)
        return $0
    }(UIView())
    lazy var progressLabelToday: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = "Ваш прогресс сегодня"
        $0.textColor = .colorLabelCard
        $0.heightAnchor.constraint(equalToConstant: 17).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 157).isActive = true
        return $0
    }(UILabel())
    lazy var countOfCompletedTasks: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
        $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 157).isActive = true
        return $0
    }(UILabel())
    lazy var progressCompletedNotes: UIProgressView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 8).isActive = true
        $0.layer.cornerRadius = 4
        $0.progressViewStyle = .default
        $0.trackTintColor = .colorProgressCard
        $0.progressTintColor = .white
        return $0
    }(UIProgressView())
    lazy var phrasesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .left
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        $0.textColor = .colorLabelCard
        return $0
    }(UILabel())
    //MARK: Создание таблицы с ближайшими делами
    lazy var tableNotes: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.backgroundColor = .colorBackgroundView
        $0.register(CustomCellNoteMainView.self, forCellReuseIdentifier: CustomCellNoteMainView.reuseId)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    //MARK: Создание коллекции с заметками
    lazy var taskCollectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .colorBackgroundView
        $0.isScrollEnabled = false
        $0.register(CustomCellTasks.self, forCellWithReuseIdentifier: CustomCellTasks.reuseId)
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainTaskPresenter.updateCollectionCoreManager()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupConstraints()
    }
    
    private func setupElements() {
        view.backgroundColor = .colorBackgroundView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews(taskCollectionView,tableNotes,upComingAffairsStack,categoriesStack,progressCardView)
        progressCardView.addSubViews(progressLabelToday,countOfCompletedTasks,progressCompletedNotes,phrasesLabel)
        categoriesStack.addArrangesViews(categoriesLabel,allCategoriesButton)
        upComingAffairsStack.addArrangesViews(upcomingAffairsLabel,showAllUpComingAffairsButton)
        phrasesLabel.text = mainTaskPresenter.generatingMotivationPhrases()
        title = "Мои заметки"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addTaskButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addNote))
        addTaskButton.tintColor = .colorButton
        navigationItem.rightBarButtonItem = addTaskButton
    }
    
    @objc func addNote() {
        let picker = categoryPickerView as! CategoryPickerViewController
        if let sheet = picker.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 25
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        picker.onCategoriesSelected = { [weak self] category in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.showTaskCreationConfirmation(category: category)
            }
        }
        present(picker, animated: true)
    }
 
    private func updateCollectionHeight() {
            taskCollectionView.layoutIfNeeded()
            let height = taskCollectionView.collectionViewLayout.collectionViewContentSize.height
            collectionHeightConstraint.constant = max(height, 10)
        }
        
        private func updateTableHeight() {
            tableNotes.layoutIfNeeded()
            tableHeightConstraint.constant = tableNotes.contentSize.height
        }
    
    func reloadData() {
        taskCollectionView.reloadData()
        tableNotes.reloadData()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            updateCollectionHeight()
            updateTableHeight()
            countOfCompletedTasks.text = mainTaskPresenter.countOfCompletedTasks()
            progressCompletedNotes.progress = mainTaskPresenter.countProgressAllNotes()
        }
    }
    
    func deleteItem(at id: String) {
        guard let index = mainTaskPresenter.tasks.firstIndex(where: {$0.id == id}) else {
            reloadData()
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        taskCollectionView.performBatchUpdates {
            taskCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    private func showTaskCreationConfirmation(category: String) {
        let messageText: String = "Создать задачу?"
        let alert = UIAlertController(title: messageText, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive))
        alert.addAction(UIAlertAction(title: "Создать", style: .default, handler: { [weak self] _ in
            self?.mainTaskPresenter.createNewTaskCoreManager(category)
        }))
        present(alert,animated: true)
    }
    
    func createNewTask(_ category: String) {
        let success = UIAlertController(title: nil, message: category, preferredStyle: .alert)
        present(success, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            success.dismiss(animated: true)
        }
    }
    
    
    
    private func setupConstraints(){
        collectionHeightConstraint = taskCollectionView.heightAnchor.constraint(equalToConstant: 180)
        tableHeightConstraint = tableNotes.heightAnchor.constraint(equalToConstant: 300)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            progressCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            progressCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            progressLabelToday.topAnchor.constraint(equalTo: progressCardView.topAnchor, constant: 20),
            progressLabelToday.leadingAnchor.constraint(equalTo: progressCardView.leadingAnchor, constant: 20),
            
            countOfCompletedTasks.leadingAnchor.constraint(equalTo: progressLabelToday.leadingAnchor),
            countOfCompletedTasks.topAnchor.constraint(equalTo: progressLabelToday.bottomAnchor, constant: 4),
            
            progressCompletedNotes.leadingAnchor.constraint(equalTo: progressCardView.leadingAnchor, constant: 20),
            progressCompletedNotes.trailingAnchor.constraint(equalTo: progressCardView.trailingAnchor, constant: -20),
            progressCompletedNotes.topAnchor.constraint(equalTo: countOfCompletedTasks.bottomAnchor, constant: 20),
            
            phrasesLabel.leadingAnchor.constraint(equalTo: progressCompletedNotes.leadingAnchor),
            phrasesLabel.trailingAnchor.constraint(equalTo: progressCompletedNotes.trailingAnchor),
            phrasesLabel.bottomAnchor.constraint(equalTo: progressCardView.bottomAnchor, constant: -20),
            
            categoriesStack.topAnchor.constraint(equalTo: progressCardView.bottomAnchor, constant: 32),
            categoriesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoriesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            taskCollectionView.topAnchor.constraint(equalTo: categoriesStack.bottomAnchor, constant: 16),
            taskCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionHeightConstraint,
            
            upComingAffairsStack.topAnchor.constraint(equalTo: taskCollectionView.bottomAnchor, constant: 32),
            upComingAffairsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upComingAffairsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tableNotes.topAnchor.constraint(equalTo: upComingAffairsStack.bottomAnchor, constant: 12),
            tableNotes.leadingAnchor.constraint(equalTo: upComingAffairsStack.leadingAnchor),
            tableNotes.trailingAnchor.constraint(equalTo: upComingAffairsStack.trailingAnchor),
            tableNotes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            tableHeightConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TasksView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainTaskPresenter.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = taskCollectionView.dequeueReusableCell(withReuseIdentifier: CustomCellTasks.reuseId, for: indexPath) as! CustomCellTasks
        let task = mainTaskPresenter.tasks[indexPath.item]
        cell.setupCell(tasks: task)
        cell.deleteTask.tag = indexPath.item
        cell.deleteTask.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = mainTaskPresenter.tasks[indexPath.item]
        let noteView = Builder.createNoteView(tasks: task)
        navigationController?.pushViewController(noteView, animated: true)
        
    }
    
    @objc
    func deleteTask(_ sender: UIButton) {
        let index = sender.tag
        guard index < mainTaskPresenter.tasks.count else { return }
        let task = mainTaskPresenter.tasks[index]
        if let taskId = task.id {
            mainTaskPresenter.deleteTask(with: taskId)
        }
    }
}

extension TasksView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let leftRightInset: CGFloat = 20
        let spacing: CGFloat = 12
        let columns: CGFloat = 2
        
        // Ширина = (ширина экрана - левый отступ - правый отступ - расстояние между карточками) / 2
        let width = (collectionView.bounds.width - leftRightInset * 2 - spacing) / columns
        let height: CGFloat = 166
        
        return CGSize(width: width, height: height)
    }
}

extension TasksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTaskPresenter.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellNoteMainView.reuseId, for: indexPath) as! CustomCellNoteMainView
        let note = mainTaskPresenter.notes[indexPath.row]
        cell.setupElementsCell(note: note)
        return cell
    }
    
    
}
