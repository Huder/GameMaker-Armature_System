// ---------------- SYSTEM -----------------------------------------------------------------------------------------

/// @function Armature(Name, PosX, PosY, Rot, Scale, [Sprite], [Mask], [SpriteAngle], [SpriteScaleX], [SpriteScaleY])
/// @description Tworzy system armatury (strukturę), która zarządza kośćmi, animacjami i transformacjami.
/// @param {string}  Name           Nazwa nadrzędnej kości (root).
/// @param {real}    PosX           Pozycja X systemu w świecie.
/// @param {real}    PosY           Pozycja Y systemu w świecie.
/// @param {real}    Rot            Początkowa rotacja systemu.
/// @param {real}    Scale          Skala systemu.
/// @param {asset}   [Sprite]       Sprite kości root.
/// @param {asset}   [Mask]         Maska kolizji kości root.
/// @param {real}    [SpriteAngle]  Kąt rysowania sprita.
/// @param {real}    [SpriteScaleX] Skala X sprita.
/// @param {real}    [SpriteScaleY] Skala Y sprita.
function Armature(Name, PosX, PosY, Rot, Scale, Sprite=-1, Mask=-1, SpriteAngle=0, SpriteScaleX=1, SpriteScaleY=1) constructor 
{
    x = PosX;
    y = PosY;
    rotation = Rot;
    scale = Scale;
    
    bones_map = {}; 
    bones_list = []; 
    
    
    ownerId = other.id;

    poses = {};
    anim_player = new Armature_AnimationPlayer(self);
    
    system_name = "unknown_armature";
    
    /// @function Update()
    /// @description Główna pętla aktualizująca system: przelicza animację i transformacje wszystkich kości.
    static Update = function() 
    {
        anim_player.Update();
        
        var len = array_length(bones_list);
        for ( var i = 0; i < len; i++ )
        {
            var bone = bones_list[i];
            if ( instance_exists(bone) )
            {
                with ( bone ) armature_bone_update_transform();
            }
        }
    };
    
    /// @function Get_rootBone()
    /// @description Zwraca instancję kości nadrzędnej (root) jeśli istnieje.
    /// @returns {id.Instance|undefined}
    static Get_rootBone = function()
    {
        if ( instance_exists(root_bone) )
        {
            return root_bone;
        }
        return undefined;
    }
    
    /// @function Add_bone(BoneName, ParentName, PosXStart, PosYStart, PosXEnd, PosYEnd, Layer, [Sprite], [Mask], [SprRot], [SprScaleX], [SprScaleY], [InheritRot])
    /// @description Dodaje nową kość do systemu armatury.
    /// @param {string}  BoneName     Unikalna nazwa kości.
    /// @param {string}  ParentName   Nazwa kości rodzica (pusty string dla root).
    /// @param {real}    PosXStart    Pozycja X początku kości.
    /// @param {real}    PosYStart    Pozycja Y początku kości.
    /// @param {real}    PosXEnd      Pozycja X końcówki (definiuje długość i kąt).
    /// @param {real}    PosYEnd      Pozycja Y końcówki.
    /// @param {real}    Layer        Warstwa (depth) kości względem systemu.
    /// @param {asset}   [Sprite]     Sprite kości.
    /// @param {asset}   [Mask]       Maska kolizji.
    /// @param {real}    [SprRot]     Dodatkowa rotacja sprita.
    /// @param {real}    [SprScaleX]  Skala X sprita.
    /// @param {real}    [SprScaleY]  Skala Y sprita.
    /// @param {bool}    [InheritRot] Czy kość ma dziedziczyć obrót po rodzicu (domyślnie true).
    /// @returns {id.Instance}        Zwraca identyfikator stworzonej instancji kości.
    static Add_bone = function(BoneName, ParentName, PosXStart, PosYStart, PosXEnd, PosYEnd, Layer, Sprite=-1, Mask=-1, SprRot=0, SprScaleX=1, SprScaleY=1, InheritRot=true) 
    {
        var dist = point_distance(PosXStart, PosYStart, PosXEnd, PosYEnd);
        var dir = point_direction(PosXStart, PosYStart, PosXEnd, PosYEnd);
        
        var parent_inst = undefined;
        var parent_world_angle = 0;
        
        if ( ParentName != "" )
        {
            parent_inst = bones_map[$ ParentName];
            if ( instance_exists(parent_inst) )
            {
                parent_world_angle = parent_inst.world_angle;
            }
        }
        
        var local_dir = dir;
        if ( InheritRot && instance_exists(parent_inst) )
        {
            local_dir = angle_difference(dir, parent_world_angle);
        }
        
        var bone = instance_create_depth(PosXStart, PosYStart, 0, ARMATURE_BONE);
        bone.name = BoneName;
        bone.parent_name = ParentName;
        bone.parent_bone = parent_inst;
        bone.layer_index = Layer;
        
        bone.sprite_index = Sprite;
        bone.mask_index = Mask;
        bone.spriteAngle = SprRot;
        bone.spriteScaleX = SprScaleX;
        bone.spriteScaleY = SprScaleY;
        bone.inherit_rot = InheritRot;
        
        bone.bone_length = dist;
        bone.local_angle = local_dir;
        bone.world_angle = dir;

        bone.system_struct = self;
        bone.system_instance = ownerId; 
        
        if ( !instance_exists(parent_inst) )
        {
            bone.isRoot = true;
        } 
        else 
        {
            bone.isRoot = false;
            array_push(parent_inst.children_list, bone);
        }
        
        if ( instance_exists(bone.system_instance) )
        {
            bone.depth = bone.system_instance.depth-bone.layer_index;
        } 
        else 
        {
            bone.depth = -bone.layer_index; 
        }
        
        bones_map[$ BoneName] = bone;
        array_push(bones_list, bone);
        
        return bone;
    };
    
    /// @function toString()
    /// @description Zwraca sformatowany tekst z informacjami o stanie armatury.
    /// @returns {string}
    static toString = function()
    {
        if ( system_name == "unknown_armature" && instance_exists(ownerId) )
        {
            var names = variable_instance_get_names(ownerId);
            for ( var i = 0; i < array_length(names); i++ )
            {
                if ( variable_instance_get(ownerId, names[i]) == self )
                {
                    system_name = names[i];
                    break;
                }
            }
        }
        
        var str  = $"ARMATURE: {system_name}\n";
            str += $"    ownerId: {object_get_name(ownerId.object_index)}, id: {real(ownerId)}\n";
            str += $"    root_bone: {real(root_bone)}\n\n";

        var len = array_length(bones_list);
            str += $"    bone number: {len} ---------------------\n\n";
        
        for ( var i = 0; i < len; i++ )
        {
            var bone = bones_list[i];
            if ( instance_exists(bone) )
            {
                str += $"        bone name: {bone.name}\n";
                // Obsługa wieloliniowego watchString z zachowaniem wcięcia
                var watchFormatted = string_replace_all(bone.watchString, "\n", "\n        ");
                str += $"        {watchFormatted}\n\n";
            }
            else
            {
                str += "        bone name: [Destroyed]\n\n";
            }
        }
        
        var pose_count = array_length(variable_struct_get_names(poses));
            str += $"    pose number: {pose_count} ---------------------\n\n";
        
            str += "    animation player ---------------------\n\n";
        var anim_str = anim_player.toString();
            str += $"        {string_replace_all(anim_str, "\n", "\n        ")}\n";
        
        return str;
    };
    
    // Create Root Bone
    root_bone = Add_bone(Name, "", PosX, PosY, PosX, PosY, 0, Sprite, Mask, SpriteAngle, SpriteScaleX, SpriteScaleY, false);
}


