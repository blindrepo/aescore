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

entity rotWord is
	PORT(
		clk:				in			std_logic;
		keyWordIn:		in			keyWordType;
		keyWordOut:		out		keyWordType
	);
end rotWord;

architecture Behavioral of rotWord is
begin
	
	keyWordOut(0) <= keyWordIn(1);
	keyWordOut(1) <= keyWordIn(2);
	keyWordOut(2) <= keyWordIn(3);
	keyWordOut(3) <= keyWordIn(0);
	
end Behavioral;

