binwidth=10000
bin(x,width)=width*floor(x/width)
plot "output.txt" using(bin($1,binwidth)):(1.0) smooth freq with boxes
pause 10
