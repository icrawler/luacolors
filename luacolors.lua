local luacolors = {
    _VERSION     = 'luacolors v0.1.0',
    _DESCRIPTION = 'Color utility library for Lua',
    _URL         = 'https://github.com/icrawler/luacolors',
    _LICENSE     = [[
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
  ]]
}

-- private methods
local function f1(t)
    return t > 0.0088564516790356 and t^0.3333333333333333 or
               0.3333333333333333*23.3611111111111111*t + 0.1379310344827586
end

local function f2(t)
    return t > 0.2068965517241379 and t*t*t or
               3*0.0428061831153388*(t-0.1379310344827586)
end

-- public functions

-- Convert gamma-corrected RGB to CIEXYZ
local function sRGBtoXYZ(r, g, b)
	local f = 1/255
	r = r*f
	g = g*f
	b = b*f
	r = r <= 0.04045 and r/12.92 or ((r+0.055)/(1.055))^2.4
	g = g <= 0.04045 and g/12.92 or ((g+0.055)/(1.055))^2.4
	b = b <= 0.04045 and b/12.92 or ((b+0.055)/(1.055))^2.4
	local X = 0.4124*r + 0.3576*g + 0.1805*b
	local Y = 0.2126*r + 0.7152*g + 0.0722*b
	local Z = 0.0193*r + 0.1192*g + 0.9502*b
	return X*100, Y*100, Z*100
end


-- Convert CIEXYZ to gamma-corrected RGB
local function XYZtosRGB(X, Y, Z)
	X, Y, Z = X/100, Y/100, Z/100
	local r =  3.2406*X - 1.5372*Y - 0.4986*Z
	local g = -0.9689*X + 1.8758*Y + 0.0415*Z
	local b =  0.0557*X - 0.2040*Y + 1.0570*Z
	local k = 1/2.4
	local floor = math.floor
	r = floor((r <= 0.0031308 and 12.92*r or 1.055*r^k-0.055)*255+0.5)
	g = floor((g <= 0.0031308 and 12.92*g or 1.055*g^k-0.055)*255+0.5)
	b = floor((b <= 0.0031308 and 12.92*b or 1.055*b^k-0.055)*255+0.5)
	return r, g, b
end

-- convert CIEXYZ to CIELAB
local function XYZtoLab(X, Y, Z)
	local yon = f1(Y/100)
	local L = 116*(yon) - 16
	local a = 500*(f1(X/95.047) - yon)
	local b = 200*(yon - f1(Z/108.883))
	return L, a, b
end


-- convert gamma-corrected RGB to CIELAB
local function sRGBtoLab(r, g, b)
	return XYZtoLab(sRGBtoXYZ(r, g, b))
end

-- convert CIELAB to CIEXYZ
local function LabtoXYZ(L, a, b)
	local k = 0.0086206896551724*(L+16)
	local Y = 100*f2(k)
	local X = 95.047*f2(k+0.002*a)
	local Z = 108.883*f2(k-0.005*b)
	return X, Y, Z
end


-- convert CIELAB to gamma-corrected RGB
local function LabtosRGB(L, a, b)
	return XYZtosRGB(LabtoXYZ(L, a, b))
end


-- convert HSL to RGB
-- (taken from https://www.love2d.org/wiki/HSL_color with a few modifications)
local function HSLtoRGB(h, s, l)
    if s<=0 then return l,l,l   end
    h, s, l = h/360*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end


-- convert RGB to HSL
local function RGBtoHSL(r, g, b)
    r, g, b    = r/255, g/255, b/255
	local M, m =  math.max(r, g, b),
				  math.min(r, g, b)
	local c, H = M - m, 0
	if     M == r then H = (g-b)/c%6
	elseif M == g then H = (b-r)/c+2
	elseif M == b then H = (r-g)/c+4
	end	local L = 0.5*M+0.5*m
	local S = c == 0 and 0 or c/(1-math.abs(2*L-1))
	return ((1/6)*H)*360%360, S*255, L*255
end

-- public interface
luacolors.sRGBtoXYZ = sRGBtoXYZ
luacolors.XYZtosRGB = XYZtosRGB
luacolors.XYZtoLab = XYZtoLab
luacolors.LabtoXYZ = LabtoXYZ
luacolors.LabtosRGB = LabtosRGB
luacolors.sRGBtoLab = sRGBtoLab
luacolors.HSLtoRGB = HSLtoRGB
luacolors.RGBtoHSL = RGBtoHSL


-- colors
-- taken from http://en.wikipedia.org/wiki/CSS_colors
luacolors.white = {255, 255, 255}
luacolors.silver = {191, 191, 191}
luacolors.gray = {127, 127, 127}
luacolors.black = {0, 0, 0}
luacolors.red = {255, 0, 0}
luacolors.maroon = {127, 0, 0}
luacolors.yellow = {255, 255, 0}
luacolors.olive = {127, 127, 0}
luacolors.lime = {0, 255, 0}
luacolors.green = {0, 127, 0}
luacolors.aqua = {0, 255, 255}
luacolors.teal = {0, 127, 127}
luacolors.blue = {0, 0, 255}
luacolors.navy = {0, 0, 127}
luacolors.fuchsia = {255, 0, 255}
luacolors.purple = {127, 0, 127}

return luacolors