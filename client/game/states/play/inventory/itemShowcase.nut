local holdedId = -1;

function showcaseHover(el)
{
    if (TradeBox.IsEnabled()) return;
    if (el.elementType != ElementType.BUTTON) return;
    if (el.more == null) return;
    if (el.more.instance == null || el.more.instance == "" || el.more.instance == "-1" || el.more.instance == "0") return;

    holdedId = el.id;
    Showcase.Update(el.more.render.instance);

    Showcase.Enable(true);
}

function showcaseUnhover(el)
{
    if (el.elementType != ElementType.BUTTON) return;
    if (holdedId != el.id) return;

    Showcase.Enable(false);
}

function handleShowcaseClick(id)
{
    if (!Showcase.IsEnabled()) return;

    invUnhover({id = id, elementType = ElementType.BUTTON});
}

function showcaseRender()
{
    //Showcase.Render();
}