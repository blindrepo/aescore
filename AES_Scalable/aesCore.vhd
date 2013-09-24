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

-- -------------------------------------
-- DATA TYPE INFORMATION:
--
-- 'stateMatrix' is a 4x4 matrix of std_logic_vector(7 downto 0)
--
-- -------------------------------------

-- #######################################################
--
--
-- #######################################################

entity aesCore is
	PORT(
		clk:					in			std_logic;
		rst:					in			std_logic;
		readKeyCmd:			in 		std_logic;
		partialKey:			in			partialKeyType;
		enableEnc:			in			std_logic;
		enableDec:			in			std_logic;
		encInput:			in			stateMatrix;
		decInput:			in			stateMatrix;
		encOutAvailable:	out		std_logic;
		decOutAvailable:	out		std_logic;
		encOutput:			out		stateMatrix;
		decOutput:			out		stateMatrix;
		ready:				out		std_logic;
		errorEnc:			out		std_logic;
		errorDec:			out		std_logic

	);
end aesCore;

architecture Behavioral of aesCore is


	component encypherOPT2 is
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
	end component;
	
	component decypherOPT2 is
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
	end component;


	component encypherOPT2_noPipe is
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
	end component;
	
	component decypherOPT2_noPipe is
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
	end component;
	
	
	component keyExpander is
	PORT(
			clk:				in			std_logic;
			rst:				in			std_logic;
			keyEnable:		in			std_logic;
			aesKey:			in			std_logic_vector(KEY_SIZE-1 downto 0);		
			expKey:			out		expKeyType;
			expKeyReady:	out		std_logic
	);
	end component;

	signal key:					keyType;
	signal expKey:				expKeyType;
	signal keyReady:			std_logic := '0';
	signal expKeyReady: 		std_logic := '0';
	signal encOutEnable:		std_logic := '0';
	signal decOutEnable:		std_logic := '0';
	signal enableEnc_cmd:	std_logic := '0';
	signal enableDec_cmd:	std_logic := '0';
	
	signal partialKeyCounter_current, partialKeyCounter_next : keyCounterType := KEY_SIZE-1;

	type STATE_TYPE is (RESET, STANDBY, READ_KEY, STARTEXPANSI0N, EXPANDING, KEYAVAILABLE);
    signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
begin

			ready <= expKeyReady;

			----------------------------------------------
			-- 	HERE DESIGN OF KEY SERIAL READING (32 bit step)
			----------------------------------------------			
			
			  COMBIN: process(CURRENT_STATE, readKeyCmd, encOutEnable, expKeyReady, keyReady)
			  begin
					 case CURRENT_STATE is
					   when RESET =>								
								keyReady <= '0';
								partialKeyCounter_next <= KEY_SIZE-1;
								NEXT_STATE <= STANDBY;
						
						-- WAITING FOR READ-KEY COMMAND
						when STANDBY =>							
								if (readKeyCmd='1') then
									NEXT_STATE <= READ_KEY;
								else
									NEXT_STATE <= STANDBY;
								End if;
								
			-- ===================================================================
							
						when READ_KEY =>
							key(partialKeyCounter_current downto (partialKeyCounter_current-31)) <= partialKey;
							
							if (partialKeyCounter_current = 31) then
								NEXT_STATE <= STARTEXPANSI0N;
							else
								partialKeyCounter_next <= partialKeyCounter_current - 32;
								NEXT_STATE <= READ_KEY;
							End if;
							
	
			------------------------- End reading key: step of 32bit 	-----------------------------------
			--			STARTING KEY EXPANSION
			
						when STARTEXPANSI0N =>
								keyReady <= '1';	
								NEXT_STATE <= EXPANDING;
								
						when EXPANDING =>
								if (expKeyReady = '1') then
									NEXT_STATE <= KEYAVAILABLE;
								else
									NEXT_STATE <= EXPANDING;
								End if;
						
						when KEYAVAILABLE =>
								NEXT_STATE <= KEYAVAILABLE;
								
					 end case;
				--end if;
			  end process;
			 
			  -- This process controls the "COMBIN" process 
			  SYNCH: process
			  begin
				if (clk'event and clk = '1') then 
					if (rst='1') then
						CURRENT_STATE <= RESET;
						partialKeyCounter_current <= KEY_SIZE-1;
					else	  
						 CURRENT_STATE <= NEXT_STATE;
						 partialKeyCounter_current <= partialKeyCounter_next;
					End if;
				End if;
			  end process;
			  
			  
			  -- "encController" process controls the encryption core
			  encController: process(keyReady, enableEnc)
			  begin
					if (expKeyReady = '1') then
						if (enableEnc = '1') then
							enableEnc_cmd <= '1';
						else
							enableEnc_cmd <= '0';
						End if;
					else
						if (enableEnc = '1') then
							errorEnc <= '1';
						else
							errorEnc <= '0';
						End if;					
					End if;
			  end process;

			  -- "decController" process controls the decryption core
			  decController: process(keyReady, enableDec)
			  begin
					if (expKeyReady = '1') then
						if (enableDec = '1') then
							enableDec_cmd <= '1';
						else
							enableDec_cmd <= '0';
						End if;
					else
						if (enableDec = '1') then
							errorDec <= '1';
						else
							errorDec <= '0';
						End if;					
					End if;
			  end process;
			  			  
			  

			----------------------------------------------
			-- 	MAPPING KEY EXPANSION
			----------------------------------------------
			
			-- You can avoid keyExpander mapping if you provide the entire expanded key to encCore and decCore using 'expKey' array.
			-- If you don't want to use keyExpander sub-core remember to set 'expKeyReady' signal to 1.

			KEYEXPANDER_ENABLED : if (ENABLE_KEY_EXPANDER = 1) generate
				keyExpansion:  keyExpander PORT MAP (clk, rst, keyReady, key, expKey, expKeyReady);		
			end generate;

			KEYEXPANDER_NOT_ENABLED : if (ENABLE_KEY_EXPANDER /= 1) generate
				expKeyReady <= '1';	
			end generate;
			
						
			----------------------------------------------
			-- 	MAPPING CYPHER AND DECYPHER
			----------------------------------------------
			
			-- Using cypher e decypher with pipeline (use this core on streaming elaboration to maximize performances) 
			
			PIPELINE_ENABLED : if (ENABLE_PIPELINE = 1) generate

				CYPHER_P_ENABLED : if (ENABLE_CYPHER = 1) generate
					encCore:  encypherOPT2 PORT MAP (clk, rst, expKeyReady, expKey, enableEnc_cmd, encInput, encOutAvailable, encOutput);
				end generate;

				DECYPHER_P_ENABLED : if (ENABLE_DECYPHER = 1) generate
					decCore:  decypherOPT2  PORT MAP (clk, rst, expKeyReady, expKey, enableDec_cmd, decInput, decOutAvailable, decOutput);
				end generate;

			end generate;

			PIPELINE_DISABLED : if (ENABLE_PIPELINE /= 1) generate

				CYPHER_ENABLED : if (ENABLE_CYPHER = 1) generate
					encCore:  encypherOPT2_noPipe PORT MAP (clk, rst, expKeyReady, expKey, enableEnc_cmd, encInput, encOutAvailable, encOutput);
				end generate;

				DECYPHER_ENABLED : if (ENABLE_DECYPHER = 1) generate					
					decCore: decypherOPT2_noPipe  PORT MAP (clk, rst, expKeyReady, expKey, enableDec_cmd, decInput, decOutAvailable, decOutput);
				end generate;

			end generate;

						
			
				
end Behavioral;

