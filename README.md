# Swift JSON Comment Stripper

A simple Swift library that removes comments from JSON.

## Why?

I needed this for a project I'm working on that's using JSON files I have no control over.
Comments aren't part of the JSON spec, but some parsers still support them.

## Usage

Pretty self explanatory

    let jsonString = "{\"key\":/*this comment gets removed*/ \"value\"}"
    
    print(JSONCommentStripper().stripComments(jsonString, replaceWithWhitespace: false))
    //Outputs: {"key": "value"}

The `stripComments()` function can take an optional 2nd parameter `replaceWithWhitespace: Bool`. It defaults to `true`. This allows JSON error positions to remain as close as possible to the original source.

This removes both multi line and single line comments. (`/*comment*/` and `//comment`)

## Installation

#### Just copy and paste it

There's only one file/class no need for an extra dependency.

[JSONCommentStripper/JSONCommentStripper.swift](https://github.com/jdf221/JSONCommentStripper/blob/master/JSONCommentStripper/JSONCommentStripper.swift)

Feel free to just copy that file into your project and use it.

#### Carthage

Just add this to your Cartfile:

    github "jdf221/JSONCommentStripper" ~> 1.0

And of course import it

    import JSONCommentStripper

___

#### The code for this library is based on a Javascript implementation of the same idea

Check that out here: https://github.com/sindresorhus/strip-json-comments
