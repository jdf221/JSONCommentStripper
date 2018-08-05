//
//  JSONCommentStripperTests.swift
//  JSONCommentStripperTests
//
//  Created by Jared Furlow on 8/4/18.
//  Copyright © 2018 Jared Furlow. All rights reserved.
//

import XCTest
@testable import JSONCommentStripper

//Tests from https://github.com/sindresorhus/strip-json-comments/blob/master/test.js

class JSONCommentStripperTests: XCTestCase {
    let commentsStripper = JSONCommentStripper()
    
    func testReplaceCommentsWithWhitespace() {        
        XCTAssertEqual(commentsStripper.stripComments("//comment\n{\"a\":\"b\"}", replaceWithWhitespace: true), "         \n{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("//comment\n{\"a\":\"b\"}"), "         \n{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("/*//comment*/{\"a\":\"b\"}"), "             {\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"/*comment*/}"), "{\"a\":\"b\"           }")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\"/*\n\n\ncomment\r\n*/:\"b\"}"), "{\"a\"  \n\n\n       \r\n  :\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("/*!\n * comment\n */\n{\"a\":\"b\"}"), "   \n          \n   \n{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{/*comment*/\"a\":\"b\"}"), "{           \"a\":\"b\"}")
    }
    
    func testRemoveComments() {
        XCTAssertEqual(commentsStripper.stripComments("//comment\n{\"a\":\"b\"}", replaceWithWhitespace: false), "\n{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("/*//comment*/{\"a\":\"b\"}", replaceWithWhitespace: false), "{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"//comment\n}", replaceWithWhitespace: false), "{\"a\":\"b\"\n}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"/*comment*/}", replaceWithWhitespace: false), "{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\"/*\n\n\ncomment\r\n*/:\"b\"}", replaceWithWhitespace: false), "{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("/*!\n * comment\n */\n{\"a\":\"b\"}", replaceWithWhitespace: false), "\n{\"a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{/*comment*/\"a\":\"b\"}", replaceWithWhitespace: false), "{\"a\":\"b\"}")
    }
    
    func testStringsWithComments() {
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b//c\"}"), "{\"a\":\"b//c\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b/*c*/\"}"), "{\"a\":\"b/*c*/\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"/*a\":\"b\"}"), "{\"/*a\":\"b\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"\\\"/*a\":\"b\"}"), "{\"\\\"/*a\":\"b\"}")
    }
    
    func testEscaping() {
        XCTAssertEqual(commentsStripper.stripComments("{\"\\\\\":\"https://foobar.com\"}"), "{\"\\\\\":\"https://foobar.com\"}")
        XCTAssertEqual(commentsStripper.stripComments("{\"foo\\\"\":\"https://foobar.com\"}"), "{\"foo\\\"\":\"https://foobar.com\"}")
    }
    
    func testLineEndingsNoComments() {
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"\n}"), "{\"a\":\"b\"\n}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"\r\n}"), "{\"a\":\"b\"\r\n}")
    }
    
    func testLineEndingsSingleLineComment() {
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"//c\n}"), "{\"a\":\"b\"   \n}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"//c\r\n}"), "{\"a\":\"b\"   \r\n}")
    }
    
    func testLineEndingsSingleLineBlockComment() {
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"/*c*/\n}"), "{\"a\":\"b\"     \n}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\"/*c*/\r\n}"), "{\"a\":\"b\"     \r\n}")
    }
    
    func testLineEndingsMultiLineBlockComment() {
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\",/*c\nc2*/\"x\":\"y\"\n}"), "{\"a\":\"b\",   \n    \"x\":\"y\"\n}")
        XCTAssertEqual(commentsStripper.stripComments("{\"a\":\"b\",/*c\r\nc2*/\"x\":\"y\"\r\n}"), "{\"a\":\"b\",   \r\n    \"x\":\"y\"\r\n}")
    }
    
    func testLineEndingsEOF() {
        XCTAssertEqual(commentsStripper.stripComments("{\r\n\t\"a\":\"b\"\r\n} //EOF"), "{\r\n\t\"a\":\"b\"\r\n}      ")
        XCTAssertEqual(commentsStripper.stripComments("{\r\n\t\"a\":\"b\"\r\n} //EOF", replaceWithWhitespace: false), "{\r\n\t\"a\":\"b\"\r\n} ")
    }
}
