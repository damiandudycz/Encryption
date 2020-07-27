import XCTest

import EncryptionTests

var tests = [XCTestCaseEntry]()
tests += EncryptionTests.allTests()
XCTMain(tests)
