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


entity subBytes is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end subBytes;

architecture Behavioral of subBytes is

	component subElement is
		PORT(
			clk:			in		std_logic;
			inValue:		in		sboxElement_subType;
			outValue:	out	sboxElement_subType
		);
	end component;

begin	

	-- generating subBytes elaboration units


	subByteI	:  FOR i IN 0 TO 3 GENERATE
		subByteJ	:	FOR j IN 0 TO 3 GENERATE
							new_sByte:  subElement PORT MAP (clk, inState(i)(j), outState(i)(j));
						END GENERATE;						
					END GENERATE;



	
end Behavioral;

