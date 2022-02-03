plot "dual_gps.txt" using 1:2 w lp, "dual_gps.txt" using (-1*$3+$4/60):($5+$6/60) w lp
pause 5 
reread

