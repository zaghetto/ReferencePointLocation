%Note: this might be eventualy deleted!
%Main reason is that, while num2str does that, this function was created due to "coder" plugin from Matlab.

function s = num2strSpecial(n)
   s = [];
   while n > 0
      d = mod(n,10);
      s = [char(48+d), s];
      n = (n-d)/10;
   end
end