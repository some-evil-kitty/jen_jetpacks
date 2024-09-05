class CfgSounds
{
    class GVAR(soundLoop)
    {
        name = "";
        sound[]={QPATHTOF(snd\jetpack_loop.wss),1.5,1,25};
        titles[]={};
    };
    class knd_jetpack_ignition : GVAR(soundLoop)
    {
	sound[]={QPATHTOF(snd\jetpack_ignition.wss),1.3,1,20};
    };
    class knd_jetpack_off : GVAR(soundLoop)
    {
	sound[]={QPATHTOF(snd\jetpack_off.wss),2.4,1,20};
    };
    class knd_jetpack_shutdown : GVAR(soundLoop)
    {
	sound[]={QPATHTOF(snd\jetpack_shutdown.wss),3.8,1,20};
    };
    class GVAR(soundWarning) : GVAR(soundLoop)
    {
	sound[]={QPATHTOF(snd\jetpack_warning.wss),1,1,5};
    };
};