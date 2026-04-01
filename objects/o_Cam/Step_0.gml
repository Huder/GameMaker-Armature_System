var m_scroll = mouse_wheel_down()-mouse_wheel_up();
zoom_target += zoom_inc*m_scroll;
zoom_target = clamp(zoom_target, zoom_min, zoom_max);

// Zoom
if ( abs(zoom_target-cam_zoom) > 0.001 )
{
    cam_zoom = lerp(cam_zoom, zoom_target, cam_lerp);
    cam_w = view_w*cam_zoom;
    cam_h = view_h*cam_zoom;
    camera_set_view_size(cam, cam_w, cam_h);
}

if ( follow != noone )
{

}
else 
{
    // Powrót do braku obrotu przy braku celu
    cam_angle += angle_difference(0, cam_angle)*cam_lerp;
    camera_set_view_angle(cam, cam_angle);

    if ( mouse_check_button(mb_middle) )
    {
        var md_x = window_mouse_get_delta_x();
        var md_y = window_mouse_get_delta_y();
        
        x -= md_x*cam_zoom;
        y -= md_y*cam_zoom;
    }
}

// Wygładzanie pozycji focal point (cam_x, cam_y)
cam_x = lerp(cam_x, x, cam_lerp);
cam_y = lerp(cam_y, y, cam_lerp);

camera_set_view_pos(cam, x-cam_w*0.5, y-cam_h*0.5);