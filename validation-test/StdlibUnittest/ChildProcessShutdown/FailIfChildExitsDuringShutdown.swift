// RUN: %target-run-simple-swift 2>&1 | %FileCheck %s
// REQUIRES: executable_test

import StdlibUnittest
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  import Darwin
#elseif os(Linux) || os(FreeBSD) || os(PS4) || os(Android) || os(Cygwin) || os(Haiku)
  import Glibc
#elseif os(Windows)
  import MSVCRT
#else
#error("Unsupported platform")
#endif

_setTestSuiteFailedCallback() { print("abort()") }

//
// Test that harness aborts when a test crashes if a child process exits with a
// non-zero code after all tests have finished running.
//

var TestSuiteChildExits = TestSuite("TestSuiteChildExits")

TestSuiteChildExits.test("passes") {
  atexit {
    _exit(1)
  }
}

// CHECK: [ RUN      ] TestSuiteChildExits.passes
// CHECK: [       OK ] TestSuiteChildExits.passes
// CHECK: TestSuiteChildExits: All tests passed
// CHECK: Abnormal child process termination: Exit(1).
// CHECK: The child process failed during shutdown, aborting.
// CHECK: abort()

runAllTests()