// ---------------- POSES & ANIMATION -------------------------------------------------------------------------------

/// @function Armature_Pose()
/// @description Kontener przechowujący dane o rotacjach kości dla konkretnej pozy.
function Armature_Pose() constructor 
{
    bone_rotations = {}; 
    
    /// @function Set_bone_rotation(BoneName, Angle)
    /// @description Zapisuje rotację lokalną dla danej kości wewnątrz pozy.
    /// @param {string} BoneName Nazwa kości.
    /// @param {real}   Angle    Kąt rotacji.
    static Set_bone_rotation = function(BoneName, Angle) 
    {
        bone_rotations[$ BoneName] = Angle;
    };
    
    /// @function Get_bone_rotation(BoneName)
    /// @description Zwraca zapisaną rotację dla danej kości.
    /// @param {string} BoneName Nazwa kości.
    /// @returns {real}
    static Get_bone_rotation = function(BoneName)
    {
        return bone_rotations[$ BoneName];
    };
    
    /// @function toString()
    /// @description Zwraca tekstową reprezentację rotacji wewnątrz pozy.
    /// @returns {string}
    static toString = function()
    {
        var str  = $"ARMATURE_POSE: {ptr(self)}\n";
        var names = variable_struct_get_names(bone_rotations);
        for ( var i = 0; i < array_length(names); i++ )
        {
            str += $"    {names[i]}: {bone_rotations[$ names[i]]}\n";
        }
        return str;
    };
}

