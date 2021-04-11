const std = @import("std");
const pkgs = @import("gyro").pkgs;
const zzz = @import("zzz");

const examples = [_][]const u8{"getext", "triangle"};

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    inline for(examples) |name| {
        const example = b.addExecutable(name, name ++ ".zig");
        example.linkLibC();
        example.linkSystemLibrary("vulkan");
        example.linkSystemLibrary("glfw3");
        example.setBuildMode(mode);
        example.install();
        pkgs.addAllTo(example);
        example.addPackagePath("zulkan", "../src/main.zig");

        const example_step = b.step(name, "Build the " ++ name ++ " example");
        example_step.dependOn(&example.step);

        const example_run_step = b.step(name ++ "-run", "Run the " ++ name ++ " example");

        const example_run = example.run();
        example_run_step.dependOn(&example_run.step);
    }
}