----------------------------------------------------------------------------------
-- THIS CODE CANNOT BE USED OR DISTRIBUTED
-- PLEASE DO NOT DISTRIBUTE THIS CODE WITHOUT THE AUTHOR INFORMATION
-- THIS CODE HAS BEEN DOWNLOADED FROM https://github.com/blindrepo/aescore
-- THIS REPO HAS BEEN SET UP TO HAVE A BLIND REVIEW FOR FPGA 2014
-- AS SOON THE PAPER WILL BE ACCEPTED, THIS CODE WILL BE MOVED ON THE FINAL GITHUB REPO
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY mytetst_vhd IS
END mytetst_vhd;

ARCHITECTURE behavior OF mytetst_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT aesCore
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		readKeyCmd : IN std_logic;
		partialKey : IN std_logic_vector(31 downto 0);
		enableEnc : IN std_logic;
		enableDec : IN std_logic;
		encInput : IN std_logic_vector(0 to 3);
		decInput : IN std_logic_vector(0 to 3);          
		encOutAvailable : OUT std_logic;
		decOutAvailable : OUT std_logic;
		encOutput : OUT std_logic_vector(0 to 3);
		decOutput : OUT std_logic_vector(0 to 3);
		ready : OUT std_logic;
		errorEnc : OUT std_logic;
		errorDec : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '0';
	SIGNAL readKeyCmd :  std_logic := '0';
	SIGNAL enableEnc :  std_logic := '0';
	SIGNAL enableDec :  std_logic := '0';
	SIGNAL partialKey :  std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL encInput :  std_logic_vector(0 to 3) := (others=>'0');
	SIGNAL decInput :  std_logic_vector(0 to 3) := (others=>'0');

	--Outputs
	SIGNAL encOutAvailable :  std_logic;
	SIGNAL decOutAvailable :  std_logic;
	SIGNAL encOutput :  std_logic_vector(0 to 3);
	SIGNAL decOutput :  std_logic_vector(0 to 3);
	SIGNAL ready :  std_logic;
	SIGNAL errorEnc :  std_logic;
	SIGNAL errorDec :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: aesCore PORT MAP(
		clk => clk,
		rst => rst,
		readKeyCmd => readKeyCmd,
		partialKey => partialKey,
		enableEnc => enableEnc,
		enableDec => enableDec,
		encInput => encInput,
		decInput => decInput,
		encOutAvailable => encOutAvailable,
		decOutAvailable => decOutAvailable,
		encOutput => encOutput,
		decOutput => decOutput,
		ready => ready,
		errorEnc => errorEnc,
		errorDec => errorDec
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
