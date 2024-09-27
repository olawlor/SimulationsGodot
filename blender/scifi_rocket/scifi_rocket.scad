/*
Truss based science fiction rocket

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

// Y axis symmetry
function flip(p) = [ p[0], -p[1], p[2] ];
// Z axis symmetry
function flop(p) = [ p[0], p[1], -p[2] ];
// X axis symmetry
function back(p) = [ -p[0], p[1], p[2] ];

// Tube list, then flipped
module tube_listF(pair,OD,enlarge)
{
    tube_list(pair,OD,enlarge);
    tube_list([flip(pair[0]),flip(pair[1])],OD,enlarge);
}
// Tube list, then back
module tube_listB(pair,OD,enlarge)
{
    tube_list(pair,OD,enlarge);
    tube_list([back(pair[0]),back(pair[1])],OD,enlarge);
}
// Tube list, flipped and flopped
module tube_listFF(pair,OD,enlarge)
{
    tube_listF(pair,OD,enlarge);
    tube_listF([flop(pair[0]),flop(pair[1])],OD,enlarge);
}

OD=50; // diameter of main tubes

center=[3800,0,0];
front=[3200,800,0];
cheek=[2200,1000,700]; // outside corner of hull

bump = [1500,0,900]; // bump on top/bottom faces
thrust = [-cheek[0]-800,0,0]; // rocket engine mount
box=[cheek,bump,flip(cheek),
flop(flip(cheek)), flop(bump), flop(cheek)];

// One side's vertexes
vertexlist_oneside=[
    center,
    front,
    cheek, flop(cheek),
    back(cheek), back(flop(cheek))
];

// Full set of pressure hull vertexes
vertexlist_pressure = [ bump, flop(bump), back(bump), back(flop(bump)), 
    for (p=vertexlist_oneside) p, 
    for (p=vertexlist_oneside) flip(p) 
];

// Full set of framed vertexes
vertexlist_thrust = [ 
    for (p=vertexlist_pressure) p, 
    thrust
];

// Thrust structure
module truss_thrust(enlarge=0)
{
    for (i=[0:len(box)-1]) {
        b=box[i];
        tube_list([thrust,back(b)],OD,enlarge);
    }
}

// Full list of truss tubes
module truss_tubes(enlarge=0)
{
    tube_listF([front, center],OD,enlarge);
    tube_listF([front, cheek],OD,enlarge);
    tube_listFF([cheek, center],OD,enlarge);
    tube_listF([front, flop(cheek)],OD,enlarge);
    
    tube_listB([cheek,flip(cheek)],OD,enlarge);
    tube_listB([flop(cheek),flop(flip(cheek))],OD,enlarge);
    
    // Edges around box
    for (i=[0:len(box)-1]) {
        b=box[i];
        n=box[(i+1)%len(box)];
        
        tube_list([b,back(b)],OD,enlarge); // front-back sides
        tube_list([b,n],OD,enlarge); // front rect
        tube_list([back(b),back(n)],OD,enlarge); // back rect
        if (i>=1 && i<=3) {
            tube_list([b,back(n)],OD,enlarge); // diagonal
        } else {
            tube_list([back(b),n],OD,enlarge); // diagonal facing other way
        }
    }
    truss_thrust(enlarge);
}



// One generic truss vertex, centered at this point
module truss_vertex(p,wall=6,range=100) 
{
    intersection() {
        translate(p) rotate([0,90,0]) sphere(r=range);
        
        union() {
            //translate(p) sphere(r=OD/2+wall);
            truss_tubes(wall);
        }
    }
}

module truss_vertexes(wall=6)
{
    for (p = vertexlist_thrust) truss_vertex(p,wall);
}

// Entire spacecraft pressure volume
module craft_solid(enlarge=0)
{
    hull() {
        for (p = vertexlist_pressure) translate(p) cube([1,1,1]*(1+2*enlarge),center=true);
    }
}

module craft_frame() {
    difference() {
        union() {
            truss_tubes();
            truss_vertexes();
        }
        
        craft_solid(0);
    }
    truss_thrust();
}

craft_solid(0); // panels
craft_frame(); // frame


