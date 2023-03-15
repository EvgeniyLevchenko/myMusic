//
//  UserDefaultsService.swift
//  myMusic
//
//  Created by QwertY on 14.03.2023.
//

import Foundation

extension UserDefaults {
    
    func save<T: NSCoding>(objects: [T], forKey key: String, completion: @escaping (Error?) -> Void) {
        let defaults = UserDefaults.standard
        guard let savedData = try? NSKeyedArchiver.archivedData(withRootObject: objects, requiringSecureCoding: false) else {
            completion(UserDefaultsError.cannotSaveData)
            return
        }
        defaults.set(savedData, forKey: key)
        completion(nil)
    }
    
    func fetchObjects<T: NSCoding>(ofClass type: T.Type, forKey key: String, completion: @escaping (Result<[T], Error>) -> Void) {
        let defaults = UserDefaults.standard
        guard let savedData = defaults.object(forKey: key) as? Data else {
            completion(.failure(UserDefaultsError.cannotFetchData))
            return
        }
        
        guard let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [T] else {
            completion(.failure(UserDefaultsError.cannotFetchData))
            return
        }
        
        completion(.success(decodedData))
    }
    
    func fetchTracks(forKey key: String) -> [SearchViewModel.Cell] {
        var tracks = [SearchViewModel.Cell]()
        UserDefaults.standard.fetchObjects(ofClass: SearchViewModel.Cell.self, forKey: key) { result in
            switch result {
            case .success(let data):
                tracks = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return tracks
    }
}
