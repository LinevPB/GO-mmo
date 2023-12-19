mysql <- {
    handler = null,
    init = null,
    query = null,
    close = null,
    squery = null,
    gquery = null
};

mysql.init <- function()
{
    this.handler = mysql_connect("localhost", "root", "", "serv");

    if (!this.handler == null) {
        console.error("MySQL failed to connect!");
        return false;
    }

    console.log("MySQL connected successfully.")
    return true;
}

mysql.close <- function()
{
    mysql_close(this.handler);
    console.warn("MySQL connection closed.")
}

mysql.query <- function(query)
{
    local result = mysql_query(this.handler, query);

    if (result) {
        local row = mysql_fetch_row(result);
        mysql_free_result(result);
        return result;
    }

    console.error(mysql_errno(this.handler) + " : " + mysql_error(handler));
    return false;
}

mysql.gquery <- function(query)
{
    local result = mysql_query(this.handler, query);

    if (!result) {
        console.error(mysql_errno(this.handler) + " : " + mysql_error(handler));
        return false;
    }

    local tbl = [];

    local row = mysql_fetch_row(result);
    do {
        tbl.append(row);
        row = mysql_fetch_row(result);
    } while(row);

    mysql_free_result(result);

    return tbl;
}

// mysql.gquery <- function(query)
// {
//     local result = mysql_query(this.handler, query);

//     if (result) {
//         local temp = [];
//         foreach(v in result)
//             temp.append(v);

//         mysql_free_result(result);
//         return result;
//     }

//     console.error(mysql_errno(this.handler) + " : " + mysql_error(handler));
//     return false;
// }

mysql.squery <- function(query)
{
    if (!this.handler) return false;
    local result = mysql_query(this.handler, query);

    return true;
}