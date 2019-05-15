//
//  DataReceivingSideEffectTests.swift
//  Kingfisher
//
//  Created by jp20028 on 2019/05/15.
//
//  Copyright (c) 2019 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
@testable import Kingfisher

class DataReceivingSideEffectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataReceivingSideEffectBlockCanBeCalled() {
        let exp = expectation(description: #function)
        let url = testURLs[0]
        stub(url, data: testImageData)

        let receiver = DataReceivingStub()

        let options: KingfisherOptionsInfo = [.onDataReceived([receiver])]
        KingfisherManager.shared.retrieveImage(with: url, options: options) {
            result in
            XCTAssertTrue(receiver.called)
            exp.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testDataReceivingSideEffectBlockCanBeCalledButNotApply() {
        let exp = expectation(description: #function)
        let url = testURLs[0]
        stub(url, data: testImageData)

        let receiver = DataReceivingNotAppyStub()

        let options: KingfisherOptionsInfo = [.onDataReceived([receiver])]
        KingfisherManager.shared.retrieveImage(with: url, options: options) {
            result in
            XCTAssertTrue(receiver.called)
            XCTAssertFalse(receiver.appied)
            exp.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}

class DataReceivingStub: DataReceivingSideEffect {
    var called: Bool = false
    var onShouldApply: () -> Bool = { return true }
    func onDataReceived(_ session: URLSession, task: SessionDataTask, data: Data) {
        called = true
    }
}

class DataReceivingNotAppyStub: DataReceivingSideEffect {

    var called: Bool = false
    var appied: Bool = false

    var onShouldApply: () -> Bool = { return false }

    func onDataReceived(_ session: URLSession, task: SessionDataTask, data: Data) {
        called = true
        if onShouldApply() {
            appied = true
        }
    }
}
