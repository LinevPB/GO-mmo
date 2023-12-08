Shop <- {};

function Shop::Add(obj)
{
    Shop.append(obj);
}

function Shop::Contains(inst)
{
    foreach(v in Shop)
    {
        foreach(k in v)
        {
            if (k.instance == inst)
            {
                return true;
            }
        }
    }

    return false;
}