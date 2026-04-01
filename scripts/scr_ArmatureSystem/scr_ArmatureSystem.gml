function armatureSys(Rot) constructor 
{
    root_rotation = Rot;
    root_instance = other.id;
    root_x = root_instance.x;
    root_y = root_instance.y;
    root_watch = $"";
    
    /// @desc Ustawia obrót systemu
    /// @param      {Real}      Rot      Kąt
    function Set_Rotation(Rot)
    {
        root_rotation = Rot;
    }
    
    /// @function Step()
    function Step()
    {
        root_watch =    $"Root:\n"+
                        $"  Position: [{root_x}, {root_y}]\n   Rotation: {root_rotation}";
    }
}