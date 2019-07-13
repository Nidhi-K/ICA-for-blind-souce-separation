function [o] = g(s)
o = 1./(1+exp(-1.*s)); % the '.' allows us to apply g to each element of a matrix if we pass in a matrix 
end

