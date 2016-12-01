----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:07 11/25/2013 
-- Design Name: 
-- Module Name:    shifreg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shifreg is
port(clk,reset,sin: in std_logic;
     sout:out std_logic);
end shifreg;

architecture Behavioral of shifreg is
signal q:std_logic_vector(1 to 8):="00000000";
begin
	process(clk,sin,reset)
		begin
		if reset='1' then
		   sout<='0';
		else
	
	      	if clk='1' and clk'event then
		   
			   q<=sin & q(2 to 8);
			   end if;
		end if;
		sout<=q(1);
  end process;
  
end Behavioral;

