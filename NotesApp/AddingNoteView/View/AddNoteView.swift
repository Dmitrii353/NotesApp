//
//  AddNoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 24.10.2024.
//

import UIKit

protocol AddNoteViewProtocol: AnyObject {
    var selectedPriority: NotePriority { get }
}

class AddNoteView: UIViewController,AddNoteViewProtocol {

    var presenter: AddNotePresenterProtocol!
    
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
        return $0
    }(UIScrollView())
    
    private lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    
    private lazy var addNoteTitleLabel: UILabel = AddLabel(fontText: 14, fontW: .semibold, colorText: .colorDescriptionLabel, textAlignmentLabel: .left)
   private lazy var nameNote: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Например: Проверить макеты"
        $0.tintColor = .black
        let indent: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftView = indent
        $0.leftViewMode = .always
        $0.rightView = indent
        $0.rightViewMode = .always
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UITextField())
    
    private lazy var descriptionLabel: UILabel = AddLabel(fontText: 14, fontW: .semibold, colorText: .colorDescriptionLabel,textAlignmentLabel: .left)
    
    private lazy var detailNote: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.tintColor = .lightGray
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UITextView())
    
    private lazy var priorityIndicationLabel: UILabel = AddLabel(fontText: 14, fontW: .semibold,colorText: .colorDescriptionLabel, textAlignmentLabel: .left)
    private lazy var priorityControl: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.12
        $0.layer.shadowRadius = 4
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: NotePriority.allCases.map(\.title)))
    
    var selectedPriority: NotePriority {
        NotePriority.allCases[priorityControl.selectedSegmentIndex]
    }
    
    // Вью с напоминанием о выполнением
    private lazy var completionReminderView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.heightAnchor.constraint(equalToConstant: 65).isActive = true
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UIView())
    
    private lazy var reminderLabel: UILabel = AddLabel(fontText: 16, fontW: .semibold ,colorText: .black, textAlignmentLabel: .left)
    private lazy var reminderTimeLabel: UILabel = AddLabel(fontText: 12, fontW: .medium)
    private lazy var iconContainerReminderImage: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
        $0.backgroundColor = .colorHouse
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addSubview(reminderImage)
        return $0
    }(UIView())
    
    private lazy var reminderImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.tintColor = .colorCheckCircleNote
        $0.image = UIImage(systemName: "bell")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    private lazy var reminderSwitch: UISwitch = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .colorButton
        $0.onTintColor = .colorButton
        $0.isOn = false
        $0.addTarget(self, action: #selector(reminderToggled), for: .valueChanged)
        return $0
    }(UISwitch())
    
    private lazy var datePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.datePickerMode = .dateAndTime
        $0.locale = Locale(identifier: "ru_RU")
        $0.preferredDatePickerStyle = .compact
        $0.backgroundColor = .colorBackgroundView
        $0.minimumDate = Date()
        $0.isHidden = true
        return $0
    }(UIDatePicker())
    
    @objc private func reminderToggled() {
        datePicker.isHidden = !reminderSwitch.isOn
        if reminderSwitch.isOn {
            NotificationService.shared.requestPermission { granted in
                if !granted {
                    self.reminderSwitch.isOn = false
                    self.datePicker.isHidden = true
                }
            }
        }
    }
    
    private lazy var saveNote: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .colorButton
        $0.tintColor = .white
        let appConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill",withConfiguration: appConfig), for: .normal)
        $0.setTitle(" Создать заметку", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.colorButton.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 8
        return $0
    }(UIButton(primaryAction: saveDataAction))
    
    private lazy var saveDataAction: UIAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let name = nameNote.text, !name.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите название")
            return
        }
        guard let details = detailNote.text, !details.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите описание")
            return
        }
        let dueDate: Date? = reminderSwitch.isOn ? datePicker.date : nil
        presenter.createNewNote(title: name, details: details, dueDate: dueDate)
            navigationController?.popViewController(animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        title = "Новая заметка"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupElements()
    }
    
    private func setupElements() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews(nameNote,descriptionLabel,detailNote,saveNote,priorityControl,reminderSwitch,datePicker,addNoteTitleLabel,priorityIndicationLabel,completionReminderView)
        completionReminderView.addSubViews(reminderSwitch,reminderLabel,reminderTimeLabel,iconContainerReminderImage)
        descriptionLabel.text = "Описание"
        addNoteTitleLabel.text = "Название заметки"
        priorityIndicationLabel.text = "Укажите приоритет заметки"
        reminderLabel.text = "Напомнить о выполнении"
        reminderTimeLabel.text = "Не выбрано"
        setupConstraints()
        let popNaviationButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(backToNotesView))
        navigationItem.leftBarButtonItem = popNaviationButton
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc private func backToNotesView() {
        navigationController?.popViewController(animated: true)
    }
   
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Подпись к названию заметки
            addNoteTitleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            addNoteTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addNoteTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addNoteTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            //Название заметки
            nameNote.topAnchor.constraint(equalTo: addNoteTitleLabel.bottomAnchor, constant: 16),
            nameNote.leadingAnchor.constraint(equalTo: addNoteTitleLabel.leadingAnchor),
            nameNote.trailingAnchor.constraint(equalTo: addNoteTitleLabel.trailingAnchor),
            nameNote.heightAnchor.constraint(equalToConstant: 52),
            
            // Подпись к описанию
            descriptionLabel.topAnchor.constraint(equalTo: nameNote.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameNote.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 16),

            // Описание
            detailNote.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            detailNote.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            detailNote.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            detailNote.heightAnchor.constraint(equalToConstant: 160),
            
            // Подпись к приоритету
            priorityIndicationLabel.topAnchor.constraint(equalTo: detailNote.bottomAnchor, constant: 20),
            priorityIndicationLabel.leadingAnchor.constraint(equalTo: detailNote.leadingAnchor),
            priorityIndicationLabel.trailingAnchor.constraint(equalTo: detailNote.trailingAnchor),
            priorityIndicationLabel.heightAnchor.constraint(equalToConstant: 16),

            // Приоритет
            priorityControl.topAnchor.constraint(equalTo: priorityIndicationLabel.bottomAnchor, constant: 8),
            priorityControl.leadingAnchor.constraint(equalTo: priorityIndicationLabel.leadingAnchor),
            priorityControl.trailingAnchor.constraint(equalTo: priorityIndicationLabel.trailingAnchor),
            priorityControl.heightAnchor.constraint(equalToConstant: 40),
            
            completionReminderView.topAnchor.constraint(equalTo: priorityControl.bottomAnchor, constant: 30),
            completionReminderView.leadingAnchor.constraint(equalTo: priorityControl.leadingAnchor),
            completionReminderView.trailingAnchor.constraint(equalTo: priorityControl.trailingAnchor),
            
            iconContainerReminderImage.centerYAnchor.constraint(equalTo: completionReminderView.centerYAnchor),
            iconContainerReminderImage.leadingAnchor.constraint(equalTo: completionReminderView.leadingAnchor, constant: 16),
            
            reminderImage.centerYAnchor.constraint(equalTo: iconContainerReminderImage.centerYAnchor),
            reminderImage.centerXAnchor.constraint(equalTo: iconContainerReminderImage.centerXAnchor),
            
            reminderLabel.topAnchor.constraint(equalTo: completionReminderView.topAnchor, constant: 16),
            reminderLabel.leadingAnchor.constraint(equalTo: iconContainerReminderImage.trailingAnchor, constant: 12),
            reminderLabel.trailingAnchor.constraint(equalTo: reminderSwitch.leadingAnchor, constant: 25),
            reminderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            reminderTimeLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor),
            reminderTimeLabel.leadingAnchor.constraint(equalTo: reminderLabel.leadingAnchor),
            reminderTimeLabel.trailingAnchor.constraint(equalTo: reminderLabel.trailingAnchor),
            reminderTimeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // Switch напоминания
            reminderSwitch.centerYAnchor.constraint(equalTo: completionReminderView.centerYAnchor),
            reminderSwitch.trailingAnchor.constraint(equalTo: completionReminderView.trailingAnchor, constant: -16),
            
            // Date picker под switch
            datePicker.topAnchor.constraint(equalTo: completionReminderView.bottomAnchor, constant: 12),
            datePicker.leadingAnchor.constraint(equalTo: completionReminderView.leadingAnchor),
            datePicker.trailingAnchor.constraint(lessThanOrEqualTo: completionReminderView.trailingAnchor),
            
            // Кнопка внизу
            saveNote.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveNote.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveNote.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveNote.heightAnchor.constraint(equalToConstant: 60),
            
            // Чтобы datePicker не врезался в кнопку
            datePicker.bottomAnchor.constraint(lessThanOrEqualTo: saveNote.topAnchor, constant: -30)
        ])
    }
    
    private func alertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}




