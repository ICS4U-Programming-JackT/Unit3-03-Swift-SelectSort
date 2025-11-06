import Foundation

// Custom error for invalid integer input
enum InputError: Error {
    case invalidInteger
    case fileNotFound
}

// Converts a string to an integer or throws an error
func convertToInt(_ value: String) throws -> Int {
    guard let intValue = Int(value.trimmingCharacters(in: .whitespacesAndNewlines)) else {
        throw InputError.invalidInteger
    }
    return intValue
}

// Converts input file into 1D array of integers
func readFile(_ inputName: String) -> [Int] {
    var numbers: [Int] = []
    // Open file
    do {
        // Open file, get content
        let fileURL = URL(fileURLWithPath: inputName)
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        // Split file into lines
        let lines = content.split(separator: "\n")
        
        // Add line to array as int, or raise type error
        for line in lines {
            do {
                // Add number to array
                let num = try convertToInt(String(line))
                numbers.append(num)
            } catch {
                // Invalid integer found; clear and break
                numbers.removeAll()
                break
            }
        }
    } catch {
        // Tell user file couldn't be opened
        print("\nError: The file \(inputName) was not found. Please ensure it exists in the same directory.")
    }

    // Return file content as array
    return numbers
}

// Writes sorted array to output file
func writeFile(_ outputName: String, _ sorted: [Int]) {
    // Instantiate sorted text
    let output = sorted.map { String($0) }.joined(separator: "\n")
    
    do {
        // Write content to file
        let fileURL = URL(fileURLWithPath: outputName)
        try output.write(to: fileURL, atomically: true, encoding: .utf8)
        print("Sorted numbers written to \(outputName)")
    } catch {
        // Print file write error
        print("Error writing to file: \(outputName)")
    }
}

// Performs insertion sort on array
func sort(_ array: [Int]) -> [Int] {
    var sorted : [Int] = array
    for pass in 0..<array.count - 1 {
        // Set min index
        var minIndex : Int = pass
        // Loop through each proceeding number
        for index in pass..<array.count {
            // Check if min index is bigger than current num
            if (sorted[index] < sorted[minIndex]) {
                // Update minIndex
                minIndex = index
            }
        }
        // Swap min and pass elements
        let temp : Int = sorted[minIndex]
        sorted[minIndex] = sorted[pass]
        sorted[pass] = temp
    }
    return sorted
}

// Define inpuit/output files
let inputFile = "input.txt"
let outputFile = "output.txt"

// Get array, sort and then write to file
let data = readFile(inputFile)
let sorted = sort(data)
writeFile(outputFile, sorted)
