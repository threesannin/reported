//
//  IntentHandler.swift
//  Intents Handler
//
//  Created by Daniel  Ochoa Aguila on 4/22/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import Intents

class IntentHandler: INExtension, INStartWorkoutIntentHandling, INEndWorkoutIntentHandling {
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        let userActivity: NSUserActivity? = nil
        guard let spokenPhrase = intent.workoutName?.spokenPhrase else {
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: userActivity))
            return
        }
        
        print(spokenPhrase)
        
        completion(INStartWorkoutIntentResponse(code: .continueInApp, userActivity: userActivity))
    }
    
    func handle(intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
        print("in end workout")
    }
    
}
