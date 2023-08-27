#
# Created Date: Sunday August 27th 2023
# Author: Lilith
# -----
# Last Modified: Sunday August 27th 2023 6:07:46 pm
# Modified By: Lilith (definitelynotagirl115169@gmail.com)
# -----
# Copyright (c) 2023-2023 DefinitelyNotAGirl@github
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#

TARGET=x86_64

SOURCE_asm_asm=$(wildcard src/*.asm)
OBJECTS_asm_asm=$(patsubst src/%.asm,build/%.o,$(SOURCE_asm_asm))
DEPFILES_asm_asm=$(patsubst src/%.asm,build/%.d,$(SOURCE_asm_asm))
SOURCE_asm_s=$(wildcard src/*.s)
OBJECTS_asm_s=$(patsubst src/%.s,build/%.o,$(SOURCE_asm_s))
DEPFILES_asm_s=$(patsubst src/%.s,build/%.d,$(SOURCE_asm_s))
SOURCE_cpp_cpp=$(wildcard src/*.cpp)
OBJECTS_cpp_cpp=$(patsubst src/%.cpp,build/%.o,$(SOURCE_cpp_cpp))
DEPFILES_cpp_cpp=$(patsubst src/%.cpp,build/%.d,$(SOURCE_cpp_cpp))
SOURCE_cpp_cxx=$(wildcard src/*.cxx)
OBJECTS_cpp_cxx=$(patsubst src/%.cxx,build/%.o,$(SOURCE_cpp_cxx))
DEPFILES_cpp_cxx=$(patsubst src/%.cxx,build/%.d,$(SOURCE_cpp_cxx))
SOURCE_c_c=$(wildcard src/*.c)
OBJECTS_c_c=$(patsubst src/%.c,build/%.o,$(SOURCE_c_c))
DEPFILES_c_c=$(patsubst src/%.c,build/%.d,$(SOURCE_c_c))

CXXARGS=
CCARGS=
ASARGS=

all: compiler

build/%.o: src/%.asm
	@$(AS) $(ASARGS) -M -MD -c -o $@ $<
	$(info  	$(AS)	$<)
build/%.o: src/%.s
	@$(AS) $(ASARGS) -M -MD -c -o $@ $<
	$(info  	$(AS)	$<)
build/%.o: src/%.cpp
	@$(CXX) -O0 $(CXXARGS) -std=c++20 -g -Wno-write-strings -rdynamic -pedantic -Wunreachable-code -Wno-literal-suffix -Wno-pointer-arith -MP -MD -fpermissive -Iinc/ -c -o $@ $<
	$(info 	$(CXX)	$<)
build/%.o: src/%.cxx
	@$(CXX) -O0 $(CXXARGS) -std=c++20 -g -Wno-write-strings -rdynamic -pedantic -Wno-multichar -Wunreachable-code -Wno-literal-suffix -Wno-pointer-arith -MP -MD -fpermissive -Iinc/ -c -o $@ $<
	$(info 	$(CXX)	$<)
build/%.o: src/%.c
	@$(CC) $(CCARGS) -Wunreachable-code -Iinc/ -c -o $@ $<
	$(info  	$(CC)	$<)
clean:
	@-rm -r build/*.o
	$(info  	DELETE	build/*.o)
	@-rm -r build/*.d
	$(info  	DELETE	build/*.d)

compiler:  $(OBJECTS_asm_asm) $(OBJECTS_asm_s) $(OBJECTS_cpp_cxx) $(OBJECTS_cpp_cpp) $(OBJECTS_c_c)
	@$(LD) -g -rdynamic $(OBJECTS_asm_asm) $(OBJECTS_asm_s) $(OBJECTS_cpp_cxx) $(OBJECTS_cpp_cpp) $(OBJECTS_c_c) -Llib/ -lc -lstdc++ -lcargparse -o cp2
	$(info  	$(LD)	$@)

-include $(DEPFILES_asm_asm)
-include $(DEPFILES_asm_s)
-include $(DEPFILES_cpp_cpp)
-include $(DEPFILES_cpp_cxx)
-include $(DEPFILES_c_c)

