----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:09 11/28/2013 
-- Design Name: 
-- Module Name:    BITSTFNG - Behavioral 
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

entity BITSTFNG is
port(a,clk,reset:in std_logic;
     z:out std_logic);
	 
end BITSTFNG;

architecture Behavioral of BITSTFNG is
type state is(s1,s2,s3,s4,s5);
signal fm:state;


begin
  process(clk,reset,a)
    begin
	   if reset<='1' then
		   z<='0';
	   else
		   if clk='1' and clk'event then
			   case fm is
					 when s1=>
					 z<='0';
					 if a='1' then
					 fm<=s2;
					 else 
					 fm<=s1;
	             end if;
						when s2=>
						z<='0';
						if a='1' then
						fm<=s3;
						else
						fm<=s1;
						end if;
			
					when s3=>
					z<='0';
					if a='1' then
					fm<=s4;
					else
					fm<=s1;
					end if;
			
					when s4=>
					z<='0';
					if a='1' then
					fm<=s5;
					else
					fm<=s1;
					end if;
			
					when s5=>
					fm<=s1;
					if a='1' then
					z<='1';
					else
					z<='0';
					end if;
--				when s6=>   if det='1' then 
--				               y<='0';
--								end if;
--								k<=x;
--								pstate<=s7;
--								
--								
--			  when s7=>   y<=k;
--			              pstate<=s1;
			             
			  end case;
		 end if;
	 end if;
  end process;

end Behavioral;

