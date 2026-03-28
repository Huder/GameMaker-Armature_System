function init_Fmod()
{

    var max_channels = 1024
    var flags_core = FMOD_INIT.NORMAL;
    var flags_studio = FMOD_STUDIO_INIT.LIVEUPDATE;
    
    #macro USE_DEBUG_CALLBACKS true // Should debugging be initialised?

    if ( USE_DEBUG_CALLBACKS )
    {
        fmod_debug_initialize(FMOD_DEBUG_FLAGS.LEVEL_LOG, FMOD_DEBUG_MODE.CALLBACK);
    }
    
    fmod_studio_system_create();
    show_debug_message("fmod_studio_system_create: " + fmod_error_string());

    fmod_studio_system_init(max_channels, flags_studio, flags_core);
    show_debug_message("fmod_studio_system_init: " + fmod_error_string());

    /*
        FMOD Studio will create an initialize an underlying core system to work with.
    */
    global.fmod_system = fmod_studio_system_get_core_system();
}