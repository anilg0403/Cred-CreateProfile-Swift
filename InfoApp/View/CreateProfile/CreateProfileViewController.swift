//
//  CreateProfileViewController.swift
//  InfoApp
//
//  Created by Anil Gupta on 21/05/20.
//  Copyright © 2020 Anil Gupta. All rights reserved.
//

import UIKit

//MARK:- CreateProfileViewController Class
class CreateProfileViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var parentView: UIView!    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    var reuseIdentifierInfoCollectionViewCell = "InfoCollectionViewCell"

    var infoDataObj : [InfoData]?
    var showErrorLabel = false
    var infoTextField : UITextField?
    var infoTextView : UITextView?
    
    //var inputDataArray = [String]()
    var inputDataArray : Array<String> = Array()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForKeyboardNotifications()
        inputDataArray = []
        
        let data = Data(getInfoApiString().utf8)
        if let userModel = parseJSON(data: data) {
            infoDataObj = userModel.pages
        }

        self.collectionView.isPagingEnabled = true
        self.collectionView.register(UINib(nibName:reuseIdentifierInfoCollectionViewCell, bundle: Bundle(for: type(of:self))), forCellWithReuseIdentifier: reuseIdentifierInfoCollectionViewCell)
        self.collectionView.isScrollEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
}

//MARK: Extra Methods
extension CreateProfileViewController {
    
    //MARK: Handling keyboard
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            if infoDataObj?[indexPath?.row ?? 0].showNumberKeyoard ?? false {
                self.infoTextField?.keyboardType = .numberPad
            } else {
                self.infoTextField?.keyboardType = .default
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
    }
}

