//
//  NEngine.swift
//  Navigation Engine
//
//  Created by mahbub on 2/27/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class NEngine: RESTServiceDelegate {
    
    private let googleDirection = GoogleDirectionService()
    
    var delegate: EngineDelegate?
    
    init() {
        
        self.delegate = nil
        self.googleDirection.delegate = self
    }
    
    func dataDidReceive(data: Any) {
        
        guard let direction = data as? GoogleDirection,
            "OK" == direction.status else {
            
                print("No Direction is found from Google Directions API.")
                print("Google Directions API Error: \(data)")
                self.delegate?.processDidAbort(reason: "No Direction is found from Google Map.")
                return
        }
        
        print("\nCreating GMS Path ...\n")
        let steps = direction.routes.flatMap({ $0.legs.flatMap({ $0.steps }) })
        print("\nSteps: \(steps)\n")
        
        self.delegate?.processDidComplete(then: steps)
    }
    
}
