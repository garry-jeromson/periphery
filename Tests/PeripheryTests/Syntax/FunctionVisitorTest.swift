import Foundation
import XCTest
import PathKit
import TestShared
@testable import PeripheryKit

class FunctionVisitorTest: XCTestCase {
    private var results: [PeripheryKit.SourceLocation: FunctionVisitor.Result]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let multiplexingVisitor = try MultiplexingSyntaxVisitor(file: fixturePath)
        let visitor = multiplexingVisitor.add(FunctionVisitor.self)
        multiplexingVisitor.visit()
        results = visitor.resultsByLocation
    }

    func testFunctionWithSimpleReturnType() throws {
        let result = results[fixtureLocation(line: 1)]
        XCTAssertEqual(result?.returnTypeLocations, [fixtureLocation(line: 1, column: 40)])
        XCTAssertTrue(result?.parameterTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    func testFunctionWithTupleReturnType() throws {
        let result = results[fixtureLocation(line: 5)]
        XCTAssertEqual(result?.returnTypeLocations, [
            fixtureLocation(line: 5, column: 40),
            fixtureLocation(line: 5, column: 48),
        ])
        XCTAssertTrue(result?.parameterTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    func testFunctionWithPrefixedReturnType() throws {
        let result = results[fixtureLocation(line: 9)]
        XCTAssertEqual(result?.returnTypeLocations, [
            fixtureLocation(line: 9, column: 42),
            fixtureLocation(line: 9, column: 48),
        ])
        XCTAssertTrue(result?.parameterTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    func testFunctionWithClosureReturnType() throws {
        let result = results[fixtureLocation(line: 13)]
        XCTAssertEqual(result?.returnTypeLocations, [
            fixtureLocation(line: 13, column: 42),
            fixtureLocation(line: 13, column: 50),
        ])
        XCTAssertTrue(result?.parameterTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    func testFunctionWithArguments() throws {
        let result = results[fixtureLocation(line: 18)]
        XCTAssertEqual(result?.parameterTypeLocations, [
            fixtureLocation(line: 18, column: 31),
            fixtureLocation(line: 18, column: 42)
        ])
        XCTAssertTrue(result?.returnTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    func testFunctionWithGenericArguments() throws {
        let result = results[fixtureLocation(line: 20)]
        XCTAssertEqual(result?.parameterTypeLocations, [
            fixtureLocation(line: 20, column: 70)
        ])
        XCTAssertEqual(result?.genericParameterLocations, [
            fixtureLocation(line: 20, column: 37),
            fixtureLocation(line: 20, column: 54)
        ])
        XCTAssertEqual(result?.genericConformanceRequirementLocations, [
            fixtureLocation(line: 20, column: 87),
        ])
        XCTAssertTrue(result?.returnTypeLocations.isEmpty ?? false)
    }

    func testFunctionWithSomeReturnType() throws {
        let result = results[fixtureLocation(line: 23)]
        XCTAssertEqual(result?.returnTypeLocations, [
            fixtureLocation(line: 23, column: 43)
        ])
        XCTAssertTrue(result?.parameterTypeLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericParameterLocations.isEmpty ?? false)
        XCTAssertTrue(result?.genericConformanceRequirementLocations.isEmpty ?? false)
    }

    // MARK: - Private

    private var fixturePath: SourceFile {
        let path = ProjectRootPath + "Tests/Fixtures/FunctionVisitorFixtures/FunctionVisitorFixture.swift"
        return SourceFile(path: path, modules: ["FunctionVisitorFixtures"])
    }

    private func fixtureLocation(line: Int, column: Int = 6) -> SourceLocation {
        SourceLocation(file: fixturePath, line: Int64(line), column: Int64(column))
    }
}