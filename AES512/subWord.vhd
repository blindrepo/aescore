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

entity subWord is
	PORT(
		clk:				in			std_logic;
		keyWordIn:		in			keyWordType;
		keyWordOut:		out		keyWordType
		--outVector:		out	std_logic_vector(31 downto 0);		
	);
end subWord;

architecture Behavioral of subWord is

	component subElement is
		PORT(
			clk:			in		std_logic;
			inValue:		in		keyElement;
			outValue:	out	keyElement
		);
	end component;

begin

	word0:	subElement	PORT MAP  (clk, keyWordIn(0), keyWordOut(0));
	word1:	subElement	PORT MAP	 (clk, keyWordIn(1), keyWordOut(1));
	word2:	subElement	PORT MAP  (clk, keyWordIn(2), keyWordOut(2));
	word3:	subElement	PORT MAP  (clk, keyWordIn(3), keyWordOut(3));
	
end Behavioral;

