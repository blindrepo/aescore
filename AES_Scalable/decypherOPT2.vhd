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
--use work.round;
--use work.lastRound;
--use work.addRoundKey;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decypherOPT2 is
	PORT(
		clk:				in			std_logic;
		rst:				in			std_logic;
		expKeyReady:	in			std_logic;
		expKey:			in			ExpKeyType;
		enable:			in			std_logic;
		encInput:		in			stateMatrix;
		dataAvailable:	out		std_logic;
		encOutput:		out		stateMatrix
	);
end decypherOPT2;

architecture Behavioral of decypherOPT2 is
	component inv_round is
		PORT(
			clk:			in		std_logic;
			rst:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			enable:		in		std_logic;
			inState:		in		stateMatrix;
			ready:		out	std_logic;
			outState:	out	stateMatrix
		);
	end component;
	
	component inv_lastRound is
		PORT(
			clk:			in		std_logic;
			rst:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			enable:		in		std_logic;
			inState:		in		stateMatrix;
			ready:		out		std_logic;
			outState:	out	stateMatrix
		);
	end component;
	
	component inv_addRoundKey is
		PORT(
			clk:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			inState:		in		stateMatrix;
			outState:	out	stateMatrix
		);
	end component;
	
	signal 	partialKeyArray:			partialExpKeyArrayType;	
	signal	enablerArray:				std_logic_vector(N_ROUND downto 0);
	signal	enablerArray_next:		std_logic_vector(N_ROUND downto 0);
	signal	regist_next:				arrStateMatrix_type;
	signal	regist:						arrStateMatrix_type;
	signal 	encOutput_next:			stateMatrix;
	signal	dataAvailable_next:		std_logic;

	
	type STATE_TYPE is (CHECK, RESET, ACTIVE);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;

begin

	--k(0) <= expKey(15 downto 0);
	

	process(expKey)
			variable		n:		integer range 0 to N_ROUND	:= 0;				
			variable		i:		integer range 0 to 15	:= 0;				
	begin	
		for n in 0 to N_ROUND loop
				for i in 0 to 15 loop
					partialKeyArray(n)(i) <= expKey((n*16) + i);
				End loop;
		End loop;
	End process;	
		

	inv_firstAddRoundKey_instance:  inv_addRoundKey PORT MAP (clk, partialKeyArray(N_ROUND), encInput, regist_next(N_ROUND));
	
	inv_roundManager:		FOR j IN N_ROUND downto 2 GENERATE
								generalRound:  inv_round PORT MAP (clk, rst, partialKeyArray(j-1), enablerArray(j), regist(j), enablerArray_next(j-1), regist_next(j-1));
							END GENERATE;

	inv_lastRound_instance:  inv_lastRound PORT MAP (clk, rst, partialKeyArray(0), enablerArray(1), regist(1), enablerArray_next(0), regist_next(0));
		


	COMBIN: process(CURRENT_STATE, expKeyReady, enable, enablerArray, regist)
	begin
	--if (enabled='1') then
		 case CURRENT_STATE is
			when RESET => 
					dataAvailable_next <= '0';
					enablerArray_next(N_ROUND) <= '0';
					NEXT_STATE <= CHECK;
					 
			when CHECK =>
					if (expKeyReady='1') then
						if (enable = '1') then
							enablerArray_next(N_ROUND) <= '1';
							NEXT_STATE <= ACTIVE;
						else
							NEXT_STATE <= RESET;
						End if;
					else
						NEXT_STATE <= RESET;
					End if;
					
			when ACTIVE =>		
					dataAvailable_next <= enablerArray(0);
					encOutput_next <= regist(0);				
					enablerArray_next(N_ROUND) <= enable;	
					
					NEXT_STATE <= ACTIVE;
					
					
					
		 end case;
	--end if;
	end process;
						

  SYNCH: process
  begin
	if (clk'event and clk = '1') then
		if (rst='1') then
			CURRENT_STATE <= RESET;
		else
			 CURRENT_STATE <= NEXT_STATE;
			 regist <= regist_next;
			 dataAvailable <= dataAvailable_next;
			 enablerArray <= enablerArray_next;
			 encOutput <= encOutput_next;
		End if;
	End if;
  end process;
			  


end Behavioral;

