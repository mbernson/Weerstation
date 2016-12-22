bearing_outer_diameter = 10;
axle_diameter = 6;
margin = 2; // How thick the walls should be
  
bottom_height = 20;
bottom_width = 20;

houder_width = bearing_outer_diameter + margin;
houder_height = 40;

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

module bottom(height, width, wiring_hole_diameter=6) {
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

module houder(height = 40, width=40) {  
    difference() {
        cube([width, width, height]);
        translate([width/2, width/2])
            cylinder(h=height, r1=bearing_outer_diameter/2, r2=bearing_outer_diameter/2);
        cube([width/2, width, height]);
    }
}

union() {
    // Bottom part
    bottom(height=bottom_height, width=bottom_width);
    // Middle part
    translate([bottom_width/2-houder_width/2, bottom_width/2-houder_width/2, bottom_height])
        houder(height=houder_height, width=houder_width);
    // Cap
    translate([bottom_width/2-houder_width/2, bottom_width/2-houder_width/2, houder_height + bottom_height]) 
        cap(width=bearing_outer_diameter + margin);
}