//MARK: UICollectionViewDelegate,UICollectionViewDataSource
extension CreateProfileViewController :  UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat =  UIScreen.main.bounds.size.height
        return CGSize(width: width , height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoDataObj?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierInfoCollectionViewCell, for: indexPath) as! InfoCollectionViewCell
        let currentInfoDataObj = infoDataObj?[indexPath.row]
        cell.contentParentView.removeAllSubviews()
                
        let parentView = UIView.init()
        parentView.backgroundColor = UIColor.init(hex:"#4890BB")
        parentView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentParentView.addSubview(parentView)
        parentView.leadingAnchor.constraint(equalTo: cell.contentParentView.leadingAnchor, constant:0).isActive = true
        parentView.trailingAnchor.constraint(equalTo: cell.contentParentView.trailingAnchor, constant:0).isActive = true
        parentView.topAnchor.constraint(equalTo: cell.contentParentView.topAnchor, constant:0).isActive = true
        parentView.bottomAnchor.constraint(equalTo: cell.contentParentView.bottomAnchor, constant:0).isActive = true
        
        
        let headerWrapperView = UIView.init()
        headerWrapperView.backgroundColor = .clear
        headerWrapperView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(headerWrapperView)
        headerWrapperView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant:20).isActive = true
        headerWrapperView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant:-20).isActive = true
        headerWrapperView.topAnchor.constraint(equalTo:parentView.topAnchor, constant:60).isActive = true
        
        headerWrapperView.backgroundColor = UIColor.init(hex:"#4890BB")
        headerWrapperView.layer.cornerRadius = 10
        headerWrapperView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerWrapperView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        headerWrapperView.layer.shadowOpacity = 1
        headerWrapperView.layer.shadowRadius = 8
        
        let headerMsgLabel = UILabel.init()
        headerMsgLabel.numberOfLines = 2
        headerMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        headerWrapperView.addSubview(headerMsgLabel)
        headerMsgLabel.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
        headerMsgLabel.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-20).isActive = true
        headerMsgLabel.topAnchor.constraint(equalTo:headerWrapperView.topAnchor, constant:20).isActive = true
        headerMsgLabel.attributedText = NSAttributedString(string:currentInfoDataObj?.title ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 22)!])
        
        let moreInfoLabel = UILabel.init()
        moreInfoLabel.numberOfLines = 0
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        headerWrapperView.addSubview(moreInfoLabel)
        moreInfoLabel.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
        moreInfoLabel.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-40).isActive = true
        moreInfoLabel.topAnchor.constraint(equalTo:headerMsgLabel.bottomAnchor, constant:2).isActive = true
        moreInfoLabel.attributedText = NSAttributedString(string:currentInfoDataObj?.subtitle ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"Avenir-Book", size:15)!])

        if currentInfoDataObj?.isSummary ?? false {
            
            infoTextView = UITextView.init()
            infoTextView?.keyboardDismissMode = .interactive
            infoTextView?.alwaysBounceVertical = true
            infoTextView?.contentInset = UIEdgeInsets(top:5, left:10, bottom:5, right:10)
            infoTextView?.layer.cornerRadius = 5
            infoTextView?.backgroundColor = .clear
            infoTextView?.textColor = .white
            infoTextView?.tintColor = .white
            infoTextView?.layer.borderColor = UIColor.white.cgColor
            infoTextView?.layer.borderWidth = 1
            infoTextView?.delegate = self
            infoTextView?.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            infoTextView?.keyboardType = .default
            infoTextView?.translatesAutoresizingMaskIntoConstraints = false
            headerWrapperView.addSubview(infoTextView!)
            infoTextView?.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
            infoTextView?.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-20).isActive = true
            infoTextView?.topAnchor.constraint(equalTo:moreInfoLabel.bottomAnchor, constant:50).isActive = true
            infoTextView?.heightAnchor.constraint(equalToConstant:80).isActive = true
            infoTextView?.bottomAnchor.constraint(equalTo:headerWrapperView.bottomAnchor, constant:-50).isActive = true
            
            infoTextView?.textContainerInset = UIEdgeInsets(top:5, left:10, bottom:5, right:10)
            infoTextView?.textContainer.lineFragmentPadding = 0
            
            if self.showErrorLabel {
                let errorLabel = UILabel.init()
                errorLabel.textColor = .red
                errorLabel.translatesAutoresizingMaskIntoConstraints = false
                headerWrapperView.addSubview(errorLabel)
                errorLabel.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
                errorLabel.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-20).isActive = true
                errorLabel.topAnchor.constraint(equalTo:infoTextView!.bottomAnchor, constant:4).isActive = true
                errorLabel.attributedText = NSAttributedString(string:currentInfoDataObj?.emptyFieldMsg ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"Avenir-Book", size:15)!])
            }
                        
        } else {
        
            infoTextField = UITextField.init()
            infoTextField?.delegate = self
            infoTextField?.backgroundColor = .clear
            infoTextField?.tintColor = .white
            infoTextField?.textColor = .white
            infoTextField?.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            infoTextField?.translatesAutoresizingMaskIntoConstraints = false
            headerWrapperView.addSubview(infoTextField!)
            infoTextField?.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
            infoTextField?.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-60).isActive = true
            infoTextField?.topAnchor.constraint(equalTo:moreInfoLabel.bottomAnchor, constant:50).isActive = true
            infoTextField?.placeholder = currentInfoDataObj?.placeholderText
            
            if currentInfoDataObj?.showNumberKeyoard ?? false {
                infoTextField?.keyboardType = .numberPad
            } else {
                infoTextField?.keyboardType = .default
            }
            
            let seperatorView = UIView.init()
            seperatorView.backgroundColor = .white
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            headerWrapperView.addSubview(seperatorView)
            seperatorView.leadingAnchor.constraint(equalTo: headerWrapperView.leadingAnchor, constant:20).isActive = true
            seperatorView.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:-60).isActive = true
            seperatorView.topAnchor.constraint(equalTo:infoTextField!.bottomAnchor, constant:4).isActive = true
            seperatorView.bottomAnchor.constraint(equalTo:headerWrapperView.bottomAnchor, constant:-60).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
            
            if self.showErrorLabel {
                let errorLabel = UILabel.init()
                errorLabel.textColor = .red
                errorLabel.translatesAutoresizingMaskIntoConstraints = false
                headerWrapperView.addSubview(errorLabel)
                errorLabel.leadingAnchor.constraint(equalTo: seperatorView.leadingAnchor, constant:0).isActive = true
                errorLabel.trailingAnchor.constraint(equalTo: seperatorView.trailingAnchor, constant:0).isActive = true
                errorLabel.topAnchor.constraint(equalTo:seperatorView.bottomAnchor, constant:4).isActive = true
                errorLabel.attributedText = NSAttributedString(string:currentInfoDataObj?.emptyFieldMsg ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"Avenir-Book", size:15)!])
            }
        
        }
        
        let nextButton = UIButton.init()
        nextButton.contentEdgeInsets = UIEdgeInsets(top:5, left:40, bottom:5, right:40)
        nextButton.isUserInteractionEnabled = true
        nextButton.tag = indexPath.row
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(nextButton)
        nextButton.trailingAnchor.constraint(equalTo: headerWrapperView.trailingAnchor, constant:0).isActive = true
        nextButton.leadingAnchor.constraint(greaterThanOrEqualTo:headerWrapperView.leadingAnchor, constant:10).isActive = true
        nextButton.topAnchor.constraint(equalTo: headerWrapperView.bottomAnchor, constant:40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        nextButton.layer.cornerRadius = 25
        
        let nextAttrString = NSAttributedString(string:currentInfoDataObj?.nextButtonText ?? "NEXT", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"Avenir-Black", size:16)!])
        nextButton.setAttributedTitle(nextAttrString, for:.normal)
        
        nextButton.backgroundColor = UIColor.init(hex:"#4890BB")
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 8
        
        nextButton.addTargetClosure { (btn) in
            
            self.infoTextField?.resignFirstResponder()
            if self.infoTextView != nil {
                self.infoTextView?.resignFirstResponder()
            }
            self.showErrorLabel = false
            
            if currentInfoDataObj?.isSummary == false && !(self.infoTextField?.validate() ?? true) {
                self.showErrorLabel = true
                self.collectionView.reloadData()
            } else if currentInfoDataObj?.isSummary == true && !(self.infoTextView?.validate() ?? true) {
                self.showErrorLabel = true
                self.collectionView.reloadData()
            } else {
                
                /* Save entered value in array*/
                if currentInfoDataObj?.isSummary ?? true {
                    self.inputDataArray.append(self.infoTextView?.text ?? "")
                } else {
                    self.inputDataArray.append(self.infoTextField?.text ?? "")
                }
                
                if currentInfoDataObj?.canMoveNext ?? false {
                    collectionView.isScrollEnabled = true
                    collectionView.scrollToNextItem()
                } else {
                    self.collectionView.isHidden = true
                    self.setInfoView()
                }
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            if self.infoDataObj?[indexPath.row].isSummary ?? false {
                self.infoTextView?.becomeFirstResponder()
            } else {
                self.infoTextField?.becomeFirstResponder()
            }
        })
    }
    
}

