//
//  Gasto.swift
//  GastosApp
//
//  Modelo de datos principal, persistido con SwiftData.
//

import Foundation
import SwiftData

/// Categorías disponibles para clasificar un gasto.
enum CategoriaGasto: String, CaseIterable, Codable, Identifiable {
    case comida = "Comida"
    case transporte = "Transporte"
    case hogar = "Hogar"
    case ocio = "Ocio"
    case salud = "Salud"
    case otros = "Otros"

    var id: String { rawValue }

    /// Símbolo SF Symbols asociado a cada categoría.
    var icono: String {
        switch self {
        case .comida: return "fork.knife"
        case .transporte: return "car.fill"
        case .hogar: return "house.fill"
        case .ocio: return "gamecontroller.fill"
        case .salud: return "heart.fill"
        case .otros: return "square.grid.2x2.fill"
        }
    }
}

/// Modelo que representa un gasto individual.
/// La anotación @Model hace que SwiftData lo persista automáticamente en disco.
@Model
final class Gasto {

    /// Nombre o concepto del gasto (p. ej. "Supermercado").
    var nombre: String

    /// Monto en la moneda local.
    var monto: Double

    /// Fecha en la que se realizó el gasto.
    var fecha: Date

    /// Categoría del gasto (se guarda como String para máxima compatibilidad).
    var categoriaRaw: String

    /// NOTA: `@Attribute(.unique)` obliga a un identificador estable.
    /// Añadimos un id propio para poder ordenar e identificar de forma segura.
    var id: UUID

    /// Categoría como enum calculado a partir del valor persistido.
    var categoria: CategoriaGasto {
        get { CategoriaGasto(rawValue: categoriaRaw) ?? .otros }
        set { categoriaRaw = newValue.rawValue }
    }

    init(
        nombre: String,
        monto: Double,
        fecha: Date = .now,
        categoria: CategoriaGasto = .otros,
        id: UUID = UUID()
    ) {
        self.id = id
        self.nombre = nombre
        self.monto = monto
        self.fecha = fecha
        self.categoriaRaw = categoria.rawValue
    }
}

// MARK: - Datos de ejemplo (solo para Previews)
extension Gasto {
    static var ejemplos: [Gasto] {
        [
            Gasto(nombre: "Supermercado", monto: 45.90, fecha: .now, categoria: .comida),
            Gasto(nombre: "Gasolina", monto: 30.00, fecha: .now.addingTimeInterval(-86_400), categoria: .transporte),
            Gasto(nombre: "Cine", monto: 12.50, fecha: .now.addingTimeInterval(-172_800), categoria: .ocio)
        ]
    }
}
