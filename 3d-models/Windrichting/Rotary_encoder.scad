overall_height = 3;

//Encoder
encoder_width = 50;

//Center row
center_width = 12;
axle_diameter = 6;

//Inner row
inner_width = 22;

//Middle row
middle_width = 32;

//Outer row
outer_width = 42;

module encoder(width, height) {
    difference() {
        translate([width/2, width/2]) cylinder(h=height, r1=width/2, r2=width/2, $fn=50);
        translate([width/2, width/2])
            cylinder(h=height, r1=axle_diameter/2, r2=axle_diameter/2);
    }
}

module center_row(width, height) {
    difference() {
        cylinder(h=height, r1=width/2, r2=width/2, $fn=50);
        cylinder(h=height, r1=axle_diameter/2, r2=axle_diameter/2);
    }
}

module inner_row(width, height) {
    difference() {        
        cylinder(h=height, r1=width/2, r2=width/2, $fn=50);
        translate([-width/2, 0]) cube([width, width/2, height]);
        union() {
            cylinder(h=height, r1=center_width/2, r2=center_width/2, $fn=50);
        }
    }
}

module middle_row(width, height) {
    difference() {        
        cylinder(h=height, r1=width/2, r2=width/2, $fn=50);
        rotate([0,0,-90]) translate([-width/2, 0]) cube([width, width/2, height]); 
        union() {
            cylinder(h=height, r1=inner_width/2, r2=inner_width/2, $fn=50);
        }     
    }
}

module outer_row(width, height) {
    difference() {
        cylinder(h=height, r1=width/2, r2=width/2, $fn=50);
        for(a=[0:1:360]) { 
            if(!(a >= 45 && a <= 135) && !(a >= 225 && a <= 315)) {
                rotate([0,0,a]) cube([width/2, 1, height]);
            }             
        }
        union() {
            cylinder(h=height, r1=middle_width/2, r2=middle_width/2, $fn=50);
        }
    }
}

union() {
    difference() {
        //Encoder disk
        encoder(encoder_width, overall_height);
        //Inner row
        translate([encoder_width/2, encoder_width/2]) inner_row(inner_width, overall_height);
        //Middle row
        translate([encoder_width/2, encoder_width/2]) middle_row(middle_width, overall_height);
        //Outer row
        translate([encoder_width/2, encoder_width/2]) outer_row(outer_width, overall_height);
    }
    //Center
    translate([encoder_width/2, encoder_width/2]) center_row(center_width, overall_height);
}
