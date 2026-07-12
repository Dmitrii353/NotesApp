//
//  ViewController.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

class TasksView: UIViewController {
   
    var tasks : [Tasks] = []
    private let coreManager = CoreManager.shared
    
    
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
        coreManager.getFolder()
        self.tasks = coreManager.tasks
        self.taskCollectionView.reloadData()
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
    
    @objc
    func addNote() {
        let addNote = AddTaskView()
        navigationController?.pushViewController(addNote, animated: true)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            taskCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

            
        ])
    }
}
   
extension TasksView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = taskCollectionView.dequeueReusableCell(withReuseIdentifier: CustomCellTasks.reuseId, for: indexPath) as! CustomCellTasks
        let task = tasks[indexPath.item]
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
        let task = tasks[indexPath.item]
        let noteView = NoteView()
        noteView.tasks = task
        navigationController?.pushViewController(noteView, animated: true)
        
    }
    
    @objc
    func deleteTask(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(item: index, section: 0)
        let task = tasks[indexPath.item]
        tasks.remove(at: indexPath.item)
        taskCollectionView.deselectItem(at: indexPath, animated: true)
        coreManager.deleteTask(task: task)
        taskCollectionView.reloadData()
        // Удаление элемента
    
        
        
        
    }
    
    
}

