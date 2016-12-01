----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:17 09/20/2013 
-- Design Name: 
-- Module Name:    piso - Behavioral 
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

entity piso is
port(clk,reset:in std_logic;
       x:in std_logic_vector(0 to 7);
		 sout: out std_logic);
end piso;

architecture Behavioral of piso is

 signal i:integer:=0;
begin
process(clk,reset)
	begin
	   if reset='1' then
		   sout<='0';
			i<=0;
		else
			    if i<=8 then
					 sout<=x(i);
					 i<=i+1;

             
			 end if;
	  end if;
end process;
		

end Behavioral;

