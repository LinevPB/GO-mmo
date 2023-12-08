local sound = null;

function playSound(name)
{
    stopSound();

    try
    {
        sound = Sound(name);

        if (sound)
        {
            sound.play();
        }
    }
    catch(exception)
    {
        //print(exception);
    }
}

function stopSound()
{
    if (sound != null)
    {
        sound.stop();
        sound = null;
    }
}

function getSound()
{
    return sound;
}

function initSoundController()
{
}