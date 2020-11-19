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

#ifndef RAYLIB_CPP_INCLUDE_MATERIAL_HPP_
#define RAYLIB_CPP_INCLUDE_MATERIAL_HPP_

#include "./raylib.hpp"
#include "./raylib-cpp-utils.hpp"

namespace raylib {
class Material : public ::Material {
 public:
    Material(::Material material) {
        set(material);
    }

    Material() {
        set(LoadMaterialDefault());
    }

    ~Material() {
        Unload();
    }

    GETTERSETTER(::Shader, Shader, shader)

    Material& operator=(const ::Material& material) {
        set(material);
        return *this;
    }

    Material& operator=(const Material& material) {
        set(material);
        return *this;
    }

    inline void Unload() {
        ::UnloadMaterial(*this);
    }

    inline Material& SetTexture(int mapType, ::Texture2D texture) {
        ::SetMaterialTexture(this, mapType, texture);
        return *this;
    }

 protected:
    inline void set(::Material material) {
        shader = material.shader;
        maps = material.maps;
        params = material.params;
    }
};
}  // namespace raylib

#endif  // RAYLIB_CPP_INCLUDE_MATERIAL_HPP_
