//
//  MongoProvider
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-20.
// hope i can see this
//

import Vapor
import MongoKitten

public final class MongoDatabaseProvider {
    
    // Can't init is singleton
    private init() {}
    
    // MARK: Shared Instance
    public var MongoDB : MongoKitten.Database?
    
    public static let instance: MongoDatabaseProvider = MongoDatabaseProvider()

    public static func addDatabase(URL _url : String) throws
    {
        let db = MongoDatabaseProvider.instance
        db.MongoDB = try Database(_url)
    }
}
