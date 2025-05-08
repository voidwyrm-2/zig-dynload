const std = @import("std");

fn add(x: c_int, y: c_int) callconv(.C) c_int {
    return x + y;
}

fn slen(str: [*:0]const u8) callconv(.C) usize {
    var len: usize = 0;

    while (str[len] != 0) {
        len += 1;
    }

    return len;
}

const Obj = extern struct { out: *const fn (c_int) callconv(.C) void };

fn call_struct(obj: Obj) callconv(.C) void {
    obj.out(50);
}

fn fret() *const fn (c_int, c_int) void {
    const put = extern struct {
        fn put(a: c_int, b: c_int) callconv(.C) void {
            std.debug.print("{d} OR {d} from zig!", .{ a, b });
        }
    }.put;
    return &put;
}
