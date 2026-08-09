if(NOT DEFINED INPUT OR INPUT STREQUAL "")
    message(FATAL_ERROR "GenerateMenuHelpHeader.cmake requires -DINPUT=<path>")
endif()

if(NOT DEFINED OUTPUT OR OUTPUT STREQUAL "")
    message(FATAL_ERROR "GenerateMenuHelpHeader.cmake requires -DOUTPUT=<path>")
endif()

if(NOT EXISTS "${INPUT}")
    message(FATAL_ERROR "Input file does not exist: ${INPUT}")
endif()

file(STRINGS "${INPUT}" menuhelp_lines)

set(menuhelp_strings)
foreach(line IN LISTS menuhelp_lines)
    string(REPLACE "\r" "" line "${line}")
    string(STRIP "${line}" line)

    if(line STREQUAL "")
        continue()
    endif()

    if(line MATCHES "^;")
        continue()
    endif()

    string(FIND "${line}" "\"" first_quote)
    if(first_quote EQUAL -1)
        continue()
    endif()

    string(FIND "${line}" "\"" last_quote REVERSE)
    if(NOT last_quote GREATER first_quote)
        continue()
    endif()

    math(EXPR string_start "${first_quote} + 1")
    math(EXPR string_length "${last_quote} - ${string_start}")
    string(SUBSTRING "${line}" ${string_start} ${string_length} menuhelp_text)

    string(REPLACE "\\" "\\\\" menuhelp_text "${menuhelp_text}")
    string(REPLACE "\"" "\\\"" menuhelp_text "${menuhelp_text}")

    list(APPEND menuhelp_strings "${menuhelp_text}")
endforeach()

set(content "/* This file was created by GenerateMenuHelpHeader.cmake.  Do Not Edit! */\n\n")
string(APPEND content "#ifdef OPUS_X64\n")
string(APPEND content "static char *rgszOpusX64MenuHelp[] = {\n")
foreach(menuhelp_text IN LISTS menuhelp_strings)
    string(APPEND content "    \"${menuhelp_text}\",\n")
endforeach()
string(APPEND content "};\n")
string(APPEND content "#define OPUS_X64_MENU_HELP_STRING(iidstr) (((unsigned int)(iidstr) < (unsigned int)(sizeof(rgszOpusX64MenuHelp) / sizeof(rgszOpusX64MenuHelp[0]))) ? rgszOpusX64MenuHelp[(unsigned int)(iidstr)] : \"\")\n")
string(APPEND content "#endif\n")

set(should_write TRUE)
if(EXISTS "${OUTPUT}")
    file(READ "${OUTPUT}" existing_content)
    if(existing_content STREQUAL content)
        set(should_write FALSE)
    endif()
endif()

if(should_write)
    file(WRITE "${OUTPUT}" "${content}")
endif()
