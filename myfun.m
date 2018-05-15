function o = myfun(bs, im2)

keyboard

im1Block = bs.data;
startInd = bs.location;
endInd   = bs.location+bs.blockSize-1;

im2Block = im2(startInd(1):endInd(1), startInd(2):endInd(2));

o = im1Block+im2Block;
end