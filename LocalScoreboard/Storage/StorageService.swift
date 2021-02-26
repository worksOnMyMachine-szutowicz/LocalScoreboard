//
//  StorageService.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 26/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreData

class StorageService: RxRequestable<StorageServiceRequest>, StorageServiceInterface {
    private let storage: StorageInterface
    
    init(storage: StorageInterface) {
        self.storage = storage
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        request.asObservable()
            .filterByRequestType(Request.SaveScoreOccurrenceModel.self)
            .append(weak: storage.persistentContainer.viewContext)
            .subscribe(onNext: { managedContext, input in
                let fetchRequest: NSFetchRequest<DicesScoresHistory> = DicesScoresHistory.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "score == \(input.request.score)", input.request.score)
                let entity = managedContext.fetchOrEmpty(with: fetchRequest).first ?? managedContext.createObject()
                entity.score = Int16(input.request.score)
                entity.occurrences += 1
                _ = managedContext.saveChanges()
            }).disposed(by: disposeBag)
        
        request.asObservable()
            .filterByRequestType(Request.GetTopScoresByOccurrences.self)
            .append(weak: storage.persistentContainer.viewContext)
            .subscribe(onNext: { managedContext, input in
                let fetchRequest: NSFetchRequest<DicesScoresHistory> = DicesScoresHistory.fetchRequest()
                fetchRequest.fetchLimit = input.request.scoresToReturn
                fetchRequest.sortDescriptors = [.init(key: "occurrences", ascending: false)]
                let entities = managedContext.fetchOrEmpty(with: fetchRequest).map { Int($0.score) }
                
                input.resultHandler?(entities)
            }).disposed(by: disposeBag)
    }
}
