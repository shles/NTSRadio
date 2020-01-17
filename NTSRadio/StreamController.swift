//
//  StreamController.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 23/02/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit

class StreamController: UIViewController {
    /*
     Controller thet contains stream bottom bar, controls it's state
     and main hierarchy (possibly reperesented by navigationController)
     When root controller is actve bar is hidden, thet it appears from bottom and expandes by tap on it
     It has controls  for streams
     */
    private var streamBar: StreamBar
    
    init(with streams: RadioStreams, hierarchy: UINavigationController) {
        streamBar = StreamBar(with: streams)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StreamBar: UIView {
    
    //Must have several states. possibly controlled from outside
    init(with streams: RadioStreams) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
