const std = @import("std");
const zulkan = @import("zulkan");

pub fn main() !void {
    var ext_count: u32 = undefined;
    _ = try zulkan.enumerateInstanceExtensionProperties(null, &ext_count, null);

    std.log.info("{} extensions supported", .{ext_count});
}