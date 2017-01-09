totalHeight = 1;

//Arrow
arrowWidth = 16;
arrowLength = 12;

//Base
baseWidth = 4;
baseLength = -30;

//Vane
vaneAngle = 50;
vaneWidth = 20;
vaneHeight = 10;

//Hole
holeHeight = baseWidth + 1;
holeR1 = totalHeight / 4;
holeR2 = totalHeight / 4;
holeFragments = 100;

module Arrow(length, width, angle, height=totalHeight, heights=undef, center=undef, centerXYZ=[true, false, false]) {
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

module Base(width, length, height = totalHeight) {
    
    //Set the base points
    basePoints = [
       //x,     y,      z
        [0,     0,      0],       //0
        [width, 0,      0],       //1
        [width, length, 0],       //2
        [0,     length, 0],       //3
        [0,     0,      height],  //4
        [width, 0,      height],  //5
        [width, length, height],  //6
        [0,     length, height],  //7 
    ];
  
    //Set the base faces
    baseFaces = [
        [0,1,2,3], //bottom
        [4,5,1,0], //front
        [7,6,5,4], //top
        [5,6,2,1], //right
        [6,7,3,2], //back
        [7,4,0,3] //left
    ];
  
    //Create the base
    polyhedron(basePoints, baseFaces);
}

module Vane(width, angle=60, H, height=totalHeight, heights=undef, center=undef, centerXYZ=[true,false,false]) {
    
    //Calculate the heights at each point
    heightAB = ((heights==undef) ? height : heights[0]) / 2;
	heightBC = ((heights==undef) ? height : heights[1]) / 2;
	heightCD = ((heights==undef) ? height : heights[2]) / 2;
	heightDA = ((heights==undef) ? height : ((len(heights) > 3) ? heights[3] : heights[2])) / 2;
    
    //Calculate the centers
    centerX = (center || (center==undef && centerXYZ[0])) ? 0 : width / 2;
	centerY = (center || (center==undef && centerXYZ[1])) ? 0 : H / 2;
	centerZ = (center || (center==undef && centerXYZ[2])) ? 0 : max(heightAB, heightBC, heightCD, heightDA);
    
    //Calculate the points
    y = H / 2;
	bx = width / 2;
    adX = H / tan(angle);
	dx = (width - (adX * 2)) / 2;

	pointAB1 = [centerX - bx, centerY - y, centerZ - heightAB];
	pointAB2 = [centerX - bx, centerY - y, centerZ + heightAB];
	pointBC1 = [centerX + bx, centerY - y, centerZ - heightBC];
	pointBC2 = [centerX + bx, centerY - y, centerZ + heightBC];
	pointCD1 = [centerX + dx, centerY + y, centerZ - heightCD];
	pointCD2 = [centerX + dx, centerY + y, centerZ + heightCD];
	pointDA1 = [centerX - dx, centerY + y, centerZ - heightDA];
	pointDA2 = [centerX - dx, centerY + y, centerZ + heightDA];
    
    //Set the vane points
    vanePoints = [
        pointAB1,
        pointBC1, 
        pointCD1, 
        pointDA1,
        pointAB2, 
        pointBC2, 
        pointCD2, 
        pointDA2
    ];    
    
    //Set the vane faces
    vaneFaces = [
        [0, 1, 2],
        [0, 2, 3],
        [4, 6, 5],
        [4, 7, 6],
        [0, 4, 1],
        [1, 4, 5],
        [1, 5, 2],
        [2, 5, 6],
        [2, 6, 3],
        [3, 6, 7],
        [3, 7, 0],
        [0, 7, 4]
    ];
    
    //Create the vane
    polyhedron(vanePoints, vaneFaces);
}

module Hole() {
    //Create the hole
    rotate([0,90,0]) cylinder(h=holeHeight, r1=holeR1, r2=holeR1, center=true, $fn=holeFragments);
}

//Show the arrow
translate([0,20,0]) Arrow(width = arrowWidth, length = arrowLength);

//Show the base with hole
difference() {
    translate([baseWidth/-2,20,0]) Base(width = baseWidth, length = baseLength);
    translate([0,2,totalHeight/2]) Hole();
}

//Show the vane
translate([0,-19,0]) Vane(width = vaneWidth, angle = vaneAngle, H = vaneHeight);
