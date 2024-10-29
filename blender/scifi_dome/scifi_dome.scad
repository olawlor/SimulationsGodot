/*
 Sci-fi dome shape.
 Not a regular geodesic dome.

 Dr. Orion Lawlor, lawlor@alaska.edu, 2024-10-28 (Public Domain)
*/

$fs=0.1; $fa=5; // fine detail

// Make this 3D vector have unit length
function normalize(p) = p * (1.0/norm(p));

/// Create a transform matrix so the Z axis is facing this way,
///   and S is the new origin.
module point_Z_axis_toward(Znew,S)
{
    Z=normalize(Znew); // direction (new Z)
    Y=normalize(cross(Z,[0.001,-0.001,1])); // up vector (new Y)
    X=normalize(cross(Y,Z)); // out vector (new X)
    m=[
        [X.x,Y.x,Z.x,S.x],
        [X.y,Y.y,Z.y,S.y],
        [X.z,Y.z,Z.z,S.z]
    ];
    multmatrix(m) children();
}



// Create a tube between these two points
//   OD is diameter of tube
//   tube extends beyond the points by lengthen on both sides
module tube_between(p1,p2, ODraw, enlarge)
{
    OD = ODraw + 2*enlarge;
    hull() {
        for (p=[p1,p2]) translate(p) {
            //sphere(d=OD);
            cube([1,1,1]*OD, center=true);
        }
    }
    /*
    point_Z_axis_toward(p2-p1,p1)
    translate([0,0,-enlarge]) {
        len = norm(p2-p1)+2*enlarge;
        cylinder(d=OD,h=len);
    }
    */
}

// Draw a tube passing through these points
module tube_list(list,OD,enlarge)
{
    for (i=[0:len(list)-1]) 
        tube_between(list[i], list[(i+1)%len(list)], OD, enlarge);
}


domeR = 12000; // radius of dome
domeN = 12; // segments in dome, 30 degrees each

function make_dome_ring(R,Z,N,sa=0) = [
    for (a=[sa:360/N:360+sa+1])
        [R*cos(a), R*sin(a), Z],
];

domeP = make_dome_ring(domeR,0,domeN,0); // outer ring
dome1 = make_dome_ring(domeR*cos(30),domeR*sin(30),domeN,360/domeN/2); // layer 1
dome2 = make_dome_ring(domeR*cos(60),domeR*sin(60),domeN/2,360/domeN*1.5); // layer 2
dome3 = [ [0,0,domeR] ]; // top vertex

OD=100; // diameter of main tubes

// Full list of truss tubes
module truss_tubes(enlarge=0)
{
    for (i=[0:domeN-1]) {
        tube_list([domeP[i],dome1[i],domeP[i+1]],OD,enlarge);
        tube_list([dome1[i],dome2[floor(i/2)],dome1[i+1]],OD,enlarge);
    }
    for (i=[0:domeN/2-1]) {
        tube_list([dome2[i],dome3[0],dome2[i+1]],OD,enlarge);
    }
}

// Drop children at all dome points
module truss_points() {
    for (list = [domeP, dome1, dome2, dome3])
        for (p = list)
            translate(p)
                children();
}

truss_tubes(0);
color([0.3,0.5,0.8,0.3]) hull() truss_points() cube([1,1,1],center=true);

