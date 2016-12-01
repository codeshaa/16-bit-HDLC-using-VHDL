--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:55:15 11/26/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/flagen/tb_flagen.vhd
-- Project Name:  flagen
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: flagen
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
 
ENTITY tb_flagen IS
END tb_flagen;
 
ARCHITECTURE behavior OF tb_flagen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flagen
    PORT(
         clk : IN  std_logic;
			reset : IN std_logic;
         a : IN  std_logic;
         z : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
	signal reset : std_logic:= '0';
	signal a : std_logic := '0';
	--Bidirs
   

 	--Outputs
   signal z : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flagen PORT MAP (
          clk => clk,
			 reset => reset,
          a => a,
          z => z
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
	a<='0';
	wait for 100 ns;
	reset<='0';
	a<='1';
	wait for 800 ns;
	a<='0';
	wait for 300 ns;
	a<='1';
	wait for 800 ns;
	
	
      -- hold reset state for 100 ns.
   	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
