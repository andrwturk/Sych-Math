function result = shiftDotProd(block1,block2,shift)
if size(block1,1) > 1
    block1 = block1';
end

if size(block2,1) > 1
    block2 = block2';
end

if shift>0
    b1 = block1(1:(end-shift));
    b2 = block2((shift+1):end);
else
    b1 = block1((abs(shift)+1):end);
    b2 = block2(1:(end-abs(shift)));
end

result = b1*b2' ./ numel(b1);
end
