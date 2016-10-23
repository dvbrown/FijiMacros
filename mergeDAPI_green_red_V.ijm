/*
This macro expects files in a slide specific directory to be labelled 1_OLIG.tif etc
The second field of this slide is to be named 2_OLIG.tif. The macros goes through and does a background correction
binarisation and merging of channels. The merging is done by stack and not channel
if one of the images has no signal.
The number of fields is currently HARD CODED. I should change this eventually. There is no quantification of results here.
*/

// Retrieve the parameters for the current iteration
dir1 = getDirectory("Choose the parental folder containing the images");

// Background correct, threshold and make binary
function maskDAPI(image) 
	{
	open(dir1 + image);
    run("Enhance Contrast", "saturated=0.35");
	run("Convert to Mask");
    run("Fill Holes");
    run("Outline");
    run("16-bit");
	}

function merge(image1, image2, image3) {
	//Merge channels and save a new file
	//run("Merge Channels...", "c1=" + image1 + " c2=" + image2 + " c3=" + image3 + " create"); // This needs updating to FIJI
    run("Merge Channels...", "c1=" + image1 + " c2=" + image2 + " c3=" + image3);
	}

// Loop through the list of file names and get pairs of Olig2 and CD44 together

// Intialise a new array containing the first letter of the filenames
//fields = newArray("1","2","3","4","5");
fields = newArray("1","2");

for (i=0; i<fields.length; i++){
	sampleStart = fields[i];
	print(sampleStart);
    dapi = sampleStart + "_" + "DAPI.tif";
	olig = sampleStart + "_" + "OLIG.tif";
	CD44 = sampleStart + "_" + "CD44.tif";
	
    open(dir1 + olig);
    run("Enhance Contrast", "saturated=0.35");
    open(dir1 + CD44);
    run("Enhance Contrast", "saturated=0.35");
    //run("Brightness/Contrast...");
    //waitForUser("Set the threshold of the image", "Use the sliding bar to the desired threshold \nPress 'OK' on this window to continue");
	
	mergedFilename = sampleStart + "_merged.tif";
	maskDAPI(dapi);
	print(mergedFilename);
	merge(CD44, olig, dapi);
	print("The script is running ", olig, " ", CD44, " ", dapi , " ", mergedFilename,"\n");
	}
