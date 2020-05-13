




// Macro imports a series of ; or , delimited csv text images as a stack, makes avi video
// and saves composite data where each row = one frame from the stack
// Written by Russell Ligon, February 26, 2018
//


  run("Close All");
  
  Parentdir = getDirectory("Choose trial directory containing subfolders, each containing tiffs");
  print(Parentdir);
  outdir = getDirectory("Choose parent outputfolder");
  
  fileList=getFileList(Parentdir);
  folderList=newArray();
  
  
//This loops through contents of Parentdir
// and keeps only folders (which end with /)

for(i=0; i<fileList.length; i++){ // list only sub-folder names
 	if(endsWith(fileList[i], "/")==1)
		folderList = Array.concat(folderList, fileList[i]);		
}


print("There are "+folderList.length+" folders to process");

TimeStamp = "true";

  if(TimeStamp=="true"){
	  /*
	  Dialog.create("TimeStamp Settings");
		Dialog.addNumber("FontSize", 10);
		Dialog.addNumber("x coordinates", 5);
		Dialog.addNumber("y coordinates",470);
		Dialog.addChoice("FontColor",newArray("white","yellow","green","pink"));
	  Dialog.show();
	*/
		//fontS= Dialog.getNumber();
		//x1= Dialog.getNumber();
		//y1 = Dialog.getNumber();	
		//col = Dialog.getChoice();
		fontS=10;
		x1= 5;
		y1 = 470;	
		col = "white";
  }
  

for(q=0; q<folderList.length; q++){ // cycle through every folder in folderList
  print("Processing folder "+(q+1)+" out of "+folderList.length);
  
		foldernombre=folderList[q];
		folderDIR2=Parentdir+foldernombre;
		folderDIR3= replace(folderDIR2, "\\", "/");
		folderDIR4= folderDIR3;
		//folderDIR4= replace(folderDIR3, "/", "\\");
		print(folderDIR4);

				
	
		outviddirOUT=outdir+foldernombre;
		outviddirOUT3= replace(outviddirOUT, "\\", "/");
		outviddirOUT4=outviddirOUT3;
		//outviddirOUT4= replace(outviddirOUT3, "/", "\\");
		
		File.makeDirectory(outviddirOUT4);

		dir=folderDIR4;	
		print(outviddirOUT4);
 
 
	list = getFileList(folderDIR4);
	tifList=newArray();			
				
	for(i=0; i<list.length; i++) // list only csv files
		if(endsWith(list[i], ".tif")==1)
			tifList = Array.concat(tifList, list[i]);
		
																									   

 
 

  openimages=0;
  

		file = dir + tifList[0];
					

					run("Image Sequence...", "open=["+file+"] sort use");
					original=getTitle(); 
					run("Duplicate...", "duplicate");
					duper=getTitle(); 
					
					selectWindow(original);
					close();
					
					selectWindow(duper);
					



	  
		 
		run("Subtract Background...", "rolling=10 sliding stack");

	
		run("Image Sequence... ", "format=TIFF use save=["+outviddirOUT4+"/test0000.tif]");
		close();
	  }
  


  
