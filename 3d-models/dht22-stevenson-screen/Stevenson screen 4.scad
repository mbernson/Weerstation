// All units are in millimeters
width = 40; // Width of a ring
inner_width = 30; // Width of the inner/smaller part of a ring
height = 20; // Height of a single ring
stick_width = 6; // M6 = 6mm
margin = 1; // Wall thickness

count = 3; // Ring count
offset = inner_width; // Mounting hole offset
bottom_height = height/4; // Bottom plate height

module dht22() {
    color("red") cube([15,7.8,25]);
}

module bottom_plate(height) {
    difference() {
        union() {
            // Dht22 stand
            translate([-10, -5, 0]) cube([20, 5, 60]);
            
            difference() {
                cylinder(h=height,r1=width-margin*2,r2=width-margin*2);
                translate([0, 5, 0]) cylinder(h=height,r1=width/10,r2=width/10);
            }
            translate([offset, 0, height]) stick(width=stick_width, height=height);
            translate([-offset, 0, height]) stick(width=stick_width, height=height);
        }
        // Mounting holes
        translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
        translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
    }
}

module ring(width=10, height=3, closed=false) {
    difference() {
        cylinder(h=height,r1=width,r2=width);
        cylinder(h=height,r1=width-margin*2,r2=width-margin*2);
    }
    
    translate([0, 0, height])
        difference() {
            cylinder(h=height,r1=width,r2=inner_width);
            if(!closed){
                cylinder(h=height,r1=width-margin*2,r2=inner_width-margin*2);

            }
            translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
            translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
        }
}

module stick(height=1) {
    difference () {
        cylinder(h=height,r1=width,r2=width);
        cylinder(h=height,r1=width/2,r2=width/2);
    };
}

module cap() {
    difference() {
        cylinder(h=height*2,r1=width,r2=0);
        translate([0, 0, -height/2])
        cylinder(h=height*2,r1=width,r2=0);
    }
}

bottom_plate(height=bottom_height);
%translate([-7.5, 0, 30]) dht22();

translate([0, 0, bottom_height*2])
for(y=[0:height:count*height-1]) {
    translate([0, 0, y]) ring(width=width, height=height/2);
    translate([offset, 0, y]) stick(width=stick_width, height=height);
    translate([-offset, 0, y]) stick(width=stick_width, height=height);
}

cap_y=count*height+height/2;
%translate([0, 0, cap_y])
union() {
    ring(width=width, height=height/2, closed=true);
    translate([offset, 0, 0]) stick(width=stick_width, height=height/2);
    translate([-offset, 0, 0]) stick(width=stick_width, height=height/2);
}