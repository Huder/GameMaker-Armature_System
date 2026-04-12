/// @description 
for ( var i = 0; i < array_length(children_list); i++ ) 
{
    if ( instance_exists(children_list[i]) ) 
    {
        instance_destroy(children_list[i]);
    }
}

// Remove from parent's children list
if ( instance_exists(parent_bone) ) 
{
    var idx = array_get_index(parent_bone.children_list, id);
    if ( idx != -1 ) 
    {
        array_delete(parent_bone.children_list, idx, 1);
    }
}
