package mustache

import "core:c"
import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"

Mustache :: struct {
	itf:     ^mustach_itf,
  closure:  voidp,
	flags:   c.int,
  emitcb: ^mustach_emitcb,
  writecb: ^mustach_writecb,
}

mustache_init :: proc(m: ^Mustache, itf: ^mustach_itf, closure: voidp, flags: c.int, emitcb: ^mustach_emitcb, writecb: ^mustach_writecb) {
  m.closure = closure
  m.itf = itf
  m.flags = flags
  m.emitcb = emitcb
  m.writecb = writecb
}

mustache_file :: proc(template: string, values: rawptr, filepath: string) -> int {
  n := strings.clone_to_cstring(filepath)
  defer delete(n)
	f := libc.fopen(n, "r")
	defer libc.fclose(f)
	t := strings.clone_to_cstring(template)
	defer delete(t)

  m : Mustache
  itf: mustach_itf
  mustache_init(&m, &itf, values, m.flags, nil, nil)

	ret := file(t, len(template), &itf, &m, m.flags, f)
	return int(ret)
}

mustache_fd :: proc(mustache: ^Mustache, template: string, values: rawptr, d: int) -> int {
	t := strings.clone_to_cstring(template)
	defer delete(t)

  m : Mustache
  itf: mustach_itf
  mustache_init(&m, &itf, values, m.flags, nil, nil)

	ret := fd(t, len(template), &itf, &m, m.flags, cast(c.int)d)
	return int(ret)
}

mustache_mem :: proc(mustache: ^Mustache, template: string, values: rawptr, buffer: ^cstring, size: ^uint) -> int {
	t := strings.clone_to_cstring(template)
	defer delete(t)

  m : Mustache
  itf: mustach_itf
  mustache_init(&m, &itf, values, m.flags, nil, nil)

	ret := mem(
		strings.clone_to_cstring(template),
		len(template),
		&itf,
		&m,
		m.flags,
		buffer,
		size,
	)
	return int(ret)
}

main :: proc() {
	if len(os.args) < 3 do fmt.printf("%s <template file> <output file>", os.args[0])
	tf := os.args[1]
	of := os.args[2]

	template, ok := os.read_entire_file(os.args[1])
	if (!ok) {
    os.exit(1);
	}
	defer delete(template)

  stuff : struct {}
	mustache_file(string(template), &stuff, of)
}
