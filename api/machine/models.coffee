exports.machine =
{
    "id": "machine",
    "properties": {
        "id": { "type": "string" },
        "ip": { "type": "string" },
        "type": { "type": "string" }
    }
}


exports.machineList =
{
    "id": "machineList",
    "properties": {
        "machines": {
            "type": "array",
            "items": {
                "id": { "type": "string" },
                "link": { "type": "string" }
            }
        }
    }
}
