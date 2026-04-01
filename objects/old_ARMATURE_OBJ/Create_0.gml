// draw rotation ale z uwzglednieniem ustawien z room editora
rotation = image_angle; 
image_angle = 0; // przywracamy na zero bo nie chemy maski obracac


// init systemu armatur
armature = new old_armature_system();

debug_draw_armature = true;
if ( EnableDebugView )
{
    debug_watch = armature.toString();
    debug_view = dbg_view($"{object_get_name(object_index)}, {real(id)}", false);
    dbg_text(ref_create(id, "debug_watch"));
}
