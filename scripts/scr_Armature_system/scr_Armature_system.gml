// ---------------- SYSTEM -----------------------------------------------------------------------------------------

function Armature(Name, PosX, PosY, Rot, Scale, Sprite=-1, Mask=-1, SpriteAngle=0, SpriteScaleX=1, SpriteScaleY=1) constructor 
{
    var rootBone = instance_create_depth(PosX, PosY, depth, ARMATURE_BONE);
    rootBone.sprite_index = Sprite;
    rootBone.mask_index = Mask;
    rootBone.spriteAngle = SpriteAngle;
    rootBone.spriteScaleX = SpriteScaleX;
    rootBone.spriteScaleY = SpriteScaleY;
    rootBone.isRoot = true;
    rootBone.inherit_rot = false;
    
    rootBone.system_struct = self;
    rootBone.system_instance = other.id;
    
    bones = [rootBone];
    
}




// ---------------- BONES -----------------------------------------------------------------------------------------

function armature_bone_update()
{
    image_angle = spriteAngle;
    image_xscale = spriteScaleX; 
    image_yscale = spriteScaleY;
}