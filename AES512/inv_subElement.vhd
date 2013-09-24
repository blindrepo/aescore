----------------------------------------------------------------------------------
-- THIS CODE CANNOT BE USED OR DISTRIBUTED
-- PLEASE DO NOT DISTRIBUTE THIS CODE WITHOUT THE AUTHOR INFORMATION
-- THIS CODE HAS BEEN DOWNLOADED FROM https://github.com/blindrepo/aescore
-- THIS REPO HAS BEEN SET UP TO HAVE A BLIND REVIEW FOR FPGA 2014
-- AS SOON THE PAPER WILL BE ACCEPTED, THIS CODE WILL BE MOVED ON THE FINAL GITHUB REPO
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;

entity inv_subElement is
	PORT(
		clk:			in		std_logic;
		inValue:		in		sboxElement_subType;
		outValue:	out	sboxElement_subType
	);
end inv_subElement;

architecture Behavioral of inv_subElement is
	signal sBoxIndex:	integer range 0 to 255;
	signal xIndex:		std_logic_vector(7 downto 0);
	signal yIndex:		std_logic_vector(7 downto 0);
	

	
begin
	
	xIndex <=  "0000" & inValue(3 downto 0);
	yIndex <= inValue(7 downto 4) & "0000";

	sBoxIndex <= to_integer (unsigned (xIndex + yIndex));
	
	
	outValue <= sbox_inv(sBoxIndex);	

		


	
End Behavioral;

