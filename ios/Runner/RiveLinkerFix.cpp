/**
 * RiveLinkerFix.cpp
 * 
 * This file provides empty stubs for symbols that are referenced but not defined 
 * in the Rive native static libraries for the iOS Simulator.
 */

#include <stdint.h>
#include <stdbool.h>

// Dummy types for C++ signatures
struct Triple {};
struct TripleDistances {};
struct contour_point_vector_t {};
template<typename T, bool B> struct rive_hb_vector_t {};

// C++ symbols (Harfbuzz subsetting) - These were truly missing
void rebase_tent(Triple, Triple, TripleDistances) {}
void renormalizeValue(double, const Triple&, const TripleDistances&, bool) {}
void iup_delta_optimize(const contour_point_vector_t&, 
                        const rive_hb_vector_t<int, false>&, 
                        const rive_hb_vector_t<int, false>&, 
                        rive_hb_vector_t<bool, false>&, 
                        double) {}

// C symbols (Harfbuzz Rive Wrappers) - These were truly missing
extern "C" {
    void* rive_hb_face_builder_create() { return nullptr; }
    bool rive_hb_face_builder_add_table(void*, uint32_t, void*) { return false; }
}

// ReadWriteRing stubs - Keeping these unless they cause duplicates
struct ReadWriteRing {
    ReadWriteRing() {}
    void* currentRead() { return nullptr; }
    void* nextRead() { return nullptr; }
};
