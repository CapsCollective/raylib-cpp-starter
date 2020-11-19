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

#ifndef RAYLIB_CPP_INCLUDE_SOUND_HPP_
#define RAYLIB_CPP_INCLUDE_SOUND_HPP_

#include <string>

#include "./raylib.hpp"
#include "./raylib-cpp-utils.hpp"

namespace raylib {
class Sound : public ::Sound {
 public:
    Sound(::Sound vec) {
        set(vec);
    }

    Sound(const std::string& fileName) {
        set(LoadSound(fileName.c_str()));
    }

    Sound(::Wave wave) {
        set(LoadSoundFromWave(wave));
    }

    ~Sound() {
        Unload();
    }

    GETTERSETTER(unsigned int, SampleCount, sampleCount)
    GETTERSETTER(::AudioStream, Stream, stream)

    Sound& operator=(const ::Sound& sound) {
        set(sound);
        return *this;
    }

    Sound& operator=(const Sound& sound) {
        set(sound);
        return *this;
    }

    inline Sound& Update(const void *data, int sampleCount) {
        ::UpdateSound(*this, data, sampleCount);
        return *this;
    }

    inline void Unload() {
        ::UnloadSound(*this);
    }

    inline Sound& Play() {
        ::PlaySound(*this);
        return *this;
    }

    inline Sound& Stop() {
        ::StopSound(*this);
        return *this;
    }

    inline Sound& Pause() {
        ::PauseSound(*this);
        return *this;
    }
    inline Sound& Resume() {
        ::ResumeSound(*this);
        return *this;
    }

    inline Sound& PlayMulti() {
        ::PlaySoundMulti(*this);
        return *this;
    }

    inline Sound& StopMulti() {
        ::StopSoundMulti();
        return *this;
    }

    inline bool IsPlaying() const {
        return ::IsSoundPlaying(*this);
    }

    inline Sound& SetVolume(float volume) {
        ::SetSoundVolume(*this, volume);
        return *this;
    }

    inline Sound& SetPitch(float pitch) {
        ::SetSoundPitch(*this, pitch);
        return *this;
    }

 protected:
    inline void set(::Sound sound) {
        sampleCount = sound.sampleCount;
        stream = sound.stream;
    }
};
}  // namespace raylib

#endif  // RAYLIB_CPP_INCLUDE_SOUND_HPP_
