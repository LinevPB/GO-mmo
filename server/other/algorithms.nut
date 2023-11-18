function md5Hash(data) {
    local md5Result = "";
    try {
        md5Result = md5(data);
    } catch (ex) {
        console.error("Failed to hash data: " + data);
    }
    return md5Result;
}