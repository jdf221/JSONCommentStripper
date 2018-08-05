//
//  JSONCommentStripper.swift
//  JSONCommentStripper
//
//  Created by Jared Furlow (jdf2) on 8/4/18.
//  MIT License 2018 Jared Furlow
//

import Foundation

public class JSONCommentStripper {
    enum Context {
        case None
        case String
        case SingleLineComment
        case StartOfMultiLineComment
        case MultiLineComment
        case EndOfMultiLineComment
        
        var isComment: Bool {
            return (self == .SingleLineComment || self == .MultiLineComment)
        }
    }
    
    public func stripComments(_ fromString: String, replaceWithWhitespace: Bool = true) -> String {
        var newString = ""
        
        var currentContext: Context = .None
        var currentStringIndex: String.Index = fromString.startIndex
        let fromStringMaxIndex = fromString.count - 1 //Calling .count is actaully pretty slow when you end up calling it thousands of times. Having this predefined is a huge speed boost.
        
        for (index, currentCharacter) in fromString.enumerated() {
            if index != 0 {
                //Continue to the next index
                currentStringIndex = fromString.index(after: currentStringIndex)
            }
            
            //This skips the first astrick of a multiline comment
            if currentContext == .StartOfMultiLineComment {
                currentContext = .MultiLineComment
                continue
            }
            
            //This skips the final slash on the end of a multiline comment
            if currentContext == .EndOfMultiLineComment {
                currentContext = .None
                continue
            }
            
            let nextCharacter = index < fromStringMaxIndex ? fromString[fromString.index(after: currentStringIndex)] : Character(" ")
            let combinedChractersString = "\(currentCharacter)\(nextCharacter)"
            
            //If the current character is a quotation mark we need to find out if it is escaped or not
            if !currentContext.isComment && currentCharacter == "\"" {
                let previousPreviousCharacter = index - 2 >= 0 ? fromString[fromString.index(currentStringIndex, offsetBy: -2)] : Character(" ")
                let previousCharacter = index - 1 >= 0 ? fromString[fromString.index(before: currentStringIndex)] : Character(" ")
                
                //If it is *not* escaped we need to flip our current context to String or away from String. (Because an unescaped qoutation mark closes/opens a string)
                if !(previousCharacter == "\\" && previousPreviousCharacter != "\\") {
                    currentContext = currentContext == .String ? .None : .String
                }
            }
            
            //If we are currently inside a string we don't need to do anything
            if currentContext == .String {
                newString.append(currentCharacter)
                continue
            }

            //If we are starting a single line comment
            if !currentContext.isComment && combinedChractersString == "//" {
                currentContext = .SingleLineComment
            }
                //Single line comments end at the end of the line
            else if currentContext == .SingleLineComment && currentCharacter == "\r\n" {
                currentContext = .None
                newString.append("\r\n")
            }
                //Single line comments end at the end of the line
            else if currentContext == .SingleLineComment && currentCharacter == "\n" {
                currentContext = .None
                newString.append("\n")
            }
                //If we are starting a multiline comment
            else if !currentContext.isComment && combinedChractersString == "/*" {
                currentContext = .StartOfMultiLineComment
            }
                //If we are at the end of a multiline comment
            else if currentContext == .MultiLineComment && combinedChractersString == "*/" {
                currentContext = .EndOfMultiLineComment
            }
            else{
                if !currentContext.isComment {
                    //No comment characters were found so we should append the current character
                    newString.append(currentCharacter)
                }
            }
            
            //Replaces comment characters with whitespace
            if currentContext.isComment && replaceWithWhitespace {
                if currentCharacter != "\n" && currentCharacter != "\r\n" {
                    newString.append(" ")
                }
                else{
                    if currentCharacter == "\r\n" {
                        newString.append("\r\n")
                    }
                    
                    if currentCharacter == "\n" {
                        newString.append("\n")
                    }
                }
            }
            
            if (currentContext == .EndOfMultiLineComment || currentContext == .StartOfMultiLineComment) && replaceWithWhitespace {
                newString.append("  ")
            }
        }
        
        return newString
    }
}
