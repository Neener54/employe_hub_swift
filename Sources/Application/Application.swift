import Foundation
import Kitura
import LoggerAPI
import Configuration
import Generated
import CloudFoundryConfig
import SwiftMetrics
import SwiftMetricsDash
import CouchDB

public let router = Router()
public let manager = ConfigurationManager()
public var port: Int = 8080

internal var couchDBClient: CouchDBClient?

public func initialize() throws {

    manager.load(file: "config.json", relativeFrom: .project)
           .load(.environmentVariables)

    port = manager.port

    let sm = try SwiftMetrics()
    let _ = try SwiftMetricsDash(swiftMetricsInstance : sm, endpoint: router)

    let cloudantService = try manager.getCloudantService(name: "crudDataStore")
    couchDBClient = CouchDBClient(service: cloudantService)

    router.all("/*", middleware: BodyParser())

    try initializeCRUDResources(manager: manager, router: router)
    initializeSwaggerRoute(path: ConfigurationManager.BasePath.project.path + "/definitions/employeeDashboard.yaml")
}

public func run() throws {
    Kitura.addHTTPServer(onPort: port, with: router)
    Kitura.run()
}
