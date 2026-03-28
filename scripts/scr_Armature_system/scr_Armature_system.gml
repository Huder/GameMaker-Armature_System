enum CRV_ARM {linear, linear_smooth, fast_in, fast_out}

/// @desc Create armature system
function armature_system() constructor
{
    par = other;
    parID = par.id;
    
    lerp_crv_names = ["Linear", "LinearSmooth", "FastIn", "FastOut"];
    lerp_crv_index = CRV_ARM.linear_smooth;
    lerp_crv = animcurve_get_channel(crv_armature_lerps, lerp_crv_index);
    
    bones = [];
    
    /// @desc Pętla Step armatury
    function Step()
    {
        for ( var i = 0; i < array_length(bones); i++ )
        {
            var bone = bones[i];
            bone.Step();
        }
    }
    
    /// @desc Pętla Draw armatury
    function Draw()
    {
        for ( var i = 0; i < array_length(bones); i++ )
        {
            var bone = bones[i];
            bone.Draw();
        }
    }
    
    function toString()
    {
        var bone_watch = "No bones";
        for ( var i = 0; i < array_length(bones); i++ )
        {
            bone_watch = $"{bones[i].toString()}\n\n";
        }
        
        return  $"Armature sys: OBJ: {object_get_name(par.object_index)}, ID: {real(parID)}\n"+
                $"   World position: [{parID.x}, {parID.y}]\n"+
                $"   World rotation and scale: {parID.rotation} deg, [{parID.image_xscale}, {parID.image_yscale}]\n\n"+
                $"{bone_watch}\n";
    }
}

/// @desc Create armature bone
/// @param      {Asset.GMSprite}    Spr         Sprite lub undefined w przypadku braku spritu dla tego bone
/// @param      {Struct.armature_system} System     System armatury do którego ta kość jest podpięta
/// @param      {Struct.armature_bone}   ParentBone Struct kości rodzica  
/// @param      {String}            BoneName    Nazwa na potrzeby debug watch  
/// @param      {Real}              StartX      Pozycja X początku kości
/// @param      {Real}              StartY      Pozycja Y początku kości
/// @param      {Real}              EndX        Pozycja X końca kości
/// @param      {Real}              EndY        Pozycja Y końca kości
function armature_bone(Spr=undefined, System=-1, ParentBone=-1, BoneName="default", StartX=0, StartY=0, EndX=0, EndY=0) constructor
{
    par_sys = System;
    par_bone = ParentBone;
    name = BoneName;
    
    spr = Spr;
    
    // Flagi konfiguracji kości
    can_stretch = true;         // Flaga oznaczająca czy przypisany sprite może się rozciągać
    inherit_rotation = true;    // Flaga oznaczająca czy dana kość dziedziczy rotację po rodzicu
    
    // Pozycja początkowa i końcowa
    base_pos_start_x = StartX;
    base_pos_start_y = StartY;
    base_pos_end_x = EndX;
    base_pos_end_y = EndY;
    
    base_length = point_distance(base_pos_start_x, base_pos_start_y, base_pos_end_x, base_pos_end_y);
    base_rot = point_direction(base_pos_start_x, base_pos_start_y, base_pos_end_x, base_pos_end_y);
    
    world_x = 0;
    world_y = 0;
    world_rot = base_rot;
    
    local_x = 0;
    local_y = 0;
    local_rot = 0;
    local_scaleX = 1;
    local_scaleY = 1;
    
    // Zmienne do ograniczeń Constraints
    has_length_constraint = false;
    constraint_length_min = 0;
    constraint_length_max = 0;
    
    has_rot_constraint = false;
    constraint_rot_min = 0;
    constraint_rot_max = 0;
    
    // Metody umożliwiające chainowanie
    
    /// @desc Ustawianie ograniczenia długości
    function set_length_constraint(Min, Max)
    {
        has_length_constraint = true;
        constraint_length_min = Min;
        constraint_length_max = Max;
        return self;
    }
    
    /// @desc Ustawianie ograniczenia rotacji
    function set_rotation_constraint(Min, Max)
    {
        has_rot_constraint = true;
        constraint_rot_min = Min;
        constraint_rot_max = Max;
        return self;
    }
    
    /// @desc Ustaw flage rozciągania przypisanego sprite
    function set_stretch(Stretch)
    {
        can_stretch = Stretch;
        return self;
    }
    
    /// @desc Ustaw flage dziedziczenia rotacji po rodzicu
    function set_inherit_rotation(Inherit)
    {
        inherit_rotation = Inherit;
        return self;
    }
    
    /// @desc Pętla Step kości
    function Step()
    {
        
    }
    
    /// @desc Pętla Draw kości
    function Draw()
    {
        
    }
    
    function toString()
    {
        return  $"Bone: {name}\n"+
                $"   World position: [{world_x}, {world_y}]\n"+
                $"   Base Start: [{base_pos_start_x}, {base_pos_start_y}], End: [{base_pos_end_x}, {base_pos_end_y}], {base_rot} deg\n"+
                $"   Local position: [{local_x}, {local_y}]\n"+
                $"   Local rotation and scale: {local_rot} deg, [{local_scaleX}, {local_scaleY}]\n"+
                $"   Stretch: {(can_stretch ? "Yes" : "No")}, Inherit Rot: {(inherit_rotation ? "Yes" : "No")}\n";
    }
}



