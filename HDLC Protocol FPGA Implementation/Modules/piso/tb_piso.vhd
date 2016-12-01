--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:39:14 09/20/2013
-- Design Name:   
-- Module Name:   D:/Students/VLSI/CET/piso/tb_piso.vhd
-- Project Name:  piso
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: piso
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
 
ENTITY tb_piso IS
END tb_piso;
 
ARCHITECTURE behavior OF tb_piso IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT piso
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         load : IN  std_logic;
         x : IN  std_logic_vector(0 to 7);
         sout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal load : std_logic := '0';
   signal x : std_logic_vector(0 to 7) := (others => '0');

 	--Outputs
   signal sout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: piso PORT MAP (
          clk => clk,
          reset => reset,
          load => load,
          x => x,
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
x<="10110101";
reset<='1';
load<='1';	
      -- hold reset state for 100 ns.
      wait for 200 ns;	
reset<='0';
load<='0';

 wait for 200 ns;	
reset<='0';
load<='1';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
