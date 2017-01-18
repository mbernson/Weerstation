// All units are in millimeters
bearing_outer_diameter = 19;
axle_diameter = 6+2; // M6 = 6mm
margin = 2; // How thick the walls should be
  
bottom_height = 30;
bottom_width = 60;

tube_width = bearing_outer_diameter + margin;
tube_height = 60;

module cap(width) {
    height = 2;
    cone_height = height * 4;
    difference() {
        union() {
            translate([width/2, width/2, height])
                cylinder(h=cone_height, r1=width/2, r2=0);
            cube([width, width, height]);
        }
        translate([width/2, width/2])
            cylinder(h=height*10, r1=axle_diameter/2, r2=axle_diameter/2);
        cube([width/2, width, cone_height]);
    }
}

module tube(height = 40, width=40) {
    difference() {
        cube([width, width, height]);
        //Bottom hole
        translate([width/2, width/2, 0])
            cylinder(h=1, r1=axle_diameter/2, r2=axle_diameter/2);
        
        //Upper hole
        translate([width/2, width/2, 1])
            cylinder(h=height, r1=bearing_outer_diameter/2, r2=bearing_outer_diameter/2);
        cube([width/2, width, height]);
    }
}



module bottom(height, width, wiring_hole_diameter=8) {
    difference() {
        cube([width, width, height]);
        translate([margin/2, margin/2, margin/2])
            cube([width-margin, width-margin, height-margin]);

        translate([width/2, width/2, height/2])
            cylinder(h=height, r1=axle_diameter/2, r2=axle_diameter/2);
        cube([width/2, width, height]);
        
        translate([width/2, width/2 , -height/2])
            cylinder(h=height, r1=wiring_hole_diameter/2, r2=wiring_hole_diameter/2);
    }
}

//Bottom
bottom(bottom_height, bottom_width);

//Tube
union() {
    //Tube
    translate([bottom_width/2-tube_width/2, bottom_width/2-tube_width/2, bottom_height+1])
        tube(tube_height, tube_width);
    //Cap
    translate([bottom_width/2-tube_width/2, bottom_width/2-tube_width/2, tube_height + bottom_height]) 
        cap(width=bearing_outer_diameter + margin);
}