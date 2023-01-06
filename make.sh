rm ./snkbin.gb
echo ";-------ASSEMBLING------------------------------------------------------;"
rgbasm -Weverything --halt-without-nop -o snkbin.obj -p 0 main.asm;
echo ""
echo ";-------LINKING---------------------------------------------------------;"
rgblink -d -p 0 -o snkbin.gb -m snkbin.map -n snkbin.sym snkbin.obj;
echo ""
echo ";-------FIXING----------------------------------------------------------;"
rgbfix -v -p 0 snkbin.gb
echo ""
sameboy ./snkbin.gb 
