//
//  StreamsListViewController.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 17/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxDataSources
import RxSwift


typealias TransitionFromStreamList = (RadioStream) -> ()

class StreamsListViewController: UIViewController {
    
    private var tableView: UITableView
    private var streams: RadioStreams
    private var transition: TransitionFromStreamList
    
    private var disposeBag = DisposeBag()
    
    init(streams: RadioStreams, transition: @escaping TransitionFromStreamList) {
        self.transition = transition
        tableView = UITableView()//TODO: replace with "standard" table view
        self.streams = streams
        super.init(nibName: nil, bundle: nil)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        let dataSource = RxTableViewSectionedReloadDataSource<StandardSectionModel<RadioStream>>(configureCell: { ds, tv, ip, item  in
            let cell = tv.dequeueReusableCellOfType(StreamCell.self, for: ip)
            cell.setup(with: item)
            return cell
        })
        
        streams.asObservable()
            .catchErrorJustReturn([])
            .map { [StandardSectionModel(items: $0)] }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RadioStream.self)
        .subscribe(onNext: { [unowned self] in
            self.transition($0)
        })
        .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
