width=10;
height=5;
stick_width=2;

module dht22() {
    color("red") cube([1.5,0.78,2.5]);
}

module bottom_plate() {
    difference() {
        union() {
            translate([-1, -0.5, 0]) cube([2, 0.5, 6]);
            difference() {
                cylinder(h=1,r1=width*0.9,r2=width*0.9);
                translate([0, 0.5, 0]) cylinder(h=height,r1=width/10,r2=width/10);
            }
        }
        translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
        translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
    }
}

module ring(width=10, height=3, wall=0.5, res=50, closed=false) {
    inner_width = width*0.7;
    difference() {
        cylinder(h=height,r1=width,r2=width);
        cylinder(h=height,r1=width-wall*2,r2=width-wall*2);
    }
    
    translate([0, 0, height])
        difference() {
            cylinder(h=height,r1=width,r2=inner_width);
            if(!closed){
                cylinder(h=height,r1=width-wall*2,r2=inner_width-wall*2);
                translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
                translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
            }
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


bottom_plate();
%translate([-0.75, 0, 3]) dht22();

count=3;
offset=width*0.7;
translate([0, 0, height/2])
for(y=[0:height:count*height-1]) {
    translate([0, 0, y]) ring(width=width, height=height/2, wall=0.25);
    translate([offset, 0, y]) stick(width=stick_width, height=height);
    translate([-offset, 0, y]) stick(width=stick_width, height=height);
}

cap_y=count*height+height/2;
%translate([0, 0, cap_y])
union() {
    ring(width=width, height=height/2, wall=0.25, closed=true);
    translate([offset, 0, 0]) stick(width=stick_width, height=height/2);
    translate([-offset, 0, 0]) stick(width=stick_width, height=height/2);
}