/// @function Armature_AnimationPlayer(System)
/// @description System odpowiedzialny za odtwarzanie i interpolację póz.
/// @param {struct.Armature} System Referencja do nadrzędnej struktury Armature.
function Armature_AnimationPlayer(System) constructor 
{
    system = System;
    
    current_pose = undefined;
    target_pose = undefined;
    
    transition_frames = 0;
    transition_duration = 0;
    
    /// @function Play_pose(Pose, TransitionFrames)
    /// @description Rozpoczyna proces przechodzenia do nowej pozy.
    /// @param {struct.Armature_Pose} Pose             Docelowa poza.
    /// @param {real}                 TransitionFrames Czas przejścia w klatkach (0 = natychmiast).
    static Play_pose = function(Pose, TransitionFrames) 
    {
        if ( TransitionFrames <= 0 )
        {
            current_pose = Pose;
            target_pose = undefined;
            transition_frames = 0;
            
            var names = variable_struct_get_names(Pose.bone_rotations); // TODO: to być może powinno być cachowane?
            var len = array_length(names);
            for ( var i = 0; i < len; i++ )
            {
                var boneName = names[i];
                var ang = Pose.Get_bone_rotation(boneName);
                var bone = system.bones_map[$ boneName];
                if ( instance_exists(bone) )
                {
                    with ( bone ) armature_bone_set_rotation_local(ang);
                }
            }
        } 
        else 
        {
            current_pose = new Armature_Pose();
            var len = array_length(system.bones_list);
            for ( var i = 0; i < len; i++ )
            {
                var boneInst = system.bones_list[i];
                if ( instance_exists(boneInst) )
                {
                    current_pose.Set_bone_rotation(boneInst.name, boneInst.local_angle);
                }
            }
            
            target_pose = Pose;
            transition_duration = TransitionFrames;
            transition_frames = 0;
        }
    };
    
    /// @function Update()
    /// @description Aktualizuje proces interpolacji między pozami (wywoływane automatycznie przez Armature.Update).
    static Update = function() 
    {
        if ( target_pose != undefined )
        {
            transition_frames++;
            var progress = transition_frames/transition_duration;
            if ( progress >= 1 )
            {
                progress = 1;
            }
            
            var names = variable_struct_get_names(target_pose.bone_rotations); // TODO: to być może powinno być cachowane?
            var len = array_length(names);
            for ( var i = 0; i < len; i++ )
            {
                var boneName = names[i];
                var target_ang = target_pose.Get_bone_rotation(boneName);
                
                var start_ang = target_ang;
                if ( current_pose != undefined && variable_struct_exists(current_pose.bone_rotations, boneName))
                {
                    start_ang = current_pose.Get_bone_rotation(boneName);
                }
                
                var diff = angle_difference(target_ang, start_ang);
                var current_ang = start_ang+diff*progress;
                
                var bone = system.bones_map[$ boneName];
                if ( instance_exists(bone) )
                {
                    with ( bone ) armature_bone_set_rotation_local(current_ang);
                }
            }
            
            if ( progress >= 1 )
            {
                current_pose = target_pose;
                target_pose = undefined;
            }
        }
    };
    
    /// @function toString()
    /// @description Zwraca informacje o aktualnym stanie animacji.
    /// @returns {string}
    static toString = function()
    {
        var str  = $"transition: {transition_frames}/{transition_duration}\n";
            str += $"current_pose: {( (current_pose == undefined) ? "undefined" : ptr(current_pose) )}\n";
            str += $"target_pose: {( (target_pose == undefined) ? "undefined" : ptr(target_pose) )}";
        return str;
    };
}


// ---------------- BONES -----------------------------------------------------------------------------------------

