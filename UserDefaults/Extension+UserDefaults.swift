protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            print("USER_DEFAULTS_ERROR: Unable to encode object into data")
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("USER_DEFAULTS_ERROR: Unable to encode object into data")
        }
    }
}