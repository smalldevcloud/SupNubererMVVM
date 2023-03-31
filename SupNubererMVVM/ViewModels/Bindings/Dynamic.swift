//
//  Dynamic.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import Foundation

class Dynamic<Generic> {
    typealias Listener = (Generic) -> Void
    private var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    var value: Generic {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: Generic){
        value = v
    }
}
