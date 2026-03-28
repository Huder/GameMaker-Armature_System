var m_scroll = mouse_wheel_up()-mouse_wheel_down();
zoom_target += zoom_inc*m_scroll;
zoom_target = clamp(zoom_target, zoom_min, zoom_max);

if ( abs(zoom_target-cam_zoom) > 0.1 )
{
    cam_zoom = lerp(cam_zoom, zoom_target, cam_lerp);
    cam_w = view_w*cam_zoom;
    cam_h = view_h*cam_zoom;
    camera_set_view_size(cam, cam_w, cam_h);
}


cam_x = lerp(cam_x, x, cam_lerp);
cam_y = lerp(cam_y, y, cam_lerp);
camera_set_view_pos(cam, cam_x-cam_w*0.5, cam_y-cam_h*0.5);

if ( follow == noone )
{
    if ( mouse_check_button(mb_right) )
    {
        var md_x = window_mouse_get_delta_x();
        var md_y = window_mouse_get_delta_y();
        
        x -= md_x*cam_zoom;
        y -= md_y*cam_zoom;
    }
}
else 
{
    x = follow.x;
    y = follow.y;	
}