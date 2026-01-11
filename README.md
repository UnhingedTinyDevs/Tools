# Tools
This repositoy if a collection of a bunch of tools that can be grabbed and useed independently of eachother.

## Table Of Contents
- [About](#about)
- [Tools List](#tool-list)
- [Contributing](#contributing)

## About
Simple Drag and drop folder for different games tools for Godot development. Almost all Tools will be made for [Godot4.5](https://godotengine.org/download/archive/4.5-stable/) 
and above. In general tools should have as little coupling between them as possiable. Tools will be broken up in to 4 main categories 
- Autoloads: General Singleton scripts that are used throughout projects i.e. SceneManager
- Nodes: Typically tools that you will add to the game tree.
- Resources: These need to typically follow some sort of interface.

## Contributing
Feel free to open request for new tools or even add them yourself.
- follow the godot code [style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- Test all code make sure it works.
- Make sure all warnings are fixed.
- When adding a new tool make sure it is contained inside of its own file.
- **DO NOT** push any test scenes or anything unrelated to your tooling,
- All tools should attempt to be independent of eachother,
- If a tool Inherits from another place it as a sub-directory of its parent.
- If a tool depends on another assert this in your tool to alert the developer if they do not have that tool.

## Tool List
An overview of each of the tool.

### PointSampler
Uses the Poisson Disk Distribution to sample points in a given area. Allows for live editing in the editor.
