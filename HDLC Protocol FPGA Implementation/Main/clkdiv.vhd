----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:55:24 01/03/2013 
-- Design Name: 
-- Module Name:    clkdiv - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkdiv is
 generic (D : natural := 10);
 port( clk_in: in std_logic;
       reset : in std_logic;
		 clk_1hz :out  std_logic);
		 
end clkdiv;

architecture Behavioral of clkdiv is
  signal q : std_logic_vector(D-1 downto 0);
 begin
   process(clk_in,reset) is
	    begin
		  if(reset = '1')then
		    q <= (others => '0');
			 elsif(reset = '0')then --rising_edge(clk_in)then
			  q <= q+1;
			  end if;
			  end process;
			  clk_1hz <= not q(D-1);
			 
end Behavioral;

