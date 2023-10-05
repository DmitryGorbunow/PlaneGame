//
//  UserDefaults+Extension .swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/21/23.
//

import Foundation

extension UserDefaults {
    func saveData<T: Encodable>(someData: T, key: String) {
        let data = try? JSONEncoder().encode(someData)
        set(data, forKey: key)
    }
    
    func readData<T: Decodable>(type: T.Type, key: String) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        let newData = try? JSONDecoder().decode(type, from: data)
        return newData
    }
}
