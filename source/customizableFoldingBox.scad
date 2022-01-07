// parameters
box_length = 160;
box_width = 50;
box_height = 30;

printInOne = false;

thickness = 1;
foilHinge_thickness = 0.5;
foilHinge_width = 2;
foilHinge_incision = 2;

anchor_radius = 5;
anchor_width = box_height*3/4;
anchor_baseWidth = anchor_width-2*anchor_radius;
anchor_baseLength = 5;

grommet_width = 1;
grommet_length = anchor_baseWidth+1*anchor_radius;

lid_grommet = true;

lengthCompensation = printInOne==true ? 0 : 2*anchor_baseLength;

length = box_length + lengthCompensation;
width = box_width;
height = box_height;

// main
if(printInOne){
        basicBox();
} else {
    difference(){
        basicBox();
        translate([-(foilHinge_width+height),length,0])
            cube([width+2*height+2*foilHinge_width,height+foilHinge_width,10]);
        translate([-(foilHinge_width+height),length-2*anchor_baseLength,thickness/2])
            cube([width+2*height+2*foilHinge_width,height+foilHinge_width,10]);
    }
}

// modules
module basicBox(){
    linear_extrude(thickness)
    square([width, length]); //base

    translate([0,length,0])
        rotate([0,0,180])
            xSide(); //left side
        
    translate([width,0,0])
            xSide(); //right side

    translate([width,0,0])
        rotate([0,0,180])
            ySide(); //lower side
       
    translate([0,length,0])
            ySide(); //upper side
}

module grommet(){
    linear_extrude(thickness)
        hull() {
            translate([-grommet_length/2,0,0]) 
                circle(grommet_width,$fn=20);
            translate([grommet_length/2,0,0]) 
                circle(grommet_width,$fn=20);
        }
}

module anchor(){
    translate([0,anchor_baseLength,0])
        difference(){
            linear_extrude(foilHinge_thickness)
                hull() {
                    translate([-(anchor_width/2-anchor_radius),0,0]) 
                        circle(anchor_radius,$fn=20);
                    translate([(anchor_width/2-anchor_radius),0,0]) 
                        circle(anchor_radius,$fn=20);
                }
            linear_extrude(foilHinge_thickness)
                translate([-anchor_width/2,-anchor_radius,0])
                    square([anchor_width,anchor_radius]);
                
        }
    translate([-anchor_baseWidth/2,0,0])
        linear_extrude(foilHinge_thickness)
            square([anchor_baseWidth,anchor_baseLength]);
}
    
module xSide(){
    linear_extrude(foilHinge_thickness)
        translate([0,foilHinge_incision/2,0])
            square([foilHinge_width, length-foilHinge_incision]);
    difference(){
        linear_extrude(thickness)
            translate([(foilHinge_width),0,0])
                square([height, length]);
        translate([height/2+foilHinge_width,anchor_baseLength,0])
            grommet();
        translate([height/2+foilHinge_width,length-anchor_baseLength,0])
            grommet();
        if(lid_grommet){
            translate([(height-anchor_baseLength),length/2,0])
                rotate([0,0,90])
                    grommet();
        }
    }
}

module ySide(){
    translate([width,0,0]){
        rotate([0,0,90]){
            linear_extrude(foilHinge_thickness)
                translate([0,foilHinge_incision/2,0])
                    square([foilHinge_width, width-foilHinge_incision]);
            linear_extrude(thickness)
                translate([(foilHinge_width),0,0])
                    square([height, width]);
        }
    }
    
    translate([width,height/2+foilHinge_width,0])
        rotate([0,0,270])
            anchor();
    translate([0,height/2+foilHinge_width,0])
        rotate([0,0,90])
            anchor();
}