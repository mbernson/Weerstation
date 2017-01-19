// All units are in millimeters
width = 40; // Total diameter
height = 20; // Height of a single ring
stick_width = 6; // M6 = 6mm
margin = 1; // Wall thickness

count = 3; // Ring count
offset = width/2; // Mounting hole offset
bottom_height = height/4; // Bottom plate height

// cylinder(h=height,r1=diameter/2,r2=diameter/2);

module bottom_plate(height) {
    difference() {
        cylinder(h=height,r1=width-margin*2,r2=width-margin*2);

        rotate([0, 0, 90])
        translate([offset, 0, 0]) 
            cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
        rotate([0, 0, 90])
        translate([-offset, 0, 0]) 
            cylinder(h=height,r1=stick_width/2,r2=stick_width/2);
    }
}

module stick(height=1) {
    difference () {
        cylinder(h=height,r1=width,r2=width);
        cylinder(h=height,r1=width/2,r2=width/2);
    };
}

bottom_plate(5);

module Arrow(length, width, angle, height=10, heights=undef, center=undef, centerXYZ=[true, false, false]) {
    //Calcluate the angle
    triangleAngle = (angle!=undef) ? angle : atan(length / (width/2));
	
    //Calcute the length
    triangleLength = (width==undef) ? (length/sin((180-(angle*2))/2)) : (width / cos(triangleAngle))/2;
	
    //Calculate the width
    triangleWidth = (width==undef) ? (cos(angle)*triangleLength)*2:width;
    
	// Calculate Heights at each point
	heightAB = ((heights==undef) ? height : heights[0])/2;
	heightBC = ((heights==undef) ? height : heights[1])/2;
	heightCA = ((heights==undef) ? height : heights[2])/2;
	centerZ = (center || (center==undef && centerXYZ[2])) ? 0 : max(heightAB, heightBC, heightCA);

	// Calculate Offsets for centering
	offsetX = (center || (center==undef && centerXYZ[0])) ? ((cos(triangleAngle) * triangleLength) + triangleWidth) / 3:0;
	offsetY = (center || (center==undef && centerXYZ[1])) ? (sin(triangleAngle) * triangleLength) / 3:0;	
    
    //Calculate the points
	pointAB1 = [-offsetX, -offsetY, centerZ - heightAB];
	pointAB2 = [-offsetX, -offsetY, centerZ + heightAB];
	pointBC1 = [triangleWidth - offsetX, -offsetY, centerZ - heightBC];
	pointBC2 = [triangleWidth - offsetX, -offsetY, centerZ + heightBC];
	pointCA1 = [(cos(triangleAngle) * triangleLength) - offsetX,(sin(triangleAngle) * triangleLength) - offsetY, centerZ - heightCA];
	pointCA2 = [(cos(triangleAngle) * triangleLength) - offsetX,(sin(triangleAngle) * triangleLength) - offsetY, centerZ + heightCA];

    //Set the triangle points
    trianglePoints = [
        pointAB1, 
        pointBC1, 
        pointCA1,
        pointAB2, 
        pointBC2, 
        pointCA2
    ];
    
    //Set the triangle faces
    triangleFaces = [
        [0, 1, 2],
        [3, 5, 4],
        [0, 3, 1],
        [1, 3, 4],
        [1, 4, 2],
        [2, 4, 5],
        [2, 5, 0],
        [0, 5, 3]
    ];
	polyhedron(trianglePoints, triangleFaces);
}

module wipwap(width=42, height=15, depth=10, wall=2) {
    union() {
        cube([width, height, wall]);
        translate([width/2-wall/2, 0, wall])
            cube([wall, height, height]);
        translate([width/2-(stick_width+wall)/2, 0, -stick_width-wall]) difference() {
            cube([stick_width+wall, height, stick_width+wall]);
            rotate([270, 0, 0]) 
            translate([(stick_width+wall)/2, -(stick_width+wall)/2, 0])
                cylinder(h=height*99, r1=stick_width/2, r2=stick_width/2);
        }
        
        translate([width/2, wall, 0])
        rotate([90, 0, 0])
            Arrow(width = width+wall*3, length = height+wall*3, height=wall);
        
        translate([width/2, height, 0])
        rotate([90, 0, 0])
            Arrow(width = width+wall*3, length = height+wall*3, height=wall);
    }
}


translate([-42/2, -15/2, 20])
    wipwap();

