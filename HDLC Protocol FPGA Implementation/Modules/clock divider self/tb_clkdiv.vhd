--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:42:09 11/27/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/clkdiv/tb_clkdiv.vhd
-- Project Name:  clkdiv
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clkdiv
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
 
ENTITY tb_clkdiv IS
END tb_clkdiv;
 
ARCHITECTURE behavior OF tb_clkdiv IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clkdiv
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ckout : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

	--BiDirs
   signal ckout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 0.02 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clkdiv PORT MAP (
          clk => clk,
          reset => reset,
          ckout => ckout
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
      -- hold reset state for 100 ns.
      wait for 100 ns;
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
