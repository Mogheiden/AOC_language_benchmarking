const std = @import("std");

const testing = std.testing;
const math = std.math;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn read_2d_i64_array(T: type, allocator: Allocator, path: []const u8, delimeter: []const u8) ![][]T {
    return read_2d_array(T, allocator, path, delimeter, parse_i64);
}

pub fn parse_i64(in: []const u8) i64 {
    return std.fmt.parseInt(i64, in, 10) catch -1;
}

pub fn read_2d_array(T: type, allocator: Allocator, path: []const u8, delimeter: []const u8, parser: fn (in: []const u8) T) ![][]T {
    // Open the file
    const fs = std.fs.cwd();
    const file = try fs.openFile(path, .{ .mode = .read_only });
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

    var list = ArrayList(ArrayList(T)).init(allocator);
    defer list.deinit();
    defer for (list.items) |inner_list| inner_list.deinit();

    while (lines_iter.next()) |line| {
        // Trim the line to remove any extra whitespace
        const trimmed_line = std.mem.trim(u8, line, " \t\r");

        // Split the line by space
        var parts_iter = std.mem.split(u8, trimmed_line, delimeter);

        var inner_list = ArrayList(T).init(allocator);

        while (parts_iter.next()) |part| {
            const value = parser(part);
            try inner_list.append(value);
        }

        try list.append(inner_list);
    }

    const return_list = try allocator.alloc([]T, list.items.len);

    for (0..list.items.len) |i| {
        const inner_list = list.items[i];
        var return_inner_list = try allocator.alloc(T, inner_list.items.len);
        @memcpy(return_inner_list[0..], inner_list.items[0..]);
        return_list[i] = return_inner_list;
    }

    return return_list;
}

fn valid1(line: []i64) bool {
    const ascending = line[0] > line[1];
    for (1..line.len) |i| {
        const diff = @abs(line[i] - line[i - 1]);
        if (diff < 1 or diff > 3 or ascending != (line[i] < line[i - 1])) {
            return false;
        }
    }
    return true;
}

fn valid2(arr: []i64) bool {
    const allocator = std.heap.page_allocator;
    for (0..arr.len) |j| {
        var new_arr = try allocator.alloc(i64, arr.len - 1);
        defer allocator.free(new_arr);
        var rindex: usize = 0;
        for (0..arr.len) |k| {
            if (k == j) {
                continue;
            }

            new_arr[rindex] = arr[k];
            rindex += 1;
        }

        const in_list = [1][]i64{new_arr};
        const is_valid_part_1 = try valid1(in_list[0]);
        if (is_valid_part_1) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const list = try read_2d_i64_array(i64, allocator, "../input.txt", " ");

    defer cleanup_array([]i64, allocator, list);

    try solver(list);
}

pub fn cleanup_array(T: type, allocator: Allocator, array: []T) void {
    for (array) |item| {
        allocator.free(item);
    }
    allocator.free(array);
}

pub fn solver(list: [][]i64) !void {
    var part1_answer: i64 = 0;
    var part2_answer: i64 = 0;

    for (0..list.len) |i| {
        const arr = list[i];
        if (valid1(arr)) {
            part1_answer += 1;
            part2_answer += 1;
        } else {
            if (valid2(arr)) {
                part2_answer += 1;
            }
        }
    }
    std.debug.print("{}\n", .{part1_answer});
    std.debug.print("{}\n", .{part2_answer});
}

// pub fn solve_part_2(list: [][]i64) !i64 {
//     var result: i64 = 0;
//     const allocator = std.heap.page_allocator;

//     for (0..list.len) |i| {
//         const arr = list[i];

//         // Brute force all possible combinations
//         for (0..arr.len) |j| {
//             var new_arr = try allocator.alloc(i64, arr.len - 1);
//             defer allocator.free(new_arr);
//             var rindex: usize = 0;
//             for (0..arr.len) |k| {
//                 if (k == j) {
//                     continue;
//                 }

//                 new_arr[rindex] = arr[k];
//                 rindex += 1;
//             }

//             var in_list = [1][]i64{new_arr};
//             const is_valid_part_1 = try solve_part_1(&in_list);
//             if (is_valid_part_1 > 0) {
//                 result += 1;
//                 break;
//             }
//         }
//     }
// }
