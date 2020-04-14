#Python/Jython code written by Russell Ligon, Feb 2018.
#Reads raw pixel values from image stack in imagej and converts to single row of data
#binding all into compositve csv using 'ab' (append binary)

from ij import IJ
import os, csv

# 1 - Gets open image and calls it 'imp'
imp = IJ.getImage()



# 2 - Prepare stacks to split slices
stack = imp.getStack()

# prepare path
#root = "C:\\Users\\Rusty\\Amazon Drive\\MICE\\Thermal\\test2\\test3"
#filename =nameout
#fullpath = os.path.join(root, filename)

#2a - fullpath, from nameout, which is defined in imageJ macro, is a complete file path including "C:\...\Outname.csv"

fullpath = nameout

#print fullpath

# 3 - Iterate all slices
for i in range(1, imp.getNSlices()+1):
    slice = stack.getProcessor(i)
    pix_noo = slice.getPixels()
    #stack.getSliceLabel(i)
    #noo =FloatProcessor(imp.width, imp.height)
    #pix_noo = noo.getPixels()
	#print(pix)

	# open the file first (if its not there, newly created)
    f = open(fullpath, 'ab')#append binary = ab

	#	f.write(pix_noo)

	# create csv writer
    writer = csv.writer(f)
    writer.writerow(pix_noo)
    f.close()
f.close()