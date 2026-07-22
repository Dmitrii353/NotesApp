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
    
    
    lazy var taskCollectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width/2, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .colorBackgroundView
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
        view.addSubViews(taskCollectionView)
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addNote))
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
    
    func reloadData() {
        taskCollectionView.reloadData()
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
        NSLayoutConstraint.activate([
            taskCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
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
        cell.nameTask.text = task.name
        cell.countNote.text =  "\(task.notes?.count.description ?? "0") заметок"
        if let date = task.date {
            cell.datetask.text = date.formatDateForCell()
        } else {
            cell.datetask.text = "нет даты"
        }
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

