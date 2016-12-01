--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:44:27 11/25/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/shifreg/tb_shifreg.vhd
-- Project Name:  shifreg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shifreg
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
 
ENTITY tb_shifreg IS
END tb_shifreg;
 
ARCHITECTURE behavior OF tb_shifreg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shifreg
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         sin : IN  std_logic;
         sout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sin : std_logic := '0';

 	--Outputs
   signal sout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shifreg PORT MAP (
          clk => clk,
          reset => reset,
          sin => sin,
          sout => sout
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
	sin<='1';
      -- hold reset state for 100 ns.
      wait for 100 ns;
   reset<='0';
   sin<='1';
   wait for 100 ns;	
	
	reset<='0';
   sin<='1';
   wait for 100 ns;
	
	reset<='0';
   sin<='0';
   wait for 100 ns;
	
	reset<='0';
   sin<='0';
   wait for 100 ns;
	
	reset<='0';
   sin<='1';
   wait for 100 ns;
	
	reset<='0';
   sin<='1';
   wait for 100 ns;
	
	reset<='0';
   sin<='0';
   wait for 100 ns;
	
	reset<='0';
   sin<='0';
   wait for 100 ns;

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
