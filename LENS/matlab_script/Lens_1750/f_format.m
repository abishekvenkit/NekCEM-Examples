function out_str = f_format(array,nDigitTotal,type)
% type: can only be 'F' or 'E'
% print fortran format "G14.6" with array of length "num"
% note: print F14.6 only !, can support E14.6E3
if  sum(double(abs(array)<1E-8) .* double(array~=0) .* double(abs(array>1E8))) > 0
    error('digits is not enough, need to expend the code in f_format! \n')
end

% Basic format
sp1 = ' ';
sp2 = '  ';
sp3 = '   ';
sp4 = '    ';

fm0 = ' 0.00000';
fmf = '%.*f'; 
fmE = '%7.*E';

sp_a=''; % space ahead
for i=1:7-(nDigitTotal-1)
    sp_a = [sp_a ' '];
end

switch type
    case 'F'
        % total: 14, after '.': 6, sc: 4
        fm_digit = [sp_a fmf sp4];
    case 'E'
        fm_digit = [sp_a fmE];
end

% nDigitTotal = 7;                      %// Total number of characters
mask = nDigitTotal(ones(size(array)));    %// Create mask

nOrder = floor( log10(array) );           %// find order of magnitude of each element in the matrix
mask = mask - nOrder.*(nOrder>0) -1 ; %// adjust mask according to "nOrder" (only for nOrder>0)
temp = [mask(:)';array(:)'];              %// Stack the vectors and weave them

out_str='';
for i=1:length(array)
    if abs(array(i)) < eps
        f = [sp_a ' ' fm0 sp4];
    elseif array(i) < 0
        f = sprintf(fm_digit,temp(:,i));
    else
        f = sprintf([' ' fm_digit],temp(:,i));
    end
    out_str = [out_str f];
end
% out_str
end

