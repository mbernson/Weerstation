res=40;
height=3;
width=6;
stick_width=0.5;

module dht22() {
    color("red") cube([1.5,0.78,2.5]);
}

module bottom_plate() {
    difference() {
        union() {
            translate([-1, -0.5, 0]) cube([2, 0.5, 6]);
            difference() {
                cylinder(h=1,r1=width*0.9,r2=width*0.9,$fn=res);
                translate([0, 0.5, 0]) cylinder(h=height,r1=width/10,r2=width/10,$fn=res);
            }
        }
        translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2,$fn=res);
        translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2,$fn=res);
    }
}

module ring(width=10, height=3, wall=0.5, res=50, holes=true) {
    inner_width = width*0.7;
    difference() {
        cylinder(h=height,r1=width,r2=width,$fn=res);
        cylinder(h=height,r1=width-wall*2,r2=width-wall*2,$fn=res);
    }
    
    translate([0, 0, height])
        difference() {
            cylinder(h=height,r1=width,r2=inner_width,$fn=res);
            if(holes){
                cylinder(h=height,r1=width-wall*2,r2=inner_width-wall*2,$fn=res);
                translate([offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2,$fn=res);
                translate([-offset, 0, 0]) cylinder(h=height,r1=stick_width/2,r2=stick_width/2,$fn=res);
            }
        }
}

module stick() {
    difference () {
        cylinder(h=height,r1=width,r2=width,$fn=res);
        cylinder(h=height,r1=width/2,r2=width/2,$fn=res);
    };
}

module cap() {
    difference() {
        cylinder(h=height*2,r1=width,r2=0,$fn=res);
        translate([0, 0, -height/2])
        cylinder(h=height*2,r1=width,r2=0,$fn=res);
    }
}


bottom_plate();
translate([-0.75, 0, 3]) dht22();

count=0;
offset=width*0.7;
translate([0, 0, height/2])
for(y=[0:height:count*height-1]) {
    translate([0, 0, y]) ring(width=width, height=height/2, wall=0.25);
    translate([offset, 0, y]) stick(width=stick_width);
    translate([-offset, 0, y]) stick(width=stick_width);
}

cap_y=count*height+height/2;
%translate([0, 0, cap_y]) ring(width=width, height=height/2, wall=0.25, holes=false);

//cap_y=(count+1)*height;
//translate([0, 0, cap_y]) cap();
//translate([-offset, 0, cap_y]) stick();
//translate([offset, 0, cap_y]) stick();

