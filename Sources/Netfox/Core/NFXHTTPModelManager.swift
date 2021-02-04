//
// plg
// Copyright © 2021 Heads and Hands. All rights reserved.
//

import Foundation

private let _sharedInstance = NFXHTTPModelManager()

// MARK: - NFXHTTPModelManager

final class NFXHTTPModelManager: NSObject {
    // MARK: Internal

    static let sharedInstance = NFXHTTPModelManager()

    func add(_ obj: NFXHTTPModel) {
        syncQueue.async {
            self.models.insert(obj, at: 0)
            NotificationCenter.default.post(name: NSNotification.Name.NFXAddedModel, object: obj)
        }
    }

    func clear() {
        syncQueue.async {
            self.models.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name.NFXClearedModels, object: nil)
        }
    }

    func getModels() -> [NFXHTTPModel] {
        var predicates = [NSPredicate]()

        let filterValues = NFX.sharedInstance().getCachedFilters()
        let filterNames = HTTPModelShortType.allValues

        var index = 0
        for filterValue in filterValues {
            if filterValue {
                let filterName = filterNames[index].rawValue
                let predicate = NSPredicate(format: "shortType == '\(filterName)'")
                predicates.append(predicate)
            }
            index += 1
        }

        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let array = (models as NSArray).filtered(using: searchPredicate)

        return array as! [NFXHTTPModel]
    }

    // MARK: Fileprivate

    fileprivate var models = [NFXHTTPModel]()

    // MARK: Private

    private let syncQueue = DispatchQueue(label: "NFXSyncQueue")
}
