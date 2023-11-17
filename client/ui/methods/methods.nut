function repeatString(char, count) {
    local result = "";
    for (local i = 0; i < count; i++) {
        result += char;
    }
    return result;
}

function inSquare(cursor, pos, size) {
    local cursorX = cursor.x;
    local cursorY = cursor.y;
    local squareX1 = pos.x;
    local squareY1 = pos.y;
    local squareX2 = squareX1 + size.width;
    local squareY2 = squareY1 + size.height;

    return cursorX >= squareX1 && cursorX <= squareX2 &&
           cursorY >= squareY1 && cursorY <= squareY2;
}

function arrayContains(arr, element) {
    foreach (item in arr) {
        if (item == element) {
            return true;
        }
    }
    return false;
}

function initUI()
{
    enableEvent_Render(true);
    enableEvent_RenderFocus(true);
}