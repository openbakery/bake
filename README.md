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
