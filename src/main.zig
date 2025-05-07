const std = @import("std");
const DynLib = std.DynLib;

const Obj = extern struct { out: *const fn (c_int) callconv(.C) void };

const AddF = *const fn (c_int, c_int) callconv(.C) c_int;
const SlenF = *const fn ([*:0]const u8) callconv(.C) usize;
const CallStructF = *const fn (Obj) callconv(.C) void;
const FRetF = *const fn () callconv(.C) *const fn (c_int, c_int) callconv(.C) void;

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("expected 'dynload <file>'\n", .{});
        return 1;
    }

    var dynlib = try DynLib.open(args[1]);
    defer dynlib.close();

    const maybeAdd = dynlib.lookup(AddF, "add");
    if (maybeAdd) |add| {
        const x: c_int = 21;
        const y: c_int = 34;
        const n = add(x, y);

        try stdout.print("{d} + {d} = {d}\n", .{ x, y, n });
    } else {
        try stdout.print("cannot access add\n", .{});
        return 1;
    }

    const maybeSlen = dynlib.lookup(SlenF, "slen");
    if (maybeSlen) |slen| {
        const str = "hello";

        try stdout.print("{d} = {d}\n", .{ str.len, slen(str) });
    } else {
        try stdout.print("cannot access slen\n", .{});
        return 1;
    }

    const maybeCallStruct = dynlib.lookup(CallStructF, "call_struct");
    if (maybeCallStruct) |callStruct| {
        const obj = struct {
            fn out(n: c_int) callconv(.C) void {
                std.debug.print("{d}\n", .{n});
            }
        };
        callStruct(.{ .out = &obj.out });
    } else {
        try stdout.print("cannot access slen\n", .{});
        return 1;
    }

    const maybeFRet = dynlib.lookup(FRetF, "fret");
    if (maybeFRet) |fRet| {
        const f = fRet();
        f(19, 29);
    } else {
        try stdout.print("cannot access slen\n", .{});
        return 1;
    }

    try bw.flush();
    return 0;
}
