//
//  GastosAppApp.swift
//  GastosApp
//
//  Punto de entrada de la aplicación. Configura el contenedor de SwiftData.
//

import SwiftUI
import SwiftData

@main
struct GastosAppApp: App {

    /// Contenedor de SwiftData compartido por toda la app.
    /// Aquí se registran todos los modelos (@Model) que se van a persistir.
    let contenedorCompartido: ModelContainer = {
        let schema = Schema([
            Gasto.self
        ])
        let configuracion = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuracion])
        } catch {
            fatalError("No se pudo crear el ModelContainer de SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ListaGastosView()
        }
        .modelContainer(contenedorCompartido)
    }
}
