const std = @import("std");
const common = @import("mod");

const testing = std.testing;
const math = std.math;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

fn valid1(line: std.ArrayList(i64)) bool {
    const ascending = line.items[0] > line.items[1];
    for (1..line.items.len) |i| {
        const diff = @abs(line.items[i] - line.items[i - 1]);
        if (diff < 1 or diff > 3 or ascending != (line.items[i] < line.items[i - 1])) {
            return false;
        }
    }
    return true;
}

fn removeAtIndex(arr: std.ArrayList(i64), index: usize) std.ArrayList(i64) {
    var new_arr = std.ArrayList(i64).init(arr.allocator);
    new_arr.ensureTotalCapacity(arr.items.len - 1) catch {};

    for (0..arr.items.len) |i| {
        if (i != index) {
            new_arr.append(arr.items[i]) catch {};
        }
    }
    return new_arr;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const fs = std.fs.cwd();
    const file = try fs.openFile("../input.txt", .{ .mode = .read_only });
    defer file.close();

    // Read the entire file content into a buffer
    var content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

    // Convert content to a slice of u8
    const content_str = content[0 .. content.len - 1];

    // Split the content into lines
    var lines_iter = std.mem.split(
        u8,
        content_str,
        "\n",
    );

    var part1Answer: i32 = 0;
    var part2Answer: i32 = 0;
    var loop: i32 = 0;

    while (lines_iter.next()) |line| {
        // Trim the line to remove any extra whitespace
        const trimmed_line = std.mem.trim(u8, line, " \t\r");

        // Split the line by space
        var parts_iter = std.mem.split(u8, trimmed_line, " ");

        var inner_list = ArrayList(i64).init(allocator);

        while (parts_iter.next()) |part| {
            const value = std.fmt.parseInt(i64, part, 10) catch -1;
            try inner_list.append(value);
        }
        // std.debug.print("{}\n", .{inner_list.items[0]});
        if (loop == 999) {
            for (0..inner_list.items.len) |i| {
                std.debug.print("{} ", .{inner_list.items[i]});
            }
        }
        if (valid1(inner_list)) {
            part1Answer += 1;
            part2Answer += 1;
            // std.debug.print("{}\n", .{loop});
        } else {
            for (0..inner_list.items.len) |i| {
                const sliceyBoi = removeAtIndex(inner_list, i);
                if (valid1(sliceyBoi)) {
                    part2Answer += 1;
                }
            }
        }
        loop += 1;
    }
    std.debug.print("{}\n", .{part1Answer});
    std.debug.print("{}\n", .{part2Answer});
}
