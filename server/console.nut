console <- {
    log = null,
    warning = null,
    error = null
}

local function formatUnixTimestamp(unixTimestamp) {
    local dt = date(unixTimestamp);

    local year = format("%04d", dt.year);
    local month = format("%02d", dt.month + 1);
    local day = format("%02d", dt.day);
    local hours = format("%02d", dt.hour);
    local minutes = format("%02d", dt.min);
    local seconds = format("%02d", dt.sec);

    return year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
}

local function consoleLog(mode, text)
{
    // Przykład użycia
    local timestamp = time();
    local formattedTime = formatUnixTimestamp(timestamp);

    switch(mode) {
        // basic log
        case 1:
            print("[" + formattedTime + "] " + text);
        break;

        // warning
        case 2:
            print("[" + formattedTime + "] " + "[WARNING] " + text);
        break;

        // error
        case 3:
            print("[" + formattedTime + "] " + "[ERROR] " + text);
        break;
    }
}

console.log <- function(text) {
    consoleLog(1, text);
}

console.warn <- function(text) {
    consoleLog(2, text);
}

console.error <- function(text) {
    consoleLog(3, text);
}