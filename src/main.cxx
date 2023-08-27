/*
 * Created Date: Tuesday July 18th 2023
 * Author: Lilith
 * -----
 * Last Modified: Sunday August 27th 2023 6:19:23 pm
 * Modified By: Lilith (definitelynotagirl115169@gmail.com)
 * -----
 * Copyright (c) 2023-2023 DefinitelyNotAGirl@github
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <options.h>
#include <common.h>
#include <compiler.h>
#include <stdio.h>
#include <execinfo.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <util.h>
#include <miscout.h>
#include <unordered_set>
#include <filesystem>
#include <mangling.h>

void cliOptions(int argc, char **argv);
void getLines(char* content);

void HANDLER_SIGSEGV(int sig) {
    void *array[10];
    size_t size;

    // get void*'s for all entries on the stack
    size = backtrace(array, 50);

    // print out all the frames to stderr
    fprintf(stderr, "Error: signal %d:\n", sig);
    backtrace_symbols_fd(array, size, STDERR_FILENO);
    exit(1);
}

int main(int argc, char** argv)
{
    signal(SIGSEGV, HANDLER_SIGSEGV);   // install our handler
    signal(SIGABRT, HANDLER_SIGSEGV);   // install our handler

    initWarnings();

    cliOptions(argc, argv);

    for(std::string i : sourceFiles)
    {
        FILE* f = fopen(fname.c_str(), "rb");
        if(f == NULL)
        {
            std::cerr << "ERROR: could not open input file " << fname << std::endl;
            exit(-1);
        }
        fseek(f, 0, SEEK_END);
        long fsize = ftell(f);
        fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

        char* content__ = malloc(fsize + 1);
        fread(content__, fsize, 1, f);
        fclose(f);
        content__[fsize] = 0x00;//terminate content__ string
        std::string __content = content__;
        memset(content__,0x00,fsize);

        getLines(content__);
    }

    return 0;
}