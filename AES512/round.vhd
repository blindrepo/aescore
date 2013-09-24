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


entity round is
	PORT(
		clk:			in		std_logic;
		rst:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		enable:		in		std_logic;
		inState:		in		stateMatrix;
		ready:		out	std_logic;
		outState:	out	stateMatrix
	);
end round;

architecture Behavioral of round is	



-------------------------------------------------------------------------
-----------------      COMPONENT DECLARATION        ---------------------
-------------------------------------------------------------------------
component subBytes is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;	

component shiftRows is
	PORT(
		clk:		in		std_logic;
		input:	in		stateMatrix;
		output:	out	stateMatrix
	);
end component;

component mixColumn is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;

component addRoundKey is
	PORT(
		clk:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;
-------------------------------------------------------------------------
-----------------    END COMPONENT DECLARATION      ---------------------
-------------------------------------------------------------------------

	
	type STATE_TYPE is (RESET, ELABORATING, STANDBY);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
	signal	out0:				stateMatrix;
	signal	out1:				stateMatrix;
	signal	out2:				stateMatrix;
	signal 	outTmp:			stateMatrix;

	
begin

	subBytes_cmp:  		subBytes 		PORT MAP (clk, inState, out0);
	shiftRows_cmp:  		shiftRows 		PORT MAP (clk, out0, out1);
	mixColumn_cmp:  		mixColumn 		PORT MAP (clk, out1, out2);
	addRoundKey_cmp:  	addRoundKey 	PORT MAP (clk, partialKey, out2, outTmp);
	

	process (clk, enable)
	begin
		if(clk='1' and clk'EVENT) then			
			if (enable='1') then
				ready <= '1';
				outState <= outTmp;
			else 
				ready <= '0';		
			End if;
		End if;
	end process;
			  

end Behavioral;

