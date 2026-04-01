

// Sterowanie
rot = image_angle;
image_angle = 0; // resetujemy bo nie chcemy obracać maski kolizji
rot_spd = 9;

armature = new armatureSys(rot);

// Debug stuff
debug_watch = "";
debug_masks = false;
dbg_player = dbg_view("Player", true, 32, 128);
dbg_checkbox(ref_create(id, "debug_masks"), "show masks");
dbg_text(ref_create(id, "debug_watch"));
