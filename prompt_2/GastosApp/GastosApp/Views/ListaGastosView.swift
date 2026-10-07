//
//  ListaGastosView.swift
//  GastosApp
//
//  Pantalla principal: muestra el total, la lista de gastos
//  y el botón para agregar un gasto nuevo.
//

import SwiftUI
import SwiftData

struct ListaGastosView: View {

    /// Consulta reactiva: la vista se actualiza sola cuando cambian los datos.
    /// @Query sin predicados devuelve todos los gastos ordenados por fecha.
    @Query(sort: \Gasto.fecha, order: .reverse) private var gastos: [Gasto]

    /// Contexto de SwiftData para insertar y borrar registros.
    @Environment(\.modelContext) private var context

    /// Controla la presentación del formulario de nuevo gasto.
    @State private var mostrarFormulario: Bool = false

    /// Suma total de los gastos mostrados.
    private var total: Double {
        gastos.reduce(0) { $0 + $1.monto }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Tarjeta de total
                TarjetaTotal(total: total, cantidad: gastos.count)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // MARK: Lista de gastos
                if gastos.isEmpty {
                    VistaVacia()
                } else {
                    List {
                        ForEach(gastos) { gasto in
                            FilaGasto(gasto: gasto)
                        }
                        .onDelete(perform: eliminar)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("GastosApp")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !gastos.isEmpty {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Agregar gasto", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                NuevoGastoView()
            }
        }
    }

    /// Elimina los gastos seleccionados en la lista.
    private func eliminar(at offsets: IndexSet) {
        withAnimation {
            for indice in offsets {
                let gasto = gastos[indice]
                context.delete(gasto)
            }
            try? context.save()
        }
    }
}

// MARK: - Tarjeta superior con el total
private struct TarjetaTotal: View {
    let total: Double
    let cantidad: Int

    var body: some View {
        VStack(spacing: 6) {
            Text("Total gastado")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(total, format: .currency(code: "EUR"))
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text("\(cantidad) \(cantidad == 1 ? "gasto" : "gastos")")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            LinearGradient(
                colors: [.accentColor, .accentColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .accentColor.opacity(0.3), radius: 8, y: 4)
    }
}

// MARK: - Fila individual de un gasto
private struct FilaGasto: View {
    let gasto: Gasto

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: gasto.categoria.icono)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(Circle().fill(Color.accentColor.gradient))

            VStack(alignment: .leading, spacing: 3) {
                Text(gasto.nombre)
                    .font(.headline)
                Text(gasto.fecha.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(gasto.monto, format: .currency(code: "EUR"))
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Estado vacío
private struct VistaVacia: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Aún no hay gastos")
                .font(.headline)
            Text("Pulsa el botón + para agregar tu primer gasto.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    ListaGastosView()
        .modelContainer(for: Gasto.self, inMemory: true)
}
