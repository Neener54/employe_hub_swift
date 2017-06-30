public protocol EmployeeAdapter {
    func findAll(onCompletion: @escaping ([Employee], Error?) -> Void)
    func create(_ model: Employee, onCompletion: @escaping (Employee?, Error?) -> Void)
    func deleteAll(onCompletion: @escaping (Error?) -> Void)

    func findOne(_ maybeID: String?, onCompletion: @escaping (Employee?, Error?) -> Void)
    func update(_ maybeID: String?, with model: Employee, onCompletion: @escaping (Employee?, Error?) -> Void)
    func delete(_ maybeID: String?, onCompletion: @escaping (Employee?, Error?) -> Void)
}
