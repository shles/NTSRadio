//
//  StreamCell.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 17/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class StreamCell: UITableViewCell {
    private var disposeBag = DisposeBag()
    
    var streamTitle: UILabel = StandardLabel(font: .universLTPro(ofSize: 20), textColor: .black)
    var currentImage: UIImageView = UIImageView()
        .with(contentMode: .scaleAspectFill)
        .with(clipsToBounds: true)
    var currentTitle: UILabel = StandardLabel(font: .universLTPro(ofSize: 24), textColor: .black)
    var currentPeriod: UILabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .black)
    var nextTitle: UILabel = StandardLabel(font: .universLTPro(ofSize: 14), textColor: .black)
    var nextPeriod: UILabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .black)
    var playButton: UIButton = UIButton()//TODO: create paly button
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let currentLabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .black, text: "CURRENT:")
        let nextLabel = StandardLabel(font: .universCondensed(ofSize: 14), textColor: .black, text: "NEXT:")
        let accessory = UIImageView(image: #imageLiteral(resourceName: "Accessory"))
        addSubviews([streamTitle, currentLabel, currentImage,currentTitle, currentPeriod, nextLabel,  nextTitle, nextPeriod, playButton, accessory])
        currentImage.snp.makeConstraints {
            $0.height.equalTo(114)
            $0.top.leading.trailing.equalToSuperview()
        }
        [streamTitle, currentLabel,currentTitle, currentPeriod, nextLabel,  nextTitle, nextPeriod].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
            }
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
        let applyVerticalSpacing = {(first: UIView, second: UIView, offset: Float) in second.snp.makeConstraints{ $0.top.equalTo(first.snp.bottom).offset(offset)} }
        applyVerticalSpacing(currentImage, streamTitle, 19)
        applyVerticalSpacing(currentImage, playButton, 8)
        applyVerticalSpacing(streamTitle, currentLabel, 16)
        applyVerticalSpacing(currentLabel, currentTitle, 8)
        applyVerticalSpacing(currentTitle, currentPeriod, 12)
        applyVerticalSpacing(currentPeriod, nextLabel, 16)
        applyVerticalSpacing(nextLabel, nextTitle, 8)
        applyVerticalSpacing(nextTitle, nextPeriod, 12)

        nextPeriod.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
        }
        accessory.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(114/2)
            $0.trailing.equalToSuperview().inset(16)
        }
        playButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(23)
        }
    }
    
    func setup(with stream: RadioStream) {
        stream.schedule.currentProgram().image.asObservable().bind(to: currentImage.rx.image).disposed(by: disposeBag)
        currentTitle.text = stream.schedule.currentProgram().name
        currentPeriod.text = stream.schedule.currentProgram().timeSpace.asString()
        nextTitle.text = stream.schedule.nextProgram().name
        nextPeriod.text = stream.schedule.nextProgram().timeSpace.asString()
        streamTitle.text = stream.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