/// @function armature_bone_update_transform()
/// @description Przelicza pozycję X, Y oraz światową rotację kości na podstawie rodzica i parametrów lokalnych.
function armature_bone_update_transform()
{
    if ( isRoot )
    {
        world_angle = local_angle;
        if ( instance_exists(system_instance) )
        {
            x = system_instance.x;
            y = system_instance.y;
        }
    } 
    else 
    {
        if ( inherit_rot && instance_exists(parent_bone) )
        {
            world_angle = parent_bone.world_angle+local_angle;
            x = parent_bone.x+lengthdir_x(parent_bone.bone_length, parent_bone.world_angle);
            y = parent_bone.y+lengthdir_y(parent_bone.bone_length, parent_bone.world_angle);
        } 
        else
        { 
            if ( instance_exists(parent_bone) )
            {
                world_angle = local_angle;
                x = parent_bone.x+lengthdir_x(parent_bone.bone_length, parent_bone.world_angle);
                y = parent_bone.y+lengthdir_y(parent_bone.bone_length, parent_bone.world_angle);
            }
        }
    }
    
    if ( instance_exists(system_instance) )
    {
        depth = system_instance.depth-layer_index;
    } 
    else 
    {
        depth = -layer_index; 
    }
    
    image_angle = world_angle+spriteAngle;
    image_xscale = spriteScaleX; 
    image_yscale = spriteScaleY;
    
    armature_bone_watch();
}

/// @function armature_bone_watch()
/// @description Aktualizuje diagnostyczny ciąg znaków (watchString) dla instancji kości.
function armature_bone_watch()
{
    var lx = (instance_exists(parent_bone)) ? x-parent_bone.x : x;
    var ly = (instance_exists(parent_bone)) ? y-parent_bone.y : y;
    var s_depth = (instance_exists(system_instance)) ? system_instance.depth : 0;
    
    var str  = $"isRoot: {isRoot}, inherit_rot: {inherit_rot}, ignore_pose: {ignore_pose}\n";
        str += $"LocAngle: {local_angle}, WorldAngle: {world_angle}, Length: {bone_length}\n";
        str += $"LocX/Y: ({lx}, {ly}), WorldX/Y: ({x}, {y})\n";
        str += $"Depth: {depth} (Sys: {s_depth}-LayerIndex: {layer_index})";
        
    watchString = str;
}

/// @function armature_bone_set_rotation_local(Angle)
/// @description Ustawia lokalną rotację kości z uwzględnieniem limitów (o ile nie jest ignorowana przez poza).
/// @param {real} Angle Kąt w stopniach.
function armature_bone_set_rotation_local(Angle)
{
    if ( ignore_pose ) 
        return;
    
    var ang = Angle;
    if ( has_rot_limits ) 
    {
        ang = clamp(ang, rot_min, rot_max);
    }
    local_angle = ang;
}

/// @function armature_bone_add_rotation_local(Amount)
/// @description Dodaje wartość do aktualnej rotacji lokalnej kości.
/// @param {real} Amount Wartość o ile obrócić.
function armature_bone_add_rotation_local(Amount)
{
    armature_bone_set_rotation_local(local_angle+Amount);
}

/// @function armature_bone_set_rotation_world(Angle)
/// @description Ustawia światową rotację kości, przeliczając ją na odpowiednią wartość lokalną względem rodzica.
/// @param {real} Angle Kąt światowy w stopniach.
function armature_bone_set_rotation_world(Angle)
{
    if ( isRoot ) 
    {
        armature_bone_set_rotation_local(Angle);
    } 
    else 
    {
        if ( inherit_rot && instance_exists(parent_bone) )
        {
            var local_ang = angle_difference(Angle, parent_bone.world_angle);
            armature_bone_set_rotation_local(local_ang);
        } 
        else 
        {
            armature_bone_set_rotation_local(Angle);
        }
    }
}

/// @function armature_bone_detach()
/// @description Odłącza kość od systemu armatury, czyniąc ją samodzielnym rootem (wraz z dziećmi).
function armature_bone_detach()
{
    isRoot = true;
    system_struct = undefined;
    system_instance = undefined;
    
    if ( instance_exists(parent_bone) )
    {
        var idx = array_get_index(parent_bone.children_list, id);
        if (idx != -1)
        {
            array_delete(parent_bone.children_list, idx, 1);
        }
    }
    parent_bone = undefined;
    
    var boneArray = [id];
    while ( array_length(boneArray) > 0 )
    {
        var curr = boneArray[0];
        array_delete(boneArray, 0, 1);
        
        if ( instance_exists(curr) )
        {
            curr.system_struct = undefined;
            curr.system_instance = undefined;
            for ( var i=0; i<array_length(curr.children_list); i++ )
            {
                array_push(boneArray, curr.children_list[i]);
            }
        }
    }
}

/// @function armature_bone_update()
/// @description Funkcja pomocnicza wywoływana przez Step kości, jeśli ta nie posiada nadrzędnego systemu.
function armature_bone_update()
{
    armature_bone_update_transform();
}