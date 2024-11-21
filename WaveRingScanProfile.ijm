//This macro generates a series of concentric rings and extracts the mean fluorescence intensity profiles at each ring in a time series.

run("Clear Results");

//make sure to save the image stack in a local folder first. 
imageTitle=getTitle; 

//ask user to draw a circle to fit the radial wave so that the center of the wave (xc and yc) can be located.
waitForUser("Please draw a circle to fit the radial wave and click OK");
run("Fit Circle");  //apply a "Fit Circle" function so that user do not need to draw a perfect circle  
run("Set Measurements...", "centroid redirect=None decimal=3")
run("Measure");
xc = getResult("X"); 
yc = getResult("Y");

//waitForUser("make point in the centre");
//getSelectionCoordinates(x, y);
// xc = x[0];
 //yc = y[0];


//creates a series of concentric rings start with a radius of 5 pixels, ending at 200 pixesl, with a step size of 5 pixels. 
//uses could adjust the values to fit their cases.
for(i=5; i<=200; i+=5){
	 radius = i;
	 makeOval(xc-radius,yc-radius,radius*2,radius*2);
	 Overlay.addSelection("green", 1);
     run("Area to Line");
     run("Line Width...", "line=2");
     run("Plot Z-axis Profile");
     xpoints = newArray ();
	 ypoints = newArray ();
	 Plot.getValues (xpoints, ypoints);
    
//Loop2: for each  profile, saves the values of the profile in a table
     for (j = 0; j < xpoints.length; j++) {    	
    	setResult(i, j, ypoints[j]);
  	  }  
  close();
  selectWindow(imageTitle);
  }
setBatchMode(false);  

//save the results table into a Excel file in local drive defined by user; the excel file needs to be closed when running the macro   
//user need to download and install the "Read and Write Excel" plugin in order to run this function;
  
run("Read and Write Excel", "file=[/Users/.../.../...xlsx]");
