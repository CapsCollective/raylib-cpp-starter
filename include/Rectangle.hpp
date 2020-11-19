/*
*   LICENSE: zlib/libpng
*
*   raylib-cpp is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software:
*
*   Copyright (c) 2020 Rob Loach (@RobLoach)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*/

#ifndef RAYLIB_CPP_INCLUDE_RECTANGLE_HPP_
#define RAYLIB_CPP_INCLUDE_RECTANGLE_HPP_

#include "./raylib.hpp"
#include "./raylib-cpp-utils.hpp"
#include "./Vector2.hpp"

namespace raylib {
class Rectangle : public ::Rectangle {
 public:
    Rectangle(::Rectangle vec) {
        set(vec);
    }

    Rectangle(float X = 0, float Y = 0, float Width = 0, float Height = 0) {
        x = X;
        y = Y;
        width = Width;
        height = Height;
    }

    GETTERSETTER(float, X, x)
    GETTERSETTER(float, Y, y)
    GETTERSETTER(float, Width, width)
    GETTERSETTER(float, Height, height)

    Rectangle& operator=(const ::Rectangle& rect) {
        set(rect);
        return *this;
    }

    Rectangle& operator=(const Rectangle& rect) {
        set(rect);
        return *this;
    }

    inline Rectangle& Draw(::Color color) {
        ::DrawRectangle(static_cast<int>(x), static_cast<int>(y), static_cast<int>(width),
            static_cast<int>(height), color);
        return *this;
    }
    inline Rectangle& Draw(::Vector2 origin, float rotation, ::Color color) {
        ::DrawRectanglePro(*this, origin, rotation, color);
        return *this;
    }

    inline Rectangle& DrawGradientV(::Color color1, ::Color color2) {
        ::DrawRectangleGradientV(static_cast<int>(x), static_cast<int>(y), static_cast<int>(width),
            static_cast<int>(height), color1, color2);
        return *this;
    }

    inline Rectangle& DrawGradientH(::Color color1, ::Color color2) {
        ::DrawRectangleGradientH(static_cast<int>(x), static_cast<int>(y), static_cast<int>(width),
            static_cast<int>(height), color1, color2);
        return *this;
    }

    inline Rectangle& DrawGradient(::Color col1, ::Color col2, ::Color col3, ::Color col4) {
        ::DrawRectangleGradientEx(*this, col1, col2, col3, col4);
        return *this;
    }

    inline Rectangle& DrawLines(::Color color) {
        ::DrawRectangleLines(static_cast<int>(x), static_cast<int>(y), static_cast<int>(width),
            static_cast<int>(height), color);
        return *this;
    }
    inline Rectangle& DrawLinesEx(int lineThick, ::Color color) {
        ::DrawRectangleLinesEx(*this, lineThick, color);
        return *this;
    }

    inline Rectangle& DrawRounded(float roundness, int segments, ::Color color) {
        ::DrawRectangleRounded(*this, roundness, segments, color);
        return *this;
    }

    inline Rectangle& DrawRoundedLines(float roundness, int segments, int lineThick,
            ::Color color) {
        ::DrawRectangleRoundedLines(*this, roundness, segments, lineThick, color);
        return *this;
    }

    inline bool CheckCollision(::Rectangle rec2) const {
        return ::CheckCollisionRecs(*this, rec2);
    }

    inline Rectangle GetCollision(::Rectangle rec2) const {
        return ::GetCollisionRec(*this, rec2);
    }

    inline bool CheckCollision(::Vector2 point) const {
        return ::CheckCollisionPointRec(point, *this);
    }

 protected:
    inline void set(::Rectangle rect) {
        x = rect.x;
        y = rect.y;
        width = rect.width;
        height = rect.height;
    }
};
}  // namespace raylib

#endif  // RAYLIB_CPP_INCLUDE_RECTANGLE_HPP_
