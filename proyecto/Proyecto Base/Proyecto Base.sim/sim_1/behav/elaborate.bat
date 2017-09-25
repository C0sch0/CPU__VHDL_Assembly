@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto a35b2fba0be742e6ac0032a12eca4df6 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot Basys3_behav xil_defaultlib.Basys3 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
