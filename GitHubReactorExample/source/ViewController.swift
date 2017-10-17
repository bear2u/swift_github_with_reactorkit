//
//  ViewController.swift
//  GitHubReactorExample
//
//  Created by bear2u on 2017. 10. 12..
//  Copyright © 2017년 bear2u. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class ViewController: UIViewController , StoryboardView{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("#100 viewDidLoad did");
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("#200 viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("#200 viewDidAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
//    func initData(){
//        print("initData do!!");
//        Observable.just(titles)
//            .bind(to: tableView.rx.items(cellIdentifier: "customCell" , cellType : CustomCell.self)) { indexPath, item, cell in
//                cell.lbName?.text = item
//            }
//            .disposed(by:disposeBag)
//
//        tableView.rx.itemSelected
//            .subscribe( onNext : { [weak self] indexPath in
//                print("clicked -> \(indexPath)")
//            })
//            .disposed(by : disposeBag)
//    }
    
    func bind(reactor:GithubSearchReactor) {
        print("#100 bind do");
        //Action
        
        self.rx.viewWillAppear
            .do(onNext: { print("viewDidLoad -> \($0)") })
            .map{ _ in Reactor.Action.updateQuery("")}
            .do(onNext: { print("onNext-> \($0)") })
            .bind(to: reactor.action)
            .disposed(by : self.disposeBag)
        
        searchBar.rx.text
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action )
            .disposed(by : disposeBag)
        
//        tableView.rx.contentOffset
//            .filter { [weak self] offset in
//                guard let `self` = self else { return false }
//                guard self.tableView.frame.height > 0 else { return false }
//                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
//            }
        
        //State
        reactor.state.map { $0.titles }
            .bind(to: tableView
                .rx.items(cellIdentifier: "customCell" , cellType : CustomCell.self)) { indexPath, item, cell in
                    print("update table cell -> \(item)")
                    cell.lbName?.text = item
             }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .do(onNext: {
                print( "isLoading = \($0)" )
            })
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

