--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:03:50 11/27/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/clkflag/tb_clkflag.vhd
-- Project Name:  clkflag
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clkflag
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
 
ENTITY tb_clkflag IS
END tb_clkflag;
 
ARCHITECTURE behavior OF tb_clkflag IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clkflag
    PORT(
         clk : IN  std_logic;
         a : IN  std_logic;
         reset : IN  std_logic;
         cko : INOUT  std_logic;
         y : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal a : std_logic := '0';
   signal reset : std_logic := '0';

	--BiDirs
   signal cko : std_logic;

 	--Outputs
   signal y : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clkflag PORT MAP (
          clk => clk,
          a => a,
          reset => reset,
          cko => cko,
          y => y
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
	
	wait for 2000 ns;
	reset<='0';
	a<='1';
	wait for 8000000 us;
	
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
