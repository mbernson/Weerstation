// All units are in millimeters
ball_diameter = 20;
axle_diameter = 6;

module arm(height, width, length) {
    margin = (width/3)*2;
    cube([width, length, height]);
    
    translate([width/2, length+ball_diameter, 0]) 
    difference() {
        cylinder(h=height,r1=ball_diameter+margin,r2=ball_diameter+margin);
        cylinder(h=height,r1=ball_diameter,r2=ball_diameter);    
        translate([0, -(ball_diameter+margin), 0])
        cube([ball_diameter+margin, (ball_diameter+margin)*2, height]);
    }
}


module part(arm_height, arm_width, arm_length, arm_count) {
    margin = 5;
    difference() {
    union() {
        for(arm=[1:1:arm_count]) {
            mul = 360 / arm_count;
            rotate(a=[0, 0, arm*mul]) 
                translate([-arm_width/2, 0, 0])
                arm(height=arm_height, width=arm_width, length=arm_length);
        }
        cylinder(h=arm_height,r1=arm_width+margin,r2=arm_width+margin);
    }
    cylinder(h=arm_height,r1=axle_diameter,r2=axle_diameter);
    }
}

part(arm_height = 3, arm_width = 6, arm_length = ball_diameter*2, arm_count = 3);