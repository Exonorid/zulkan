const std = @import("std");

const c = @cImport(@cInclude("vulkan/vulkan.h"));

const Result = enum(i32) {
    Success = @enumToInt(c.VkResult.VK_SUCCESS),
    NotReady = @enumToInt(c.VkResult.VK_NOT_READY),
    Timeout = @enumToInt(c.VkResult.VK_TIMEOUT),
    EventSet = @enumToInt(c.VkResult.VK_EVENT_SET),
    EventReset = @enumToInt(c.VkResult.VK_EVENT_RESET),
    Incomplete = @enumToInt(c.VkResult.VK_INCOMPLETE),
    Suboptimal = 1000001003,
    ThreadIdle = 1000268000,
    ThreadDone = 1000268001,
};

const Error = error {
    InvalidArguments,
    OutOfHostMemory,
    OutOfDeviceMemory,
    InitializationFailed,
    DeviceLost,
    MemoryMapFailed,
    LayerNotPresent,
    ExtensionNotPresent,
    FeatureNotPresent,
    IncompatibleDriver,
    TooManyObjects,
    FormatNotSupported,
    FragmentedPool,
    Unknown,
    OutOfPoolMemory,
    InvalidExternalHandle,
    Fragmentation,
    InvalidOpaqueCaptureAddress,
    SurfaceLost,
    NativeWindowInUse,
    OutOfDate,
    IncompatibleDisplay,
    ValidationFailed,
    InvalidShader,
    InvalidDRMFormatModifierPlaneLayout,
    NotPermitted,
    FullScreenExclusiveModeLost,
    InvalidDeviceAddress,
    PipelineCompileRequired,
};

const ExtensionProperties = c.VkExtensionProperties;

pub fn enumerateInstanceExtensionProperties(layerName: ?[]const u8, propertyCount: *u32, properties: ?[]ExtensionProperties) !Result {
    if(propertyCount.* != 0 and properties != null)
        if(properties.?.len != @as(usize, propertyCount.*)) return Error.InvalidArguments;
    const layerNamePtr: ?[*]const u8 = if(layerName) |m_layerName| m_layerName.ptr else null;
    const propertiesPtr: ?[*]ExtensionProperties = if(properties) |m_properties| m_properties.ptr else null;
    const result = c.vkEnumerateInstanceExtensionProperties(layerNamePtr, propertyCount, propertiesPtr);
    return switch(result) {
        .VK_ERROR_OUT_OF_HOST_MEMORY => Error.OutOfHostMemory,
        .VK_ERROR_OUT_OF_DEVICE_MEMORY => Error.OutOfDeviceMemory,
        .VK_ERROR_LAYER_NOT_PRESENT => Error.LayerNotPresent,
        else => @intToEnum(Result, @enumToInt(result)),
    };
}