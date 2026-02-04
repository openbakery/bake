# Bake build

The idea behind the bake build tool is to have a simple build tool for Swift and Xcode projects.
The configuration should be a Swift source file, that is compiled before the build is executed.

This project is experimental. So use at your own risk!


# The Bake.swift file

The `Bake.swift` file is the main build configuration. This file is a normal swift bulid file
except the @import and @plugin statement. This statement is converted to a normal import. 
The difference is that a plugin can contain commands that is also added to the build.

# Install

```
curl -O https://raw.githubusercontent.com/openbakery/bake/refs/heads/main/bake
chmod +x bake
```

# Motivation

I have created this project because I want to have a nice build tool for my needs. Until now I have
used the gradle xcodebuild plugin I have started over a decade ago. Back then it looked like a 
good idea using gradle as basis. Nowadays my opinion has changed and so this project was born.

At the beginning of this file I stated that this project is experimental but I have to say that
I already use it in production.

# Contributing

Help is always welcome. I But one thing is very important must be clear when sending pull requests:
No unit tests means no merge!
