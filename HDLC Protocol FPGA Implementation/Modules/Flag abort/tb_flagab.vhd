--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:32:34 11/27/2013
-- Design Name:   
-- Module Name:   D:/PROJ MAIN/PRO-WORK/flagab/tb_flagab.vhd
-- Project Name:  flagab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: flagab
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_flagab IS
END tb_flagab;
 
ARCHITECTURE behavior OF tb_flagab IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flagab
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         a : IN  std_logic;
         z : OUT  std_logic;
			about:out std_logic;
			idlout:out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal a : std_logic := '0';

 	--Outputs
   signal z : std_logic;
	signal about:std_logic;
	signal idlout:std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flagab PORT MAP (
          clk => clk,
          reset => reset,
          a => a,
          z => z,
			 about => about,
			 idlout => idlout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
     reset<='1';
	  a<='1';
   wait for 100 ns;
     reset<='0';
	  a<='0';
	wait for 100 ns;
	a<='1';
	wait for 700 ns;
	--a<='1';
	--wait for 500 ns;
	--a<='0';
	--wait for 100 ns;
--	a<='1';
--	wait for 800 ns;
--	a<='0';
--	wait for 100 ns;
--	a<='1';
--	wait for 700 ns;
      -- hold reset state for 100 ns.
     	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
