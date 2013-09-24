----------------------------------------------------------------------------------
-- THIS CODE CANNOT BE USED OR DISTRIBUTED
-- PLEASE DO NOT DISTRIBUTE THIS CODE WITHOUT THE AUTHOR INFORMATION
-- THIS CODE HAS BEEN DOWNLOADED FROM https://github.com/blindrepo/aescore
-- THIS REPO HAS BEEN SET UP TO HAVE A BLIND REVIEW FOR FPGA 2014
-- AS SOON THE PAPER WILL BE ACCEPTED, THIS CODE WILL BE MOVED ON THE FINAL GITHUB REPO
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;

entity shiftRows is
	
	PORT(
		clk:		in		std_logic;
		input:	in		stateMatrix;
		output:	out	stateMatrix
	);

end shiftRows;

architecture Behavioral of shiftRows is
	signal encStateOut:	stateMatrix;

begin

	
	-- Shifting rows following aes specification
	

	encStateOut(0)(3) <= input(0)(3);
	encStateOut(0)(2) <= input(0)(2);
	encStateOut(0)(1) <= input(0)(1);
	encStateOut(0)(0) <= input(0)(0);

	encStateOut(1)(3) <= input(1)(0);
	encStateOut(1)(2) <= input(1)(3);
	encStateOut(1)(1) <= input(1)(2);
	encStateOut(1)(0) <= input(1)(1);

	encStateOut(2)(3) <= input(2)(1);
	encStateOut(2)(2) <= input(2)(0);
	encStateOut(2)(1) <= input(2)(3);
	encStateOut(2)(0) <= input(2)(2);

	encStateOut(3)(3) <= input(3)(2);
	encStateOut(3)(2) <= input(3)(1);
	encStateOut(3)(1) <= input(3)(0);
	encStateOut(3)(0) <= input(3)(3);
	
	output <= encStateOut;

end Behavioral;