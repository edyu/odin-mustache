package mustach

foreign import "mustach"

import _c "core:c"

_mustach_h_included_ :: 1;
MUSTACH_VERSION :: 102;
MUSTACH_VERSION_MAJOR :: 102;
MUSTACH_VERSION_MINOR :: 102;
MUSTACH_MAX_DEPTH :: 256;
MUSTACH_MAX_LENGTH :: 4096;
MUSTACH_MAX_DELIM_LENGTH :: 8;
Mustach_With_NoExtensions :: 0;
Mustach_With_Colon :: 1;
Mustach_With_EmptyTag :: 2;
Mustach_With_AllExtensions :: 3;
MUSTACH_OK :: 0;
MUSTACH_ERROR_SYSTEM :: -1;
MUSTACH_ERROR_UNEXPECTED_END :: -2;
MUSTACH_ERROR_EMPTY_TAG :: -3;
MUSTACH_ERROR_TAG_TOO_LONG :: -4;
MUSTACH_ERROR_BAD_SEPARATORS :: -5;
MUSTACH_ERROR_TOO_DEEP :: -6;
MUSTACH_ERROR_CLOSING :: -7;
MUSTACH_ERROR_BAD_UNESCAPE_TAG :: -8;
MUSTACH_ERROR_INVALID_ITF :: -9;
MUSTACH_ERROR_ITEM_NOT_FOUND :: -10;
MUSTACH_ERROR_PARTIAL_NOT_FOUND :: -11;
MUSTACH_ERROR_UNDEFINED_TAG :: -12;
MUSTACH_ERROR_USER_BASE :: -100;


mustach_sbuf :: struct {
    value : cstring,
    unamed0 : AnonymousUnion0,
    closure : rawptr,
    length : _c.size_t,
};

mustach_itf :: struct {
    start : #type proc(closure : rawptr) -> _c.int,
    put : #type proc(closure : rawptr, name : cstring, escape : _c.int, file : ^FILE) -> _c.int,
    enter : #type proc(closure : rawptr, name : cstring) -> _c.int,
    next : #type proc(closure : rawptr) -> _c.int,
    leave : #type proc(closure : rawptr) -> _c.int,
    partial : #type proc(closure : rawptr, name : cstring, sbuf : ^mustach_sbuf) -> _c.int,
    emit : #type proc(closure : rawptr, buffer : cstring, size : _c.size_t, escape : _c.int, file : ^FILE) -> _c.int,
    get : #type proc(closure : rawptr, name : cstring, sbuf : ^mustach_sbuf) -> _c.int,
    stop : #type proc(closure : rawptr, status : _c.int),
};

AnonymousUnion0 :: struct #raw_union {
    freecb : #type proc(unamed0 : rawptr),
    releasecb : #type proc(value : cstring, closure : rawptr),
};

@(default_calling_convention="c")
foreign mustach {

    @(link_name="mustach_file")
    mustach_file :: proc(template : cstring, length : _c.size_t, itf : ^mustach_itf, closure : rawptr, flags : _c.int, file : ^FILE) -> _c.int ---;

    @(link_name="mustach_fd")
    mustach_fd :: proc(template : cstring, length : _c.size_t, itf : ^mustach_itf, closure : rawptr, flags : _c.int, fd : _c.int) -> _c.int ---;

    @(link_name="mustach_mem")
    mustach_mem :: proc(template : cstring, length : _c.size_t, itf : ^mustach_itf, closure : rawptr, flags : _c.int, result : ^cstring, size : ^_c.size_t) -> _c.int ---;

}
