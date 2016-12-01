----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:32 11/26/2013 
-- Design Name: 
-- Module Name:    flagen - Behavioral 
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

entity flagen is
port(clk,reset:in std_logic;
      a:in std_logic;
     z:out std_logic);
end flagen;

architecture Behavioral of flagen is
type state is(s0,s1,s2,s3,s4,s5,s6,s7);
signal flagstate:state;
begin

  process(clk,reset)
  begin
   if reset='1' then
	   z<='0';
	else
    if clk='1' and clk'event then 
	   case flagstate is
		   when s0=> z<='0';
			    if a='1' then 
			     flagstate<=s1;
				  end if;
			when s1=> z<='1';
			    if a='1' then
				  flagstate<=s2;
				  else
				  flagstate<=s0;
				  end if;
		   when s2=> z<='1';
			    if a='1' then
				  flagstate<=s3;
				  else
				  flagstate<=s0;
				  end if;
			when s3=> z<='1';
			    if a='1' then
				  flagstate<=s4;
				  else
				  flagstate<=s0;
				  end if;
			when s4=> z<='1';
			    if a='1' then
				  flagstate<=s5;
				  else
				  flagstate<=s0;
				  end if;
			when s5=> z<='1';
			    if a='1' then
				  flagstate<=s6;
				  else
				  flagstate<=s0;
				  end if;
			when s6=> z<='0';
			    if a='1' then
				  flagstate<=s7;
				  else
				  flagstate<=s0;
				  end if;
			when s7=> z<='0';
			    if a='1' then
				  flagstate<=s0;
			
				  else
				  flagstate<=s0;
				  end if;	

		end case;
	  end if;
	 end if;
	end process;
end behavioral;