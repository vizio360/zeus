exports.hermes =
{
    "id": "hermes",
    "properties": {
        "id": { "type": "string" },
        "maxConnections": { "type": "int" },
        "ip": { "type": "string" },
        "port": { "type": "int" },
        "machineId": { "type": "string" }
    }
}


exports.hermesList =
{
    "id": "hermesList",
    "properties": {
        "instances": {
            "type": "array",
            "items": {
                "id": { "type": "string" },
                "link": { "type": "string" }
            }
        }
    }
}