//MARK:- UITextFieldDelegate Methods
extension CreateProfileViewController : UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

//MARK:- UITextViewDelegate Methods
extension CreateProfileViewController: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        infoTextView = textView
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

}

//MARK:- UITextViewDelegate Methods
extension CreateProfileViewController {
    
    func setInfoView() {
        
        self.parentView.backgroundColor = UIColor.init(hex:"#4890BB")
        
        let contentWrapperView = UIView.init()
        contentWrapperView.backgroundColor = .clear
        contentWrapperView.translatesAutoresizingMaskIntoConstraints = false
        self.parentView.addSubview(contentWrapperView)
        contentWrapperView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant:20).isActive = true
        contentWrapperView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant:-20).isActive = true
        contentWrapperView.topAnchor.constraint(equalTo:parentView.topAnchor, constant:60).isActive = true
        contentWrapperView.backgroundColor = UIColor.init(hex:"#4890BB")
        contentWrapperView.layer.cornerRadius = 10
        contentWrapperView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentWrapperView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentWrapperView.layer.shadowOpacity = 1
        contentWrapperView.layer.shadowRadius = 8
        
        var lastUILabelRef = UILabel.init()
        
        for i in 0...((inputDataArray.count) - 1) {
            
            let keyLabel = UILabel.init()
            keyLabel.numberOfLines = 1
            keyLabel.backgroundColor = .clear
            keyLabel.translatesAutoresizingMaskIntoConstraints = false
            contentWrapperView.addSubview(keyLabel)
            keyLabel.leadingAnchor.constraint(equalTo: contentWrapperView.leadingAnchor, constant:20).isActive = true
            keyLabel.trailingAnchor.constraint(equalTo: contentWrapperView.trailingAnchor, constant:-20).isActive = true
            
            if i == 0 {
                keyLabel.topAnchor.constraint(equalTo: contentWrapperView.topAnchor, constant:20).isActive = true
            } else {
                keyLabel.topAnchor.constraint(equalTo: lastUILabelRef.bottomAnchor, constant:20).isActive = true
            }
            
            keyLabel.attributedText = NSAttributedString(string:infoDataObj?[i].parameterKey ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name:"Avenir-Book", size:15)!])


            let valueLabel = UILabel.init()
            valueLabel.numberOfLines = 0
            valueLabel.backgroundColor = .clear
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            contentWrapperView.addSubview(valueLabel)
            valueLabel.leadingAnchor.constraint(equalTo: contentWrapperView.leadingAnchor, constant:20).isActive = true
            valueLabel.trailingAnchor.constraint(equalTo: contentWrapperView.trailingAnchor, constant:-20).isActive = true
            valueLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant:0).isActive = true
            valueLabel.attributedText = NSAttributedString(string:inputDataArray[i], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 16)!])

            lastUILabelRef = valueLabel
            
            if i == ((inputDataArray.count ) - 1) {
                valueLabel.bottomAnchor.constraint(equalTo: contentWrapperView.bottomAnchor, constant:-20).isActive = true
            }
            
        }
        
    }

}

//MARK:- Collection Extension
extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        UIView.animate(withDuration: 0.6, animations: {
            self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
            self.isScrollEnabled = false
        })
    }
}
