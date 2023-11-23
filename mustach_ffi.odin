package mustache

foreign import "mustach"

import "core:c"
import "core:c/libc"

filep :: ^libc.FILE
voidp :: rawptr

VERSION :: 102
VERSION_MAJOR :: (102 / 100)
VERSION_MINOR :: (102 % 100)
MAX_DEPTH :: 256
MAX_LENGTH :: 4096
MAX_DELIM_LENGTH :: 8

With_Flag :: enum u8 {
	NoExtensions  = 0,
	Colon         = 1,
	EmptyTag      = 2,
	AllExtensions = 3,
}

Errorcode :: enum c.int {
	OK                      = 0,
	ERROR_SYSTEM            = -1,
	ERROR_UNEXPECTED_END    = -2,
	ERROR_EMPTY_TAG         = -3,
	ERROR_TAG_TOO_LONG      = -4,
	ERROR_BAD_SEPARATORS    = -5,
	ERROR_TOO_DEEP          = -6,
	ERRORcLOSING            = -7,
	ERROR_BAD_UNESCAPE_TAG  = -8,
	ERROR_INVALID_ITF       = -9,
	ERROR_ITEM_NOT_FOUND    = -10,
	ERROR_PARTIAL_NOT_FOUND = -11,
	ERROR_UNDEFINED_TAG     = -12,
	ERROR_USER_BASE         = -100,
}


mustach_sbuf :: struct {
	value:     cstring,
	free_func: FuncUnion,
	closure:   voidp,
	length:    c.size_t,
}

mustach_itf :: struct {
	start:   #type proc(closure: voidp) -> c.int,
	put:     #type proc(closure: voidp, name: cstring, escape: c.int, file: filep) -> c.int,
	enter:   #type proc(closure: voidp, name: cstring) -> c.int,
	next:    #type proc(closure: voidp) -> c.int,
	leave:   #type proc(closure: voidp) -> c.int,
	partial: #type proc(closure: voidp, name: cstring, sbuf: ^mustach_sbuf) -> c.int,
	emit:    #type proc(closure: voidp, buffer: cstring, size: c.size_t, escape: c.int, file: filep) -> c.int,
	get:     #type proc(closure: voidp, name: cstring, sbuf: ^mustach_sbuf) -> c.int,
	stop:    #type proc(closure: voidp, status: c.int),
}

FuncUnion :: struct #raw_union {
	freecb:    #type proc(closure: voidp),
	releasecb: #type proc(value: cstring, closure: voidp),
}

@(default_calling_convention = "c", link_prefix = "mustach_")
foreign mustach {
	@(link_name = "mustach_file")
	file :: proc(template: cstring, length: c.size_t, itf: ^mustach_itf, closure: voidp, flags: c.int, file: filep) -> c.int ---

	@(link_name = "mustach_fd")
	fd :: proc(template: cstring, length: c.size_t, itf: ^mustach_itf, closure: voidp, flags: c.int, fd: c.int) -> c.int ---

	@(link_name = "mustach_mem")
	mem :: proc(template: cstring, length: c.size_t, itf: ^mustach_itf, closure: voidp, flags: c.int, result: ^cstring, size: ^c.size_t) -> c.int ---
}

mustach_writecb:: proc (closure: voidp, buffer: cstring, size: c.size_t)

mustach_emitcb:: proc (closure: voidp, buffer: cstring, size: c.size_t, escape: c.int)
