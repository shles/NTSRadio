//
//  StreamViewController.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 01/04/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class StreamViewController: UIViewController {
    
    enum StreamControllerCell {
        case current(RadioStream)
        case schedule(Program)
    }
    
    private var stream: ObservableStream
    private var tableView: StandardTableView
    private var backButton = UIButton()
        .with(image: #imageLiteral(resourceName: "Back"))
        .with(backgroundColor: .white)
        .with(borderWidth: 1, borderColor: .black  )
    private var streamImage = UIImageView()
        .with(contentMode: .scaleAspectFill)
    
    private var disposeBag = DisposeBag()
    
    init(stream: ObservableStream) {
        self.stream = stream
        self.tableView = StandardTableView(style: .plain, footerView: UIView(frame: .zero))
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<StandardSectionModel<StreamControllerCell>>(configureCell:  { ds, tv, ip, item  in
            switch item {
            case let .current(stream: stream):
                let cell = tv.dequeueReusableCellOfType(CurrentCell.self, for: ip)
                cell.configure(withStream: stream)
                return cell
            case let .schedule(program: program):
                let cell = tv.dequeueReusableCellOfType(ScheduleCell.self, for: ip)
                cell.configure(withProgram: program)
                return cell
            }
        })
        
        stream.asObservable()
            .map {
                [StandardSectionModel(items: [StreamControllerCell.current($0)] //+ $0.schedule.programs.map {StreamControllerCell.schedule($0) }
                     )]
            }
            .debug()
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        backButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        tableView.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayButton: UIButton {
    
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func setup(withStream stream: RadioStream) {
        stream.playing.subscribe(onNext: {
            if $0 {
                self.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            } else {
                self.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            }
        }).disposed(by: disposeBag)
        self.rx.tap.subscribe(onNext: {
            stream.toggle()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProgramDescriptionView: UIView {
    
    let nameLabel = StandardLabel(font: .universLTPro(ofSize: 18), textColor: .black)
    let locationLabel = StandardLabel(font: .universLTPro(ofSize: 12), textColor: .black)
    let descriptionLabel = StandardLabel(font: .universCondensed(ofSize: 12), textColor: .black)
    let disclosure = UIImageView(image: #imageLiteral(resourceName: "Accessory"))
    let separator = UIView().with(backgroundColor: .black)

    init( ) {
        super.init(frame: .zero)
        

        addSubviews([nameLabel, locationLabel, separator, descriptionLabel])
        
        let applyVerticalSpacing = {(first: UIView, second: UIView, offset: Float) in second.snp.makeConstraints{ $0.top.equalTo(first.snp.bottom).offset(offset)} }
        
        [nameLabel, locationLabel, separator, descriptionLabel].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().inset(16)
            }
        }
        
        applyVerticalSpacing(nameLabel, locationLabel, 8)
        applyVerticalSpacing(locationLabel, separator, 16)
        applyVerticalSpacing(separator, descriptionLabel, 16)
        
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
        }
        backgroundColor = .white
        
        addSubview(disclosure)
        disclosure.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(5)
            $0.height.equalTo(13)
            
        }
        disclosure.isHidden = true
        
    }
    
    func setup(withProgram program: Program, withDisclosure: Bool) {
        nameLabel.text = program.name
        locationLabel.text = program.location.longString.uppercased()
        descriptionLabel.text = program.description
        disclosure.isHidden = !withDisclosure
        
        if withDisclosure {
            separator.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(32)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CurrentProgramView: UIView {
    private let image = UIImageView()
    private let playButton = PlayButton()
    private let programView = ProgramDescriptionView()
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        addSubviews([image, programView, playButton])
        
        image.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(240)
        }
        
        programView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(image.snp.bottom)
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(programView).offset(20)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(40)
        }
    }
    
    func setup(withStream stream: RadioStream) {
        stream.schedule.currentProgram().image.asObservable().bind(to: image.rx.image).disposed(by: disposeBag)
        programView.setup(withProgram: stream.schedule.currentProgram(), withDisclosure: true)
        playButton.setup(withStream: stream)
    }
    
    func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NextHeader: UIView {
    init() {
        super.init(frame: .zero)
        let label = StandardLabel(font: .universCondensed(ofSize: 20), textColor: .white, text: "NEXT")
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class CurrentCell: UITableViewCell {
    
    private var programView = CurrentProgramView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let nextHeader = NextHeader()
        self.addSubviews([programView, nextHeader])
        programView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        nextHeader.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(programView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withStream stream: RadioStream) {
        programView.setup(withStream: stream)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        programView.prepareForReuse()
    }

}

class ScheduleCell: UITableViewCell {
    
    let timespaceLabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .white)
    let nameLabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .white)
    .aligned(by: .right)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([timespaceLabel, nameLabel])
        timespaceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        timespaceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(timespaceLabel.snp.trailing)
        }
        backgroundColor = .black
    }
    
    func configure(withProgram program: Program) {
        timespaceLabel.text = program.timeSpace.asString()
        nameLabel.text = program.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
