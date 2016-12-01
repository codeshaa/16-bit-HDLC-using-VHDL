----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:53:34 11/25/2013 
-- Design Name: 
-- Module Name:    sipo - Behavioral 
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

entity sipo is
port(clk,reset:in std_logic;
     sin:in std_logic;
     pout:inout std_logic_vector(7 downto 0));
end sipo;

architecture Behavioral of sipo is
--signal i:std_logic_vector(7 downto 0):="00000000";
begin
process(clk,reset)

begin
   if reset='1' then
	pout<="XXXXXXXX";
	else
	     if clk='1' and clk'event then
		  pout<=(sin & pout(7 downto 1));
		 
		  end if;

	end if;
	 --pout<=i;

 end process;
 
end Behavioral;

