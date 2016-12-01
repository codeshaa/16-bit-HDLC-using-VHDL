----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:18:22 11/27/2013 
-- Design Name: 
-- Module Name:    flagab - Behavioral 
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

entity flagab is
port(clk,reset,a:in std_logic;
		z,about,idlout:out std_logic);
		
end flagab;

architecture Behavioral of flagab is
type state is(s1,s2,s3,s4,s5,s6,s7,s8);
signal fm,idl,ab:state;
begin
process(clk,reset)
	begin
	if reset='1' then 
	   z<='0';
	else	
		if clk='1' and clk'event then
		 case fm is
		 when s1=>
		 z<='0';
		 if a='0' then
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
			z<='0';
			if a='1' then
			fm<=s6;
			else
			fm<=s1;
			end if;
			
			when s6=>
			z<='0';
			if a='1' then
			fm<=s7;
			else
			fm<=s1;
			end if;
			
			when s7=>
			z<='0';
			if a='1' then
			fm<=s8;
			else
			fm<=s1;
			end if;
			
			when s8=>
			fm<=s1;
			if a='0' then
			z<='1';
			else
			z<='0';
			
			end if;
		end case;
		
		case idl is
		 when s1=>
		 idlout<='0';
		 if a='1' then
		 idl<=s2;
		 else 
		 idl<=s1;
		 end if;
			when s2=>
			idlout<='0';
			if a='1' then
			idl<=s3;
			else
			idl<=s1;
			end if;
			
			when s3=>
			idlout<='0';
			if a='1' then
			idl<=s4;
			else
			idl<=s1;
			end if;
			
			when s4=>
			idlout<='0';
			if a='1' then
			idl<=s5;
			else
			idl<=s1;
			end if;
			
			when s5=>
			idlout<='0';
			if a='1' then
			idl<=s6;
			else
			idl<=s1;
			end if;
			
			when s6=>
			idlout<='0';
			if a='1' then
			idl<=s7;
			else
			idl<=s1;
			end if;
			
			when s7=>
			idlout<='0';
			if a='1' then
			idl<=s8;
			else
			idl<=s1;
			end if;
			
			when s8=>
			idl<=s1;
			if a='0' then
			idlout<='0';
			else
			idlout<='1';
			end if;
		end case;
		
			case ab is
		 when s1=>
		 about<='0';
		 if a='0' then
		 ab<=s2;
		 else 
		 ab<=s1;
	
		 end if;
			when s2=>
		about<='0';
			if a='1' then
			ab<=s3;
			else
			ab<=s1;
			end if;
			
			when s3=>
			about<='0';
			if a='1' then
			ab<=s4;
			else
			ab<=s1;
			end if;
			
			when s4=>
			about<='0';
			if a='1' then
			ab<=s5;
			else
			ab<=s1;
			end if;
			
			when s5=>
			about<='0';
			if a='1' then
			ab<=s6;
			else
			ab<=s1;
			end if;
			
			when s6=>
			about<='0';
			if a='1' then
			ab<=s7;
			else
			ab<=s1;
			end if;
			
			when s7=>
			about<='0';
			if a='1' then
			ab<=s8;
			else
			ab<=s1;
			end if;
			
			when s8=>
			ab<=s1;
			if a='0' then
			about<='0';
			else
			about<='1';
			end if;
		end case;
			
	end if;
 end if;
 end process;
			
end Behavioral;

