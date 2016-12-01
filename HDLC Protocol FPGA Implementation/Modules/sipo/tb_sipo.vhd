--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:03:49 11/25/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/sipo/tb_sipo.vhd
-- Project Name:  sipo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sipo
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
 
ENTITY tb_sipo IS
END tb_sipo;
 
ARCHITECTURE behavior OF tb_sipo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sipo
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
      
         x : IN  std_logic;
         pout : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
 
   signal x : std_logic := '0';

 	--Outputs
   signal pout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sipo PORT MAP (
          clk => clk,
          reset => reset,
         
          x => x,
          pout => pout
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
	x<='1';
     
      wait for 100 ns;	

	reset<='0';
	x<='1';
      wait for 100 ns;
	
	x<='0';
    
      wait for 100 ns;
	
	x<='1';
     
      wait for 100 ns;
	
	x<='0';
      
      wait for 100 ns;
	
	x<='1';
    
      wait for 100 ns;
	
	x<='1';
     
      wait for 100 ns;
	
	x<='0';
   
      wait for 100 ns;
	
	x<='1';
     
      wait for 100 ns;

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
