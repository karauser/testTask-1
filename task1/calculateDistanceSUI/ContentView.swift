//
//  ContentView.swift
//  calculateDistanceSUI
//
//  Created by Sergey on 21/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var matrix: [[Int]] = [
        [1, 0, 1],
        [0, 1, 0],
        [0, 0, 0]
        
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        CellView(value: matrix[row][col]) {
                            updateCellValue(row: row, col: col)
                        }
                    }
                }
            }
            
            Text("Distances:")
                .font(.headline)
                .padding(.top, 10)
            
            let distances = calculateDistances(matrix)
            
            ForEach(0..<distances.count, id: \.self) { row in
                HStack {
                    ForEach(0..<distances[row].count, id: \.self) { col in
                        Text("\(distances[row][col])")
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                    }
                }
            }
            Button("Сброс") {
                resetMatrix()
            }
            .padding(.top, 10)
        }
        .padding()
    }
    func calculateDistances(_ matrix: [[Int]]) -> [[Int]] {
        let rowCount  = matrix.count
        let colCount  = matrix[0].count
        var distances = [[Int]](repeating: [Int](repeating: Int.max, count: colCount), count: rowCount)
        
        // Очередь для обхода в ширину
        var queue = [(row: Int, col: Int)]()
        
        // Инициализация расстояний для ячеек со значением 1
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if matrix[i][j] == 1 {
                    distances[i][j] = 0
                    queue.append((i, j))
                }
            }
        }
        
        // Обход в ширину для вычисления расстояний
        while !queue.isEmpty {
            let (row, col) = queue.removeFirst()
            
            let neighbors = [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)]
            
            for neighbor in neighbors {
                let (nRow, nCol) = neighbor
                
                if nRow >= 0 && nRow < rowCount && nCol >= 0 && nCol < colCount && distances[nRow][nCol] == Int.max {
                    distances[nRow][nCol] = distances[row][col] + 1
                    queue.append((nRow, nCol))
                }
            }
        }
        
        return distances
    }
    
    // Немного интерактива
    
    func updateCellValue(row: Int, col: Int) {
        // Изменяем значение ячейки на +1
        guard matrix[row][col] != 1 else {
            return
        }
        matrix[row][col] += 1
        withAnimation {
            matrix[row][col] = 1
        }
    }
    func resetMatrix() {
        matrix = [[Int]](repeating: [Int](repeating: 0, count: matrix[0].count), count: matrix.count)
    }
    
    
}

struct CellView: View {
    let value: Int
    let onTap: () -> Void
    
    var body: some View {
        Text("\(value)")
            .frame(width: 20, height: 20)
            .background(value == 1 ? Color.blue : Color.gray)
            .onTapGesture {
                onTap()
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
