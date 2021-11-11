final class KeychainPersistence {
        
    public static func addCredentials(_ credentials: LoginCredentials) -> Bool {
        let username = credentials.username
        let password = credentials.password
        
        guard !username.isEmpty || !password.isEmpty else {
            print(KeychainError.emptyCredentials)
            return false
        }
        
        let usernameAdded = add(value: username, forKey: "username")
        let passwordAdded = add(value: password, forKey: "password")
        
        return usernameAdded && passwordAdded
    }
    
    public static func deleteCredentials() -> Bool {
        let usernameDeleted = delete(forKey: "username")
        let passwordDeleted = delete(forKey: "password")
        
        return usernameDeleted && passwordDeleted
    }
    
    public static func loadCredentials() -> LoginCredentials? {
        guard let username = match(forKey: "username"),
              let password = match(forKey: "password")
        else {
            return nil
        }
        
        return LoginCredentials(username: username, password: password)
    }
    
    public static func overrideCredentials(_ credentials: LoginCredentials) -> Bool {
        return deleteCredentials() && addCredentials(credentials)
    }
    
    // MARK: - Helpers
    
    private static func setupGenereicPasswordQuery(forAccount account: String) -> [String : Any] {
        var query = [String : Any]()
        
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccount as String] = account.data(using: .utf8)
        
        return query
    }
    
    private static func add(value: String, forKey key: String) -> Bool {
        var query = setupGenereicPasswordQuery(forAccount: key)
        query[kSecValueData as String] = value.data(using: .utf8)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Handle error status
        if status != errSecSuccess {
            print(KeychainError.unknown(status))
            return false
            
        } else if status == errSecDuplicateItem {
            print(KeychainError.duplicateItem(key))
            return false
        }
        
        return true
    }
    
    private static func delete(forKey key: String) -> Bool {
        let query = setupGenereicPasswordQuery(forAccount: key)
        
        let status = SecItemDelete(query as CFDictionary)
        
        // Handle error status
        if status != errSecSuccess {
            print(KeychainError.unknown(status))
            return false
        }
        
        return true
    }
    
    private static func match(forKey key: String) -> String? {
        var query = setupGenereicPasswordQuery(forAccount: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // Handle error status
        if status != errSecSuccess {
            print(KeychainError.unknown(status))
            return nil
        }
        
        guard let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)!
    }
}

struct LoginCredentials {
    let username: String
    let password: String
}

enum KeychainError: Error, CustomStringConvertible {
    case emptyCredentials
    case duplicateItem(String)
    case unknown(OSStatus)
    
    var description: String {
        switch self {
        case .emptyCredentials:
            return "KEYCHAIN_ERROR: One of the provided credentials is empty!"
        
        case let .duplicateItem(key):
            return "KEYCHAIN_ERROR: Provided key: '\(key)' is already existed!"
        
        case let .unknown(osstatus):
            return "KEYCHAIN_ERROR: Failed with status: \(osstatus)!"
        }
    }
}