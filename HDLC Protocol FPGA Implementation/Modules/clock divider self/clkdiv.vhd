----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:34:55 11/27/2013 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity 
architecture Behavioral of clkdiv is
	signal count:integer;
begin
	process(clk,reset)
--	variable count:integer;
	 begin
	  if reset='0' then
	  count<=0;
     ckout<='1';
	  elsif
	   clk='1' and clk'event then
		count<=count+1;
		if count=25 then
		ckout<=not ckout;
		count<=0;
		end if;
	end if;
end process;	
		

end Behavioral;

