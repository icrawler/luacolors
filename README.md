# luacolors - a color utility library

__luacolors__ is a collection of functions for common color conversions.

Installation
============

The luacolors.lua file should be dropped into an existing project and required by it.

```lua
luacolors = require "luacolors"
````

Function Reference
==================

###luacolors.sRGBtoXYZ(r, g, b)

Returns the CIEXYZ coordinates `X, Y, Z` for a given sRGB.

###luacolors.XYZtosRGB(X, Y, Z)

Returns the gamma-corrected RGB values `r, g, b` for a given CIEXYZ.

###luacolors.XYZtoLab(X, Y, Z)

Returns the CIELAB values `L, a, b` for a given CIEXYZ.

###luacolors.LabtoXYZ(L, a, b)

Returns the CIEXYZ values `X, Y, Z` for a given CIELAB.

###luacolors.LabtosRGB(L, a, b)

Returns the gamma-corrected RGB values `r, g, b` for a given CIELAB.

###luacolors.sRGBtoLab(r, g, b)

Returns the CIELAB values `L, a, b` for a given sRGB.

###luacolors.HSLtoRGB(h, s, l)

Returns the RGB values for a given HSL.

###luacolors.RGBtoHSL(r, g, b)

Returns the HSL values for a given RGB.

Color reference
===============

Any color included in http://en.wikipedia.org/wiki/CSS_colors .

Example:
```lua
luacolors.maroon -- returns {127, 0, 0}
````

License
=======

MIT LICENSE

Copyright (c) 2014 Phoenix Enero

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.