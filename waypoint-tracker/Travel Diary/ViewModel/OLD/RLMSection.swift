import Foundation
import RealmSwift

class RLMSection: Object {
    @objc dynamic var dateString: String = ""
    
    let visits = List<RLMVisit>()
    
    override static func primaryKey() -> String? {
        return "dateString"
    }
    
    convenience init(dateString: String) {
        self.init()
        self.dateString = dateString
    }
}

extension RLMSection {
    static func add(visit: RLMVisit) { // realm to ensure that it´s on the same thread
        let alreadyInWriteTransaction = db.realm.isInWriteTransaction
        do {
            if !alreadyInWriteTransaction {
                db.realm.beginWrite()
            }
            
            let rlmSection = db.realm.objects(RLMSection.self).filter("dateString = %@", visit.dateString).first ?? RLMSection(dateString: visit.dateString)
            if rlmSection.visits.first(where: { sameEntry in sameEntry == visit }) == nil {
                rlmSection.visits.insert(visit, at: 0)
            }
            db.realm.add(rlmSection, update: .modified)
            
            if !alreadyInWriteTransaction {
                try db.realm.commitWrite()
         //       db.realmChanged()
            }
            
        } catch {

        }
    }
    

}
