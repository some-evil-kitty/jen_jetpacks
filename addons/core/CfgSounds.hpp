class CfgSounds
{
    class knd_jetpack_loop
    {
        name = "";
        sound[]={"knd_gadgets_core\snd\jetpack_loop.wss",1.5,1,25};
        titles[]={};
    };
    class knd_jetpack_ignition : knd_jetpack_loop
    {
	sound[]={"knd_gadgets_core\snd\jetpack_ignition.wss",1.3,1,20};
    };
    class knd_jetpack_off : knd_jetpack_loop
    {
	sound[]={"knd_gadgets_core\snd\jetpack_off.wss",2.4,1,20};
    };
    class knd_jetpack_shutdown : knd_jetpack_loop
    {
	sound[]={"knd_gadgets_core\snd\jetpack_shutdown.wss",3.8,1,20};
    };
    class knd_jetpack_warning : knd_jetpack_loop
    {
	sound[]={"knd_gadgets_core\snd\jetpack_warning.wss",1,1,5};
    };
};