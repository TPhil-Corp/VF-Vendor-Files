# Vendor Files

A set of helper functions, tools, ninepatches, etc. for plugin making with TheoTown.

# How is this works?

Vendor file itself has inbuilt initializer draft to load **Modules** and **Drafts** such as: Nine patches amd Icons, and compiled them as one module named **Vendor**.
Nine patches, Icons and other frames has its owned draft and was written as **string** they are loaded with lua using the function called `append()`.
i used this way to avoid the duplication of the draft and also avoid frame duplication if you're worried about your plugin texture space.
Therefore, frames was loaded once whenever how many plugins you have that used vendor files. :)

# How to Use?

Vendor files is just like the inbuilt TheoTown APIs, you don't have to use `require` method for it to fetch the module or something inside,
all you have to do is start with the `Vendor.[+version].[+moduleName].[+otherKeys]` directly in your script.
for example:
```Lua
-- fetching icon library
local ICONS = Vendor.v3_1_0.Icon
```

# Using different version

You can use different version of the files by including the version name as its key after the `Vendor` tag, But since "dot" notation on Lua refers to the keys inside the table, You may use the underscore(_) to replace the dot in the version name,
this was intended to make it more handy than using bracket notation. Also we need to include 'v' at the beginning of the key so our code may looks like:

```Lua
-- using version 3.1.0, latest version since 12/11/22
local myVendor = Vendor.v3_1_0
```

# Available modules

• Ninepatch
I'd recommend to fetch ninepatches right after 'init()' bbecause Vendor used that event
for appending frames into the module itself.

**Usage**
```Lua
-- fetch ninepatches

local Ninepatch

function script:lateInit()
    Ninepatch = Vendor.v3_1_0.Ninepatch
end

-- use ninepatch frame
...
Drawing.drawNinePatch(Ninepatch.GROUP_BOX, x, y, w, h)
...
```

** To be Continued... **
