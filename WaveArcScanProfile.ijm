
//make sure to save the image stack in a local folder first. 
imageTitle=getTitle; 

//set the width of the arcs
run("Line Width...", "line=5");

run("Clear Results");

//define the x and y Coordinates of the wave initiation site (center).
xc = 111;
yc = 122;

arc_extent = 45; // Angle span of the arc (for 1/8th of a circle, angle = 45)

// Define Pi
pi = 3.14159265358979;

// Create an ROI Manager
run("ROI Manager...");
roiManager("Reset");

//Loop through radius 
for (radius = 5; radius <= 95; radius += 5) {

// Loop through start angles from 0 to 315 with step = 45
for (start_angle = 0; start_angle <= 315; start_angle += 45) {
	
	// Draw 1/8th of a circle as a polyline approximation
	num_points = 20; // Number of points to approximate the arc
	x_prev = xc + radius * cos(start_angle * (pi / 180));
	y_prev = yc - radius * sin(start_angle * (pi / 180));

	for (i = 0; i < num_points; i++) {
	    angle = (start_angle + i * (arc_extent / (num_points - 1))) * (pi / 180); 
	    x_new = xc + radius * cos(angle);
	    y_new = yc - radius * sin(angle);
	    makeLine(x_prev, y_prev, x_new, y_new);
	    roiManager("Add");
	    x_prev = x_new;
	    y_prev = y_new;
	   }

		// Combine the lines to an arc and extract intensity profile
		roiManager("Select", newArray(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19));
		roiManager("Combine");
		roiManager("Add");
		roiManager("Select", 20);
		Overlay.addSelection("#4f90EE90", 1);
		run("Plot Z-axis Profile");
		xpoints = newArray ();
		ypoints = newArray ();
		Plot.getValues (xpoints, ypoints);
	    
	    for (j = 0; j < xpoints.length; j++) {    	
	    	setResult("Radius_" + radius + "angle_" + start_angle, j, ypoints[j]);
	  	  }  
	  close();
	  run("ROI Manager...");
	  roiManager("Reset");
	  selectWindow(imageTitle);

}
}	
	setBatchMode(false);  


//save the results table into a Excel file in local drive defined by user 
//the excel file needs to be closed when running the macro   
//users need to download and install the "Read and Write Excel" plugin in order to run this function;  
run("Read and Write Excel", "file=[/Users/.../.../...xlsx]");
