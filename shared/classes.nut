Faction <- {
    Guardian = [],
    Mages = []
};

local function AddClass(faction, args)
{
    faction.append(args);
}

function getLeader()
{

}

AddClass(Faction.Guardian, {
    id = 0,
    name = "Straznik"
});

AddClass(Faction.Guardian, {
    id = 1,
    name = "Starszy Straznik"
});

AddClass(Faction.Mages, {
    id = 0,
    name = "Mag"
});

AddClass(Faction.Mages, {
    id = 1,
    name = "Starszy Mag"
});