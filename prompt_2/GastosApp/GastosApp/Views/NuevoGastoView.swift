//
//  NuevoGastoView.swift
//  GastosApp
//
//  Formulario modal para crear un gasto nuevo.
//

import SwiftUI
import SwiftData

struct NuevoGastoView: View {

    /// Permite cerrar el modal.
    @Environment(\.dismiss) private var dismiss

    /// Contexto de SwiftData para insertar el nuevo registro.
    @Environment(\.modelContext) private var context

    // MARK: Campos del formulario
    @State private var nombre: String = ""
    @State private var montoTexto: String = ""
    @State private var fecha: Date = .now
    @State private var categoria: CategoriaGasto = .comida

    /// Valida que el formulario tenga datos correctos.
    private var esValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Double(montoTexto.replacingOccurrences(of: ",", with: ".")) ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles del gasto") {
                    TextField("Nombre (p. ej. Supermercado)", text: $nombre)

                    HStack {
                        Text("Monto")
                        Spacer()
                        TextField("0.00", text: $montoTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }

                Section("Categoría") {
                    Picker("Categoría", selection: $categoria) {
                        ForEach(CategoriaGasto.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icono)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Nuevo gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(!esValido)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    /// Crea y guarda el nuevo gasto en SwiftData.
    private func guardar() {
        let monto = Double(montoTexto.replacingOccurrences(of: ",", with: ".")) ?? 0
        let nuevo = Gasto(
            nombre: nombre.trimmingCharacters(in: .whitespaces),
            monto: monto,
            fecha: fecha,
            categoria: categoria
        )
        context.insert(nuevo)
        try? context.save()
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    NuevoGastoView()
        .modelContainer(for: Gasto.self, inMemory: true)
}
